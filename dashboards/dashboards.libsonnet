{
  grafanaDashboards+:: {
    'cert-manager-overview.json': (import 'cert-manager-overview.json') + { _config: $._config },
  },
}
