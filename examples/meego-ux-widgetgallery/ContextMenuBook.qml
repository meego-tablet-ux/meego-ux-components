/*
 * Copyright 2011 Intel Corporation.
 *
 * This program is licensed under the terms and conditions of the
 * LGPL, version 2.1.  The full text of the LGPL Licence is at
 * http://www.gnu.org/licenses/lgpl.html
 */

/* This page demonstrates the flexibility of the context menu. */

import Qt 4.7
import MeeGo.Components 0.1

AppPage {
    id: pageDummy

    pageTitle: "Context Menu Test"

    property variant model1: [ "Short list", "Long list", "Thin list", "Sub menu", "5", "Locust", "Locust", "Locust", "Locust", "Locust", "Locust", "Locust", "Locust", "Locust", "Locust", "Locust", "Locust", "Last Locust" ]
    property variant model0: [ "Short list", "Long list", "Thin list", "Sub menu", "Very long fourth entry" ]
    property variant model2: [ "Short",  "Long", "Thin", "Sub" ]

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

    Flickable{
        anchors.fill:  parent
        anchors.topMargin: 20

        contentHeight: textItem.height
        Text{
            id: textItem
            anchors.centerIn: parent
            width: parent.width * 0.6

            font.pixelSize: 20
            wrapMode: Text.WordWrap
            text:  "This is an example page for different ModalContextMenus.<br>"
                    + "Click anywhere to get a context menu.<br><br>"
                    + "You can choose between different menus:<br>"
                    + "- Short list: a short list. The fourth entry is too long and is elided.<br>"
                    + "- Long list: a long list with many entries. Note that the menu gets scrollable.<br>"
                    + "- Thin list: a list with short entries. Note that the width adjusts to it and chooses its minimum width.<br><br>"
                    + "In addition, the action menu is replaced by a custom context menu. <br>This way you can create much more complex context menus."
        }
    }

    Rectangle {
        id: clickItem
        width:  30
        height: 30
        color: "black"

        x: parent.width * 0.1
        y: parent.height * 0.2
        radius: 15
    }

    MouseArea {
        anchors.fill: parent
        onClicked: {
            if( activeModel == 0 )
                bookMenu.model = model0
            if( activeModel == 1 )
                bookMenu.model = model1
            if( activeModel == 2 )
                bookMenu.model = model2

            contextMenu.setPosition( mapToItem( topItem.topItem, mouseX, mouseY ).x, mapToItem( topItem.topItem, mouseX, mouseY ).y )
            contextMenu.show()
        }
    }

    TopItem{ id: topItem }

    ModalContextMenu {
        id: contextMenu

        forceFingerMode: -1

        title: "Context"

        subMenuModel: [ "Very long first entry", "Second entry", "Third entry", "Fourth entry", "Back" ]

        onSubMenuTriggered: {
            if( index == 4 ){
                contextMenu.subMenuVisible = false
            }
            else{
                contextMenu.hide()
            }
        }

        content:  ActionMenu{
            id: bookMenu

            maxWidth: 200
            minWidth: 100

            model: model2

            onTriggered: {
                if( index == 0 )
                    activeModel = 0
                if( index == 1 )
                    activeModel = 1
                if( index == 2 )
                    activeModel = 2
                if( index == 3 ){
                    contextMenu.subMenuVisible = true
                }

                if( index != 3 )
                    contextMenu.hide()
            }
        }
    }

    ModalContextMenu {
        id: contextActionMenu
        forceFingerMode: 2

        onVisibleChanged: {
            actionMenuOpen = visible
        }

        title:  "Custom ContextMenu"

        content:  Item {
            width: 300
            height: 300

            Column {
                id: column

                width: parent.width

                anchors.fill: parent
                anchors.margins: 10

                spacing: 10

                ToggleButton{

                }

                TextEntry{
                    width: 250
                    defaultText:"some entry"
                }

                Text{
                    width: parent.width
                    font.pixelSize: 20
                    wrapMode: Text.WordWrap
                    text:  "This is an example of a completely own customizable context menu each page can set."
                }
            }
        }
    }
}

