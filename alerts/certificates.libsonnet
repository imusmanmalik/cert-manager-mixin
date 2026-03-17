{
  prometheusAlerts+:: {
    groups+: [{
      name: 'certificates',
      rules: [
        {
          local alert = 'CertManagerCertExpirySoon',
          local clusterSel = if $._config.enableMultiCluster && $._config.clusterVariableSelector != '' then ', ' + $._config.clusterVariableSelector else '',
          alert: alert,
          local remainingThreshold = '%g' % (1 - $._config.certManagerCertExpiryRenewalElapsedThreshold),
          expr: if $._config.certManagerReplaceExportedNamespace then
            |||
              min without (exported_namespace) (
                label_replace(
                  avg by (exported_namespace, namespace, name%s) (
                    (certmanager_certificate_expiration_timestamp_seconds - time())
                    and on (exported_namespace, namespace, name%s)
                    (certmanager_certificate_ready_status{condition="True"} == 1)
                  ),
                  "namespace", "$1", "exported_namespace", "(.*)"
                )
              )
              <
              min without (exported_namespace) (
                label_replace(
                  avg by (exported_namespace, namespace, name%s) (
                    certmanager_certificate_expiration_timestamp_seconds - certmanager_certificate_renewal_timestamp_seconds
                  ),
                  "namespace", "$1", "exported_namespace", "(.*)"
                )
              ) * %s
            ||| % [clusterSel, clusterSel, clusterSel, remainingThreshold]
          else
            |||
              avg by (exported_namespace, namespace, name%s) (
                (certmanager_certificate_expiration_timestamp_seconds - time())
                and on (exported_namespace, namespace, name%s)
                (certmanager_certificate_ready_status{condition="True"} == 1)
              )
              <
              avg by (exported_namespace, namespace, name%s) (
                certmanager_certificate_expiration_timestamp_seconds - certmanager_certificate_renewal_timestamp_seconds
              ) * %s
            ||| % [clusterSel, clusterSel, clusterSel, remainingThreshold],
          'for': '1h',
          labels: {
            severity: 'warning',
          },
          annotations:
            {
              summary: 'The cert `{{ $labels.name }}` is {{ $value | humanizeDuration }} from expiry, it should have been renewed by now.',
              description: 'The domain that this cert covers will be unavailable after {{ $value | humanizeDuration }}. Clients using endpoints that this cert protects will start to fail in {{ $value | humanizeDuration }}.',
            }
            + (if $._config.grafanaExternalUrlEnabled then {
                 dashboard_url: $._config.grafanaExternalUrl + '/d/TvuRo2iMk/cert-manager',
               } else {})
            + (if $._config.certManagerRunbookURLEnabled then {
                 runbook_url: $._config.certManagerRunbookURLPattern % std.asciiLower(alert),
               } else {}),
        },
        {
          local alert = 'CertManagerCertNotReady',
          local clusterSel = if $._config.enableMultiCluster && $._config.clusterVariableSelector != '' then ', ' + $._config.clusterVariableSelector else '',
          alert: alert,
          expr: if $._config.certManagerReplaceExportedNamespace then
            |||
              min without (exported_namespace) (
                label_replace(
                  max by (name, exported_namespace, namespace, condition%s) (
                    certmanager_certificate_ready_status{condition!="True"} == 1
                  ),
                  "namespace", "$1", "exported_namespace", "(.*)"
                )
              )
            ||| % clusterSel
          else
            |||
              max by (name, exported_namespace, namespace, condition%s) (
                certmanager_certificate_ready_status{condition!="True"} == 1
              )
            ||| % clusterSel,
          'for': '10m',
          labels: {
            severity: 'critical',
          },
          annotations:
            {
              summary: 'The cert `{{ $labels.name }}` is not ready to serve traffic.',
              description: 'This certificate has not been ready to serve traffic for at least 10m. If the cert is being renewed or there is another valid cert, the ingress controller _may_ be able to serve that instead.',
            }
            + (if $._config.grafanaExternalUrlEnabled then {
                 dashboard_url: $._config.grafanaExternalUrl + '/d/TvuRo2iMk/cert-manager',
               } else {})
            + (if $._config.certManagerRunbookURLEnabled then {
                 runbook_url: $._config.certManagerRunbookURLPattern % std.asciiLower(alert),
               } else {}),
        },
        {
          local alert = 'CertManagerHittingRateLimits',
          alert: alert,
          expr: |||
            sum by (host%s) (
              rate(certmanager_http_acme_client_request_count{status="429"}[5m])
            ) > 0
          ||| % (if $._config.enableMultiCluster && $._config.clusterVariableSelector != '' then ', ' + $._config.clusterVariableSelector else ''),
          'for': '5m',
          labels: {
            severity: 'critical',
          },
          annotations:
            {
              summary: 'Cert manager hitting LetsEncrypt rate limits.',
              description: 'Depending on the rate limit, cert-manager may be unable to generate certificates for up to a week.',
            }
            + (if $._config.grafanaExternalUrlEnabled then {
                 dashboard_url: $._config.grafanaExternalUrl + '/d/TvuRo2iMk/cert-manager',
               } else {})
            + (if $._config.certManagerRunbookURLEnabled then {
                 runbook_url: $._config.certManagerRunbookURLPattern % std.asciiLower(alert),
               } else {}),
        },
      ],
    }],
  },
}
