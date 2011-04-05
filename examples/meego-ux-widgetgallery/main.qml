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

Window {
    id: window

    bookMenuModel: [ "Gallery", "Context menu test", "Book 2", "Book 3", "BottomBar", "Fullscreen Test" ]
    bookMenuPayload: [ gallery, contextMenuBook, book2, book3, bottomBar, fullScreenPage ]
    bookMenuTitle: "Book Menu"

    Component.onCompleted: switchBook( gallery )

    Component { id: gallery; MainPage {} }
    Component { id: contextMenuBook; ContextMenuBook {} }
    Component { id: book2; Book2 {} }
    Component { id: book3; Book3 {} }
    Component { id: bottomBar; WidgetPageBottomBar {} }
    Component { id: fullScreenPage; WidgetPageFullScreen {} }
}
