/*
 * Copyright 2011 Intel Corporation.
 *
 * This program is licensed under the terms and conditions of the
 * LGPL, version 2.1.  The full text of the LGPL Licence is at
 * http://www.gnu.org/licenses/lgpl.html
 */

/* This pages shows the LayoutTextItem.qml and offers controls to manipulate it.
 */

import Qt 4.7
import MeeGo.Components 0.1

WidgetPage {
    id: widgetPage

    pageTitle: "LayoutTextItem"

    controlContent: [

        LabeledEntry {
            id: heightEntry

            label:  "font.pixelSize: "
            defaultValue: button.font.pixelSize

            onTextUpdated: {
                if( value >= 0 ){
                    button.font.pixelSize = parseInt( value )
                }
            }
        },

        LabeledEntry {
            id: minWidthEntry

            label:  "minWidth: "
            defaultValue: button.minWidth

            onTextUpdated: {
                if( value >= 0 ){
                    button.minWidth = parseInt( value )
                }
            }
        },

        LabeledEntry {
            id: maxWidthEntry

            label:  "maxWidth: "
            defaultValue: button.maxWidth

            onTextUpdated: {
                if( value >= 0 ){
                    button.maxWidth = parseInt( value )
                }
            }
        },

        LabeledEntry {
            id: textEntry

            label:  "text: "
            defaultValue: button.text

            onTextUpdated: {
                button.text = value
            }
        },

        CheckBoxEntry {
            id: elideBox

            label: qsTr("elideText:")
        }
    ]

    description: "This is a basic text item that resizes to its given text. " +
                 "You can control the width of the item with minWidth and maxWidth. " +
                 "The automatic resize can be controlled via 'bool autoResize'. " +
                 "The blue rect in the background only shows the actual text items size."


    widget: Flickable {

        anchors.fill: parent
        contentHeight: height > button.height ? height : button.height
        contentWidth: width > button.width ? width : button.width
        clip: true

        LayoutTextItem {
            id: button

            text: "Test me!"

            anchors.centerIn: parent
            font.pixelSize: 30

            elide: elideBox.isChecked ? Text.ElideRight : Text.ElideNone

            Rectangle {
                color:  "lightblue"
                z: -1
                anchors.fill: parent
            }
        }
    }
}
