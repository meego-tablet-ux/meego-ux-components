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
            id: incrementEntry

            label:  "minutesIncrement: "
            defaultValue: timePicker.minutesIncrement

            onTextUpdated: {
                if( value < 0 ){
                    text = "0"
                    timePicker.minutesIncrement = 0
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
        minutesIncrement: 1

        onAccepted: {
            timeEntry.value = time
            signalEntry.value = "accepted"
        }
        onRejected: {
            timeEntry.value = "-"
            signalEntry.value = "rejected"
        }
    }

    TopItem {
        id: topItem
    }
}


