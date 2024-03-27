revolt_dm_only_sources = [
  'main.vala',
  'application.vala',
  'window.vala',
  'api.vala',
  'chat-page.vala',
  'websocket.vala',
]

revolt_dm_only_deps = [
  dependency('gtk4'),
  dependency('libsoup-3.0'),
  dependency('json-glib-1.0'),
  dependency('libadwaita-1', version: '>= 1.4'),
]

revolt_dm_only_sources += gnome.compile_resources('revolt-dm-only-resources',
  'revolt-dm-only.gresource.xml',
  c_name: 'revolt_dm_only'
)

executable('revolt-dm-only', revolt_dm_only_sources,
  dependencies: revolt_dm_only_deps,
       install: true,
)
