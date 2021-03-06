/********************************************************************
# Copyright 2016-2017 Daniel 'grindhold' Brendle
#
# This file is part of liboparl.
#
# liboparl is free software: you can redistribute it and/or
# modify it under the terms of the GNU Lesser General Public License
# as published by the Free Software Foundation, either
# version 3 of the License, or (at your option) any later
# version.
#
# liboparl is distributed in the hope that it will be
# useful, but WITHOUT ANY WARRANTY; without even the implied
# warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR
# PURPOSE. See the GNU Lesser General Public License for more details.
#
# You should have received a copy of the GNU Lesser General Public
# License along with liboparl.
# If not, see http://www.gnu.org/licenses/.
*********************************************************************/

using OParl;

namespace OParlTest {
    public class LocationTest {
        private static GLib.HashTable<string,string> test_input;

        private static void init() {
            LocationTest.test_input = new GLib.HashTable<string,string>(GLib.str_hash, GLib.str_equal);

            LocationTest.test_input.insert("https://oparl.example.org/", Fixtures.system_sane);
            LocationTest.test_input.insert("https://oparl.example.org/bodies", Fixtures.body_list_sane);
            LocationTest.test_input.insert("https://oparl.example.org/body/0", Fixtures.body_sane);
            LocationTest.test_input.insert("https://oparl.example.org/organization/0", Fixtures.organization_sane);
            LocationTest.test_input.insert("https://oparl.example.org/meeting/0", Fixtures.meeting_sane);
            LocationTest.test_input.insert("https://oparl.example.org/paper/0", Fixtures.paper_sane);
            LocationTest.test_input.insert("https://oparl.example.org/location/0", Fixtures.location_sane);
        }

        public static void add_tests () {
            LocationTest.init();

            Test.add_func ("/oparl/location/sane_input", () => {
                var client = new Client();
                client.resolve_url.connect((url)=>{
                    return LocationTest.test_input.get(url);
                });
                System s;
                try {
                    s = client.open("https://oparl.example.org/");
                } catch (ParsingError e) {
                    GLib.assert_not_reached();
                }

                try {
                    Body b = s.get_body().nth_data(0);
                    Location l = b.location;

                    assert (l != null);
                    assert (l.id == "https://oparl.example.org/location/0");
                    assert (l.description == "Rathaus der Beispielstadt, Ratshausplatz 1, 12345 Beispielstadt");
                    assert (l.street_address == "Rathausplatz 1");
                    assert (l.room == "1337");
                    assert (l.postal_code == "13337");
                    assert (l.sub_locality == "Beispielbezirk");
                    assert (l.locality == "Beispielstadt");
                    assert (l.get_bodies() != null);
                    assert (l.get_bodies().length() == 1);
                    assert (l.get_organizations() != null);
                    assert (l.get_organizations().length() == 1);
                    assert (l.get_meetings() != null);
                    assert (l.get_meetings().length() == 1);
                    assert (l.get_papers() != null);
                    assert (l.get_papers().length() == 1);
                    assert (l.geojson != null);
                } catch (ParsingError e) {
                    GLib.assert_not_reached();
                }
            });

            Test.add_func ("/oparl/location/wrong_description_type", () => {
                var client = new Client();
                client.resolve_url.connect((url)=>{
                    return LocationTest.test_input.get(url).replace(
                        "\"Rathaus der Beispielstadt, Ratshausplatz 1, 12345 Beispielstadt\"", "1"
                    );
                });
                try {
                    System s = client.open("https://oparl.example.org/");
                    s.get_body().nth_data(0);
                    GLib.assert_not_reached();
                } catch (ParsingError e) {
                    assert(e.message.contains("'description'"));
                }
            });

            Test.add_func ("/oparl/location/wrong_street_address_type", () => {
                var client = new Client();
                client.resolve_url.connect((url)=>{
                    return LocationTest.test_input.get(url).replace(
                        "\"Rathausplatz 1\"", "1"
                    );
                });
                try {
                    System s = client.open("https://oparl.example.org/");
                    s.get_body().nth_data(0);
                    GLib.assert_not_reached();
                } catch (ParsingError e) {
                    assert(e.message.contains("'streetAddress'"));
                }
            });

            Test.add_func ("/oparl/location/wrong_room_type", () => {
                var client = new Client();
                client.resolve_url.connect((url)=>{
                    return LocationTest.test_input.get(url).replace(
                        "\"1337\"", "1"
                    );
                });
                try {
                    System s = client.open("https://oparl.example.org/");
                    s.get_body().nth_data(0);
                    GLib.assert_not_reached();
                } catch (ParsingError e) {
                    assert(e.message.contains("'room'"));
                }
            });

            Test.add_func ("/oparl/location/wrong_postal_code_type", () => {
                var client = new Client();
                client.resolve_url.connect((url)=>{
                    return LocationTest.test_input.get(url).replace(
                        "\"13337\"", "1"
                    );
                });
                try {
                    System s = client.open("https://oparl.example.org/");
                    s.get_body().nth_data(0);
                    GLib.assert_not_reached();
                } catch (ParsingError e) {
                    assert(e.message.contains("'postalCode'"));
                }
            });

            Test.add_func ("/oparl/location/wrong_sub_locality_type", () => {
                var client = new Client();
                client.resolve_url.connect((url)=>{
                    return LocationTest.test_input.get(url).replace(
                        "\"Beispielbezirk\"", "1"
                    );
                });
                try {
                    System s = client.open("https://oparl.example.org/");
                    s.get_body().nth_data(0);
                    GLib.assert_not_reached();
                } catch (ParsingError e) {
                    assert(e.message.contains("'subLocality'"));
                }
            });

            Test.add_func ("/oparl/location/wrong_locality_type", () => {
                var client = new Client();
                client.resolve_url.connect((url)=>{
                    return LocationTest.test_input.get(url).replace(
                        "\"Beispielstadt\"", "1"
                    );
                });
                try {
                    System s = client.open("https://oparl.example.org/");
                    s.get_body().nth_data(0);
                    GLib.assert_not_reached();
                } catch (ParsingError e) {
                    assert(e.message.contains("'locality'"));
                }
            });
       }
    }
}
