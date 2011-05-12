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
import MeeGo.Labs.Components 0.1 as Labs

WidgetPage {
    id: widgetPage

    // This is an example
//    Component {
//        id: contactsPicker
//        ContactsPicker{}
//    }

//    Component.onCompleted : {
//        var picker = contactsPicker.createObject (widgetPage);
//        picker.show ();
//    }

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
            id: maxWidthEntry

            label:  qsTr("maxWidth: ")
            defaultValue: button.maxWidth

            onTextUpdated: {
                if( value >= 0 ){
                    button.maxWidth = value
                }
            }
        },

        LabeledEntry {
            id: minWidthEntry

            label:  qsTr("minWidth: ")
            defaultValue: button.minWidth

            onTextUpdated: {
                if( value >= 0 ){
                    button.minWidth = value
                }
            }
        },

        LabeledEntry {
            id: maxHeightEntry

            label:  qsTr("maxHeight: ")
            defaultValue: button.maxHeight

            onTextUpdated: {
                if( value >= 0 ){
                    button.maxHeight = value
                }
            }
        },

        LabeledEntry {
            id: minHeightEntry

            label:  qsTr("minHeight: ")
            defaultValue: button.minHeight

            onTextUpdated: {
                if( value >= 0 ){
                    button.minHeight = value
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
        },

        CheckBoxEntry {
            id: enabledBox

            isChecked: true
            label: qsTr("enabled:")
        }
    ]

    statusContent: [
        StatusEntry {
            id: statusEntry

            label: qsTr("Button status:")
            value: qsTr("released")
        }
    ]

    description: qsTr("This is a button with customizable size and label. Unless a specific width and height is specified, the button auto-sizes to the text and font size.  Activate the checkbox for elide if desired. \n")

    widget: Flickable {

        anchors.fill: parent
        contentHeight: height > button.height ? height : button.height
        contentWidth: width > button.width ? width : button.width
        clip: true

        Button {
            id: button

            anchors.centerIn: parent

            text: qsTr("Button")

            elideText: elideBox.isChecked
            active: activeBox.isChecked
            enabled: enabledBox.isChecked

            onPressedChanged: {
                if( pressed ) { 
                    statusEntry.value = qsTr("pressed") 
                } else { 
                    statusEntry.value = qsTr("released") 
                } 
            }
            //onClicked: { widgetPage.outputText = "clicked" }
        }
    }
}
