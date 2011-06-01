/*
 * Copyright 2011 Intel Corporation.
 *
 * This program is licensed under the terms and conditions of the
 * LGPL, version 2.1.  The full text of the LGPL Licence is at
 * http://www.gnu.org/licenses/lgpl.html
 */

/* This pages shows the VerticalLayout.qml and offers controls to manipulate it.
 */

import Qt 4.7
import MeeGo.Components 0.1

WidgetPage {
    id: widgetPage

    pageTitle: qsTr("VerticalLayout")

    controlContent: [

        LabeledEntry {
            id: maxWidthEntry

            label:  qsTr("maxWidth: ")
            defaultValue: verticalLayout.maxWidth

            onTextUpdated: {
                if( value >= 0 ){
                    verticalLayout.maxWidth = value
                }
            }
        },

        LabeledEntry {
            id: minWidthEntry

            label:  qsTr("minWidth: ")
            defaultValue: verticalLayout.minWidth

            onTextUpdated: {
                if( value >= 0 ){
                    verticalLayout.minWidth = value
                }
            }
        },

        LabeledEntry {
            id: maxHeightEntry

            label:  qsTr("maxHeight: ")
            defaultValue: verticalLayout.maxHeight

            onTextUpdated: {
                if( value >= 0 ){
                    verticalLayout.maxHeight = value
                }
            }
        },

        LabeledEntry {
            id: minHeightEntry

            label:  qsTr("minHeight: ")
            defaultValue: verticalLayout.minHeight

            onTextUpdated: {
                if( value >= 0 ){
                    verticalLayout.minHeight = value
                }
            }
        },

        LabeledEntry {
            id: blueWidthEntry

            label:  qsTr("blue width: ")
            defaultValue: blue.width

            onTextUpdated: {
                if( value >= 0 ){
                    blue.width = value
                }
            }
        },

        LabeledEntry {
            id: blueHeightEntry

            label:  qsTr("blue height: ")
            defaultValue: blue.height

            onTextUpdated: {
                if( value >= 0 ){
                    blue.height = value
                }
            }
        },

        LabeledEntry {
            id: greenWidthEntry

            label:  qsTr("green width: ")
            defaultValue: green.width

            onTextUpdated: {
                if( value >= 0 ){
                    green.width = value
                }
            }
        },

        LabeledEntry {
            id: greenHeightEntry

            label:  qsTr("green height: ")
            defaultValue: green.height

            onTextUpdated: {
                if( value >= 0 ){
                    green.height = value
                }
            }
        },

        LabeledEntry {
            id: textEntry

            label:  qsTr("text: ")
            defaultValue: textItem.text

            onTextUpdated: {
                    textItem.text = value
            }
        },

        CheckBoxEntry {
            id: activeBox

            isChecked: true
            label: qsTr("clip:")
        }
    ]

    statusContent: [
        StatusEntry {
            id: widthEntry

            label: ( verticalLayout.maxWidth < verticalLayout.minWidth )? qsTr("maxWidth < minWidth !") : ""
        },

        StatusEntry {
            id: heightEntry

            label: ( verticalLayout.maxHeight < verticalLayout.minHeight )? qsTr("maxHeight < minHeight !") : ""
        }
    ]

    description: qsTr("This is a vertical layout. It's basically a Column with additional maximum and minimum values for width and height. The grey background only shows the VerticalLayout item's size.")

    widget: Flickable {

        anchors.fill: parent
        contentHeight: height > button.height ? height : button.height
        contentWidth: width > button.width ? width : button.width
        clip: true

        Rectangle {
            anchors.fill: verticalLayout
            color: "grey"
            opacity: 0.5

        }

        VerticalLayout {
            id: verticalLayout

            minWidth: 150
            maxWidth: 200

            minHeight: 150
            maxHeight: 200

            clip: activeBox.isChecked

            Rectangle {
                id: blue

                width:  100
                height:  50
                color: "blue"

                Behavior on height{
                    NumberAnimation{ duration: 200 }
                }
                Behavior on width{
                    NumberAnimation{ duration: 200 }
                }
            }
            Rectangle {
                id: green

                width:  20
                height:  50
                color: "green"

                Behavior on height{
                    NumberAnimation{ duration: 200 }
                }
                Behavior on width{
                    NumberAnimation{ duration: 200 }
                }
            }
            LayoutTextItem {
                id: textItem

                elide: Text.ElideRight
                maxWidth: verticalLayout.maxWidth
                text:"Hello world"
            }
        }
    }
}
