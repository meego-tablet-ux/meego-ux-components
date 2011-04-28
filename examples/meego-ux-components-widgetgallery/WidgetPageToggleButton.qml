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
        },

        CheckBoxEntry {
            id: enableBox

            label: qsTr("enable:")
            isChecked: true
        }

    ]

    statusContent: [
        StatusEntry {
            label: "toggleButton status:"
            value: togglebutton.on ? togglebutton.onLabel : togglebutton.offLabel
        }
    ]

    description: "This is a toggle button with customizable labels. \n"
               + "You can toggle the button by tapping it or by swiping horizontally. \n\n"
               + "If due to i18n translation the labels for \"on\" or \"off\" are either "
               + "too long or empty, icons will be displayed instead of the labels. The lower "
               + "toggle button shows that case.\n\n"
               + "If enabled is not checked, the toggle button can't be interacted with and is "
               + "display with dimmed graphics."

    widget: Flickable {

        anchors.fill: parent
        contentHeight: height > togglebutton.height ? height : togglebutton.height
        contentWidth: width > togglebutton.width ? width : togglebutton.width
        clip: true

        ToggleButton {
            id: togglebutton

            enabled: enableBox.isChecked
            anchors.centerIn: parent
            anchors.verticalCenterOffset: -25
            on: false
            onToggled: {
                toggleButtonNoText.on = isOn
            }
        }

        ToggleButton {
            id: toggleButtonNoText

            enabled: enableBox.isChecked
            anchors.top: togglebutton.bottom
            anchors.topMargin: 50
            anchors.horizontalCenter: togglebutton.horizontalCenter
            on: false
            onLabel: ""
            offLabel: ""
            onToggled: {
                togglebutton.on = isOn
            }
        }
    }
}
