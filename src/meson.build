
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

executable(
    app_id,
    gresource,
    config_file,
    sources,
    dependencies: picker_dependencies,
    install: true
)