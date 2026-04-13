/*
 * SPDX-License-Identifier: GPL-3.0-or-later
 * SPDX-FileCopyrightText:  2022 Adithyan K V <adithyankv@protonmail.com>
 *                          2025 Contributions from the ellie-Commons community (github.com/ellie-commons/)
 *                          2025-2026 Stella & Charlie (teamcons.carrd.co)
 */
/**
* Buttons for color operation all goes there
*/
class Cherrypick.MainView: Gtk.Box {

    private Granite.Toast toast;
    private ColorPicker color_picker;
    private Cherrypick.FormatArea format_area;
    private HistoryHeader history_header;
    private HistoryButtons history_buttons;
    public Gtk.Button pick_button;

    public SimpleActionGroup actions { get; construct; }
    public const string ACTION_PREFIX = "view.";
    public const string ACTION_PICK = "pick";
    public const string ACTION_COPY = "copy";
    public const string ACTION_PASTE = "paste";
    public const string ACTION_RESET = "reset";
    public const string ACTION_SAVE = "save";
    public const string ACTION_RESTORE = "restore";

    public static Gee.MultiMap<string, string> action_accelerators = new Gee.HashMultiMap<string, string> ();

    public const GLib.ActionEntry[] ACTION_ENTRIES = {
        { ACTION_PICK, on_pick},
        { ACTION_COPY, copy},
        { ACTION_PASTE, paste},
        { ACTION_RESET, reset},
        { ACTION_SAVE, on_save},
        { ACTION_RESTORE, on_restore},
    };

    construct {
        // We use a lot of margin_top for each subelement
        // This way we avoid Le Blank Space caused by overlay eating up spacing
        orientation = Gtk.Orientation.VERTICAL;
        spacing = SPACING_STANDARD;
        vexpand = true;
        valign = Gtk.Align.START;
        margin_start = margin_end = SPACING_DOUBLE;
        margin_top = 0;
        margin_bottom = SPACING_STANDARD;

        actions = new SimpleActionGroup ();
        actions.add_action_entries (ACTION_ENTRIES, this);

        unowned var app = ((Gtk.Application) GLib.Application.get_default ());
        app.set_accels_for_action (ACTION_PREFIX + ACTION_PICK, {"<Control>P"});
        app.set_accels_for_action (ACTION_PREFIX + ACTION_COPY, {"<Control>C"});
        app.set_accels_for_action (ACTION_PREFIX + ACTION_PASTE, {"<Control>V"});
        app.set_accels_for_action (ACTION_PREFIX + ACTION_RESET, {"<Control>W"});
        app.set_accels_for_action (ACTION_PREFIX + ACTION_SAVE, {"<Control>S"});
        app.set_accels_for_action (ACTION_PREFIX + ACTION_RESTORE, {"<Control>R"});


        /* ---------------- TOASTS ---------------- */
        toast = new Granite.Toast ("");
        var overlay = new Gtk.Overlay ();
        overlay.add_overlay (toast);

        /* ---------------- FORMAT ---------------- */
        var format_label = new Gtk.Label (_("Format")) {
            xalign = 0f,
            margin_top = SPACING_STANDARD
        };
        format_label.add_css_class (Granite.STYLE_CLASS_H4_LABEL);
        format_area = new Cherrypick.FormatArea ();


        /* ---------------- HISTORY ---------------- */

        history_header = new HistoryHeader () {
            margin_top = SPACING_DOUBLE
        };

        history_buttons = new HistoryButtons ();

        /* ---------------- BIG BUTTON ---------------- */
        pick_button = new Gtk.Button.with_label (_("Pick Color")) {
            margin_top = SPACING_DOUBLE,
            tooltip_markup = Granite.markup_accel_tooltip (
                {"<Control>P"},
                _("Click to pick a color on the screen"))
        };
        pick_button.add_css_class (Granite.STYLE_CLASS_SUGGESTED_ACTION);



        /* ---------------- PARENT ---------------- */
        append (overlay);
        append (format_label);
        append (format_area);
        append (history_header);
        append (history_buttons);
        append (pick_button);

        color_picker = new ColorPicker ();

        // Make sure all the tooltips are up to date
        history_buttons.update_buttons ();


        /* ---------------- CONNECTS AND BINDS ---------------- */
        format_area.format_selector.notify ["selected"].connect_after (history_buttons.update_buttons);

        format_area.copied.connect (on_message);
        history_header.on_message.connect (on_message);

        color_picker.picked.connect (format_area.copy_to_clipboard);
        pick_button.clicked.connect (on_pick);
    }

    private void on_message (string message) {
        toast.title = message;
        toast.send_notification ();
    }

    public void on_pick () {
        color_picker.pick.begin ();
    }

    public void copy () {
        format_area.copy_to_clipboard ();
    }

    public void paste () {
        format_area.paste_from_clipboard ();
    }

    public void reset () {
        var settings = Cherrypick.Settings.get_instance ();
        settings.reset (KEY_HISTORY);
        ColorController.get_instance ().load_history_from_gsettings ();
        history_buttons.update_buttons ();
        on_message (_("Color palette reset"));
    }

    public void on_save () {
        history_header.on_save ();
    }

    public void on_restore () {
        history_header.on_restore ();
    }
}
