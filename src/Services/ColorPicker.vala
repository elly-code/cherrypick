/*
 * SPDX-License-Identifier: GPL-3.0-or-later
 * SPDX-FileCopyrightText:  2022 Adithyan K V <adithyankv@protonmail.com>
 *                          2025 Contributions from the ellie-Commons community (github.com/ellie-commons/)
 *                          2025-2026 Stella & Charlie (teamcons.carrd.co)
 */
/**
* Service responsible for interacting with portals
* It will communicate via the signal picked () when it is done
* It communicates results to the ColorController
*/
public class Cherrypick.ColorPicker : Object {
    private Xdp.Portal portal;
    public ColorController color_controller;

    public signal void picked ();

    construct {
        color_controller = ColorController.get_instance ();
    }

    public async void pick () {
        portal = new Xdp.Portal ();
        portal.pick_color.begin (null, null, color_picked);
    }

    private void color_picked (Object? obj, AsyncResult result) {
        try {
            var color = portal.pick_color.end (result);
            double r, g, b;

            VariantIter iter = color.iterator ();
            iter.next ("d", out r);
            iter.next ("d", out g);
            iter.next ("d", out b);

            var picked_color = new Color () {
                red = (uint8) (r * 255),
                green = (uint8) (g * 255),
                blue = (uint8) (b * 255),
                alpha = (double) 1.0
            };

            color_controller.last_picked_color = picked_color;
            color_controller.color_history.append (picked_color);
            picked ();

        } catch (Error e) {
            critical (e.message);
        }
    }
}
