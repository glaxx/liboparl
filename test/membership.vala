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
    public class MembershipTest {
        private static GLib.HashTable<string,string> test_input;

        private static void init() {
            MembershipTest.test_input = new GLib.HashTable<string,string>(GLib.str_hash, GLib.str_equal);

            MembershipTest.test_input.insert("https://oparl.example.org/", Fixtures.system_sane);
            MembershipTest.test_input.insert("https://oparl.example.org/bodies", Fixtures.body_list_sane);
            MembershipTest.test_input.insert("https://oparl.example.org/organization/0", Fixtures.organization_sane);
            MembershipTest.test_input.insert("https://oparl.example.org/body/0/people/", Fixtures.person_list_sane);
            MembershipTest.test_input.insert("https://oparl.example.org/membership/0", Fixtures.membership_sane_1);
            MembershipTest.test_input.insert("https://oparl.example.org/membership/1", Fixtures.membership_sane_2);
        }

        public static void add_tests () {
            MembershipTest.init();

            Test.add_func ("/oparl/membership/sane_input", () => {
                var client = new Client();
                client.resolve_url.connect((url)=>{
                    return MembershipTest.test_input.get(url);
                });
                System s;
                try {
                    s = client.open("https://oparl.example.org/");
                } catch (ParsingError e) {
                    GLib.assert_not_reached();
                }

                try {
                    Body b = s.get_body().nth_data(0);
                    Person p = b.get_person().nth_data(0);
                    Membership m = p.membership.nth_data(1);

                    assert (m.id == "https://oparl.example.org/membership/1");
                    assert (m.get_organization() != null);
                    assert (m.get_organization() is OParl.Organization);
                    assert (m.get_on_behalf_of() != null);
                    assert (m.get_on_behalf_of() is OParl.Organization);
                    assert (m.get_person() != null);
                    assert (m.get_person() is OParl.Person);
                    assert (m.role == "Sachkundige Bürgerin");
                    assert (m.voting_right == false);
                    assert (m.start_date.to_string() == "2013-12-02T00:00:00+0000");
                    assert (m.end_date.to_string() == "2014-07-27T00:00:00+0000");
                } catch (ParsingError e) {
                    GLib.assert_not_reached();
                }
            });

            Test.add_func ("/oparl/membership/wrong_id_type", () => {
                var client = new Client();
                client.resolve_url.connect((url)=>{
                    return MembershipTest.test_input.get(url).replace(
                        "\"https://oparl.example.org/membership/1\"", "1"
                    );
                });
                try {
                    System s = client.open("https://oparl.example.org/");
                    Body b = s.get_body().nth_data(0);
                    Person p = b.get_person().nth_data(0);
                    p.membership.nth_data(1);
                    GLib.assert_not_reached();
                } catch (ParsingError e) {
                    assert(e.message.contains("'id'"));
                }
            });

            Test.add_func ("/oparl/membership/wrong_organization_type", () => {
                var client = new Client();
                client.resolve_url.connect((url)=>{
                    return MembershipTest.test_input.get(url).replace(
                        "\"https://oparl.example.org/organization/0\"", "1"
                    );
                });
                try {
                    System s = client.open("https://oparl.example.org/");
                    Body b = s.get_body().nth_data(0);
                    Person p = b.get_person().nth_data(0);
                    p.membership.nth_data(1);
                    GLib.assert_not_reached();
                } catch (ParsingError e) {
                    assert(e.message.contains("'organizations'"));
                }
            });

            Test.add_func ("/oparl/membership/wrong_role_type", () => {
                var client = new Client();
                client.resolve_url.connect((url)=>{
                    return MembershipTest.test_input.get(url).replace(
                        "\"Sachkundige Bürgerin\"", "1"
                    );
                });
                try {
                    System s = client.open("https://oparl.example.org/");
                    Body b = s.get_body().nth_data(0);
                    Person p = b.get_person().nth_data(0);
                    p.membership.nth_data(1);
                    GLib.assert_not_reached();
                } catch (ParsingError e) {
                    assert(e.message.contains("'role'"));
                }
            });

            Test.add_func ("/oparl/membership/wrong_voting_right_type", () => {
                var client = new Client();
                client.resolve_url.connect((url)=>{
                    return MembershipTest.test_input.get(url).replace(
                        "false", "\"foobar\""
                    );
                });
                try {
                    System s = client.open("https://oparl.example.org/");
                    Body b = s.get_body().nth_data(0);
                    Person p = b.get_person().nth_data(0);
                    p.membership.nth_data(1);
                    GLib.assert_not_reached();
                } catch (ParsingError e) {
                    assert(e.message.contains("'votingRight'"));
                }
            });

            Test.add_func ("/oparl/membership/wrong_start_date_type", () => {
                var client = new Client();
                client.resolve_url.connect((url)=>{
                    return MembershipTest.test_input.get(url).replace(
                        "\"2013-12-02\"", "1"
                    );
                });
                try {
                    System s = client.open("https://oparl.example.org/");
                    Body b = s.get_body().nth_data(0);
                    Person p = b.get_person().nth_data(0);
                    p.membership.nth_data(1);
                    GLib.assert_not_reached();
                } catch (ParsingError e) {
                    assert(e.message.contains("'startDate'"));
                }
            });

            Test.add_func ("/oparl/membership/wrong_end_date_type", () => {
                var client = new Client();
                client.resolve_url.connect((url)=>{
                    return MembershipTest.test_input.get(url).replace(
                        "\"2014-07-27\"", "1"
                    );
                });
                try {
                    System s = client.open("https://oparl.example.org/");
                    Body b = s.get_body().nth_data(0);
                    Person p = b.get_person().nth_data(0);
                    p.membership.nth_data(1);
                    GLib.assert_not_reached();
                } catch (ParsingError e) {
                    assert(e.message.contains("'endDate'"));
                }
            });
        }
    }
}
