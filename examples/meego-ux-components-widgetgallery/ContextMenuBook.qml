/*
 * Copyright 2011 Intel Corporation.
 *
 * This program is licensed under the terms and conditions of the
 * LGPL, version 2.1.  The full text of the LGPL Licence is at
 * http://www.gnu.org/licenses/lgpl.html
 */

/* This page demonstrates the flexibility of the context menu. */

import Qt 4.7
import MeeGo.Ux.Gestures 0.1
import MeeGo.Ux.Components.Common 0.1

AppPage {
    id: pageDummy

    pageTitle: qsTr("Context Menu Test")

    property variant model1: [  qsTr("Short list"),
        qsTr("Long list"),
        qsTr("Thin list"),
        qsTr("Sub menu"),
        qsTr("5"),
        qsTr("Locust"),
        qsTr("Locust"),
        qsTr("Locust"),
        qsTr("Locust"),
        qsTr("Locust"),
        qsTr("Locust"),
        qsTr("Locust"),
        qsTr("Locust"),
        qsTr("Locust"),
        qsTr("Locust"),
        qsTr("Locust"),
        qsTr("Locust"),
        qsTr("Last Locust") ]

    property variant model0: [ qsTr("Short list"),
        qsTr("Long list"),
        qsTr("Thin list"),
        qsTr("Sub menu"),
        qsTr("Very long fourth entry") ]

    property variant model2: [ qsTr("Short"),
        qsTr("Long"),
        qsTr("Thin"),
        qsTr("Sub") ]

    property int activeModel: 0

    enableCustomActionMenu: true

    onActionMenuTriggered: {
        // action menu was triggered
    }

    onActionMenuIconClicked: {
        pageDummy.actionMenuOpen = true
        contextActionMenu.setPosition( mouseX, mouseY )
        contextActionMenu.show()
    }

    Rectangle{
        anchors.fill: parent
        color: "lightblue"
        z: -1
    }

    Text{
        id: textItem
        anchors.top: parent.top
        anchors.horizontalCenter: parent.horizontalCenter
        width: parent.width * 0.75

        font.pixelSize: 20
        wrapMode: Text.WordWrap
        text:  qsTr( "This is an example page for different ContextMenus.<br>"
                    + "You can list a set of entries which are selectable. <br>"
                    + "The menu will always try to use as little space as possible, up to a given maximum width. "
                    + "If it exceeds in height it gets scrollable.<br>"
                    + "Click anywhere to get a context menu.<br><br>"
                    + "You can choose between different menus:<br>"
                    + "- Short list: a short list. The fourth entry is too long and is elided.<br>"
                    + "- Long list: a long list with many entries. Note that the menu gets scrollable.<br>"
                    + "- Thin list: a list with short entries. Note that the width adjusts to it and chooses its minimum width.<br>"
                    + "- Sub menu: shows a submenu that appears in the already opened context menu.<br><br>"
                    + "In addition, the action menu is replaced by a custom context menu. This way you can create much more complex context menus.<br><br>"
                    + "Note: We recommend to set the position a new with setPosition() after rotating (as done for the book and action menu). "
                    + "Otherwise the context menu will try to move relatively, which can lead to a small offset. Try to click the blue spot." )
    }

    Rectangle {
        id: clickItem
        width:  30
        height: 30
        color: "darkblue"

        x: parent.width * 0.05
        y: parent.height * 0.2
        radius: 15
    }

    GestureArea {
        anchors.fill: parent

        Tap {
            onFinished: {
                if( pageDummy.activeModel == 0 ){
                    bookMenu.model = pageDummy.model0
                }
                if( pageDummy.activeModel == 1 ){
                    bookMenu.model = pageDummy.model1
                }
                if( pageDummy.activeModel == 2 ){
                    bookMenu.model = pageDummy.model2
                }

                modalContextMenu.setPosition( mapToItem( topItem.topItem, gesture.position.x, gesture.position.y ).x, mapToItem( topItem.topItem, gesture.position.x, gesture.position.y ).y )
                modalContextMenu.show()
            }
        }
        TapAndHold {
            onFinished: {
                if( pageDummy.activeModel == 0 )
                    bookMenu.model = pageDummy.model0
                if( pageDummy.activeModel == 1 )
                    bookMenu.model = pageDummy.model1
                if( pageDummy.activeModel == 2 )
                    bookMenu.model = pageDummy.model2

                modalContextMenu.setPosition( mapToItem( topItem.topItem, gesture.position.x, gesture.position.y ).x, mapToItem( topItem.topItem, gesture.position.x, gesture.position.y ).y )
                modalContextMenu.show()
            }
        }
    }

//    Button {
//        id: modalButton
//        text: qsTr( "show modal context menu" )
//        x: parent.width * 0.05
//        y: parent.height * 0.6

//        onClicked: {
//            contextMenu.setPosition( modalButton.x + modalButton.width, modalButton.y + modalButton.height )
//            contextMenu.show()
//        }
//    }

    TopItem{ id: topItem }

    ContextMenu {
        id: contextActionMenu
        forceFingerMode: 2

        onVisibleChanged: {
            actionMenuOpen = visible
        }

        title:  qsTr("Custom ContextMenu")

        content:  Item {
            id: contentItem
            width: 300
            height: 300

            Column {
                id: column

                width: parent.width

                anchors.fill: parent
                anchors.margins: 10

                spacing: 10

                Row {
                    spacing: 10
                    ToggleButton{
                        onToggled:{
                            if(isOn)
                                contentItem.height = 400
                            else
                                contentItem.height = 300
                        }
                    }
                    Text {
                        anchors.verticalCenter: parent.verticalCenter

                        font.pixelSize: 20
                        text: qsTr("Test me!")
                    }
                }

                TextEntry{
                    width: 250
                    defaultText: qsTr("some entry")
                }

                Text{
                    width: parent.width
                    font.pixelSize: 20
                    wrapMode: Text.WordWrap
                    text:  qsTr("This is an example of a completely own customizable action menu each page can set.")
                }
            }
        }
    }

    ContextMenu {
        id: modalContextMenu

        forceFingerMode: -1

        subMenuModel: [ qsTr("Very long first entry"),
            qsTr("Second entry"),
            qsTr("Third entry"),
            qsTr("Fourth entry"),
            qsTr("Back") ]

        onSubMenuTriggered: {
            if( index == 4 ){
                modalContextMenu.subMenuVisible = false
            }
            else{
                modalContextMenu.hide()
            }
        }

        content: ActionMenu {
            id: bookMenu

            maxWidth: 200
            minWidth: 100
            maxHeight: modalContextMenu.sizeHintMaxHeight

            model: model2

            onTriggered: {
                if( index == 0 ){
                    activeModel = 0
                }
                if( index == 1 ){
                    activeModel = 1
                }
                if( index == 2 ){
                    activeModel = 2
                }
                if( index == 3 ){
                    modalContextMenu.subMenuVisible = true
                }

                // This tests the resizing behaviour.
                //                if( activeModel == 0 )
                //                    bookMenu.model = model0
                //                else if( activeModel == 1 )
                //                    bookMenu.model = model1
                //                else if( activeModel == 2 )
                //                    bookMenu.model = model2
                //                else
                // end of test for the resizing behaviour.

                if( index != 3 )
                    modalContextMenu.hide()
            }
        }

    }
}

