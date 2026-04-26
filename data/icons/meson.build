
icon_sizes = ['16', '32', '48', '64', '128']

foreach i : icon_sizes
    install_data(
        'hicolor' / i + '.png',
        install_dir: get_option('datadir') / 'icons' / 'hicolor' / i + 'x' + i / 'apps',
        rename: app_id + '.png'
    )
    install_data(
        'hicolor@2' / i + '@2.png',
        install_dir: get_option('datadir') / 'icons' / 'hicolor' / i + 'x' + i + '@2' / 'apps',
        rename: app_id + '.png'
    )
endforeach