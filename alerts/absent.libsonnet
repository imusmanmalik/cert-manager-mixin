{
  prometheusAlerts+:: {
    groups+: [{
      name: 'cert-manager',
      rules: [
        {
          alert: 'CertManagerAbsent',
          expr: 'absent(up{job="%(certManagerJobLabel)s"})' % $._config,
          'for': '10m',
          labels: {
            severity: 'critical',
          },
          annotations: {
            summary: 'Cert Manager has dissapeared from Prometheus service discovery.',
            description: "New certificates will not be able to be minted, and existing ones can't be renewed until cert-manager is back.",
            // runbook_url: 'https://gitlab.com/uneeq-oss/cert-manager-mixin/-/blob/master/RUNBOOK.md#certmanagerabsent',
          },
        },
      ],
    }],
  },
}
