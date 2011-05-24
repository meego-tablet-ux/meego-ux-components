/*
 * Copyright 2011 Intel Corporation.
 *
 * This program is licensed under the terms and conditions of the
 * LGPL, version 2.1.  The full text of the LGPL Licence is at
 * http://www.gnu.org/licenses/lgpl.html
 */

/* The starting point for the widgetgallery. This is the window which
   contains the book menu and controls the book/page switch. */

import Qt 4.7
import MeeGo.Components 0.1
import MeeGo.Ux.Gestures 0.1

Window {
    id: window

    bookMenuModel: [ qsTr("Gallery"), qsTr("Context menu test"), qsTr("Book 2"), qsTr("Book 3"), qsTr("BottomBar"), qsTr("Fullscreen Test"), qsTr("Orientation Test") ]
    bookMenuPayload: [ gallery, contextMenuBook, book2, book3, bottomBar, fullScreenPage, orientationPage ]
    bookMenuTitle: qsTr("Book Menu")

    Component.onCompleted: {
        switchBook( gallery )
        bookMenuSelectedIndex = 0
    }

//    overlayItem: Rectangle {  // this is a very simple example for overlayItem use.
//        color: "green"
//        anchors.fill: parent
//        opacity: 0.5
//        Rectangle {  // this is a very simple example for overlayItem use.
//                color: "red"
//                anchors.fill: parent
//                opacity: 0.5
//                anchors.margins: 10
//            }
//    }

    Component { id: gallery; MainPage { name: qsTr("Gallery") } }
    Component { id: contextMenuBook; ContextMenuBook { name: qsTr("Context menu test") } }
    Component { id: book2; Book2 { name: qsTr("Book 2") } }
    Component { id: book3; Book3 { name: qsTr("Book 3") } }
    Component { id: bottomBar; WidgetPageBottomBar { name: qsTr("BottomBar") } }
    Component { id: fullScreenPage; WidgetPageFullScreen { name: qsTr("Fullscreen Test") } }
    Component { id: orientationPage; WidgetPageOrientation { name: qsTr("Orientation Test") } }
}
