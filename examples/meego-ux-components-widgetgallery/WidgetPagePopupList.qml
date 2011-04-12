/*
 * Copyright 2011 Intel Corporation.
 *
 * This program is licensed under the terms and conditions of the
 * LGPL, version 2.1.  The full text of the LGPL Licence is at
 * http://www.gnu.org/licenses/lgpl.html
 */

/* This pages shows a spinnable PopupList.qml.
 */

import Qt 4.7
import MeeGo.Components 0.1

WidgetPage {
    id: widgetPage

    pageTitle: "PopupList"

    controlContent: [
        LabeledEntry {
            id: widthEntry

            label:  "width: "
            defaultValue: popupList.width

            onTextUpdated: {
                if( value >= 0 ){
                    popupList.width = value
                }
            }
        },

        LabeledEntry {
            id: heightEntry

            label:  "height: "
            defaultValue: popupList.height

            onTextUpdated: {
                if( value >= 0 ){
                    popupList.height = value
                }
            }
        },

        LabeledEntry {
            id: itemCountEntry

            label:  "pathItemCount: "
            defaultValue: popupList.pathItemCount

            onTextUpdated: {
                if( value >= 1 ){
                    popupList.pathItemCount = value
                }
            }
        },

        LabeledEntry {
            id: fontSizeEntry

            label:  "fontSize: "
            defaultValue: popupList.fontSize

            onTextUpdated: {
                if( value >= 6 ){
                    popupList.fontSize = value
                }
            }
        }
    ]

    statusContent: [
        StatusEntry {
            id: valueStatus

            label: "Current value:"
            value: parseInt( popupList.selectedValue ) + 1
        }
    ]

    description: "The PopupList is a spinnable list of entries. \n" +
                 "The size of the entries in the spinner depends on the " +
                 "number of entries to display at a time (set by the API " +
                 "property pathItemCount) and the available space set by " +
                 "the API property height.\n" +
                 "The fontSize sets the font size of the non-highlighted entries " +
                 "in pixels. Sizes bigger than the entry height are cut down while " +
                 "sizes smaller than 6 are set to 6."

    widget: Flickable {

        anchors.fill: parent
        contentHeight: height > popupList.height ? height : popupList.height
        contentWidth: width > popupList.width ? width : popupList.width
        clip: true

        PopupList {
            id: popupList

            anchors.centerIn: parent
            width: 100
            height: 110
            value: 1
            popupListModel: myModel

            ListModel {
                id:myModel

                ListElement { tag: "1" }
                ListElement { tag: "2" }
                ListElement { tag: "3" }
                ListElement { tag: "4" }
                ListElement { tag: "5" }
                ListElement { tag: "6" }
                ListElement { tag: "7" }
                ListElement { tag: "8" }
                ListElement { tag: "9" }
            }
        }
    }
}
