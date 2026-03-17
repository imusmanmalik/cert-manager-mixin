// Prometheus Mixin Config
{
  _config+:: {
    local cfg = self,

    // Fraction of the renewal window elapsed before alerting (0.3 = alert after 30% of renewal window has passed).
    certManagerCertExpiryRenewalElapsedThreshold: 0.3,
    certManagerJobLabel: 'cert-manager',
    certManagerRunbookURLEnabled: true,
    certManagerRunbookURLPattern: 'https://github.com/imusmanmalik/cert-manager-mixin/blob/main/RUNBOOK.md#%s',
    grafanaExternalUrlEnabled: true,
    grafanaExternalUrl: 'https://grafana.example.com',

    // When true, replaces exported_namespace with namespace in certificate alerts
    certManagerReplaceExportedNamespace: false,

    enableMultiCluster: false,
    clusterVariableSelector: '',

    // Selectors are inserted between {} in Prometheus queries.
    dashboards: {
      defaultSelector: if cfg.enableMultiCluster then 'cluster="$cluster"' else '',
      containerSelector: if cfg.enableMultiCluster then 'container=~"cert-manager.*", cluster="$cluster"' else 'container=~"cert-manager.*"',
      namespaceSelector: if cfg.enableMultiCluster then 'namespace="cert-manager", cluster="$cluster"' else 'namespace="cert-manager"',

      certmanagerCertificateReadyStatusSelector: self.defaultSelector,
      certmanagerCertificateExpirationTimestampSecondsSelector: self.defaultSelector,
      certmanagerControllerSyncCallCountSelector: self.defaultSelector,
      certmanagerHttpAcmeClientRequestCountSelector: self.defaultSelector,
      certmanagerHttpAcmeClientRequestDurationSecondsSumSelector: self.defaultSelector,
      certmanagerHttpAcmeClientRequestDurationSecondsCountSelector: self.defaultSelector,
      containerCPUUsageSecondsTotalSelector: self.containerSelector,
      kubePodContainerResourceLimitsCpuCoresSelector: self.containerSelector,
      kubePodContainerResourceRequestsCpuCoresSelector: self.containerSelector,
      containerCpuCfsThrottledPeriodsTotalSelector: self.containerSelector,
      containerCpuCfsPeriodsTotalSelector: self.containerSelector,
      containerMemoryUsageBytesSelector: self.containerSelector,
      kubePodContainerResourceLimitsMemoryBytesSelector: self.containerSelector,
      kubePodContainerResourceRequestsMemoryBytesSelector: self.containerSelector,
      containerNetworkReceiveBytesTotalSelector: self.namespaceSelector,
      containerNetworkTransmitBytesTotalSelector: self.namespaceSelector,
    },
  },
}
