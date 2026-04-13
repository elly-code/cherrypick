project('cherrypick', 
'c', 'vala', 
version: '2.4.0')

app_name = 'Cherrypick'
correct_app_id = 'io.github.elly_code.' + meson.project_name()
legacy_app_id = 'io.github.ellie_commons.' +  meson.project_name()

if get_option('legacy-rdnn')
    app_id = legacy_app_id
    alternate_app_id = correct_app_id
    app_path = '/io/github/ellie_commons/cherrypick/'
else
    app_id = correct_app_id
    alternate_app_id = legacy_app_id
    app_path = '/io/github/elly_code/cherrypick/'

endif

app_version = meson.project_version()
gettext_name = meson.project_name()

i18n = import('i18n')
gnome = import('gnome')


vala_flags = []
if get_option('development')
  app_id +=  '.devel'
  vcs_tag = run_command('git', 'rev-parse', '--short', 'HEAD').stdout().strip()
  version_suffix = '-@0@'.format (vcs_tag)
  vala_flags += ['--define', 'DEVEL']

else
  name_prefix = ''
  version_suffix = ''
endif


add_project_arguments(vala_flags, language: 'vala')


# Set our translation domain
add_global_arguments('-DGETTEXT_PACKAGE="@0@"'.format (gettext_name), language:'c')



glib_dep = dependency('glib-2.0')
gtk_dep = dependency('gtk4')
granite_dep = dependency('granite-7')
portal_dep = dependency('libportal')

picker_dependencies = [glib_dep, gtk_dep, granite_dep, portal_dep, meson.get_compiler('c').find_library('m', required: true)]

config_data = configuration_data()
config_data.set_quoted('LOCALEDIR', get_option('prefix') / get_option('localedir'))
config_data.set_quoted('GETTEXT_PACKAGE', gettext_name)
config_data.set_quoted('APP_NAME', app_name)
config_data.set_quoted('APP_ID', app_id)
config_data.set_quoted('APP_PATH', app_path)
config_data.set_quoted('APP_VERSION', app_version)
config_file = configure_file(
    input: 'src/Config.vala.in',
    output: '@BASENAME@',
    configuration: config_data
)

subdir('data')
subdir('po')
subdir('src')

gnome.post_install(
  glib_compile_schemas: true,
  gtk_update_icon_cache: true,
  update_desktop_database: true
  )