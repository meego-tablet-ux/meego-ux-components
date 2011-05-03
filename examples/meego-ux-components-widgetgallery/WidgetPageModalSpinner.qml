/*
 * Copyright 2011 Intel Corporation.
 *
 * This program is licensed under the terms and conditions of the
 * LGPL, version 2.1.  The full text of the LGPL Licence is at
 * http://www.gnu.org/licenses/lgpl.html
 */

/* This pages shows the ModalSpinner.qml and offers controls to manipulate it.
 */

import Qt 4.7
import MeeGo.Components 0.1

WidgetPage {
    id: widgetPage

    pageTitle: "ModalSpinner"

    controlContent: [
        LabeledEntry {
            id: intervalEntry

            label:  "interval: "
            defaultValue: modalSpinner.interval

            onTextUpdated: {
                if( value >= 0 ){
                    modalSpinner.interval = parseInt( value )
                }
            }
        }

    ]

    statusContent: [

    ]

    description: "This shows a modal spinner which is meant to be shown while an application "
               + "is busy with a process which blocks everything else. In this example the "
               + "fog is set clickable so the spinner can be stopped. \n"
               + "The interval sets the time in milliseconds needed for one animation step."

    ModalSpinner {
        id: modalSpinner

        fogClickable: true
    }

    widget: Flickable {

        anchors.fill: parent
        contentHeight: height > modalSpinner.height ? height : modalSpinner.height
        contentWidth: width > modalSpinner.width ? width : modalSpinner.width
        clip: true

        Button {
            id: button

            anchors.centerIn: parent
            text: "Show modal spinner"

            onClicked: {
                modalSpinner.show()
            }
        }
    }
}

