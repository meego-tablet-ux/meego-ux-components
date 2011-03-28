/*!
    \page Test-DatePicker
    \title Test-DatePicker
    \unittest Test DatePicker

    \testcase datePicker_properties
    \testcm Checks if the string lists hold the expected content. \endtestcm

    \testcase datePicker_functions
    \testcm Tests functions and their return values \endtestcm

    Units tests for the component \l { DatePicker }
*/

import Qt 4.7
import QtQuickTest 1.0
import MeeGo.Components 0.1

DatePicker {
    id: datePicker

    height: 800
    width: height * 0.6

    TestCase {
        id: propertyTests
        name: "test_datePicker_properties"

        //check if the days of the week are set correctly
        function test_datePicker_daysOfWeek() {
            compare( datePicker.daysOfWeek[0], "Sun", "daysOfWeek: Sun failed" )
            compare( datePicker.daysOfWeek[1], "Mon", "daysOfWeek: Mon failed" )
            compare( datePicker.daysOfWeek[2], "Tue", "daysOfWeek: Tue failed" )
            compare( datePicker.daysOfWeek[3], "Wed", "daysOfWeek: Wed failed" )
            compare( datePicker.daysOfWeek[4], "Thu", "daysOfWeek: Thu failed" )
            compare( datePicker.daysOfWeek[5], "Fri", "daysOfWeek: Fri failed" )
            compare( datePicker.daysOfWeek[6], "Sat", "daysOfWeek: Sat failed" )
        }

        //check if the abbreviations of the months are set correctly
        function test_datePicker_shortMonths() {
            compare( datePicker.shortMonths[0], "Jan", "shortMonts: Jan failed" )
            compare( datePicker.shortMonths[1], "Feb", "shortMonts: Feb failed" )
            compare( datePicker.shortMonths[2], "Mar", "shortMonts: Mar failed" )
            compare( datePicker.shortMonths[3], "Apr", "shortMonts: Apr failed" )
            compare( datePicker.shortMonths[4], "May", "shortMonts: May failed" )
            compare( datePicker.shortMonths[5], "Jun", "shortMonts: Jun failed" )
            compare( datePicker.shortMonths[6], "Jul", "shortMonts: Jul failed" )
            compare( datePicker.shortMonths[7], "Aug", "shortMonts: Aug failed" )
            compare( datePicker.shortMonths[8], "Sep", "shortMonts: Sep failed" )
            compare( datePicker.shortMonths[9], "Oct", "shortMonts: Oct failed" )
            compare( datePicker.shortMonths[10], "Nov", "shortMonts: Nov failed" )
            compare( datePicker.shortMonths[11], "Dec", "shortMonts: Dec failed" )
        }

        //check if the months are set correctly
        function test_datePicker_fullMonths() {
            compare( datePicker.fullMonths[0], "January", "fullMonths: January failed" )
            compare( datePicker.fullMonths[1], "February", "fullMonths: February failed" )
            compare( datePicker.fullMonths[2], "March", "fullMonths: March failed" )
            compare( datePicker.fullMonths[3], "April", "fullMonths: April failed" )
            compare( datePicker.fullMonths[4], "May", "fullMonths: May failed" )
            compare( datePicker.fullMonths[5], "June", "fullMonths: June failed" )
            compare( datePicker.fullMonths[6], "July", "fullMonths: July failed" )
            compare( datePicker.fullMonths[7], "August", "fullMonths: August failed" )
            compare( datePicker.fullMonths[8], "September", "fullMonths: September failed" )
            compare( datePicker.fullMonths[9], "October", "fullMonths: October failed" )
            compare( datePicker.fullMonths[10], "November", "fullMonths: November failed" )
            compare( datePicker.fullMonths[11], "December", "fullMonths: December failed" )
        }
    }

    TestCase {
        id: functionTest
        name: "test_datePicker_functions"

        //check if the date returned by today() returns true when passed to isCurrentDate()
        function test_datePicker_todayIsCurrentDay() {
            compare( datePicker.isCurrentDate( datePicker.today() ), true, "today or isCurrentDay failed" )
        }

        //check if prevMonth() and nextMonth() correctly decrement and increment the month of a given date
        function test_datePicker_testPrevAndNextMonth() {
            var tempDate = new Date();
            tempDate.setDate(10)
            tempDate.setMonth(10)   //10 corresponds to November
            tempDate.setFullYear(2010)

            tempDate = datePicker.prevMonth( tempDate );
            compare( datePicker.shortMonths[ tempDate.getMonth() ], "Oct", "prevMonth failed" )

            tempDate = datePicker.nextMonth( tempDate );
            compare( datePicker.shortMonths[ tempDate.getMonth() ], "Nov", "nextMonth failed" )
        }
    }
}
