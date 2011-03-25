/*
 * Copyright 2011 Intel Corporation.
 *
 * This program is licensed under the terms and conditions of the
 * LGPL, version 2.1.  The full text of the LGPL Licence is at
 * http://www.gnu.org/licenses/lgpl.html
 */

/* This pages shows the TextField.qml and offers controls to manipulate it.
 */

import Qt 4.7
import MeeGo.Components 0.1

WidgetPage {
    id: widgetPage

    pageTitle: "TextField"

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
                    button.height = parseInt( value )
                }
            }
        },

        LabeledEntry {
            id: fontSizeEntry

            label:  "fontsize: "
            defaultValue: button.font.pixelSize

            onTextUpdated: {
                if( value >= 0 ){
                    button.font.pixelSize = value
                }
            }
        },

        CheckBoxEntry {
            id: readBox

            label: "readOnly:"

            onCheckedChanged: {
                button.readOnly = checked
            }
        }
    ]

    description: "This is a text field for multiple lines of text. If the text does not fit, it becomes scrollable. " +
                 "It can be set to to read-only to block user input."

    widget: Flickable {

        anchors.fill: parent
        contentHeight: height > button.height ? height : button.height
        contentWidth: width > button.width ? width : button.width
        clip: true

        TextField {
            id: button

            anchors.centerIn: parent
            width:  200
            height:  50
        }
    }
}
