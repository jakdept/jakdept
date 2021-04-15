# Prometheus
Let's talk Prometheus generally as an idea.

## Background Terms
### Server Monitoring Categories
* Status Monitoring

Focus is whether something is up or down - a binary version of monitoring.

* Metrics Monitoring

Focus on the status of something - # of connections to an endpoint, CPU usage of a server, similar.

* Telemetry

A more general term for expanded data gathering from a server.
A longer interval than the above would be expected - hours or once a day.
For instance, the domains on a server, or the packages and versions installed on a server.

* Log Shipping

Generally not exactly monitoring, per se.
Sending the logs on a server off to a central location.
Some systems allow alerting on specified conditions.

* Push

Data is generated on the server then pushed off to an endpoint.

* Pull

A service not on the server connects to a server and retrieves some data.
With basic up/down status, this may be checking whether the server is up via ping.
With more complex data (metrics, telemetry, log shipping) the data is likely presented on a webpage or similar and an external server scrapes it.

### Prometheus Specific System Areas
* Target Discovery

Determining what to monitor with each Prometheus node.

* Exporter

Something that runs and provides data for ingest into Prometheus.

* Federation

Service that combines streaming data from multiple sources.

## Parts of an Ideal Prometheus Cluster
This is the ideal Prometheus Cluster.
You may not like it,
but this is what Peak Performance looks like.

### Containers

The majority of this will not carry state.
It should not need it - aside from specific parts.
Thus, stick everything in containers and stick it in Kubernetes so it scales.
So, do like `k3os` or something and spin up Rancher somewhere and go do it.

And if you're not using `helm` and `flux` in there, you're doing it wrong.
Go revisit that.

[Also, y'all gonna be using these](https://github.com/prometheus-community/helm-charts).

### Replicated Stack

You're going to have a replicated stack to do the scraping and alerting.
* `prometheus` - do the scraping
* `blackbox_exporter` - `prometheus` scrapes against this to do ping etc...
* `alertmanager` - prometheus sends it's stream of data and you get alerts

You're going to run a bunch of replicas of this.
Keep your host count per replica down - theoritically 50 servers for now.
There will probably shortly be examples in here idk fam.

### Target Discovery
Target discovery is difficult to do. You've got three basic options:
* Use `counsul` - but then you're bought into the Hashicorp system.
* Write out config files and do some Prometheus filtering on the config files you're reading in so you see that.
* Maybe I write a service to do this?

### Short-term Historical

Stick up a pair of Prometheus nodes, outside of `kubernetes`.
Ingest data into there.
Just keep it simple.
Hit it for current stats as well.
You'll appreciate it when your persistent storage gets flakey.

### Long-term Storage

Ingeset Prometheus stream data into InfluxDB or something IDK you figure that out.

Then point a Prometheus node at that as a storage location so you query the same Prometheus endpoint.

Bonus points if you reuse the Prometheus historical stuff from before
