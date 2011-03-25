/*!
    \page Test-TimePicker
    \title Test-TimePicker
    \unittest Test TimePicker

    \testcase timePicker_properties
    \testcm Checks if switching hr24 correctly updates the current hour \endtestcm

    Units tests for the component \l { TimePicker }
*/

import Qt 4.7
import QtQuickTest 1.0
import Otc.Components 0.1

TimePicker {
    id: timePicker

    height: 800
    width: height * 0.6

    TestCase {
        id: propertyTest
        name: "test_timePicker_properties"

        function test_timePicker_hr24() {
            //set initial system to 12 hour system
            timePicker.hr24 = false
            //the AM/PM toggle is on false (= PM) as default

            //switch hour system and check hour value
            timePicker.hours = 8
            timePicker.hr24 = true
            compare( timePicker.hours, 20, "switching 8 from 12 to 24 hour system failed" )

            timePicker.hours = 16
            timePicker.hr24 = false
            compare( timePicker.hours, 4, "switching 16 from 24 to 12 hour system failed" )

            timePicker.hours = 12
            timePicker.hr24 = true
            compare( timePicker.hours, 0, "switching 12 from 12 to 24 hour system failed" )

            timePicker.hours = 0
            timePicker.hr24 = false
            compare( timePicker.hours, 12, "switching 0 from 24 to 12 hour system failed" )

        }

    }
}
