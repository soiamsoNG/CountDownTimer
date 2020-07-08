countdowntimer_sources = [
  'main.vala',
  'cdt.vala',
]

countdowntimer_deps = [
  dependency('gio-2.0', version: '>= 2.50'),
  dependency('gtk+-3.0', version: '>= 3.22'),
  dependency('gsound', version: '>= 1.0.2'),
]

gnome = import('gnome')

countdowntimer_sources += gnome.compile_resources('countdowntimer-resources',
  'countdowntimer.gresource.xml',
  c_name: 'countdowntimer'
)

executable('countdowntimer', countdowntimer_sources,
  vala_args: '--target-glib=2.50',  dependencies: countdowntimer_deps,
  install: true,
)
