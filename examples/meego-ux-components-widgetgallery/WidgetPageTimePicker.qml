/*
 * Copyright 2011 Intel Corporation.
 *
 * This program is licensed under the terms and conditions of the
 * LGPL, version 2.1.  The full text of the LGPL Licence is at
 * http://www.gnu.org/licenses/lgpl.html
 */

/* This pages opens the TimePicker.qml and offers controls to manipulate it.
 */

import Qt 4.7
import MeeGo.Components 0.1


WidgetPage {
    id: widgetPage

    pageTitle: "TimePicker"

    controlContent: [
        LabeledEntry {
            id: hoursEntry

            label:  "hours: "
            defaultValue: timePicker.hours

            onTextUpdated: {
                if( value < 0 ){
                    text = "0"
                    timePicker.hours = 0
                }else if( value > 23 ) {
                    text = "23"
                    timePicker.hours = 23
                }else{
                    timePicker.hours = value
                }
            }
        },

        LabeledEntry {
            id: minutesEntry

            label:  "minutes: "
            defaultValue: timePicker.minutes

            onTextUpdated: {
                if( value < 0 ){
                    text = "0"
                    timePicker.minutes = 0
                }else if( value > 60 ) {
                    text = "60"
                    timePicker.minutes = 60
                }else{
                    timePicker.minutes = value
                }
            }
        },

        LabeledEntry {
            id: incrementEntry

            label:  "minutesIncrement: "
            defaultValue: timePicker.minutesIncrement
            text: "1"

            onTextUpdated: {
                if( value < 1 ){
                    text = "1"
                    timePicker.minutesIncrement = 1
                }else if( value > 60 ) {
                    text = "60"
                    timePicker.minutesIncrement = 60
                }else{
                    timePicker.minutesIncrement = value
                }
            }
        },

        CheckBoxEntry {
            id: timeSystemBox

            label: "hr24:"
        }
    ]

    statusContent: [
        StatusEntry {
            id: signalEntry

            label: "Last signal: "
            value: "-"
        },

        StatusEntry {
            id: timeEntry

            label: "Selected time: "
            value: "-"
        },

        StatusEntry {
            id: hoursStatus

            label: "Hours: "
            value: "-"
        },

        StatusEntry {
            id: minutesStatus

	    label: "Minutes: "
	    value: "-"
        }
    ]

    description: "This page brings up the time picker when the button at the bottom is clicked. \n \n"
               + "The minutes increment sets the step width used to display and select the minutes in the time picker. "
               + "Setting it to 15 for example will only display the minutes 0, 15, 30 and 45. "
               + "Only values from 0 to 60 are accepted. Values below 0 are set to 0 and values over 60 are set to 60. \n\n"
               + "hr24: use 24 hour system"

    widget: Button {
        id: button

        anchors.centerIn: parent
        width:  240
        height:  80
        text: "Show TimePicker"

        onClicked: { timePicker.show() }
    }

    TimePicker {
        id: timePicker

        hr24: timeSystemBox.isChecked
        minutesIncrement: +incrementEntry.text

        onAccepted: {
            timeEntry.value = time
            hoursStatus.value = hours
            minutesStatus.value = minutes
            signalEntry.value = "accepted"
        }
        onRejected: {
            timeEntry.value = "-"
            hoursStatus.value = "-"
            minutesStatus.value = "-"
            signalEntry.value = "rejected"
        }
    }

    TopItem {
        id: topItem
    }
}


