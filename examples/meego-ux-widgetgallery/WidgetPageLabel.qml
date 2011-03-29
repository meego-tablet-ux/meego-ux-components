/*
 * Copyright 2011 Intel Corporation.
 *
 * This program is licensed under the terms and conditions of the
 * LGPL, version 2.1.  The full text of the LGPL Licence is at
 * http://www.gnu.org/licenses/lgpl.html
 */

/* This pages shows the Label.qml and offers controls to manipulate it.
 */

import Qt 4.7
import MeeGo.Components 0.1

WidgetPage {
    id: widgetPage

    pageTitle: "Label"

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
            id: labelEntry

            label:  "text: "
            defaultValue: button.text

            onTextUpdated: {
                button.text = value
            }
        },

        CheckBoxEntry {
            id: elideBox

            label: "elideText:"
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
        }
    ]

    statusContent: [
        StatusEntry {
            id: statusEntry

            label: "Text"
            value: button.text
        }
    ]

    description: "This is a text with a background image meant as a general label for look-alike reasons. \n "
               + "If the text is too big to be displayed, activate the checkbox to elide if desired. \n"

    widget: Flickable {

        anchors.fill: parent
        contentHeight: height > button.height ? height : button.height
        contentWidth: width > button.width ? width : button.width
        clip: true

        Label {
            id: button

            anchors.centerIn: parent
            text: "Label"
            elideText: elideBox.isChecked
        }
    }
}
