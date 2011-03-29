/*
 * Copyright 2011 Intel Corporation.
 *
 * This program is licensed under the terms and conditions of the
 * LGPL, version 2.1.  The full text of the LGPL Licence is at
 * http://www.gnu.org/licenses/lgpl.html
 */

/*!
  \qmlclass BottomToolBar
  \title BottomToolBar
  \section1 BottomToolBar
  \qmlcm This is a generic BottomToolBar.

  \section2  API Properties

  \qmlproperty item content
  \qmlcm this property holds the child widget of the BottomToolBar,
  most likely a BottomToolBarRow.

  \section2 Private Properties
  \qmlnone

  \section2 Signal

  \qmlsignal active
  \qmlcm emitted on fully visibility

  \qmlsignal inactive
  \qmlcm emitted on completly hidden toolbar
  
  \section2  Functions

  \qmlfn show
  \qmlcm fades the BottomToolBar in

  \qmlfn hide
  \qmlcm fades the BottomToolBar out

  \section2 Example
  \qml
  
  \endqml

*/

import Qt 4.7

Item {
    id : bottomToolBar

    // API
    property alias content: bottomToolBarSurface.children
    property bool landscape: false

    signal active;
    signal inactive;

    function show(){        
        visible = true
        scrollIn.running = true
        focus = true
    }

    function hide(){
        scrollOut.running = true
        focus = false
    }

    anchors.left: parent.left
    anchors.right: parent.right
    y: parent.height
    height: 64

    visible: false

    Theme {
        id: theme
    }

    BorderImage {
        id: background

        anchors.fill: parent
        source: (landscape) ? "image://themedimage/navigationBar_l" : "image://themedimage/navigationBar_p"
        opacity: theme.statusBarOpacity
    }

    // this item only sets up an orientation point for the content.
    // if autoCenter is off, origin is up left, otherwise it's centered.
    // This would be much better if the bottomToolBarSurface could adjust to its child size...
    // but none of the usual ways work.
    Item {
        id: bottomToolBarSurface
        anchors.fill: parent
    }

    PropertyAnimation {
        id: scrollOut
        duration: theme.dialogAnimationDuration
        target: bottomToolBar
        property: "y"
        from: bottomToolBar.parent.height - bottomToolBar.height
        to: bottomToolBar.parent.height
        easing.type: Easing.InOutQuad
        onCompleted: {
            bottomToolBar.visible = false
            inactive()
        }
    }

    PropertyAnimation {
        id: scrollIn
        duration: theme.dialogAnimationDuration
        target: bottomToolBar
        property: "y"
        from: bottomToolBar.parent.height
        to: bottomToolBar.parent.height - bottomToolBar.height
        easing.type: Easing.InOutQuad
        onCompleted: {
            bottomToolBar.visible = true
            active()
        }
    }

}

