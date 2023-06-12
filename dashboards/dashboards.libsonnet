{
  grafanaDashboards+:: {
    'cert-manager.json': (import 'cert-manager.json') + { _config: $._config },
  },
}
