# service-proxy

An app that can be provisioned on Dokku to provide a proxy between the service's web ui and your browser.

## Usage

## Supported Services

- clickhouse: port `8123`
- couchdb: port `5984`
- elasticsearch: port `9200`
- graphite: port `80`
- rabbitmq: port `15672`
- rethinkdb: port `8080`
- solr: port `8983`

### Deploying

In this example, a `rabbitmq` service named `lollipop` will be exposed under the app `service-proxy`.

To start, we'll need to create an app for the service proxy.

```shell
dokku apps:create service-proxy
```

In order to proxy to a given service, some config variables need to be provisioned.

At a minimum, both `SERVICE_NAME` and `SERVICE_TYPE` should be set where:

- `SERVICE_NAME`: the name of the service, eg. `my-database`
- `SERVICE_TYPE`: the type of the service, eg. `rabbitmq` (this is the command prefix)

These will be used to infer the host/port to fetch. For the above example, the host would be `dokku-rabbitmq-my-database`.

The port will be infered to be the _first_ port exposed by the service. This may be incorrect, especially when the first port is a tcp port for communication to the datastore itself. In those cases, a `SERVICE_PORT` environment variable can be set to force a specific port number.

In the following example, we configure for rabbitmq:

```shell
dokku config:set service-proxy SERVICE_NAME=queue SERVICE_TYPE=rabbitmq SERVICE_PORT=15672
```

Next, we'll create the service itself and link it to our app:

```shell
# create the rabbitmq service
dokku rabbitmq:create queue

# link the rabbitmq service
dokku rabbitmq:link queue service-proxy
```

Finally, the service-proxy can be deployed, after which the service will be available on the app's url.

```shell
dokku git:from-image service-proxy dokku/service-proxy:latest
```

Since the service proxy is treated as an app, it can be configured to use any app-related setting. For example, letsencrypt can be used to provision SSL certificates.

```shell
dokku letsencrypt:enable service-proxy
```
