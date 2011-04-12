/*
 * Copyright 2011 Intel Corporation.
 *
 * This program is licensed under the terms and conditions of the
 * LGPL, version 2.1.  The full text of the LGPL Licence is at
 * http://www.gnu.org/licenses/lgpl.html
 */

/* This pages shows the ToggleButton.qml and offers controls to manipulate it.
 */

import Qt 4.7
import MeeGo.Components 0.1

WidgetPage {
    id: widgetPage

    pageTitle: "ToggleButton"

    controlContent: [
        LabeledEntry {
            id: labelEntry

            label:  "onLabel: "
            defaultValue: togglebutton.onLabel

            onTextUpdated: {
                togglebutton.onLabel = value
            }
        },

        LabeledEntry {
            id: fontSizeEntry

            label:  "offLabel: "
            defaultValue: togglebutton.offLabel

            onTextUpdated: {
                togglebutton.offLabel = value
            }
        }
    ]

    statusContent: [
        StatusEntry {
            label: "toggleButton status:"
            value: togglebutton.on ? togglebutton.onLabel : togglebutton.offLabel
        }
    ]

    description: "This is a toggle button with customizable labels. \n"
               + "You can toggle the button by tapping it or by swiping horizontally. \n"

    widget: Flickable {

        anchors.fill: parent
        contentHeight: height > togglebutton.height ? height : togglebutton.height
        contentWidth: width > togglebutton.width ? width : togglebutton.width
        clip: true

        ToggleButton {
            id: togglebutton

            anchors.centerIn: parent
            on: false
        }
    }
}
