/*
* Copyright (c) 2022 Adithyan K V <adithyankv@protonmail.com>
* Copyright (c) 2025 Stella, Charlie, (teamcons on GitHub) and the Ellie_Commons community
*
* This program is free software; you can redistribute it and/or
* modify it under the terms of the GNU General Public
* License as published by the Free Software Foundation; either
* version 2 of the License, or(at your option) any later version.
*
* This program is distributed in the hope that it will be useful,
* but WITHOUT ANY WARRANTY; without even the implied warranty of
* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
* General Public License for more details.
*
* You should have received a copy of the GNU General Public
* License along with this program; if not, write to the
* Free Software Foundation, Inc., 51 Franklin Street, Fifth Floor,
* Boston, MA 02110-1301 USA
*
*/

public class Cherrypick.Application : Gtk.Application {
    private static Window? window;
    private static bool is_immediately_pick = false;

    public const string ACTION_PREFIX = "app.";
    public const string ACTION_QUIT = "action_quit";
    public static Gee.MultiMap<string, string> action_accelerators = new Gee.HashMultiMap<string, string> ();

    private const GLib.ActionEntry[] ACTION_ENTRIES = {
        { ACTION_QUIT, quit}
    };

    public Application () {
        Object (
            application_id: APP_ID,
            flags: ApplicationFlags.HANDLES_COMMAND_LINE
        );
    }

    construct {
        Intl.setlocale (LocaleCategory.ALL, "");
        Intl.bindtextdomain (GETTEXT_PACKAGE, LOCALEDIR);
        Intl.bind_textdomain_codeset (GETTEXT_PACKAGE, "UTF-8");
        Intl.textdomain (GETTEXT_PACKAGE);
    }

    public override void startup () {
        base.startup ();
        Gtk.init ();
        Granite.init ();

        add_action_entries (ACTION_ENTRIES, this);
        set_accels_for_action ("app.action_quit", {"<Control>q"});

        var granite_settings = Granite.Settings.get_default ();
        var gtk_settings = Gtk.Settings.get_default ();
        gtk_settings.gtk_icon_theme_name = "elementary";
        gtk_settings.gtk_theme_name = "io.elementary.stylesheet.strawberry";

        gtk_settings.gtk_application_prefer_dark_theme = (
            granite_settings.prefers_color_scheme == DARK
        );

        granite_settings.notify["prefers-color-scheme"].connect (() => {
            gtk_settings.gtk_application_prefer_dark_theme = (
                granite_settings.prefers_color_scheme == DARK
            );
        });

        var provider = new Gtk.CssProvider ();
        provider.load_from_resource (APP_PATH + "Application.css");
        Gtk.StyleContext.add_provider_for_display (
            Gdk.Display.get_default (),
            provider,
            Gtk.STYLE_PROVIDER_PRIORITY_APPLICATION
        );

    }

    public override void activate () {

        if (window == null) {
            window = new Cherrypick.Window () {
                application = this
            };
            window.show ();

        } else {
            window.present ();
        }

        /* Opens and immediately starts picking color if the --immediately-pick
            flag is passed when launching from the command line. This could
            be helpful for the user to set up keybindings and stuff */
        if (is_immediately_pick) {
            window.activate_action (MainView.ACTION_PREFIX + MainView.ACTION_PICK, null);
            is_immediately_pick = false;
        };
    }

    public static int main (string[] args) {
        return new Application ().run (args);
    }

    public override int command_line (ApplicationCommandLine command_line) {
        debug ("Parsing commandline arguments");

        OptionEntry[] cmd_option_entries = {
            {"immediately-pick", 'p', OptionFlags.NONE, OptionArg.NONE, ref is_immediately_pick, _("Pick a colour and copy it to clipboard"), null}
        };

        // We have to make an extra copy of the array, since .parse assumes
        // that it can remove strings from the array without freeing them.
        string[] args = command_line.get_arguments ();
        string[] _args = new string[args.length];
        for (int i = 0; i < args.length; i++) {
            _args[i] = args[i];
        }

        try {
            var ctx = new OptionContext ();
            ctx.set_help_enabled (true);
            ctx.add_main_entries (cmd_option_entries, null);
            unowned string[] tmp = _args;
            ctx.parse (ref tmp);

        } catch (OptionError e) {
            command_line.print ("error: %s\n", e.message);
            return 0;
        }

        activate ();
        return 0;
    }


}
