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

  \qmlproperty bool fullScreen
  \qmlcm hides the statusbar if true.

  \qmlproperty bool fullContent
  \qmlcm hides the statusbar and the toolbar if true.

  \qmlproperty bool pageUsingFullScreen
  \qmlcm If set to true, the page will use the complete space available. Statusbar and
  toolbar will still be visible above it and obfuscate what's below. If set to false,
  the page will always occupy the space below the toolbar, stretching/squeezing to fit it.

  \qmlproperty bool actionMenuHighlightSelection
  \qmlcm set true if the actionMenu should highlight the last selected item

  \qmlproperty bool actionMenuOpen
  \qmlcm true if the actionMenu is currently open

  \qmlproperty bool backButtonLocked
  \qmlcm set to true to lock the backButton

  \qmlproperty bool fastPageSwitch
  \qmlcm if true, allows multiple addPage and popPage. If false, addPage
         and popPage calls are ignored while the page switch animation is
         busy. Default is false.

  \qmlproperty string actionMenuTitle
  \qmlcm holds the title of the actionMenu

  \qmlproperty bool showSearch
  qmlcm extends the searchbar if set to true, hides it on false. Default is false.

  \qmlproperty bool disableSearch
  qmlcm disables the searchbar on true, enables it on false. Default is false.

 \qmlproperty string lockOrientationIn
 \qmlcm this property can be used to lock the window in a given orientation.
 Possible values are:
 \qml
 "landscape"
 "portrait"
 "invertedLandscape"
 "invertedPortrait"
 Every other value will unlock the orientation. Default is "".
 \endqml

    property bool allowActionMenuSignal: true
    property bool fastPageSwitch: false

  \section2 Signals

  \qmlsignal actionMenuTriggered
  \qmlcm is emitted when the an action menu entry was selected
  and returns the corrsponding item from the payload.

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

  \qmlsignal focusChanged
  \qmlcm Signal that fires if the focus was changed.
        \param bool appPageHasFocus
        \qmlpcm true if the page has focus. \endparam

  \qmlsignal searchExtended
  \qmlcm Signal that fires when the searchbar is extending.

  \qmlsignal searchRetracted
  \qmlcm Signal that fires when the searchbar retracted.

  \qmlsignal search
  \qmlcm is sent when a string was typed into the searchbar
        \param string needle
        \qmlpcm The text that was typed into the searchbar. This signal is sent for every key pressed. \endparam

  \section2 Functions
  \qmlfn addPage
  \qmlcm adds a page to the page stack and sets it as the current page. This
  function is defined in Window.qml.
           \param  AppPage pageComponent
           \qmlpcm page which sould be added \endparam

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
    property int actionMenuSelectedIndex: -1
    property bool actionMenuOpen: false
    property bool fullScreen: false
    property bool fullContent: false
    property bool pageUsingFullScreen: false
    property bool backButtonLocked: false
    property bool enableCustomActionMenu: false
    property bool allowActionMenuSignal: false
    property bool showSearch: false
    property bool disableSearch: false
    property bool fastPageSwitch: false
    property bool pageActive: false

    property string lockOrientationIn: "" // FIXME: strings right now. Should be: enum of qApp

    signal actionMenuTriggered( variant selectedItem )
    signal actionMenuIconClicked( int mouseX, int mouseY )
    signal activating // emitted by PageStack.qml
    signal activated // emitted by PageStack.qml
    signal deactivating // emitted by PageStack.qml
    signal deactivated // emitted by PageStack.qml    
    signal focusChanged(bool appPageHasFocus)

    signal searchExtended()
    signal searchRetracted()
    signal search( string needle )

    anchors.fill:  parent
    anchors.topMargin: pageUsingFullScreen? 0 : top.topDecorationHeight //window.barsHeight

    TopItem{ id: top }

    onActivating: { // from PageStack.qml
        window.fullScreen = fullScreen
        window.fullContent = fullContent
        window.toolBarTitle = pageTitle

        window.actionMenuHighlightSelection = actionMenuHighlightSelection
        window.actionMenuSelectedIndex = actionMenuSelectedIndex
        window.backButtonLocked = backButtonLocked
        window.lockOrientationIn = lockOrientationIn
        window.showToolBarSearch = showSearch
        window.disableToolBarSearch = disableSearch
    }
    
    onActivated: { // from PageStack.qml
        window.customActionMenu = enableCustomActionMenu
        window.actionMenuModel = actionMenuModel
        window.actionMenuPayload = actionMenuPayload
        window.actionMenuTitle = actionMenuTitle
        pageActive = true
    }

    onDeactivating: { // from PageStack.qml
        pageActive = false
    }

    onFastPageSwitchChanged: {
        window.fastPageSwitch = fastPageSwitch
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

    onActionMenuSelectedIndexChanged: {
        concole.log("muuuuuuh")
        window.actionMenuSelectedIndex = actionMenuSelectedIndex
    }

    onActionMenuModelChanged: {
        window.actionMenuModel = actionMenuModel
    }

    onActionMenuPayloadChanged: {
        window.actionMenuPayload = actionMenuPayload
    }

    onActionMenuTitleChanged: {
        window.actionMenuTitle = actionMenuTitle
    }

    onBackButtonLockedChanged: {
        window.backButtonLocked = backButtonLocked
    }

    Component.onCompleted: {
        window.toolBarTitle = pageTitle
    }

    Connections{
        target: window
        onActionMenuTriggered: {
            if( pageActive )
                actionMenuTriggered( selectedItem )
        }

        onActionMenuIconClicked: {
            if( pageActive ){
               if( appPage.allowActionMenuSignal || appPage.enableCustomActionMenu ){
                  actionMenuIconClicked( mouseX, mouseY )
               }
            }
        }

//        onWindowFocusChanged: { // from Window.qml

//        }

        onWindowActiveChanged: { // from Window.qml

        }

        onSearch: if( pageActive ) appPage.search( needle )
        onSearchExtended: if( pageActive ) appPage.searchExtended()
        onSearchRetracted: if( pageActive ) appPage.searchRetracted()
    }
}
