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
    property string pageTitle: ""

    property variant actionMenuModel: []
    property variant actionMenuPayload: []
    property string actionMenuTitle: ""

    property bool enableCustomActionMenu: false

    signal actionMenuTriggered( variant selectedItem )
    signal actionMenuIconClicked( int mouseX, int mouseY )
    property bool actionMenuOpen: false

    visible: false

    // Signal that fires when the page is being activated.
    signal activating

    // Signal that fires when the page has been activated.
    signal activated

    // Signal that fires when the page is being deactivated.
    signal deactivating

    // Signal that fires when the page has been deactivated.
    signal deactivated

    onActivated: {
        window.toolBarTitle = pageTitle
        window.customActionMenu = enableCustomActionMenu
        window.actionMenuModel = actionMenuModel
        window.actionMenuPayload = actionMenuPayload
        window.actionMenuTitle = actionMenuTitle
    }

    onActionMenuOpenChanged: {
        window.actionMenuPresent = actionMenuOpen
    }

    Component.onCompleted: {
        window.toolBarTitle = pageTitle
    }

    anchors.fill:  parent

    Connections{
        target: window
        onActionMenuTriggered: {
            actionMenuTriggered( selectedItem )
        }
        onActionMenuIconClicked: {
            actionMenuIconClicked( mouseX, mouseY )
        }
    }
}
