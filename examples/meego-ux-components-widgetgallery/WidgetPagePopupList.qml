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
            value: "3"
            popupListModel: myModel

            ListModel {
                id:myModel

                property variant myList: [ "1", "2", "3", "4", "5", "6", "7", "8", "9" ]

                Component.onCompleted: {
                    for( var i = 0; i < myList.length; i++ ) {
                        myModel.append( { tag: myList[i] } )
                    }
                    popupList.reInit()
                }
            }

        }
    }
}
