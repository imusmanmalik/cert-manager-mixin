// Prometheus Mixin Config
{
  _config+:: {
    certManagerJobLabel: 'cert-manager',
    certManagerCertExpiryDays: '21',
    grafanaExternalUrl: 'https://grafana.example.com',
  },
}
