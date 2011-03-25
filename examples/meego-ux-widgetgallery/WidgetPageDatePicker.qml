/*
 * Copyright 2011 Intel Corporation.
 *
 * This program is licensed under the terms and conditions of the
 * LGPL, version 2.1.  The full text of the LGPL Licence is at
 * http://www.gnu.org/licenses/lgpl.html
 */

/* This pages opens the DatePicker.qml and offers controls to manipulate it.
 */

import Qt 4.7
import MeeGo.Components 0.1

WidgetPage {
    id: widgetPage

    pageTitle: "DatePicker"

    controlContent: [
        LabeledEntry {
            id: widthEntry

            label:  "width: "
            defaultValue: datePicker.width

            onTextUpdated: {
                if( value >= 0 ){
                    datePicker.width = value
                }
            }
        },

        LabeledEntry {
            id: heightEntry

            label:  "height: "
            defaultValue: datePicker.height

            onTextUpdated: {
                if( value >= 0 ){
                    datePicker.height = value
                }
            }
        }
    ]

    statusContent: [
        StatusEntry {
            id: signalEntry

            label: "Last signal: "
            value: "-"
        },

        StatusEntry {
            id: stateEntry

            label: "Selected date: "
            value: "-"
        },

        StatusEntry {
            id: futurePastEntry

            label: "Date is: "
            value: "-"

            states: [
                State {
                    name: "future"
                    when: datePicker.isFuture
                    PropertyChanges {
                        target: futurePastEntry
                        value: "future"
                    }
                },
                State {
                    name: "past"
                    when: datePicker.isPast
                    PropertyChanges {
                        target: futurePastEntry
                        value: "past"
                    }
                },
                State {
                    name: "today"
                    when: !datePicker.isPast && !datePicker.isFuture
                    PropertyChanges {
                        target: futurePastEntry
                        value: "today"
                    }
                }
            ]
        }
    ]

    description: "This page brings up the date picker when the button at the bottom is clicked. The controls to the left "
               + "can be used to change the width and height of the date picker to see how its elements adapt to the new "
               + "size. Choosing too small sizes will break the date picker, because at some point all the elements shown "
               + "in the picker won't just fit into small space."

    widget: Button {
        id: button

        anchors.centerIn: parent
        width:  240
        height:  80
        text: "Show DatePicker"

        onClicked: { datePicker.show() }
    }

    DatePicker {
        id: datePicker

        minYear: 1980
        maxYear: 2030

//        width: height * 0.6
//        height: topItem.topItem.height * 0.9

        onDateSelected: {
            stateEntry.value = selectedDate.getDate() + "." + ( selectedDate.getMonth() + 1 ) + "." + selectedDate.getFullYear()
            signalEntry.value = "dateSelected"
        }
        onRejected: {
            stateEntry.value = "-"
            signalEntry.value = "rejected"
        }
    }

    TopItem {
        id: topItem
    }
}

