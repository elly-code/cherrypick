/*
 * SPDX-License-Identifier: GPL-3.0-or-later
 * SPDX-FileCopyrightText:  2022 Adithyan K V <adithyankv@protonmail.com>
 *                          2025 Contributions from the ellie-Commons community (github.com/ellie-commons/)
 *                          2025-2026 Stella & Charlie (teamcons.carrd.co)
 */
/**
* A label announcing the HistoryButtons, with a couple buttons on the right operating it
*/
class Cherrypick.HistoryHeader: Granite.Bin {

    public signal void on_message (string message);

    construct {
        /* -------- START WIDGET -------- */
        var centerbox = new Gtk.CenterBox ();

        var history_label = new Gtk.Label (_("History")) {
            xalign = 0f
        };
        history_label.add_css_class (Granite.STYLE_CLASS_H4_LABEL);

        /* -------- END WIDGET -------- */
        var right_buttons = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 0);

        var history_save = new Gtk.Button.from_icon_name ("document-save-symbolic") {
            tooltip_text = _("Save a snapshot of current color history")
        };
        history_save.add_css_class (Granite.STYLE_CLASS_FLAT);

        var history_restore = new Gtk.Button.from_icon_name ("view-refresh-symbolic") {
            tooltip_text = _("Restore history snapshot")
        };
        history_restore.add_css_class (Granite.STYLE_CLASS_FLAT);

        right_buttons.append (history_save);
        right_buttons.append (history_restore);


        /* -------- PARENT WIDGET -------- */
        centerbox.start_widget = history_label;
        //centerbox.end_widget = right_buttons;

        child = centerbox;

        history_save.clicked.connect (on_save);
        history_restore.clicked.connect (on_restore);
    }

    public void on_save () {
        var settings = Settings.get_instance ();
        var snapshot = settings.get_strv (KEY_HISTORY);
        settings.set_strv (KEY_SNAPSHOT, snapshot);
        on_message (_("History saved"));
    }

    public void on_restore () {
        var settings = Settings.get_instance ();
        var snapshot = settings.get_strv (KEY_SNAPSHOT);
        settings.set_strv (KEY_HISTORY, snapshot);
        ColorController.get_instance ().load_history_from_gsettings ();
        on_message (_("History restored"));
    }
}
