/*
 * SPDX-License-Identifier: GPL-3.0-or-later
 * SPDX-FileCopyrightText:  2022 Adithyan K V <adithyankv@protonmail.com>
 *                          2025 Contributions from the ellie-Commons community (github.com/ellie-commons/)
 *                          2025-2026 Stella & Charlie (teamcons.carrd.co)
 */

public class Cherrypick.Window : Gtk.ApplicationWindow {

    public Window () {
        Object (
            ///TRANSLATORS: Do not translate app name
            title: _("Cherrypick"),
            default_width: 480,
            default_height: 240,
            resizable: false
        );
    }

    construct {
        Intl.setlocale ();

        // We need to hide the title area for the split headerbar
        titlebar = new Gtk.Grid () {visible = false};

        var titlelabel = new Gtk.Label (_("Cherrypick"));
        titlelabel.add_css_class (Granite.STYLE_CLASS_TITLE_LABEL);

#if DEVEL
        title = _("Cherrypick (Devel)");
        titlelabel.label = _("Cherrypick (Devel)");
        add_css_class (DEVEL);
#endif

        var headerbar = new Gtk.HeaderBar () {
            title_widget = titlelabel
        };
        headerbar.add_css_class (Granite.STYLE_CLASS_FLAT);
        //headerbar.show_title_buttons = false;
        //headerbar.pack_start (new Gtk.WindowControls (Gtk.PackType.START));

        var main_view = new Cherrypick.MainView ();
        var actions = new SimpleActionGroup ();
        actions.add_action_entries (MainView.ACTION_ENTRIES, this);
        insert_action_group ("view", main_view.actions);

        /* We want the color preview area to span the entire height of the
            window, so using a custom grid layout for the entire window
            including the headerbar */
        var window_grid = new Gtk.Grid ();
        window_grid.attach (headerbar, 0, 0);
        window_grid.attach (main_view, 0, 1);
        window_grid.attach (new Cherrypick.ColorPreview (), 1, 0, 1, 2);

        /* As the headerbar spans only half the window, it would be
            more convenient to be able to move the window from anywhere */
        var window_handle = new Gtk.WindowHandle () {
            child = window_grid
        };
        child = window_handle;

        /* when the app is opened the user probably wants to pick the color
            straight away. So setting the pick button as focused default
            action so that pressing Return or Space starts the pick */
        set_focus (main_view.pick_button);
    }
}
