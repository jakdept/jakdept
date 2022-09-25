# CockroachDB Server Setup

## Installing Cockroach

Kick 3 Servers.
You don't need private networks, but if you want them you can add them.
Throw these things on there to make your life easier.

```bash
yum install -y sudo coreutils tar curl wget net-tools lsof ntp
```

### DNS & Networking

Do not count on DNS records.
Bypass them.
Put your nodes in `/etc/hosts` on each node to bypass DNS failures.

```bash
cat <<EOM >/etc/hosts
127.0.0.1   localhost localhost.localdomain localhost4 localhost4.localdomain4
::1         localhost localhost.localdomain localhost6 localhost6.localdomain6
209.59.144.29   cockroach-1.jakdept.dev cockroach-1
209.59.160.72   cockroach-2.jakdept.dev cockroach-2
209.59.144.33   cockroach-3.jakdept.dev cockroach-3
EOM
```

Also make sure you have a DNS record for that hostname - `dig +short <hostname>` should pass.

### Time stuff

Make sure `timesyncd` is off:

```bash
timedatectl
```

If it's not:

```bash
timedatectl set-ntp no
```

Ensure NTP is installed:

```bash
yum install -y ntp
service ntp stop
ntpd -b time.google.com
service ntp start
```

Maybe go use google's NTP servers as well if you want, if you do they're below:

```text
server time1.google.com iburst
server time2.google.com iburst
server time3.google.com iburst
server time4.google.com iburst
```

### Firewall Stuff

You need firewall rules for both CockroachDB across the cluster, and external access to the cluster.

```bash
firewall-cmd --zone public --add-service=http --permanent # let certbot in the door
firewall-cmd --zone public --add-service=https --permanent # let certbot in the door
firewall-cmd --zone public --add-service=postgresql --permanent
firewall-cmd  --zone internal --add-source 209.59.144.29 --permanent # add each node in the cluster to internal zone
firewall-cmd  --zone internal --add-source 209.59.160.72 --permanent
firewall-cmd  --zone internal --add-source 209.59.144.33 --permanent
firewall-cmd  --zone internal --add-port 26257/tcp --permanent # add each node in the cluster to internal zone
firewall-cmd --reload
```

### Install Cockroach Binary

This command will change every once in a while depending on their version.
So just follow the link below.
Install `cockroach` on your local machine and all server nodes.

<https://www.cockroachlabs.com/docs/v20.1/install-cockroachdb-linux>

Verify it's installed:

```bash
cockroach version
```

### Actual Cockroach Cluster Setup

At this point, we're basically doing this page

#### Generate the CA

First, locally, generate the CA cert - make it last for 25 years.
Default is 10y but `--lifetime` flag controls that.

```bash
mkdir cockroach
cockroach cert create-ca \
  --lifetime=219150h0m0s \
  --certs-dir=cockroach \
  --ca-key=cockroach/ca.key
```

Look at the details with:

```bash
cat cockroach/ca.crt | openssl x509 -noout -enddate -subject -issuer
```

When you are done, `cockroach/ca.crt` and `cockroach/ca.key` should be stored in Lastpass or similar.

#### Write out the systemd unit

Put this file in `cockroach` folder and **change the join address**.
Call it `cockroach.service`.
`--join` should be `,` separated hostname or IP of all nodes (including the current one).

This will put your listen on `*.26257` unless you set `--listen` to an IP or host.

```systemd
[Unit]
Description=Cockroach Database cluster node
Requires=network.target
[Service]
Type=notify
WorkingDirectory=/var/lib/cockroach
ExecStart=/usr/local/bin/cockroach start --certs-dir=/var/lib/cockroach/certs --join=<node-hostnames> --cache=.25 --max-sql-memory=.25
TimeoutStopSec=60
Restart=always
RestartSec=10
StandardOutput=syslog
StandardError=syslog
SyslogIdentifier=cockroach
User=cockroach
[Install]
WantedBy=default.target
```

Example:

```systemd
[Unit]
Description=Cockroach Database cluster node
Requires=network.target
[Service]
Type=notify
WorkingDirectory=/var/lib/cockroach
ExecStart=/usr/local/bin/cockroach start --certs-dir=/var/lib/cockroach/certs --join=cockroach1,cockroach2,cockroach3 --cache=.25 --max-sql-memory=.25
TimeoutStopSec=60
Restart=always
RestartSec=10
StandardOutput=syslog
StandardError=syslog
SyslogIdentifier=cockroach
User=cockroach
[Install]
WantedBy=default.target
```

#### Create a Cert for each Node

```bash
read NODE_HOSTNAME
cockroach cert create-node \
  --lifetime=219150h0m0s \
  --certs-dir=cockroach \
  --ca-key=cockroach/ca.key \
  localhost 127.0.0.1 \
  $NODE_HOSTNAME $(dig +short $NODE_HOSTNAME)
ssh $NODE_HOSTNAME mkdir -p /var/lib/cockroach/certs
ssh $NODE_HOSTNAME useradd -d /var/lib/cockroach cockroach
scp cockroach/{ca.crt,node.crt,node.key} $NODE_HOSTNAME:/var/lib/cockroach/certs/
scp cockroach.service $NODE_HOSTNAME:/etc/systemd/system/
ssh $NODE_HOSTNAME chown -R cockroach. /var/lib/cockroach
rm cockroach/node.{crt,key}
```

Then on each host:

```bash
openssl x509 -noout -enddate -subject -issuer < /var/lib/cockroach/certs/node.crt
```

```bash
openssl x509 -noout -text < /var/lib/cockroach/certs/node.crt |grep DNS
```

#### Start Cockroach

Also grab the `systemd` unit file while you're at it.

On each node:

```bash
systemctl start cockroach.service
```

Watch logs:

```bash
journalctl -fu cockroach.service
tail -f /var/lib/cockroach/cockroach-data/logs/cockroach.log
```

### Create a Client Key

```bash
cockroach cert create-client \
  root \
  --certs-dir=cockroach \
  --ca-key=cockroach/ca.key
```

Then to use that key you're going to want:

- `cockroach/ca.crt`
- `cockroach/client.root.key`
- `cockroach/client.root.crt`

You will need that key to init the cluster.

#### Init the cluster

From somewhere with your `client.root.crt` and key,
allow yourself to hit port 26257 on one of the nodes.
Then run:

```bash
cockroach init --certs-dir=cockroach --host=cockroach1.hostbaitor.com:26257
```

### TLS Certs

Read about Cockroach Authentication and security:
<https://www.cockroachlabs.com/docs/stable/authentication.html>

Installing Certbot is basically dependency hell.

First add `epel-release`:

```bash
yum install -y epel-release
```

Add `snapd`:

```bash
yum install -y snapd
systemctl enable --now snapd.socket
ln -s /var/lib/snapd/snap /snap
snap install core
snap refresh core
```

Install `certbot`:

```bash
snap install --classic certbot
sudo ln -s /snap/bin/certbot /usr/bin/certbot
```

Get a certificate:

```bash
certbot certonly --standalone --domain $(hostname)
```

Set up something to reload cockroachdb after TLS renewal.

```bash
certbot renew --deploy-hook /path/to/deploy-hook-script
```

### Perl examples

<https://github.com/cockroachdb/docs/issues/6697>

<https://metacpan.org/pod/DBD::Pg>

<https://www.cockroachlabs.com/docs/stable/install-client-drivers.html?filters=go#pgx>
