/*
 * Copyright 2011 Intel Corporation.
 *
 * This program is licensed under the terms and conditions of the
 * LGPL, version 2.1.  The full text of the LGPL Licence is at
 * http://www.gnu.org/licenses/lgpl.html
 */

/*!
  \qmlclass BottomToolBar
  \title BottomToolbar
  \section1 BottomToolbar
  \qmlcm This is a base qml for bottomToolBard widgets. 

  \section2  API Properties

  \qmlproperty item contents
  \qmlcm this property holds the child widget of the BottomToolBar, most likely a BottomToolBarRow

  \qmlproperty bool fogClickable
  \qmlcm wether the ModalFog closes if the fog was clicked

  \qmlproperty bool fogMaskVisible
  \qmlcm hides the fog, but still maintains a invisible mouse area

  \section2 Private Properties
  \qmlnone

  \section2 Signal

  \qmlsignal visible
  \qmlcm emitted on fully visibility

  \qmlsignal hidden
  \qmlcm emitted on completly hidden toolbar
  
  \qmlsignal showCalled
  \qmlcm notifies the children that the BottomToolBar is about to show

  \section2  Functions

  \qmlfn  show
  \qmlcm fades the BottomToolBar in

  \qmlfn hide
  \qmlcm fades the BottomToolBar out

  \section2 Example
  \qml
  
  \endqml
*/

import Qt 4.7

Item {
    id : bottomToolBarRow

    // API
    property alias leftContent: bottomToolBarRowContentLeft.children
    property alias centerContent: bottomToolBarRowContentCenter.children
    property alias rightContent: bottomToolBarRowContentRight.children

    anchors.fill: parent

    Item {
        id: contentLeft

        anchors.verticalCenter: parent.verticalCenter
        anchors.right: contentCenter.left
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.leftMargin: 15
    }
    Item {
        id: contentCenter

        anchors.verticalCenter: parent.verticalCenter
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        width: 200
    }
    Item {
        id: contentRight

        anchors.verticalCenter: parent.verticalCenter
        anchors.left: contentCenter.right
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.rightMargin: 15
    }
}

