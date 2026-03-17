# cert-manager Mixin

[![CI Test](https://github.com/imusmanmalik/cert-manager-mixin/actions/workflows/test.yaml/badge.svg)](https://github.com/imusmanmalik/cert-manager-mixin/actions/workflows/test.yaml) [![CI Release](https://github.com/imusmanmalik/cert-manager-mixin/actions/workflows/release.yaml/badge.svg)](https://github.com/imusmanmalik/cert-manager-mixin/actions/workflows/release.yaml)

The cert-manager mixin is a collection of reusable and configurable [Prometheus](https://prometheus.io/) alerts, and a [Grafana](https://grafana.com) dashboard to help with operating [cert-manager](https://cert-manager.io/).

## Configuration Options

See [config.libsonnet](config.libsonnet) for all available options. Some notable ones:

| Option | Default | Description |
|--------|---------|-------------|
| `certManagerCertExpiryRenewalElapsedThreshold` | `0.3` | Fraction of the renewal window that must elapse before `CertManagerCertExpirySoon` fires. Each certificate's renewal window is computed dynamically from `certmanager_certificate_expiration_timestamp_seconds - certmanager_certificate_renewal_timestamp_seconds`. A value of `0.3` means the alert fires once 30% of that window has passed without a successful renewal. |
| `certManagerReplaceExportedNamespace` | `false` | When `true`, certificate alerts use `label_replace` to promote `exported_namespace` to `namespace` and drop the original `exported_namespace` label. This is useful when the `namespace` label should reflect the namespace where the certificate resource lives, rather than the namespace of the cert-manager controller itself. |
| `enableMultiCluster` | `false` | Enable multi-cluster label selectors in alerts and dashboards. |
| `clusterVariableSelector` | `''` | The label name used to distinguish clusters (e.g. `cluster`). Only effective when `enableMultiCluster` is `true`. |

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

To use the dashboard, it can be imported or provisioned for Grafana by grabbing the [cert-manager-overview.json](dashboards/cert-manager-overview.json) file as is.

## Multi Cluster Support

It is becoming a common use-case where we run multiple Kubernetes clusters, each one has its own certmanager and Prometheus instance. Those Prometheus remote-write metrics to a remote Long Term Storage, such as Thanos or Cortex, and a Grafana will now query metrics from the LTS tool instead of multiple Prometheus.

Grafana dashboard have now selectors for the queries to the `_config` jsonnet object.

There is a variable named `enableMultiCluster` to enable the multi cluster queries for both the dashboard and the alerts.

## Manifests

Pre rendered manifests can also be found at https://monitoring.mixins.dev/cert-manager/

## Credits

Since [cert-manager-mixin](https://gitlab.com/uneeq-oss/cert-manager-mixin) is not maintained anymore. This is the fork of the repository and it was imported into GitHub.
