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
            id: titleEntry

            label:  "title: "
            defaultValue: "Pick a date"

            onTextUpdated: {
                datePicker.title = value
            }
        },

        LabeledEntry {
            id: widthEntry

            label:  "width: "
            defaultValue: datePicker.width

            onTextUpdated: {
                if( value >= 0 ){
                    datePicker.width = +value
                }
            }
        },

        LabeledEntry {
            id: heightEntry

            label:  "height: "
            defaultValue: datePicker.height

            onTextUpdated: {
                if( value >= 0 ){
                    datePicker.height = +value
                }
            }
        },

        LabeledEntry {
            id: startYearEntry

            label:  "startYear: "
            defaultValue: datePicker.startYear

            onTextUpdated: {
                if( value >= 0 && value <= datePicker.endYear ){
                    datePicker.startYear = +value
                }
            }
        },

        LabeledEntry {
            id: endYearEntry

            label:  "endYear: "
            defaultValue: datePicker.endYear

            onTextUpdated: {
                if( value >= 0 && value >= datePicker.startYear ){
                    datePicker.endYear = +value
                }
            }
        },

        LabeledEntry {
            id: dateOrderEntry

            label: "dateFormat (0=YMD, 1=DMY, 2=MDY): "
            defaultValue: datePicker.dateFormat

            onTextUpdated: {
                datePicker.dateFormat = +value
            }
        },

        LabeledEntry {
            id: firstDayEntry

            label: "firstDayOfWeek (1=Monday .. 7=Sunday): "
            defaultValue: datePicker.firstDayOfWeek

            onTextUpdated: {
                datePicker.firstDayOfWeek = +value
            }
        },

        LabeledEntry {
            id: dateUnitOneEntry

            label: "dateUnitOneText: "
            defaultValue: datePicker.dateUnitOneText

            onTextUpdated: {
                datePicker.dateUnitOneText = value
            }
        },

        LabeledEntry {
            id: dateUnitTwoEntry

            label: "dateUnitTwoText: "
            defaultValue: datePicker.dateUnitTwoText

            onTextUpdated: {
                datePicker.dateUnitTwoText = value
            }
        },

        LabeledEntry {
            id: dateUnitThreeEntry

            label: "dateUnitThreeText: "
            defaultValue: datePicker.dateUnitThreeText

            onTextUpdated: {
                datePicker.dateUnitThreeText = value
            }
        },

        LabeledEntry {
            id: dateUnitFourEntry

            label: "dateUnitFourText: "
            defaultValue: datePicker.dateUnitFourText

            onTextUpdated: {
                datePicker.dateUnitFourText = value
            }
        },
        LabeledEntry {
            id: cancelText

            label:  "cancel text: "
            defaultValue: datePicker.cancelButtonText

            onTextUpdated: {
                datePicker.cancelButtonText = value
            }
        },
        LabeledEntry {
            id: acceptText

            label:  "accept text: "
            defaultValue: datePicker.acceptButtonText

            onTextUpdated: {
                datePicker.acceptButtonText = value
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
        }
    ]

    description: "This page brings up the date picker when the button at the bottom is clicked. The controls to the left "
               + "can be used to change the width and height of the date picker to see how its elements adapt to the new "
               + "size. Choosing too small sizes will break the date picker, because at some point all the elements shown "
               + "in the picker won't just fit into small space. \n"
               + "The following properties are not meant to be part of the API, they exist for demonstration purposes: \n \n"
               + "With dateOrder you can specify in which order the day-, month- and year-spinner are displayed in the "
               + "DatePicker. Any combinations of the keywords \"day\", \"month\" and \"year\" separated by \"-\" are accepted, "
               + "for example \"year-month-day\". \n "
               + "The four dateUnit... entries can be used to set some characters between the spinners, like a \"d\" to mark it "
               + "as days for example or simply a pipe as separator. If the characters don't fit in the small space between "
               + "the spinners, then they won't be displayed at all.\n"

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

        title: "Pick a date"

        startYear: 2008
        endYear: 2012

        onDateSelected: {
            stateEntry.value = date.getFullYear() + "." + ( date.getMonth() + 1 ) + "." + date.getDate()
            signalEntry.value = "dateSelected"

            if( datePicker.isFuture ){
                futurePastEntry.value = "future"
            }else if( datePicker.isPast ) {
                futurePastEntry.value = "past"
            }else{
                futurePastEntry.value = "today"
            }
        }
        onRejected: {
            stateEntry.value = "-"
            signalEntry.value = "rejected"
            futurePastEntry.value = "-"
        }
    }

    TopItem {
        id: topItem
    }
}

