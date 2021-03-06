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
    class Main {
        public static int main (string[] args) {
            Test.init (ref args);
            Test.set_nonfatal_assertions();
            ObjectTest.add_tests ();
            SystemTest.add_tests ();
            BodyTest.add_tests ();
            LegislativeTermTest.add_tests ();
            LocationTest.add_tests ();
            OrganizationTest.add_tests ();
            PersonTest.add_tests ();
            MembershipTest.add_tests ();
            MeetingTest.add_tests ();
            AgendaItemTest.add_tests ();
            PaperTest.add_tests ();
            ConsultationTest.add_tests ();
            FileTest.add_tests ();
            Test.run ();
            return 0;
        }
    }
}
