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
      containerName: 'cert-manager-controller',
      containerNamespace: 'cert-manager',

      defaultSelector: if self.enableMultiCluster then 'cluster="$cluster"' else '',
      containerSelector: 'container="%s"' % self.containerName + if self.enableMultiCluster then ',cluster="$cluster"' else '',
      namespaceSelector: 'namespace="%s"' % self.containerNamespace + if self.enableMultiCluster then ',cluster="$cluster"' else '',

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
