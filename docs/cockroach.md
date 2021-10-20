# CockroachDB Server Setup

## Install Cockroach

```bash
yum install -y sudo coreutils tar curl
```

```bash
curl https://binaries.cockroachdb.com/cockroach-v21.1.9.linux-amd64.tgz | tar -xz && sudo cp -i cockroach-v21.1.9.linux-amd64/cockroach /usr/local/bin/
```

Verify it's installed:

```bash
cockroach version
```

If someone needs libgeos spatial queries, look at this:
[https://www.cockroachlabs.com/docs/v21.1/install-cockroachdb-linux]<https://www.cockroachlabs.com/docs/v21.1/install-cockroachdb-linux>

Once installed, there are 4 major things to plan for:

- DNS Prep
- Firewall Prep
- TLS Prep
- Disk Prep

### DNS Prep

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

### Firewall Stuff

You need firewall rules for both CockroachDB across the cluster, and external access to the cluster.

```bash
firewall-cmd --zone public --add-service=http --permanent # let certbot in the door
firewall-cmd --zone public --add-service=https --permanent # let certbot in the door
firewall-cmd  --zone internal --add-source 209.59.144.29 --permanent # add each node in the cluster to internal zone
firewall-cmd  --zone internal --add-source 209.59.160.72 --permanent
firewall-cmd  --zone internal --add-source 209.59.144.33 --permanent
firewall-cmd  --zone internal --add-port 26257/tcp --permanent # add each node in the cluster to internal zone
firewall-cmd --reload
```

### TLS Prep

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

## Start Cockroach

On each node:

```bash
cockroach start \
--certs-dir=certs \
--store=$(hostname) \
--listen-addr=:26257 \
--http-addr=:443 \
--join=cockroach-1.jakdept.dev:26257,cockroach-2.jakdept.dev:26257,cockroach-3.jakdept.dev:26257
--background
```

On one node:

```bash
cockroach init --certs-dir=certs --host=localhost:26257
```

### Perl examples

<https://github.com/cockroachdb/docs/issues/6697>

<https://metacpan.org/pod/DBD::Pg>

<https://www.cockroachlabs.com/docs/stable/install-client-drivers.html?filters=go#pgx>
