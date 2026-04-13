/*
 * SPDX-License-Identifier: GPL-3.0-or-later
 * SPDX-FileCopyrightText:  2022 Adithyan K V <adithyankv@protonmail.com>
 *                          2025 Contributions from the ellie-Commons community (github.com/ellie-commons/)
 *                          2025-2026 Stella & Charlie (teamcons.carrd.co)
 */
/**
* Wrapper around GLib.Settings to retried it directly via get_instance ()
*/
public class Cherrypick.Settings: GLib.Settings {
    private static Settings? instance;

    public static Settings get_instance () {
        if (instance == null) {
            instance = new Settings ();
        }
        return instance;
    }

    private Settings () {
        Object (
            schema_id: APP_ID
        );
    }
}

