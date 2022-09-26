# CockroachDB

## Building a Cockroach Cluster

Kick 3 Servers.
You don't need private networks, but if you want them you can add them.
Throw these things on there to make your life easier.

```bash
mkdir -p /root/.ssh
curl -sSL https://github.com/jakdept.keys > /root/.ssh/authorized_keys
```

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
209.59.130.169   cockroach1.hostbaitor.com cockroach1
209.59.130.158   cockroach2.hostbaitor.com cockroach2
209.59.164.21   cockroach3.hostbaitor.com cockroach3
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

Add in Google's NTP servers in `/etc/ntp.conf`.

```text
server time1.google.com iburst
server time2.google.com iburst
server time3.google.com iburst
server time4.google.com iburst
```

Ensure NTP is installed:

```bash
yum install -y ntp
systemctl restart ntpd.service
ntpdate -b -u time.google.com
```

### Firewall Stuff

You need firewall rules for both CockroachDB across the cluster, and external access to the cluster.

```bash
firewall-cmd --zone public --add-service=http --permanent # let certbot in the door
firewall-cmd --zone public --add-service=https --permanent # let certbot in the door
firewall-cmd --zone public --add-service=postgresql --permanent
firewall-cmd  --zone internal --add-source 209.59.130.169 --permanent # add each node in the cluster to internal zone
firewall-cmd  --zone internal --add-source 209.59.130.158 --permanent
firewall-cmd  --zone internal --add-source 209.59.164.21 --permanent
firewall-cmd  --zone internal --add-port 26257/tcp --permanent # add each node in the cluster to internal zone
firewall-cmd --reload
```

### Install Cockroach Binary

This command will change every once in a while depending on their version.
So just follow the link below.
Install `cockroach` on your local machine and all server nodes.

<https://www.cockroachlabs.com/docs/v22.1/install-cockroachdb-linux.html>

Verify it's installed:

```bash
cockroach version
```

### Write out the systemd unit

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
ExecStart=/usr/local/bin/cockroach start --certs-dir=/var/lib/cockroach/certs --join=cockroach1.hostbaitor.com,cockroach2.hostbaitor.com,cockroach3.hostbaitor.com --cache=.25 --max-sql-memory=.25
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

### Generate the CA

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

### Create a Cert for each Node

```bash
read NODE_HOSTNAME
cockroach cert create-node \
  --lifetime=170880h0m0s \
  --certs-dir=cockroach \
  --ca-key=cockroach/ca.key \
  localhost 127.0.0.1 \
  $NODE_HOSTNAME $(dig +short $NODE_HOSTNAME)
scp cockroach/{ca.crt,node.crt,node.key} $NODE_HOSTNAME:/var/lib/cockroach/certs/
ssh $NODE_HOSTNAME chown -R cockroach. /var/lib/cockroach
rm cockroach/node.{crt,key}

scp cockroach/cockroach.service $NODE_HOSTNAME:/etc/systemd/system/
ssh $NODE_HOSTNAME mkdir -p /var/lib/cockroach/certs
ssh $NODE_HOSTNAME useradd -d /var/lib/cockroach cockroach
```

Then see the details on each host:

```bash
openssl x509 -noout -enddate -subject -issuer < /var/lib/cockroach/certs/node.crt
```

```bash
openssl x509 -noout -text < /var/lib/cockroach/certs/node.crt |grep DNS
```

### Start Cockroach

The previous step should have added a `cockroach.service` on each node.
Now start `cockroach` on each node:

```bash
systemctl start cockroach.service
```

Watch logs:

```bash
journalctl -fu cockroach.service &
tail -f /var/lib/cockroach/cockroach-data/logs/cockroach.log &
```

Stop watching those logs:

```bash
kill %1 %2
```

In those logs, you want to see something like:

```text
I220925 23:58:17.541970 138 server/init.go:418 ⋮ [n?] 59  ‹cockroach1.hostbaitor.com:26257› is itself waiting for init, will retry
I220925 23:58:18.542298 138 server/init.go:418 ⋮ [n?] 60  ‹cockroach2.hostbaitor.com:26257› is itself waiting for init, will retry
I220925 23:58:19.542389 138 server/init.go:418 ⋮ [n?] 61  ‹cockroach1.hostbaitor.com:26257› is itself waiting for init, will retry
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

You may want to put that key in `/root` on each node, if you would like to do so:

```bash
ssh cockroach1.hostbaitor.com 'mkdir -p /root/.cockroach-certs && chmod 700 /root/.cockroach-certs'
scp cockroach/{ca.crt,client.root.*} cockroach1.hostbaitor.com:/root/.cockroach-certs/
```

### Init the cluster

**ONLY INITIALIZE A CLUSTER ONCE**.
Send this command at one node, it will set up all nodes.
If you add nodes, simply add them - do not initialize them.

You can init the cluster from one of the nodes - if you would like to do so, this will do it:

```bash
cockroach init --host=localhost:26257
```

Alternatively, start an ssh tunnel and run the following:

```bash
ssh -f -N -L localhost:26257:localhost:26257 cockroach1.hostbaitor.com
ssh -f -N -L localhost:8080:localhost:8080 cockroach1.hostbaitor.com
cockroach init --certs-dir=cockroach --host=localhost:26257
```

Or you can open the port in the firewall - but we're going to set up `haproxy` for that port instead.

### Create an Admin User

```sql
CREATE USER admin WITH PASSWORD 'hunter2' VALID UNTIL '2022-10-31';
```

This will let you log into the webinterface on 8080 with that user. If you need to reset that password, or drop that user:

```sql
MODIFY USER webadmin WITH PASSWORD 'hunter2' VALID UNTIL'2022-10-31';
DROP USER webadmin;
```

### More Info

<https://www.cockroachlabs.com/docs/stable/deploy-cockroachdb-on-premises.html#step-5-test-the-cluster>

### Perl examples

<https://github.com/cockroachdb/docs/issues/6697>

<https://metacpan.org/pod/DBD::Pg>

<https://www.cockroachlabs.com/docs/stable/install-client-drivers.html?filters=go#pgx>
