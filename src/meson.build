

#================================
# Config.vala allows us to set variables in Meson, for the Vala app to use later

config_file = configure_file(
    input: 'Config.vala.in',
    output: '@BASENAME@',
    configuration: config_data
)


#================================
# dependencies
# libportal for color picker
# maths ('m') for the conversions between formats

dependencies = [
  dependency ('gtk4'),
  dependency ('granite-7', version: '>=7.7.0'),
  dependency('libportal'),
  meson.get_compiler('c').find_library('m', required: true)
]

#================================
sources = files(
  'Constants.vala',
  'Application.vala',
  'Models/Color.vala',
  'Models/Format.vala',
  'Models/ColorHistory.vala',
  'Windows/Window.vala',
  'Views/MainView.vala',
  'Widgets/ColorPreview.vala',
  'Widgets/FormatArea.vala',
  'Widgets/HistoryHeader.vala',
  'Widgets/HistoryButtons.vala',
  'Widgets/ColorButton.vala',
  'Services/ColorPicker.vala',
  'Services/Settings.vala',
  'Controllers/ColorController.vala'
)

#================================
executable(
    app_id,
    gresource,
    config_file,
    sources,
    dependencies: dependencies,
    vala_args: vala_flags,
    install: true
)