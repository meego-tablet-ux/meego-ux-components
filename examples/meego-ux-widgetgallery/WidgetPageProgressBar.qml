/*
 * Copyright 2011 Intel Corporation.
 *
 * This program is licensed under the terms and conditions of the
 * LGPL, version 2.1.  The full text of the LGPL Licence is at
 * http://www.gnu.org/licenses/lgpl.html
 */

/* This pages shows the ProgressBar.qml and offers controls to manipulate it.
 */

import Qt 4.7
import MeeGo.Components 0.1

WidgetPage {
    id: widgetPage

    pageTitle: "ProgressBar"

    controlContent: [
        LabeledEntry {
            id: widthEntry

            label:  "width: "
            defaultValue: progressBar.width

            onTextUpdated: {
                if( value >= 0 ){
                    progressBar.width = parseInt( value )
                }
            }
        },

        LabeledEntry {
            id: heightEntry

            label:  "height: "
            defaultValue: progressBar.height

            onTextUpdated: {
                if( value >= 0 ){
                    progressBar.height = parseInt( value )
                }
            }
        },

        LabeledEntry {
            id: labelEntry

            label:  "percentage: "
            defaultValue: progressBar.percentage

            onTextUpdated: {
                if( value.length > 0 )
                progressBar.percentage = parseFloat( value )
            }
        }
    ]

    statusContent: [
        Row {
            id: statusEntry

            width: widgetPage.width / 4
            height: 70

            Button {
                text: "Start!"

                onClicked: {
                    loadAnimation.running = true
                }
            }
        }
    ]

    NumberAnimation {
        id: loadAnimation

        running: false
        target: progressBar;
        property: "percentage";
        from:  0
        to: 100
        duration: 4000
    }

    description: "This is a progress bar with customizable size."

    widget: Flickable {

        anchors.fill: parent
        contentHeight: height > progressBar.height ? height : progressBar.height
        contentWidth: width > progressBar.width ? width : progressBar.width
        clip: true

        ProgressBar {
            id: progressBar

            anchors.centerIn: parent
            fontColor: "black"
            width:  200
            height:  80
        }
    }
}
