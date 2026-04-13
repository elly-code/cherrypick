

gresource_conf = configuration_data()
gresource_conf.set('APP_PATH', app_path)
gresource_file = configure_file(
    input: 'cherrypick.gresource.xml.in',
    output: 'cherrypick.gresource.xml',
    configuration: gresource_conf,
)

gresource = gnome.compile_resources(
    'gresource',
    gresource_file,
    source_dir: 'data'
)


gschema_conf = configuration_data()
gschema_conf.set('APP_ID', app_id)
gschema_conf.set('APP_PATH', app_path)
gschema_file = configure_file(
    input: 'cherrypick.gschema.xml.in',
    output: app_id + '.gschema.xml',
    configuration: gschema_conf,
)

install_data(
    gschema_file,
    install_dir: get_option('datadir') / 'glib-2.0' / 'schemas',
)

compile_schemas = find_program('glib-compile-schemas', required: false, disabler: true)
    test('Validate schema file',
    compile_schemas,
    args: ['--strict', '--dry-run', meson.current_source_dir()],
)


#picker_resources = gnome.compile_resources(
#    'picker-resources',
#    'gresource.xml',
#)

# Install our icons in all the required sizes
icon_sizes = ['16', '24', '32', '48', '64', '128']

foreach i : icon_sizes
    # Since we're using pngs, need to install separate files for low and high DPI
    # LoDPI
    install_data(
        'icons' / 'png' / i + '.png',
        install_dir: get_option('datadir') / 'icons' / 'hicolor' / i + 'x' + i / 'apps',
        rename: app_id + '.png'
    )
    # HiDPI
    install_data(
        'icons' / 'png' / i + '@2x' + '.png',
        install_dir: get_option('datadir') / 'icons' / 'hicolor' / i + 'x' + i + '@2' / 'apps',
        rename: app_id + '.png'
    )
endforeach


# Inject some variables into the desktop file before merging in the translations
desktop_conf = configuration_data()
desktop_conf.set('APP_NAME', app_name)
desktop_conf.set('APP_ID', app_id)
desktop_file_in = configure_file(
input: 'cherrypick.desktop.in.in',
output: app_id + '.desktop.in',
configuration: desktop_conf,
)

desktop_file = i18n.merge_file(
input: desktop_file_in,
output: app_id + '.desktop',
po_dir: meson.project_source_root() / 'po' / 'extra',
type: 'desktop',
install: true,
install_dir: get_option('datadir') / 'applications',
)


# Inject some variables into the metainfo file before merging in the translations
appstream_conf = configuration_data()
appstream_conf.set('APP_NAME', app_name)
appstream_conf.set('APP_ID', app_id)
appstream_conf.set('APP_VERSION', app_version)
appstream_conf.set('GETTEXT_PACKAGE', gettext_name)
appstream_conf.set('ALTERNATE_APP_ID', alternate_app_id)
appstream_file_in = configure_file(
    input: 'cherrypick.metainfo.xml.in.in',
    output: app_id + '.metainfo.xml.in',
    configuration: appstream_conf,
)

appstream_file = i18n.merge_file(
    input: appstream_file_in,
    output: app_id + '.metainfo.xml',
    po_dir: meson.project_source_root() / 'po' / 'extra',
    type: 'xml',
    install: true,
    install_dir: get_option('datadir') / 'metainfo',
)



# Test definitions
desktop_utils = find_program('desktop-file-validate', required: false)
if desktop_utils.found()
    test('Validate desktop file', desktop_utils, args: [desktop_file])
endif

appstreamcli = find_program('appstreamcli', required: false, disabler: true)
    test('Validate appstream file',
appstreamcli,
args: ['validate', '--no-net', '--explain', appstream_file],
)