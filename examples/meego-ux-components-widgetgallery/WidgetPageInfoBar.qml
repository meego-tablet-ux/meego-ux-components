/*
 * Copyright 2011 Intel Corporation.
 *
 * This program is licensed under the terms and conditions of the
 * LGPL, version 2.1.  The full text of the LGPL Licence is at
 * http://www.gnu.org/licenses/lgpl.html
 */

/* This pages shows the InfoBar.qml and offers controls to manipulate it.
 */

import Qt 4.7
import MeeGo.Components 0.1

WidgetPage {
    id: widgetPage

    pageTitle: qsTr("InfoBar")

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
            id: labelEntry

            label:  qsTr("text: ")
            defaultValue: qsTr("<center>Attention<br>Incoming bugs!</center>")

            onTextUpdated: {
                button.text = value
            }
        }
    ]

    statusContent: [
    ]

    description: qsTr("This is a info box. When hidden it has height zero. When you call show() it will extend and show up, showing the message you set to 'text'. This is a rich text component.")

    widget: Flickable {

        anchors.fill: parent
        contentHeight: height > box.height ? height : box.height
        contentWidth: width > box.width ? width : box.width
        clip: true

        Column{
            id: box

            anchors.centerIn: parent

            Text {
                width: 200
                text:  qsTr("Click the button")
                font.pixelSize: theme.fontPixelSizeLarge
            }

            InfoBar {
                id: button

                text: qsTr("<center>Attention<br>Incoming Message!</center>")

                width: 200
            }
            Button{
                property bool infoState: false
                text: "show()"
                width: 200
                onClicked: {
                    infoState = !infoState
                    if(infoState){
                        button.show()
                        text = "hide()"
                    }
                    else{
                        button.hide()
                        text = "show()"
                    }
                }
            }
        }
    }

    Theme {id: theme}
}
