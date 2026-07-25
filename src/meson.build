#
# Sources
#

#================================
# Config.vala allows us to set variables in Meson, for the Vala app to use later

config_file = configure_file(
    input: 'Config.vala.in',
    output: '@BASENAME@',
    configuration: config_data
)


#================================
# dependencies

dependencies = [
  dependency ('gtk4'),                                                    #
  dependency ('granite-7', version: '>=7.7.0'),                           # 
  dependency('libportal'),                                                # Filepicker access
  meson.get_compiler('c').find_library('m', required: true)     # Math calculations for conversion between color formats
  ]

#================================
sources = files(
  'Controllers' / 'ColorController.vala',

  'Models' / 'Color.vala',
  'Models' / 'Format.vala',
  'Models' / 'ColorHistory.vala',

  'Services' / 'ColorPicker.vala',
  'Services' / 'Settings.vala',

  'Views' / 'MainView.vala',

  'Widgets' / 'ColorPreview.vala',
  'Widgets' / 'FormatArea.vala',
  'Widgets' / 'HistoryHeader.vala',
  'Widgets' / 'HistoryButtons.vala',
  'Widgets' / 'ColorButton.vala',

  'Windows' / 'Window.vala',

  'Application.vala',
  'Constants.vala',
  )

#================================
executable(
    app_id,
    gresource,
    config_file,
    sources,
    dependencies: dependencies,
    install: true
)