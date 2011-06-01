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
                    clip:  true

                    MouseArea {
                        anchors.fill: buttonItem
                        z: 1

                        onClicked: addPage( buttonComponent )
                    }

                    Item {
                        id: button

                        x: parent.width / 2 - width - ( parent.width / 2 - width ) / 2
                        width:  parent.width  * flickContainer.leftFactor
                        anchors.verticalCenter: parent.verticalCenter
                        Button {
                            text:  qsTr("Button")

                            width: parent.width
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
                        text: qsTr("Button, with customizable size and label.")
                    }

                    Component { id: buttonComponent; WidgetPageButton{} }
                }

                Rectangle {
                    id: bottomItem

                    width: parent.width
                    height:  flickContainer.itemHeight

                    anchors.left: parent.left

                    anchors.right: parent.right

                    border.width: 1
                    border.color: "grey"

                    color: flickContainer.backColor
                    clip:  true

                    MouseArea {
                        anchors.fill: bottomItem
                        z: 1

                        onClicked: addPage( bottomPage )
                    }

                    Item {
                        x: parent.width / 2 - width - ( parent.width / 2 - width ) / 2
                        width:  parent.width  * flickContainer.leftFactor
                        anchors.verticalCenter: parent.verticalCenter
                        Button {
                            text:  "BottomBar"

                            width: parent.width
                            anchors.centerIn: parent
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
                        text: "BottomToolBar, a tool bar at the bottom."
                    }

                    Component { id: bottomPage; WidgetPageBottomBar{} }
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
                    clip:  true

                    Item{

                        x: parent.width / 2 - width - ( parent.width / 2 - width ) / 2
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
                        text: qsTr("CheckBox, to set a boolean value.")
                    }
                }

                Rectangle {
                    id: contextItem

                    width: parent.width
                    height:  flickContainer.itemHeight

                    anchors.left: parent.left

                    anchors.right: parent.right

                    border.width: 1
                    border.color: "grey"

                    color: flickContainer.backColor
                    clip:  true

                    MouseArea {
                        anchors.fill: contextItem
                        z: 1

                        onClicked: addPage( contextPage )
                    }

                    Item {
                        x: parent.width / 2 - width - ( parent.width / 2 - width ) / 2
                        width:  parent.width  * flickContainer.leftFactor
                        anchors.verticalCenter: parent.verticalCenter
                        Button {
                            text:  "ContextMenu"

                            width: parent.width
                            anchors.centerIn: parent
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
                        text: "Context menu, a simple flyout."
                    }

                    Component { id: contextPage; ContextMenuBook{} }
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

                        DropDown {
                            width:  parent.width
                            anchors.centerIn: parent

                            replaceDropDownTitle: false

                            title: "DropDown"
                            titleColor: "black"
                        }
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

                    Component{ id: dropDownComponent; WidgetPageDropDown{} }
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
                    id: iconButtonItem

                    width: parent.width
                    height:  flickContainer.itemHeight

                    anchors.left: parent.left
                    anchors.right: parent.right

                    border.width: 1
                    border.color: "grey"

                    color: flickContainer.backColor
                    clip:  true

                    MouseArea {
                        anchors.fill: iconButtonItem
                        z: 1

                        onClicked: addPage( iconButtonComponent )
                    }

                    Item {
                        id: iconButton
                        x: parent.width / 2 - width - ( parent.width / 2 - width ) / 2
                        width:  parent.width  * flickContainer.leftFactor
                        anchors.verticalCenter: parent.verticalCenter

                        IconButton {
                            width: parent.width
                            anchors.centerIn: parent
                            icon: "image://themedimage/images/media/icn_addtoalbum_up"
                        }
                    }

                    Text {
                        x: parent.width / 2
                        width: parent.width * flickContainer.rightFactor
                        height: parent.height

                        verticalAlignment: Text.AlignVCenter
                        wrapMode: Text.WordWrap
                        font.pixelSize: flickContainer.textSize
                        text: qsTr("IconButton, with customizable size and icons.")
                    }

                    Component { id: iconButtonComponent; WidgetPageIconButton{} }
                }

                Rectangle {
                    id: infoItem

                    width: parent.width
                    height: flickContainer.itemHeight

                    border.width: 1
                    border.color: "grey"

                    color: flickContainer.backColor
                    clip:  true

                    MouseArea {
                        anchors.fill: infoItem
                        z: 1

                        onClicked: addPage( infoComponent )
                    }

                    Item{
                        id: infoButton

                        x: parent.width / 2 - width - ( parent.width / 2 - width) / 2
                        width:  parent.width * flickContainer.leftFactor
                        anchors.verticalCenter: parent.verticalCenter

                        InfoBar {
                            width: parent.width
                            anchors.centerIn: parent

                            text: "InfoBar"
                            animationTime: 0
                            Component.onCompleted: {
                                show()
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
                        text: "InfoBar, displaying info messages."
                    }

                    Component{ id: infoComponent; WidgetPageInfoBar{} }
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
                    id: layoutTextItem

                    width: parent.width
                    height: flickContainer.itemHeight

                    border.width: 1
                    border.color: "grey"

                    color: flickContainer.backColor
                    clip:  true

                    MouseArea {
                        anchors.fill: layoutTextItem
                        z: 1

                        onClicked: addPage( layoutTextItemComponent )
                    }

                    Item{
                        id: layoutTextButton

                        x: parent.width / 2 - width - ( parent.width / 2 - width) / 2
                        width:  parent.width * flickContainer.leftFactor
                        anchors.verticalCenter: parent.verticalCenter

                        LayoutTextItem {
                            maxWidth: parent.width
                            anchors.centerIn: parent

                            text: "LayoutTextItem"
                        }
                    }

                    Text {
                        x: parent.width / 2
                        width: parent.width * flickContainer.rightFactor
                        height: parent.height

                        verticalAlignment: Text.AlignVCenter
                        wrapMode: Text.WordWrap
                        font.pixelSize: flickContainer.textSize
                        text: "Text item, with resize behavior."
                    }

                    Component{ id: layoutTextItemComponent; WidgetPageLayoutTextItem{} }
                }

                Rectangle {
                    id: messagenItem

                    width: parent.width
                    height:  flickContainer.itemHeight

                    anchors.left: parent.left

                    anchors.right: parent.right

                    border.width: 1
                    border.color: "grey"

                    color: flickContainer.backColor
                    clip:  true

                    MouseArea {
                        anchors.fill: messagenItem
                        z: 1

                        onClicked: addPage( messageBoxPage )
                    }

                    Item {
                        id: messageItem

                        x: parent.width / 2 - width - ( parent.width / 2 - width ) / 2
                        width:  parent.width  * flickContainer.leftFactor
                        anchors.verticalCenter: parent.verticalCenter
                        Button {
                            text:  "message"

                            width: parent.width
                            anchors.centerIn: parent
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
                        text: "Message box, to display a message in a dialog."
                    }

                    Component { id: messageBoxPage; WidgetPageMessageBox{} }
                }

                Rectangle {
                    id: modalSpinnerItem

                    width: parent.width
                    height: flickContainer.itemHeight

                    border.width: 1
                    border.color: "grey"

                    color: flickContainer.backColor
                    clip:  true

                    MouseArea {
                        anchors.fill: modalSpinnerItem
                        z: 1

                        onClicked: addPage( modalSpinnerComponent )
                    }

                    Item{
                        id: modalSpinnerButton

                        x: parent.width / 2 - width - ( parent.width / 2 - width) / 2
                        width:  parent.width * flickContainer.leftFactor
                        anchors.verticalCenter: parent.verticalCenter

                        Item{
                            id: spinner

                            anchors.centerIn: parent

                            clip: true

                            width:  spinnerImage.height
                            height:  spinnerImage.height

                            Image {
                                id: spinnerImage

                                x: 0

                                source: "image://themedimage/widgets/common/spinner/spinner-small"
                                width: sourceSize.width
                                height: sourceSize.height
                                smooth: true
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
                        text: "ModalSpinner, blocking the complete app."
                    }

                    Component{ id: modalSpinnerComponent; WidgetPageModalSpinner{} }
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
                    id: radioItem

                    width: parent.width
                    height:  flickContainer.itemHeight

                    anchors.left: parent.left

                    anchors.right: parent.right

                    border.width: 1
                    border.color: "grey"

                    color: flickContainer.backColor
                    clip:  true

                    MouseArea {
                        anchors.fill: radioItem
                        z: 1

                        onClicked: addPage( radioComponent )
                    }

                    Item {
                        id: radio

                        x: parent.width / 2 - width - ( parent.width / 2 - width ) / 2
                        width:  parent.width  * flickContainer.leftFactor
                        anchors.verticalCenter: parent.verticalCenter

                        RadioButton {
                            anchors.centerIn: parent

                            text: qsTr("Radio")
                        }
                    }

                    Text {
                        x: parent.width / 2
                        width: parent.width * flickContainer.rightFactor
                        height: parent.height

                        verticalAlignment: Text.AlignVCenter
                        wrapMode: Text.WordWrap
                        font.pixelSize: flickContainer.textSize
                        text: qsTr("RadioButton, can be organized in a RadioGroup.")
                    }

                    Component { id: radioComponent; WidgetPageRadioButton{} }
                }

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
                    id: spinnerItem

                    width: parent.width
                    height: flickContainer.itemHeight

                    border.width: 1
                    border.color: "grey"

                    color: flickContainer.backColor
                    clip:  true

                    MouseArea {
                        anchors.fill: spinnerItem
                        z: 1

                        onClicked: addPage( spinnerComponent )
                    }

                    Item{
                        id: spinnerButton

                        x: parent.width / 2 - width - ( parent.width / 2 - width) / 2
                        width:  parent.width * flickContainer.leftFactor
                        anchors.verticalCenter: parent.verticalCenter

                        Item{
                            id: spinner2

                            anchors.centerIn: parent

                            clip: true

                            width:  spinnerImage2.height
                            height:  spinnerImage2.height

                            Image {
                                id: spinnerImage2

                                x: 0

                                source: "image://themedimage/widgets/common/spinner/spinner-small"
                                width: sourceSize.width
                                height: sourceSize.height
                                smooth: true
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
                        text: "Spinner, that can be placed anywhere."
                    }

                    Component{ id: spinnerComponent; WidgetPageSpinner{} }
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
                    id: toggleButtonItem

                    width: parent.width
                    height:  flickContainer.itemHeight

                    anchors.left: parent.left

                    anchors.right: parent.right

                    border.width: 1
                    border.color: "grey"

                    color: flickContainer.backColor
                    clip:  true

                    MouseArea {
                        anchors.fill: toggleButtonItem
                        z: 1

                        onClicked: addPage( toggleButtonComponent )
                    }

                    Item{
                        id: toggleButton

                        x: parent.width / 2 - width - ( parent.width / 2 - width ) / 2
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
                        text: qsTr("ToggleButton, with customizable size and labels.")
                    }

                    Component { id: toggleButtonComponent; WidgetPageToggleButton{} }
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
                    id: verticalLayoutItem

                    width: parent.width
                    height: flickContainer.itemHeight

                    border.width: 1
                    border.color: "grey"

                    color: flickContainer.backColor
                    clip:  true

                    MouseArea {
                        anchors.fill: verticalLayoutItem
                        z: 1

                        onClicked: addPage( layoutPage )
                    }

                    Item{
                        id: verticalLayout

                        x: parent.width / 2 - width - ( parent.width / 2 - width) / 2
                        width:  parent.width  * flickContainer.leftFactor
                        anchors.verticalCenter: parent.verticalCenter
                        Button {
                            text:  "VerticalLayout"

                            width: parent.width
                            anchors.centerIn: parent
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
                        text: "Vertical Layout, to position items."
                    }

                    Component { id: layoutPage; WidgetPageVerticalLayout { } }
                }
            }
        }
    } //end outerRect
}
