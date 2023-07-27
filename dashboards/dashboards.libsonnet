{
  grafanaDashboards+:: {
    'overview.json': (import 'overview.json') + { _config: $._config },
  },
}
