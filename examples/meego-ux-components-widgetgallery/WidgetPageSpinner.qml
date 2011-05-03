/*
 * Copyright 2011 Intel Corporation.
 *
 * This program is licensed under the terms and conditions of the
 * LGPL, version 2.1.  The full text of the LGPL Licence is at
 * http://www.gnu.org/licenses/lgpl.html
 */

/* This pages shows the Spinner.qml and offers controls to manipulate it.
 */

import Qt 4.7
import MeeGo.Components 0.1

WidgetPage {
    id: widgetPage

    pageTitle: "Spinner"

    controlContent: [
        LabeledEntry {
            id: intervalEntry

            label:  "interval: "
            defaultValue: spinner.interval

            onTextUpdated: {
                if( value >= 0 ){
                    spinner.interval = parseInt( value )
                }
            }
        },

        LabeledEntry {
            id: maxSpinTimeEntry

            label:  "maxSpinTime: "
            defaultValue: spinner.maxSpinTime

            onTextUpdated: {
                if( value >= 0 ){
                    spinner.maxSpinTime = parseInt( value )
                }
            }
        },

        CheckBoxEntry {
            id: spinningEntry

            isChecked: false
            label: "spinning: "

            onCheckedChanged: {
                if( isChecked != spinner.spinning ) {
                    spinner.spinning = spinningEntry.isChecked;
                }
            }

        }

    ]

    statusContent: [

    ]

    description: "This shows a spinner which is meant to be shown while an application "
               + "is busy with a process. \n"
               + "The interval sets the time in milliseconds needed for one animation step.\n"
               + "MaxSpinTime sets how long the spinner should run repeatedly in milliseconds."
               + "Spinning can be used to start/stop the animation and to check if the animation "
               + "is currently running."


    widget: Flickable {

        anchors.fill: parent
        contentHeight: height > spinner.height ? height : spinner.height
        contentWidth: width > spinner.width ? width : spinner.width
        clip: true

        Spinner {
            id: spinner

            onSpinningChanged: {
                spinningEntry.isChecked = spinner.spinning
            }
        }
    }
}


