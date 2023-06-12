// Prometheus Mixin Config
{
  _config+:: {
    certManagerCertExpiryDays: '21',
    certManagerJobLabel: 'cert-manager',
    certManagerRunbookURLPattern: 'https://github.com/imusmanmalik/cert-manager-mixin/blob/main/RUNBOOK.md#%s',
    grafanaExternalUrl: 'https://grafana.example.com',

    // Selectors are inserted between {} in Prometheus queries.

    dashboards: {
      enableMultiCluster: false,
      clusterVariableSelector: '',

      defaultSelector: if self.enableMultiCluster then 'cluster="$cluster"' else '',
      containerSelector: if self.enableMultiCluster then 'container="cert-manager", cluster="$cluster"' else 'container="cert-manager"',
      namespaceSelector: if self.enableMultiCluster then 'namespace="cert-manager", cluster="$cluster"' else 'namespace="cert-manager"',

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
