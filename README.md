# cert-manager Mixin

[![CI Test](https://github.com/imusmanmalik/cert-manager-mixin/actions/workflows/test.yaml/badge.svg)](https://github.com/imusmanmalik/cert-manager-mixin/actions/workflows/test.yaml) [![CI Release](https://github.com/imusmanmalik/cert-manager-mixin/actions/workflows/release.yaml/badge.svg)](https://github.com/imusmanmalik/cert-manager-mixin/actions/workflows/release.yaml)

The cert-manager mixin is a collection of reusable and configurable [Prometheus](https://prometheus.io/) alerts, and a [Grafana](https://grafana.com) dashboard to help with operating [cert-manager](https://cert-manager.io/).

## Config Tweaks

There are some configurable options you may want to override in your usage of this mixin, as they will be specific to your deployment of cert-manager. They can be found in [config.libsonnet](config.libsonnet).

## Using the mixin with kube-prometheus

See the [kube-prometheus](https://github.com/coreos/kube-prometheus#kube-prometheus)
project documentation for examples on importing mixins.

## Using the mixin as raw files

If you don't use the jsonnet based `kube-prometheus` project then you will need to
generate the raw yaml files for inclusion in your Prometheus installation.

Install the `jsonnet` dependencies (tested against versions v0.20+):

```shell
go install github.com/google/go-jsonnet/cmd/jsonnet@latest
go install github.com/google/go-jsonnet/cmd/jsonnetfmt@latest
```

Generate yaml:

```shell
make
```

To use the dashboard, it can be imported or provisioned for Grafana by grabbing the [cert-manager.json](dashboards/cert-manager.json) file as is.

## Multi Cluster Support

It is becoming a common use-case where we run multiple Kubernetes clusters, each one has its own certmanager and Prometheus instance. Those Prometheus remote-write metrics to a remote Long Term Storage, such as Thanos or Cortex, and a Grafana will now query metrics from the LTS tool instead of multiple Prometheus.

Grafana dashboard have now selectors for the queries to the `_config` jsonnet object.

There is a variable named `enableMultiCluster` to enable the multi cluster queries for the dashboard.

## Manifests

Pre rendered manifests can also be found at https://monitoring.mixins.dev/cert-manager/

## Credits

Since [cert-manager-mixin](https://gitlab.com/uneeq-oss/cert-manager-mixin) is not maintained anymore. This is the fork of the repository and it was imported into GitHub.
