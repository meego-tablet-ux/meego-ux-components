/*
 * Copyright 2011 Intel Corporation.
 *
 * This program is licensed under the terms and conditions of the
 * LGPL, version 2.1.  The full text of the LGPL Licence is at
 * http://www.gnu.org/licenses/lgpl.html
 */

/*!
 \qmlclass AppPage
 \title AppPage
 \section1 AppPage
 This is a basic meego-ux-components page. It provides functionality and access to the
 windows action menu and should be the base for every page used.

  \section2 API Properties

  \qmlproperty string pageTitle
  \qmlcm sets the title of the page displayed in the toolbar.

  \qmlproperty variant actionMenuModel
  \qmlcm holds the action menus clickable entries.

  \qmlproperty variant actionMenuPayload
  \qmlcm holds the action menus data for each entry.

  \qmlproperty bool enableCustomActionMenu
  \qmlcm enables custom action menus set by the AppPage.

  \qmlproperty fullScreen
  \qmlcm bool, hides the statusbar if true.

  \qmlproperty fullContent
  \qmlcm bool, hides the statusbar and the toolbar if true.

  \section2 Private Properties
  \qmlnone

  \section2 Signals

  \qmlsignal actionMenuTriggered
  \qmlcm is emitted when the an action menu entry was selected
  and returns the corrsponding item from the payload.

  \qmlsignal selectedItem
  \qmlcm holds the payload entry for the selected item.
        \param variant selectedItem
        \qmlpcm selected payload item. \endparam

  \qmlsignal actionMenuIconClicked
  \qmlcm provides the context menu position for own action menus.

  \qmlsignal activating
  \qmlcm Signal that fires when the page is about to be shown.

  \qmlsignal activated
  \qmlcm Signal that fires when the page has been shown.

  \qmlsignal deactivating
  \qmlcm Signal that fires when the page is being hidden.

  \qmlsignal deactivated
  \qmlcm Signal that fires when the page has been hidden.

  \section2 Functions
  \qmlnone

  \section2 Example
  \qml

    AppPage {
       id: singlePage

       pageTitle: "My first page"

       actionMenuModel: [ "First choice", "Second choice" ]
       actionMenuPayload: [ 1, 2 ]

       onActionMenuTriggered: {
           // an action menu entry was clicked, action menu hidden
           // and '1' or '2' returned in selectedItem
       }
    }
  \endqml   
 */

import Qt 4.7
import MeeGo.Components 0.1

Item {

    id: appPage

    width:  parent ? parent.width : 0
    height: parent ? parent.height : 0
    z: 50
    visible: false
    
    property string pageTitle: ""
    property variant actionMenuModel: []
    property variant actionMenuPayload: []
    property string actionMenuTitle: ""
    property bool actionMenuHighlightSelection: false
    property bool actionMenuOpen: false
    property bool fullScreen: false
    property bool fullContent: false
    property bool backButtonLocked: false
    property bool enableCustomActionMenu: false

    property int orientationLock: 0 // warning: int right now should be: enum of qApp

    signal actionMenuTriggered( variant selectedItem )
    signal actionMenuIconClicked( int mouseX, int mouseY )
    signal activating // emitted by PageStack.qml
    signal activated // emitted by PageStack.qml
    signal deactivating // emitted by PageStack.qml
    signal deactivated // emitted by PageStack.qml    
    signal focusChanged(bool appPageHasFocus)

    anchors.fill:  parent

    onActivating: { // from PageStack.qml
        window.fullScreen = fullScreen
        window.fullContent = fullContent
        window.toolBarTitle = pageTitle
        window.backButtonLocked = backButtonLocked
        window.actionMenuHighlightSelection = actionMenuHighlightSelection
        window.orientationLock = orientationLock
    }
    
    onActivated: { // from PageStack.qml
        window.customActionMenu = enableCustomActionMenu
        window.actionMenuModel = actionMenuModel
        window.actionMenuPayload = actionMenuPayload
        window.actionMenuTitle = actionMenuTitle
    }

    onFullScreenChanged: {
        window.fullScreen = fullScreen
    }    
    onFullContentChanged: {
        window.fullContent = fullContent
    }

    onActionMenuOpenChanged: {
        window.actionMenuPresent = actionMenuOpen
    }

    Component.onCompleted: {
        window.toolBarTitle = pageTitle
    }

    Connections{
        target: window
        onActionMenuTriggered: {
            actionMenuTriggered( selectedItem )
        }

        onActionMenuIconClicked: {
            actionMenuIconClicked( mouseX, mouseY )
        }

//        onWindowFocusChanged: { // from Window.qml

//        }

        onWindowActiveChanged: { // from Window.qml

        }
    }
}
