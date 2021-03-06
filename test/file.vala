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
    public class FileTest {
        private static GLib.HashTable<string,string> test_input;

        private static void init() {
            FileTest.test_input = new GLib.HashTable<string,string>(GLib.str_hash, GLib.str_equal);

            FileTest.test_input.insert("https://oparl.example.org/", Fixtures.system_sane);
            FileTest.test_input.insert("https://oparl.example.org/bodies", Fixtures.body_list_sane);
            FileTest.test_input.insert("https://oparl.example.org/body/0/papers/", Fixtures.paper_list_sane);
            FileTest.test_input.insert("https://oparl.example.org/paper/0", Fixtures.paper_sane);
            FileTest.test_input.insert("https://oparl.example.org/agendaitem/0", Fixtures.agenda_item_sane);
            FileTest.test_input.insert("https://oparl.example.org/meeting/0", Fixtures.meeting_sane);
            FileTest.test_input.insert("https://oparl.example.org/file/0", Fixtures.file_sane);
        }

        public static void add_tests () {
            FileTest.init();

            Test.add_func ("/oparl/file/sane_input", () => {
                var client = new Client();
                client.resolve_url.connect((url)=>{
                    return FileTest.test_input.get(url);
                });
                System s;
                try {
                    s = client.open("https://oparl.example.org/");
                } catch (ParsingError e) {
                    GLib.assert_not_reached();
                }

                try {
                    Body b = s.get_body().nth_data(0);
                    Paper p = b.get_paper().nth_data(0);
                    OParl.File f = p.auxiliary_file.nth_data(0);

                    assert (f.id == "https://oparl.example.org/file/0");
                    assert (f.name == "Nachtrags-Tagesordnung");
                    assert (f.file_name == "nachtrag-TO.pdf");
                    assert (f.mime_type == "application/pdf");
                    assert (f.date.to_string() == "2012-01-08T00:00:00+0000");
                    assert (f.sha1_checksum == "da39a3ee5e6b4b0d3255bfef95601890afd80709");
                    assert (f.size == 82930);
                    assert (f.access_url == "https://oparl.example.org/file/0.pdf");
                    assert (f.download_url  == "https://oparl.example.org/file/download/0.pdf");
                    assert (f.modified.to_string() == "2012-01-08T14:05:27+0000");
                    assert (f.external_service_url == "https://www.youtube.com/watch?v=MKp30C3MwVk");
                    assert (f.text == "blablatextblabla");
                    assert (f.get_master_file() != null);
                    assert (f.get_master_file() is OParl.File);
                    assert (f.get_derivative_file() != null);
                    assert (f.get_derivative_file().nth_data(0) is OParl.File);
                    assert (f.get_meeting() != null);
                    assert (f.get_meeting().nth_data(0) is Meeting);
                    assert (f.get_paper() != null);
                    assert (f.get_paper().nth_data(0) is Paper);
                    assert (f.get_agenda_item() != null);
                    assert (f.get_agenda_item().nth_data(0) is AgendaItem);
                    assert (f.file_license == "http://www.wtfpl.net/wp-content/uploads/2012/12/wtfpl-badge-1.png");
                } catch (ParsingError e) {
                    GLib.assert_not_reached();
                }
            });

            Test.add_func ("/oparl/file/wrong_id_type", () => {
                var client = new Client();
                client.resolve_url.connect((url)=>{
                    return FileTest.test_input.get(url).replace(
                        "\"https://oparl.example.org/file/0\"", "1"
                    );
                });
                try {
                    System s = client.open("https://oparl.example.org/");
                    Body b = s.get_body().nth_data(0);
                    Paper p = b.get_paper().nth_data(0);
                    p.auxiliary_file.nth_data(0);
                    GLib.assert_not_reached();
                } catch (ParsingError e) {
                    assert(e.message.contains("'id'"));
                }
            });

            Test.add_func ("/oparl/file/wrong_name_type", () => {
                var client = new Client();
                client.resolve_url.connect((url)=>{
                    return FileTest.test_input.get(url).replace(
                        "\"Nachtrags-Tagesordnung\"", "1"
                    );
                });
                try {
                    System s = client.open("https://oparl.example.org/");
                    Body b = s.get_body().nth_data(0);
                    Paper p = b.get_paper().nth_data(0);
                    p.auxiliary_file.nth_data(0);
                    GLib.assert_not_reached();
                } catch (ParsingError e) {
                    assert(e.message.contains("'name'"));
                }
            });

            Test.add_func ("/oparl/file/wrong_file_name_type", () => {
                var client = new Client();
                client.resolve_url.connect((url)=>{
                    return FileTest.test_input.get(url).replace(
                        "\"nachtrag-TO.pdf\"", "1"
                    );
                });
                try {
                    System s = client.open("https://oparl.example.org/");
                    Body b = s.get_body().nth_data(0);
                    Paper p = b.get_paper().nth_data(0);
                    p.auxiliary_file.nth_data(0);
                    GLib.assert_not_reached();
                } catch (ParsingError e) {
                    assert(e.message.contains("'fileName'"));
                }
            });

            Test.add_func ("/oparl/file/wrong_mime_type_type", () => {
                var client = new Client();
                client.resolve_url.connect((url)=>{
                    return FileTest.test_input.get(url).replace(
                        "\"application/pdf\"", "1"
                    );
                });
                try {
                    System s = client.open("https://oparl.example.org/");
                    Body b = s.get_body().nth_data(0);
                    Paper p = b.get_paper().nth_data(0);
                    p.auxiliary_file.nth_data(0);
                    GLib.assert_not_reached();
                } catch (ParsingError e) {
                    assert(e.message.contains("'mimeType'"));
                }
            });

            Test.add_func ("/oparl/file/wrong_date_type", () => {
                var client = new Client();
                client.resolve_url.connect((url)=>{
                    return FileTest.test_input.get(url).replace(
                        "\"2012-01-08\"", "1"
                    );
                });
                try {
                    System s = client.open("https://oparl.example.org/");
                    Body b = s.get_body().nth_data(0);
                    Paper p = b.get_paper().nth_data(0);
                    p.auxiliary_file.nth_data(0);
                    GLib.assert_not_reached();
                } catch (ParsingError e) {
                    assert(e.message.contains("'date'"));
                }
            });

            Test.add_func ("/oparl/file/wrong_sha1_checksum_type", () => {
                var client = new Client();
                client.resolve_url.connect((url)=>{
                    return FileTest.test_input.get(url).replace(
                        "\"da39a3ee5e6b4b0d3255bfef95601890afd80709\"", "1"
                    );
                });
                try {
                    System s = client.open("https://oparl.example.org/");
                    Body b = s.get_body().nth_data(0);
                    Paper p = b.get_paper().nth_data(0);
                    p.auxiliary_file.nth_data(0);
                    GLib.assert_not_reached();
                } catch (ParsingError e) {
                    assert(e.message.contains("'sha1Checksum'"));
                }
            });

            Test.add_func ("/oparl/file/wrong_size_type", () => {
                var client = new Client();
                client.resolve_url.connect((url)=>{
                    return FileTest.test_input.get(url).replace(
                        "82930", "\"1\""
                    );
                });
                try {
                    System s = client.open("https://oparl.example.org/");
                    Body b = s.get_body().nth_data(0);
                    Paper p = b.get_paper().nth_data(0);
                    p.auxiliary_file.nth_data(0);
                    GLib.assert_not_reached();
                } catch (ParsingError e) {
                    assert(e.message.contains("'size'"));
                }
            });

            Test.add_func ("/oparl/file/wrong_access_url_type", () => {
                var client = new Client();
                client.resolve_url.connect((url)=>{
                    return FileTest.test_input.get(url).replace(
                        "\"https://oparl.example.org/file/0.pdf\"", "1"
                    );
                });
                try {
                    System s = client.open("https://oparl.example.org/");
                    Body b = s.get_body().nth_data(0);
                    Paper p = b.get_paper().nth_data(0);
                    p.auxiliary_file.nth_data(0);
                    GLib.assert_not_reached();
                } catch (ParsingError e) {
                    assert(e.message.contains("'accessUrl'"));
                }
            });

            Test.add_func ("/oparl/file/wrong_download_url_type", () => {
                var client = new Client();
                client.resolve_url.connect((url)=>{
                    return FileTest.test_input.get(url).replace(
                        "\"https://oparl.example.org/file/download/0.pdf\"", "1"
                    );
                });
                try {
                    System s = client.open("https://oparl.example.org/");
                    Body b = s.get_body().nth_data(0);
                    Paper p = b.get_paper().nth_data(0);
                    p.auxiliary_file.nth_data(0);
                    GLib.assert_not_reached();
                } catch (ParsingError e) {
                    assert(e.message.contains("'downloadUrl'"));
                }
            });

            Test.add_func ("/oparl/file/wrong_external_service_url_type", () => {
                var client = new Client();
                client.resolve_url.connect((url)=>{
                    return FileTest.test_input.get(url).replace(
                        "\"https://www.youtube.com/watch?v=MKp30C3MwVk\"", "1"
                    );
                });
                try {
                    System s = client.open("https://oparl.example.org/");
                    Body b = s.get_body().nth_data(0);
                    Paper p = b.get_paper().nth_data(0);
                    p.auxiliary_file.nth_data(0);
                    GLib.assert_not_reached();
                } catch (ParsingError e) {
                    assert(e.message.contains("'externalServiceUrl'"));
                }
            });

            Test.add_func ("/oparl/file/wrong_text_type", () => {
                var client = new Client();
                client.resolve_url.connect((url)=>{
                    return FileTest.test_input.get(url).replace(
                        "\"blablatextblabla\"", "1"
                    );
                });
                try {
                    System s = client.open("https://oparl.example.org/");
                    Body b = s.get_body().nth_data(0);
                    Paper p = b.get_paper().nth_data(0);
                    p.auxiliary_file.nth_data(0);
                    GLib.assert_not_reached();
                } catch (ParsingError e) {
                    assert(e.message.contains("'text'"));
                }
            });
            // TODO: maybe also check composite types
        }
    }
}
