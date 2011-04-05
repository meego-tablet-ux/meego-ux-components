/*
 * Copyright 2011 Intel Corporation.
 *
 * This program is licensed under the terms and conditions of the
 * LGPL, version 2.1.  The full text of the LGPL Licence is at
 * http://www.gnu.org/licenses/lgpl.html
 */

/* This pages shows the Button.qml and offers controls to manipulate it.
 */

import Qt 4.7
import MeeGo.Components 0.1

WidgetPage {
    id: widgetPage

    pageTitle: qsTr("Button")

    controlContent: [
        LabeledEntry {
            id: widthEntry

            label:  qsTr("width: ")
            defaultValue: button.width

            onTextUpdated: {
                if( value >= 0 ){
                    button.width = value
                }
            }
        },

        LabeledEntry {
            id: heightEntry

            label:  qsTr("height: ")
            defaultValue: button.height

            onTextUpdated: {
                if( value >= 0 ){
                    button.height = value
                }
            }
        },

        LabeledEntry {
            id: labelEntry

            label:  qsTr("text: ")
            defaultValue: button.text

            onTextUpdated: {
                button.text = value
            }
        },

        CheckBoxEntry {
            id: elideBox

            label: qsTr("elideText:")
        },

        LabeledEntry {
            id: fontSizeEntry

            label:  qsTr("fontsize: ")
            defaultValue: button.font.pixelSize

            onTextUpdated: {
                if( value >= 0 ){
                    button.font.pixelSize = value
                }
            }
        },

        CheckBoxEntry {
            id: activeBox

            isChecked: true
            label: qsTr("active:")
        }
    ]

    statusContent: [
        StatusEntry {
            id: statusEntry

            label: qsTr("Button status:")
            value: qsTr("released")
        }
    ]

    description: qsTr("This is a button with customizable size and label. If the label is too big to be displayed in the button, "
               + "activate the checkbox for elide if desired. \n")

    widget: Flickable {

        anchors.fill: parent
        contentHeight: height > button.height ? height : button.height
        contentWidth: width > button.width ? width : button.width
        clip: true

        Button {
            id: button

            anchors.centerIn: parent
            width:  200
            height:  80
            text: qsTr("Button")
            elideText: elideBox.isChecked
            active: activeBox.isChecked

            onPressedChanged: { if( pressed ) { statusEntry.value = qsTr("pressed") } else { statusEntry.value = qsTr("released") } }
            //onClicked: { widgetPage.outputText = "clicked" }
        }
    }
}
