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
        },

        LabeledEntry {
            id: startYearEntry

            label:  "startYear: "
            defaultValue: datePicker.startYear

            onTextUpdated: {
                if( value >= 0 && value <= datePicker.startYear ){
                    datePicker.startYear = value
                }
            }
        },

        LabeledEntry {
            id: endYearEntry

            label:  "endYear: "
            defaultValue: datePicker.endYear

            onTextUpdated: {
                if( value >= 0 && value >= datePicker.endYear ){
                    datePicker.endYear = value
                }
            }
        },

        LabeledEntry {
            id: minYearEntry

            label:  "minYear: "
            defaultValue: datePicker.minYear

            onTextUpdated: {
                if( value >= 0 && value <= datePicker.maxYear ){
                    datePicker.minYear = value
                }else if( value > datePicker.maxYear ) {
                    //deny
                }
            }
        },

        LabeledEntry {
            id: minMonthEntry

            label:  "minMonth: "
            defaultValue: datePicker.minMonth

            onTextUpdated: {
                if( datePicker.minYear == datePicker.maxYear ) {
                    if( value >= 1 && value <= datePicker.maxMonth ){
                        datePicker.minMonth = value
                    }else if( value < 1 ) {
                        //deny
                    }else if( value > datePicker.maxMonth ) {
                        //deny
                    }
                }else if( datePicker.minYear < datePicker.maxYear ) {
                    if( value >= 1 && value <= 12 ) {
                        datePicker.minMonth = value
                    }else if( value < 1 ) {
                        //deny
                    }else if( value > 12 ) {
                        //deny
                    }
                }
            }
        },

        LabeledEntry {
            id: minDayEntry

            label:  "minDay: "
            defaultValue: datePicker.minDay

            onTextUpdated: {
                var dayLimit = datePicker.daysInMonth( datePicker.maxMonth - 1, datePicker.maxYear )
                if( datePicker.minYear == datePicker.maxYear && datePicker.minMonth == datePicker.maxMonth ) {
                    if( value >= 1 && value <= dayLimit ) {
                        datePicker.minDay = value
                    }else if( value < 1 ) {
                        //deny
                    }else if( value > dayLimit ) {
                        //deny
                    }
                }else{
                    if( value >= 1 && value <= dayLimit ){
                        datePicker.minDay = value
                    }else if( value < 1 ) {
                        //deny
                    }else if( value > dayLimit ) {
                        //deny
                    }
                }
            }
        },

        LabeledEntry {
            id: maxYearEntry

            label:  "maxYear: "
            defaultValue: datePicker.maxYear

            onTextUpdated: {
                if( value >= datePicker.minYear ){
                    datePicker.maxYear = value
                }else if( value < datePicker.minYear ) {
                    //deny
                }
            }
        },

        LabeledEntry {
            id: maxMonthEntry

            label:  "maxMonth: "
            defaultValue: datePicker.maxMonth

            onTextUpdated: {
                if( datePicker.minYear == datePicker.maxYear ) {
                    if( value >= datePicker.minMonth && value <= 12 ){
                        datePicker.maxMonth = value
                    }else if( value < datePicker.minMonth ) {
                        //deny
                    }else if( value > 12 ) {
                        //deny
                    }
                }else {
                    if( value >= 1 && value <= 12 ){
                        datePicker.maxMonth = value
                    }else if( value < 1 ) {
                        //deny
                    }else if( value > 12 ) {
                        //deny
                    }
                }
            }
        },

        LabeledEntry {
            id: maxDayEntry

            label:  "maxDay: "
            defaultValue: datePicker.maxDay

            onTextUpdated: {
                var dayLimit = datePicker.daysInMonth( datePicker.maxMonth - 1, datePicker.maxYear )
                if( datePicker.minYear == datePicker.maxYear && datePicker.minMonth == datePicker.maxMonth ) {
                    if( value >= datePicker.minDay && value <= dayLimit ) {
                        datePicker.maxDay = value
                    }else if( value < datePicker.minDay ) {
                        //deny
                    }else if( value > dayLimit ) {
                        //deny
                    }
                }else {
                    if( value >= 1 && value <= dayLimit ) {
                        datePicker.maxDay = value
                    }else if( value < 1 ) {
                        //deny
                    }else if( value > dayLimit ) {
                        //deny
                    }
                }
            }
        },

        LabeledEntry {
            id: dateOrderEntry

            label: "dateOrder: "
            defaultValue: "day-month-year"

            onTextUpdated: {
                datePicker.dateOrder = value
            }
        },

        LabeledEntry {
            id: dateUnitOneEntry

            label: "dateUnitOneText: "
            defaultValue: ""

            onTextUpdated: {
                datePicker.dateUnitOneText = value
            }
        },

        LabeledEntry {
            id: dateUnitTwoEntry

            label: "dateUnitTwoText: "
            defaultValue: ""

            onTextUpdated: {
                datePicker.dateUnitTwoText = value
            }
        },

        LabeledEntry {
            id: dateUnitThreeEntry

            label: "dateUnitThreeText: "
            defaultValue: ""

            onTextUpdated: {
                datePicker.dateUnitThreeText = value
            }
        },

        LabeledEntry {
            id: dateUnitFourEntry

            label: "dateUnitFourText: "
            defaultValue: ""

            onTextUpdated: {
                datePicker.dateUnitFourText = value
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
        },

        StatusEntry {
            id: minDateEntry

            label: "current min date: "
            value: datePicker.minYear + "." + datePicker.minMonth + "." + datePicker.minDay
        },

        StatusEntry {
            id: maxDateEntry

            label: "current max date: "
            value: datePicker.maxYear + "." + datePicker.maxMonth + "." + datePicker.maxDay
        }
    ]

    description: "This page brings up the date picker when the button at the bottom is clicked. The controls to the left "
               + "can be used to change the width and height of the date picker to see how its elements adapt to the new "
               + "size. Choosing too small sizes will break the date picker, because at some point all the elements shown "
               + "in the picker won't just fit into small space. \n"
               + "You can use the min and max API properties to set a range of eligible dates to choose from. Dates outside "
               + "of that range can be selected but the Ok-button will be disabled. \n"
               + "Be aware that the min values may not exceed the max values and vice versa. So only allowed values are "
               + "handed through to the DatePicker. The currently active min and max date can be seen in the window below "
               + "this text.\n \n"
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


        minYear: 2009; minMonth: 3; minDay: 10
        maxYear: 2012; maxMonth: 9; maxDay: 20

//        width: height * 0.6
//        height: topItem.topItem.height * 0.9

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

