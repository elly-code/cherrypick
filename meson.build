project(
    'cherrypick', 
    'c', 'vala', 
    version: '2.4.1',
    license: 'GPL-3.0-or-later'
    )

app_name = meson.project_name()
correct_app_id = 'io.github.elly_code.' + app_name
legacy_app_id = 'io.github.ellie_commons.' +  app_name

if get_option('legacy-rdnn')
    app_id = legacy_app_id
    alternate_app_id = correct_app_id
    app_path = '/io/github/ellie_commons/cherrypick'
else
    app_id = correct_app_id
    alternate_app_id = legacy_app_id
    app_path = '/io/github/elly_code/cherrypick'

endif

app_version = meson.project_version()

#================================
# Include Gnome and the translations module
gnome = import('gnome')
i18n = import('i18n')
vala_flags = []

development_build = get_option('development')
if development_build
  app_id +=  '.devel'
  vala_flags += ['--define', 'DEVEL']
endif


# Set our translation domain
add_global_arguments('-DGETTEXT_PACKAGE="@0@"'.format (app_name), language:'c')


#================================

# config_data is reused accross all project to propagate variables we set once
config_data = configuration_data()
config_data.set('LOCALEDIR', get_option('prefix') / get_option('localedir'))
config_data.set('APP_NAME', app_name)
config_data.set('APP_ID', app_id)
config_data.set('APP_PATH', app_path)
config_data.set('APP_VERSION', app_version)

subdir('po')
subdir('data')
subdir('src')

gnome.post_install(
  glib_compile_schemas: true,
  gtk_update_icon_cache: true,
  update_desktop_database: true
  )