/*
 * Copyright 2011 Intel Corporation.
 *
 * This program is licensed under the terms and conditions of the
 * LGPL, version 2.1.  The full text of the LGPL Licence is at
 * http://www.gnu.org/licenses/lgpl.html
 */

/* This pages shows the IconButton.qml and offers controls to manipulate it.
 */

import Qt 4.7
import MeeGo.Components 0.1

WidgetPage {
    id: widgetPage

    pageTitle: "IconButton"

    controlContent: [
        LabeledEntry {
            id: widthEntry

            label:  "width: "
            defaultValue: button.width

            onTextUpdated: {
                if( value >= 0 ){
                    button.width = value
                }
            }
        },

        LabeledEntry {
            id: heightEntry

            label:  "height: "
            defaultValue: button.height

            onTextUpdated: {
                if( value >= 0 ){
                    button.height = value
                }
            }
        },

        LabeledEntry {
            id: iconEntry

            label:  "icon: "
            defaultValue: button.icon

            onTextUpdated: {
                button.icon = value
            }
        },

        LabeledEntry {
            id: iconDownEntry

            label:  "iconDown: "
            defaultValue: button.iconDown

            onTextUpdated: {
                button.iconDown = value
            }
        },

        CheckBoxEntry {
            id: bgCheckBox

            isChecked: false
            label: "hasBackground:"

            onCheckedChanged: {
                button.hasBackground = bgCheckBox.isChecked;
            }

        },

        LabeledEntry {
            id: backgroundImage

            label:  "bgSourceUp: "
            defaultValue: button.bgSourceUp

            onTextUpdated: {
                button.bgSourceUp = value
            }
        },

        LabeledEntry {
            id: backgroundImageDown

            label:  "bgSourceDn:"
            defaultValue: button.bgSourceDn

            onTextUpdated: {
                button.bgSourceDn = value
            }
        },

        CheckBoxEntry {
            id: iconCheckBox

            isChecked: false
            label: "fillIcon:"

            onCheckedChanged: {
                button.iconFill = iconCheckBox.isChecked;
            }
        }
    ]

    statusContent: [
        StatusEntry {
            id: statusEntry

            label: "IconButton status:"
            value: "released"
        }
    ]

    description: "This is an IconButton with customizable size and icons for normal and pressed state.\n"

    widget: Flickable {

        anchors.fill: parent
        contentHeight: height > button.height ? height : button.height
        contentWidth: width > button.width ? width : button.width
        clip: true

        IconButton {
            id: button

            anchors.centerIn: parent
            width:  200
            height:  80

            icon: "image://themedimage/media/icn_addtoalbum_up"
            iconDown: "image://themedimage/media/icn_addtoalbum_dn"

            onPressedChanged: { if( pressed ) { statusEntry.value = "pressed" } else { statusEntry.value = "released" } }
        }
    }
}
