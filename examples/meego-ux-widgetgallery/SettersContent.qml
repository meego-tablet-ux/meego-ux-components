/*
 * Copyright 2011 Intel Corporation.
 *
 * This program is licensed under the terms and conditions of the
 * LGPL, version 2.1.  The full text of the LGPL Licence is at
 * http://www.gnu.org/licenses/lgpl.html
 */

/* This file is meant to show different kind of widgets used for user input.
   On clicked most widgets open another page where a detailed view is given. */

import Qt 4.7
import MeeGo.Components 0.1

Item {
    id: settersContent

    anchors.fill: parent

    Rectangle {
        id: outerRect

        anchors.margins: parent.width * 0.01
        anchors.top:  parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        width:  parent.width * 0.75
        color:  "darkgrey"
        radius:  5

        Flickable {
            id: flickContainer
            property int itemHeight: 80
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
                    id: sliderItem

                    width: parent.width
                    height:  flickContainer.itemHeight

                    anchors.left: parent.left

                    anchors.right: parent.right

                    border.width: 1
                    border.color: "grey"

                    color: flickContainer.backColor
                    clip:  true

                    MouseArea {
                        anchors.fill: sliderItem
                        z: 1

                        onClicked: addPage( sliderComponent )
                    }

                    Item{
                        id: slider

                        x: parent.width / 2 - width - ( parent.width / 2 - width) / 2
                        width:  parent.width  * flickContainer.leftFactor
                        anchors.verticalCenter: parent.verticalCenter
                        Slider {

                            anchors.centerIn: parent
                            width: parent.width
                        }
                    }

                    Text {
                        x: parent.width / 2
                        width: parent.width * flickContainer.rightFactor
                        height: parent.height

                        verticalAlignment: Text.AlignVCenter
                        wrapMode: Text.WordWrap
                        font.pixelSize: flickContainer.textSize
                        text: "Slider, to set a value on a scale."
                    }

                    Component { id: sliderComponent; WidgetPageSlider{} }
                }

                Rectangle {
                    id: vsliderItem

                    width: parent.width
                    height: flickContainer.itemHeight

                    border.width: 1
                    border.color: "grey"

                    color: flickContainer.backColor
                    clip:  true

                    MouseArea {
                        anchors.fill: vsliderItem
                        z: 1

                        onClicked: addPage( vsliderComponent )
                    }

                    Item{
                        id: vslider

                        x: parent.width / 2 - width - ( parent.width / 2 - width) / 2
                        width:  parent.width  * flickContainer.leftFactor
                        anchors.verticalCenter: parent.verticalCenter
                        Slider {
                            anchors.centerIn: parent
                            width:  parent.width
                        }
                    }

                    Text {
                        x: parent.width / 2
                        width: parent.width * flickContainer.rightFactor
                        height: parent.height

                        verticalAlignment: Text.AlignVCenter
                        wrapMode: Text.WordWrap
                        font.pixelSize: flickContainer.textSize
                        text: "Vertical Slider, to set a value on a scale."
                    }

                    Component { id: vsliderComponent; WidgetPageVerticalSlider{} }
                }

                Rectangle {
                    id: textEntryItem

                    width: parent.width
                    height: flickContainer.itemHeight

                    border.width: 1
                    border.color: "grey"

                    color: flickContainer.backColor
                    clip:  true

                    MouseArea {
                        anchors.fill: textEntryItem
                        z: 1

                        onClicked: addPage( textEntryComponent )
                    }

                    Item{
                        id: textEntry

                        x: parent.width / 2 - width - ( parent.width / 2 - width) / 2
                        width:  parent.width  * flickContainer.leftFactor
                        anchors.verticalCenter: parent.verticalCenter

                        TextEntry{

                            width:  parent.width
                            anchors.centerIn: parent

                            text: "Write in this box..."
                        }
                    }

                    Text {
                        x: parent.width / 2
                        width: parent.width * flickContainer.rightFactor
                        height: parent.height

                        verticalAlignment: Text.AlignVCenter
                        wrapMode: Text.WordWrap
                        font.pixelSize: flickContainer.textSize
                        text: "TextEntry, for a single line of text."
                    }

                    Component{ id: textEntryComponent; WidgetPageTextEntry{} }
                }

                Rectangle {
                    id: textFieldItem

                    width: parent.width
                    height: flickContainer.itemHeight

                    border.width: 1
                    border.color: "grey"

                    color: flickContainer.backColor
                    clip:  true

                    MouseArea {
                        anchors.fill: textFieldItem
                        z: 1

                        onClicked: addPage( textFieldComponent )
                    }

                    Item{
                        id: textField

                        x: parent.width / 2 - width - ( parent.width / 2 - width) / 2
                        width:  parent.width  * flickContainer.leftFactor
                        anchors.verticalCenter: parent.verticalCenter

                        TextField{
                            anchors.centerIn: parent
                            width:  parent.width

                            text: "TextField, for multiple lines of text."
                        }
                    }

                    Text {
                        x: parent.width / 2
                        width: parent.width * flickContainer.rightFactor
                        height: parent.height

                        verticalAlignment: Text.AlignVCenter
                        wrapMode: Text.WordWrap
                        font.pixelSize: flickContainer.textSize
                        text: "TextField, for multiple lines of text."
                    }

                    Component{ id: textFieldComponent; WidgetPageTextField{} }
                }

                Rectangle {
                    id: progressBarItem

                    width: parent.width
                    height: flickContainer.itemHeight

                    border.width: 1
                    border.color: "grey"

                    color: flickContainer.backColor
                    clip:  true

                    MouseArea {
                        anchors.fill: progressBarItem
                        z: 1

                        onClicked: addPage( progressBarComponent )
                    }

                    Item{
                        id: progressBar

                        x: parent.width / 2 - width - ( parent.width / 2 - width) / 2
                        width:  parent.width  * flickContainer.leftFactor
                        anchors.verticalCenter: parent.verticalCenter
                        ProgressBar {
                            anchors.centerIn: parent

                            width:  parent.width
                        }
                    }

                    Text {
                        x: parent.width / 2
                        width: parent.width * flickContainer.rightFactor
                        height: parent.height

                        verticalAlignment: Text.AlignVCenter
                        wrapMode: Text.WordWrap
                        font.pixelSize: flickContainer.textSize
                        text: "ProgressBar, to show the progress of a process."
                    }

                    Component{ id: progressBarComponent; WidgetPageProgressBar{} }
                }

                Rectangle {
                    id: expandingBoxItem

                    width: parent.width
                    height: flickContainer.itemHeight

                    border.width: 1
                    border.color: "grey"

                    color: flickContainer.backColor
                    clip:  true

                    MouseArea {
                        anchors.fill: expandingBoxItem
                        z: 1

                        onClicked: addPage( expandingComponent )
                    }

                    Item{
                        id: expandingBox

                        x: parent.width / 2 - width - ( parent.width / 2 - width) / 2
                        width:  parent.width  * flickContainer.leftFactor
                        anchors.verticalCenter: parent.verticalCenter

                        ExpandingBox {

                            width:  parent.width
                            anchors.centerIn: parent

                            titleText: "ExpandingBox"
                            titleTextColor: "black"
                            detailsComponent: expandingBoxComponent

                            Component {
                                id: expandingBoxComponent

                                Item {
                                    id: expandingBoxItem

                                    width: parent.width
                                    height:  60

                                    Rectangle { id: rect1; color: "blue"; height: 30; width: parent.width; anchors{ top: parent.top; horizontalCenter: parent.horizontalCenter } }
                                    Rectangle { id: rect3; color: "orange"; height: 30; width: parent.width; anchors{ top: rect1.bottom; horizontalCenter: parent.horizontalCenter } }
                                }
                            }
                        }
                    }

                    Text {
                        x: parent.width / 2
                        width: parent.width * flickContainer.rightFactor
                        height: parent.height

                        verticalAlignment: Text.AlignVCenter
                        wrapMode: Text.WordWrap
                        font.pixelSize: flickContainer.textSize
                        text: "ExpandingBox, design/specs missing."
                    }

                    Component{ id: expandingComponent; WidgetPageExpandingBox{} }
                }


                Rectangle {
                    id: dropDownBoxItem

                    width: parent.width
                    height: flickContainer.itemHeight

                    border.width: 1
                    border.color: "grey"

                    color: flickContainer.backColor
                    clip:  true

                    MouseArea {
                        anchors.fill: dropDownBoxItem
                        z: 1

                        onClicked: addPage( dropDownComponent )
                    }

                    Item{
                        id: dropDownBox

                        x: parent.width / 2 - width - ( parent.width / 2 - width) / 2
                        width:  parent.width  * flickContainer.leftFactor
                        anchors.verticalCenter: parent.verticalCenter

//                        DropDown {

//                            width:  parent.width
//                            anchors.centerIn: parent

//                            titleText: "DropDown"
//                            titleTextColor: "black"

//                        }
                    }

                    Text {
                        x: parent.width / 2
                        width: parent.width * flickContainer.rightFactor
                        height: parent.height

                        verticalAlignment: Text.AlignVCenter
                        wrapMode: Text.WordWrap
                        font.pixelSize: flickContainer.textSize
                        text: "Drop Down, design/specs missing."
                    }

//                    Component{ id: dropDownComponent; WidgetPageDropDown{} }
                }



                Rectangle {
                    id: labelItem

                    width: parent.width
                    height: flickContainer.itemHeight

                    border.width: 1
                    border.color: "grey"

                    color: flickContainer.backColor
                    clip:  true

                    MouseArea {
                        anchors.fill: labelItem
                        z: 1

                        onClicked: addPage( labelComponent )
                    }

                    Item{
                        id: label

                        x: parent.width / 2 - width - ( parent.width / 2 - width) / 2
                        width:  parent.width  * flickContainer.leftFactor
                        anchors.verticalCenter: parent.verticalCenter

                        Label {
                            width:  parent.width
                            anchors.centerIn: parent

                            text: "Label"
                        }
                    }

                    Text {
                        x: parent.width / 2
                        width: parent.width * flickContainer.rightFactor
                        height: parent.height

                        verticalAlignment: Text.AlignVCenter
                        wrapMode: Text.WordWrap
                        font.pixelSize: flickContainer.textSize
                        text: "Label, a text with background graphics."
                    }

                    Component{ id: labelComponent; WidgetPageLabel{} }
                }

                Rectangle {
                    id: popupListItem

                    width: parent.width
                    height: flickContainer.itemHeight

                    border.width: 1
                    border.color: "grey"

                    color: flickContainer.backColor
                    clip:  true

                    MouseArea {
                        anchors.fill: popupListItem
                        z: 1

                        onClicked: addPage( popupComponent )
                    }

                    Item{
                        id: popupListButton

                        x: parent.width / 2 - width - ( parent.width / 2 - width) / 2
                        width:  parent.width * flickContainer.leftFactor
                        anchors.verticalCenter: parent.verticalCenter

                        Button {
                            width: parent.width
                            anchors.centerIn: parent

                            text: "PopupList"
                            elideText: true
                        }
                    }

                    Text {
                        x: parent.width / 2
                        width: parent.width * flickContainer.rightFactor
                        height: parent.height

                        verticalAlignment: Text.AlignVCenter
                        wrapMode: Text.WordWrap
                        font.pixelSize: flickContainer.textSize
                        text: "PopupList, to select from a range of values."
                    }

                    Component{ id: popupComponent; WidgetPagePopupList{} }
                }

            }
        }

    } // end outerRect
}
