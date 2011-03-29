/*
 * Copyright 2011 Intel Corporation.
 *
 * This program is licensed under the terms and conditions of the
 * LGPL, version 2.1.  The full text of the LGPL Licence is at
 * http://www.gnu.org/licenses/lgpl.html
 */

/* This file is meant to show different kind of buttons.
   On clicked most buttons open another page where a detailed view is given. */

import Qt 4.7
import MeeGo.Components 0.1

Item {
    id: buttonContent

    anchors.fill: parent

    Rectangle {
        id: outerRect

        anchors.margins: parent.width * 0.01
        anchors.top:  parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        color:  "darkgrey"
        radius:  5

        Flickable {
            id: flickContainer
            property int itemHeight: 80
            property int itemMargin: 50
            property int textMargin: 20
            property int textSize: 16
            property real leftFactor: 0.3
            property real rightFactor: 0.4
            property string backColor: "lightgrey"

            contentHeight: column.height
            anchors.fill: parent

            interactive: height < contentHeight
            onHeightChanged: { contentY = 0 }

            clip: true

            Column {
                id: column

                width: parent.width * 0.75
                anchors.horizontalCenter: parent.horizontalCenter

                spacing: 2

                Rectangle {
                    id: buttonItem

                    width: parent.width
                    height:  flickContainer.itemHeight

                    anchors.left: parent.left

                    anchors.right: parent.right

                    border.width: 1
                    border.color: "grey"

                    color: flickContainer.backColor

                    MouseArea {
                        anchors.fill: buttonItem
                        z: 1

                        onClicked: addPage( buttonComponent )
                    }

                    Item {
                        id: button

                        x: parent.width / 2 - width - flickContainer.itemMargin
                        width:  parent.width  * flickContainer.leftFactor
                        anchors.verticalCenter: parent.verticalCenter
                        Button {
                            text:  "OK"

                            anchors.centerIn: parent
                        }
                    }

                    Text {
                        x: parent.width / 2
                        width: parent.width * flickContainer.rightFactor
                        height: parent.height

                        verticalAlignment: Text.AlignVCenter
                        wrapMode: Text.WordWrap
                        font.pixelSize: flickContainer.textSize
                        text: "Button, with customizable size and label."
                    }

                    Component { id: buttonComponent; WidgetPageButton{} }
                }

                Rectangle {
                    id: iconButtonItem

                    width: parent.width
                    height:  flickContainer.itemHeight

                    anchors.left: parent.left
                    anchors.right: parent.right

                    border.width: 1
                    border.color: "grey"

                    color: flickContainer.backColor

                    MouseArea {
                        anchors.fill: iconButtonItem
                        z: 1

                        onClicked: addPage( iconButtonComponent )
                    }

                    Item {
                        id: iconButton
                        x: parent.width / 2 - width - flickContainer.itemMargin
                        width:  parent.width  * flickContainer.leftFactor
                        anchors.verticalCenter: parent.verticalCenter

                        IconButton {
                            anchors.centerIn: parent
                            icon: "image://themedimage/media/icn_addtoalbum_up"
                        }
                    }

                    Text {
                        x: parent.width / 2
                        width: parent.width * flickContainer.rightFactor
                        height: parent.height

                        verticalAlignment: Text.AlignVCenter
                        wrapMode: Text.WordWrap
                        font.pixelSize: flickContainer.textSize
                        text: "IconButton, with customizable size and icons."
                    }

                    Component { id: iconButtonComponent; WidgetPageIconButton{} }
                }

                Rectangle {
                    id: radioItem

                    width: parent.width
                    height:  flickContainer.itemHeight

                    anchors.left: parent.left

                    anchors.right: parent.right

                    border.width: 1
                    border.color: "grey"

                    color: flickContainer.backColor

                    MouseArea {
                        anchors.fill: radioItem
                        z: 1

                        onClicked: addPage( radioComponent )
                    }

                    Item {
                        id: radio

                        x: parent.width / 2 - width - flickContainer.itemMargin
                        width:  parent.width  * flickContainer.leftFactor
                        anchors.verticalCenter: parent.verticalCenter

                        RadioButton {
                            anchors.centerIn: parent

                            text: "Radio"
                        }
                    }

                    Text {
                        x: parent.width / 2
                        width: parent.width * flickContainer.rightFactor
                        height: parent.height

                        verticalAlignment: Text.AlignVCenter
                        wrapMode: Text.WordWrap
                        font.pixelSize: flickContainer.textSize
                        text: "RadioButton, can be organized in a RadioGroup."
                    }

                    Component { id: radioComponent; WidgetPageRadioButton{} }
                }

                Rectangle {
                    id: toggleButtonItem

                    width: parent.width
                    height:  flickContainer.itemHeight

                    anchors.left: parent.left

                    anchors.right: parent.right

                    border.width: 1
                    border.color: "grey"

                    color: flickContainer.backColor

                    MouseArea {
                        anchors.fill: toggleButtonItem
                        z: 1

                        onClicked: addPage( toggleButtonComponent )
                    }

                    Item{
                        id: toggleButton

                        x: parent.width / 2 - width - flickContainer.itemMargin
                        width:  parent.width  * flickContainer.leftFactor
                        anchors.verticalCenter: parent.verticalCenter

                        ToggleButton {
                            anchors.centerIn: parent
                        }
                    }

                    Text {
                        x: parent.width / 2
                        width: parent.width * flickContainer.rightFactor
                        height: parent.height

                        verticalAlignment: Text.AlignVCenter
                        wrapMode: Text.WordWrap
                        font.pixelSize: flickContainer.textSize
                        text: "ToggleButton, with customizable size and labels."
                    }

                    Component { id: toggleButtonComponent; WidgetPageToggleButton{} }
                }

                Rectangle {
                    id: checkBoxItem

                    width: parent.width
                    height:  flickContainer.itemHeight

                    anchors.left: parent.left

                    anchors.right: parent.right

                    border.width: 1
                    border.color: "grey"

                    color: flickContainer.backColor

                    Item{

                        x: parent.width / 2 - width - flickContainer.itemMargin
                        width:  parent.width  * flickContainer.leftFactor
                        anchors.verticalCenter: parent.verticalCenter

                        CheckBox {
                            anchors.centerIn: parent
                        }
                    }

                    Text {
                        x: parent.width / 2
                        width: parent.width * flickContainer.rightFactor
                        height: parent.height

                        verticalAlignment: Text.AlignVCenter
                        wrapMode: Text.WordWrap
                        font.pixelSize: flickContainer.textSize
                        text: "CheckBox, to set a boolean value."
                    }
                }

            }
        }
    } //end outerRect
}
