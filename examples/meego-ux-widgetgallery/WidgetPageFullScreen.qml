/*
 * Copyright 2011 Intel Corporation.
 *
 * This program is licensed under the terms and conditions of the
 * LGPL, version 2.1.  The full text of the LGPL Licence is at
 * http://www.gnu.org/licenses/lgpl.html
 */

/* This pages can call up the ExpandingBox.qml and offers controls to manipulate it.
 */

import Qt 4.7
import MeeGo.Components 0.1

WidgetPage {
    id: widgetPage

    pageTitle: "Fullscreen Testing"

    controlContent: [
        Item {
            id: widthEntry

            anchors { left: parent.left; right: parent.right }
            height:  50

            Text {
                id: label

                anchors { left: parent.left; right: parent.horizontalCenter; top: parent.top; bottom: parent.bottom; margins: 5 }
                verticalAlignment: "AlignVCenter"
                horizontalAlignment: "AlignLeft"
                font.pixelSize: parent.height * 0.5
                elide: Text.ElideRight
                text: qsTr("fullScreen: " )
            }

            Text {
                id: textEntry

                anchors { left: parent.horizontalCenter; right: parent.right; top: parent.top; bottom: parent.bottom; margins: 5 }
                verticalAlignment: "AlignVCenter"
                font.pixelSize: parent.height * 0.5
                elide: Text.ElideRight
                text: widgetPage.fullScreen
            }


        }
    ]

    description: qsTr("Here you can test the fullscreen mode.")

    widget: Flickable {

        anchors.fill: parent
        contentHeight: height > ebox1.height ? height : ebox1.height
        contentWidth: width > ebox1.width ? width : ebox1.width
        clip: true

        Button {
            id: ebox1

            anchors.centerIn: parent

            text: widgetPage.fullScreen ? "End Fullscreen" : "Fullscreen"

            onClicked: {
                widgetPage.fullScreen = widgetPage.fullScreen ? false : true
            }
        }
    }

    TopItem {
        id: topItem
    }
}


