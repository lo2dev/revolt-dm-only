/* window.vala
 *
 * Copyright 2024 Gauss
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 *
 * SPDX-License-Identifier: GPL-3.0-or-later
 */

namespace RevoltDmOnly {
	[GtkTemplate (ui = "/io/github/lo2dev/revoltDmOnly/window.ui")]
	public class Window : Adw.ApplicationWindow {
		[GtkChild]
		private unowned Gtk.ListBox dm_listbox;
		[GtkChild]
		private unowned Adw.NavigationView nav_view;

		public Window (Gtk.Application app) {
			Object (application: app);
		}

		construct {
            Soup.Session global_session = new Soup.Session ();
            RevoltApi api = new RevoltApi (global_session);
            WebsocketClient websocket_client = new WebsocketClient (global_session, "TOKEN");
            websocket_client.ws_connect.begin ((obj, res) => {
                websocket_client.ws_connect.end (res);
            });

            Json.Array ready_users_json = websocket_client.ready_users;

            int i2 = 0;
            ready_users_json.foreach_element ((user) => {
                message (user.get_element (i2).get_object ().get_string_member ("username"));
            });

            api.fetchDMs.begin ((obj, res) => {
                Json.Array dms_list = api.fetchDMs.end (res);

				int i = 0;
 				dms_list.foreach_element ((dm) => {

                    var dm_element = dm.get_object_element (i);

					var dm_row = new Adw.ActionRow () {
						title = dm_element.get_string_member ("_id"),
					};

					var dm_avatar = new Adw.Avatar (35, @"$(dm_element.get_string_member ("_id"))", false);
	                var dm_row_suffix = new Gtk.Button () {
                        label = "chat",
                        has_frame = false,
                        valign = Gtk.Align.CENTER,
                    };

	                dm_row_suffix.clicked.connect (() => {
                        var dm_chat_page = new RevoltDmOnly.ChatPage () {
                            title = dm_element.get_string_member ("_id"),
                        };
                        this.nav_view.push (dm_chat_page);
                    });

	                dm_row.add_prefix (dm_avatar);
	                dm_row.add_suffix (dm_row_suffix);
					dm_listbox.append (dm_row);

					i++;
				});
            });
        }
	}
}

