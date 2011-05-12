/*
* Copyright 2011 Intel Corporation.
 *
 * This program is licensed under the terms and conditions of the
 * LGPL, version 2.1.  The full text of the LGPL Licence is at
 * http://www.gnu.org/licenses/lgpl.html
 */

/*!
\qmlclass Window
 \title Window
 \section1 Window
 This file provides the main window for an meego-ux-components based application.
 The navigation structure is intended as follows:

 - 'page': An AppPage resembling the basic display widget. Here you can display any content
    you like. The main wi provides an action context menu for each page which
    can be activated via the action menu icon in the toolbar. This action context
    menu offers text entries by default, but can be completely customized if needed.

 - 'book': a set of pages. Books have a first page from which you can reach all the others,
   either directly or via other pages in the book. The window provides a page stack
   to manage them. Pages removed from the stack are destroyed.

 - main window: displays the current page. The main window can switch between books via the
   book menu icon which provides a context menu displaying all available books.
   Switching books resets the stack and displays the first page of the chosen book.

   To add books and pages to a window, set the model and a payload property:

 - the model property is a list of strings which identify the books and are used as entries for
   the book context menu.

 - the payload property is a list of indexes of the the main pages used to display them.

 \section1 IMPORTANT:
 The id of the applications main window must always be id: window

 Otherwise the AppPages cannot link correctly.

 \section1  API Properties:
 \qmlproperty string toolBarTitle
 \qmlcm sets a label for the toolbar.

 \qmlproperty bool showToolBarSearch
 \qmlcm hides/shows the search bar.

 \qmlproperty bool actionMenuActive
 \qmlcm activates/deactivates the windowMenuButton

 \qmlproperty string bookMenuModel
 \qmlcm string list that sets the menu entry labels for the bookMenu.

 \qmlproperty variant bookMenuPayload
 \qmlcm string list that sets the filenames for the books (their initial pages).

 \qmlproperty fullScreen
 \qmlcm bool, hides the statusbar if true.

 \qmlproperty fullContent
 \qmlcm bool, hides the statusbar and the toolbar if true.

 \qmlproperty bool actionMenuActive
 \qmlcm activates/deactivates the windowMenuButton.

 \qmlproperty bool automaticBookSwitching
 \qmlcm if set to 'true', selected book pages will automatically be called.
 If set to false, the page is not switched and a signal bookMenuTriggered() is sent
 to react on the selection manually.

 \qmlproperty int orientation
 \qmlcm int, the orientation the window is in. This property can be set manualy.
 \qml
 1 = landscape
 2 = portrait
 3 = inverted landscape
 4 = inverted portrait
 \endqml

 \qmlproperty string lockOrientationIn
 \qmlcm string, this property can be used to lock the window in a given orientation.
 Possible values are:
 \qml
 "landscape"
 "portrait"
 "invertedLandscape"
 "invertedPortrait"
 Every other value will unlock the orientation. Default is "".
 \endqml

 \qmlproperty bool isOrientationLocked
 \qmlcm bool, indicates if oriention was locked.

 \qmlproperty bool inLandscape
 \qmlcm bool, true if the current orientation is landscape

 \qmlproperty bool inPortrait
 \qmlcm bool, true if the current orientation is portrait

 \qmlproperty bool inInvertedLandscape
 \qmlcm bool, true if the current orientation is inverted landscape

 \qmlproperty bool inInvertedPortrait
 \qmlcm bool, true if the current orientation is inverted portrait

 \qmlproperty bool inhibitScreenSaver
 \qmlcm bool, inhibits activation of the screen saver.

 \qmlproperty bool backButtonEnabled
 \qmlcm bool, inhibits if the backButton is enabled or not. if not enabled.

 \qmlproperty Item overlayItem
 \qmlcm Item, an item spanning over the content area where the AppPages are shown. Here you can add for example
 application wide extra toolbars. This overlayItem will be above the AppPage contents, but below dialogs.

 \qmlproperty alias statusBar
 \qmlcm convenience property to anchor something to the statusBar for example. Intended as read-only.

 \qmlproperty alias toolBar
 \qmlcm convenience property to anchor something to the toolBar for example. Intended as read-only.

 \qmlproperty bool customActionMenu
 \qmlcm if true, the default context menu not shown. This enables AppPages to use completely custom context menus.

 \qmlproperty bool actionMenuPresent
 \qmlcm bool, this notifies the action and bookmenu buttons if they should be in 'pressed'

  \section1  Signals:

  \qmlsignal searchExtended
  \qmlcm Signal that fires when the searchbar is extending.

  \qmlsignal searchRetracted
  \qmlcm Signal that fires when the searchbar retracted.

  \qmlsignal search
   \qmlcm indicates that a search was started
   \param string needle
    \qmlpcm The text that was typed into the searchbar. This signal is sent for every key pressed. \endparam

  \qmlsignal actionMenuIconClicked
   \qmlcm provides the action menu context menu coordinate
    for custom action menus created by AppPages

  \qmlsignal bookMenuTriggered
   \param variant selectItem
    \qmlpcm selected payload item of the BookMenu. This is only sent when automaticBookSwitching
     is set to false. \endparam

  \qmlsignal actionMenuTriggered( variant selectedItem )
   \param variant selectItem
    \qmlpcm selected payload item of the ActionMenu \endparam

  \qmlsignal actionMenuIconClicked
   \param int mouseX
    \qmlpcm x position of the mouse \endparam
     \param int mouseY
      \qmlpcm x position of the mouse \endparam

  \qmlsignal orientationChangeAboutToStart
   \qmlcm Signals that a orientation change will come
        \param string newOrientation
        \qmlpcm provides the new orientation \endparam
        \param string oldOrientation
        \qmlpcm provides the old orientation \endparam
  \qmlsignal orientationChangeStarted
   \qmlcm Signals the start of the orientation change

  \qmlsignal orientationChangeFinished
   \qmlcm Signales the end of the orientationChange
        \param string newOrientation
        \qmlpcm provides the new orientation \endparam
        \param string oldOrientation
        \qmlpcm provides the old orientation \endparam

  \qmlsignal orientationChanged
   \qmlcm obsolete signal, will be triggered just as orientationChangeFinished.

  \section1  Functions
  \qmlfn  setBookMenuData
  \qmlcm sets model and payload at once.
        \param variant model
        \qmlpcm sets the book menus model \endparam
        \param variant payload
        \qmlpcm sets the book menus payload \endparam

  \qmlfn switchBook
  \qmlcm clears the page stack and loads the page given as parameter.
                    Usually you don't need to call that function at all if you just
                    hand a proper model and payload to the bookContextMenu. But
                    if you want to switch between books by other means, you can use
                    this function.
           \param AppPage pageComponent
           \qmlpcm first page of the selected book to switch to \endparam

  \qmlfn addPage
  \qmlcm adds a page to the page stack and sets it as the current page.
           \param  AppPage pageComponent
           \qmlpcm page which sould be added \endparam

  \qmlfn popPage
  \qmlcm pops a page to the page stack and sets the last page as the current page.

  \section1  Example
   \qml
    Window {
        id: window

        bookMenuModel: [ qsTr("Page1") , qsTr("Page2") ]
        bookMenuPayload: [ book1Component,  book2Component ]

        Component.onCompleted: {
            console.log("load MainPage")
            switchBook( book1Component )
        }

        Component { id: book1Component; Page1 {} }
        Component { id: book2Component; Page2 {} }
    }
  \endqml
*/

import Qt 4.7
import MeeGo.Components 0.1

Item {
    id: window

    property alias toolBarTitle: toolBar.title
    property alias showToolBarSearch: toolBar.showSearch
    property alias disableToolBarSearch: toolBar.disableSearch
    property alias actionMenuActive: toolBar.appFilterMenuActive

    property alias bookMenuModel: bookMenu.model
    property alias bookMenuPayload: bookMenu.payload
    property alias bookMenuTitle: bookContextMenu.title
    property alias bookMenuHighlightSelection: bookMenu.highlightSelectedItem

    property alias actionMenuModel: actionMenu.model
    property alias actionMenuPayload: actionMenu.payload
    property alias actionMenuTitle: pageContextMenu.title
    property alias actionMenuHighlightSelection: actionMenu.highlightSelectedItem

    property bool fullScreen: false
    property bool fullContent: false
    property bool isActiveWindow: true

    property bool actionMenuPresent: false

    property alias orientation: scene.orientation
    property bool isOrientationLocked: (lockOrientationIn == "landscape" || lockOrientationIn == "invertedLandscape"
                                         || lockOrientationIn == "portrait" || lockOrientationIn == "invertedPortrait")
    property string lockOrientationIn: ""

    property bool inLandscape: window_content_topitem.state == "landscape"
    property bool inPortrait: window_content_topitem.state == "portrait"
    property bool inInvertedPortrait: window_content_topitem.state == "invertedPortrait"
    property bool inInvertedLandscape: window_content_topitem.state == "invertedLandscape"

    property bool inhibitScreenSaver: false
    property bool backButtonLocked: false

    property alias overlayItem: overlayArea.children
    property alias pageStack: pageStack
    property alias statusBar: statusBar
    property alias toolBar: toolBar
    property bool automaticBookSwitching: true
    property bool customActionMenu: false
    property int topDecorationHeight: toolBar.height + toolBar.offset + ( ( fullScreen ) ? 0 : statusBar.height )

    signal searchExtended()
    signal searchRetracted()
    signal search( string needle )

    property bool fastPageSwitch: false

    signal bookMenuTriggered( variant selectedItem )
    signal actionMenuTriggered( variant selectedItem )
    signal actionMenuIconClicked( int mouseX, int mouseY )
    signal windowActiveChanged( bool isActiveWindow )
    signal backButtonPressed( bool backButtonLocked )

    signal orientationChangeAboutToStart( string oldOrientation, string newOrientation )
    signal orientationChangeStarted
    signal orientationChangeFinished( string oldOrientation, string newOrientation )
    signal orientationChanged

    //sets the content of the book menu
    function setBookMenuData( model, payload ) {
        bookMenu.model = model
        bookMenu.payload = payload
    }

    //switches between "books"
    function switchBook( pageComponent ) {
        if( !pageStack.busy ){
            pageStack.clear();  //first remove all pages from the stack
            pageStack.push( pageComponent ) //then add the new page
        }
    }

    //adds a new page of a "book"
    function addPage( pageComponent ) {
        if( !pageStack.busy || fastPageSwitch ){ pageStack.push( pageComponent ) }//add the new page
    }

    // pop the current Page from the stack
    function popPage() {
        if( !pageStack.busy || fastPageSwitch ){ pageStack.pop() }// pops the page
    }

    width: { try { screenWidth; } catch (err) { 1024; } }
    height: { try { screenHeight;} catch (err) {  576; } }
    clip: true

    Theme { id: theme }

    Translator {
        id: translator
        catalog: "meego-ux-components"
    }

    Scene {
        id: scene

        onOrientationChanged: {
            if( qApp ) {
                if(qApp.orientation != orientation)
                    qApp.orientation = orientation
            }
        }

        onOrientationLockChanged: {
            if( qApp ) {
                if( qApp.orientationLock != orientationLock )
                    qApp.orientationLock = lockOrientation
            }
        }

    }

    Item {
        id: window_content_topitem

        property string oldState: ""

        anchors.centerIn: parent

        width: (rotation == 90 || rotation == -90) ? parent.height : parent.width
        height: (rotation == 90 || rotation == -90) ? parent.width : parent.height

        StatusBar {
            id: statusBar

            x: 0
            y: if( fullContent ){
                - statusBar.height - clipBox.height
            }
            else if( fullScreen ){
                - statusBar.height
            }
            else{
                0
            }
            width: window_content_topitem.width
            height: 30
            z: 1

            Behavior on y {
                PropertyAnimation {
                    duration: theme.dialogAnimationDuration
                    easing.type: "OutSine"
                }
            }
        } //end of statusBar

        //the toolbar consists of a searchbar and the titlebar. The latter contains menus for navigation and actions.
        Item {
            id: clipBox

            anchors.top: statusBar.bottom
            width: parent.width
            height: toolBar.height + toolBar.offset

            clip: true

            Behavior on height {
                NumberAnimation{
                    duration: theme.dialogAnimationDuration
                }
            }

            Item {
                id: toolBar

                property string title: ""   //title shown in the toolBar
                property bool showSearch: false //search bar visible?
                property bool disableSearch: false  //search bar interactive?
                property bool appFilterMenuActive: true  //ActionMenu visible
                property bool showBackButton: pageStack.depth > 1    //show back button if more than one page is on the stack
                property int offset: toolBar.showSearch ? 0 : -searchTitleBar.height

                width: parent.width
                height: searchTitleBar.height + titleBar.height

                //If search isn't shown, hide behind statusbar
                anchors.top: clipBox.top
                anchors.topMargin: offset // toolBar.showSearch ? 0 : -searchTitleBar.height

                onShowSearchChanged: {
                    if( showSearch ){
                        window.searchExtended()
                    }
                    else{
                        window.searchRetracted()
                    }
                }

                Behavior on anchors.topMargin {
                    NumberAnimation{
                        duration: theme.dialogAnimationDuration
                    }
                }

                Image {
                    id: searchTitleBar

                    height: 50
                    width: parent.width
                    source: "image://themedimage/widgets/common/toolbar/toolbar-background"
                    anchors.top:  parent.top

                    TextEntry {
                        id: searchBox

                        anchors { fill: parent; rightMargin: 10; topMargin: 5; bottomMargin: 5; leftMargin: 10  }

                        onTextChanged: window.search(text)
                    }
                }

                Image {
                    id: titleBar

                    anchors.top: searchTitleBar.bottom
                    width: parent.width
                    height: backButton.height
                    source: "image://themedimage/widgets/common/toolbar/toolbar-background"

                    MouseArea {
                        id: titleBarArea

                        property int firstY: 0
                        property int firstX: 0

                        anchors.fill: parent

                        onPressed: {
                            firstY = mouseY;
                            firstX = mouseX;
                        }

                        //react on vertical mouse gestures on the titleBar to show or hide the searchTitleBar
                        onMousePositionChanged: {
                            if( titleBarArea.pressed ) {
                                if( Math.abs( titleBarArea.mouseX - titleBarArea.firstX ) < Math.abs( titleBarArea.mouseY - titleBarArea.firstY ) ) {
                                    if( titleBarArea.mouseY - titleBarArea.firstY > 20 ) {
                                        if( !toolBar.disableSearch ) {
                                            toolBar.showSearch = true
                                        }
                                    }
                                    else if( titleBarArea.mouseY - titleBarArea.firstY < -20 ) {
                                        toolBar.showSearch = false
                                    }
                                }
                            }
                        }
                    }

                    Image {
                        id: backButton

                        anchors.left: parent.left
                        source: if( backButtonMouseArea.pressed && !backButtonLocked ) {
                            "image://themedimage/images/icn_toolbar_back_button_dn"
                        } else {
                            "image://themedimage/images/icn_toolbar_back_button_up"
                        }
                        visible: toolBar.showBackButton

                        MouseArea {
                            id: backButtonMouseArea
                            enabled: !pageStack.busy
                            anchors.fill: parent
                            onClicked: {
                                backButtonPressed( backButtonLocked )
                                if( !backButtonLocked )
                                    pageStack.pop()
                            }
                        }
                    }

                    Image {
                        id: spacer

                        visible: backButton.visible
                        anchors.left: backButton.right
                        source: "image://themedimage/widgets/common/toolbar/toolbar-item-separator"
                    }

                    Text {
                        id: toolbarTitleLabel

                        anchors.horizontalCenter: parent.horizontalCenter
                        width: parent.width / 2
                        height: parent.height

                        text: toolBar.title
                        color: theme.toolbarFontColor
                        font.pixelSize: theme.toolbarFontPixelSize
                        elide: Text.ElideRight
                        verticalAlignment: Text.AlignVCenter
                        horizontalAlignment: Text.AlignHCenter
                    }

                    Image {
                        id: menuSpacer

                        anchors.right: applicationMenuButton.left
                        visible: applicationMenuButton.visible
                        source: "image://themedimage/widgets/common/toolbar/toolbar-item-separator"
                    }

                    //the application menu is used to switch between "books"
                    Image {
                        id: applicationMenuButton

                        anchors.right: spacer2.left
                        visible: bookMenu.height > 0

                        source: if( applicationMenuButtonMouseArea.pressed || bookContextMenu.visible ) {
                            "image://themedimage/images/icn_toolbar_view_menu_dn"
                        } else {
                            "image://themedimage/images/icn_toolbar_view_menu_up"
                        }

                        MouseArea {
                            id: applicationMenuButtonMouseArea

                            anchors.fill: parent
                            onClicked: {
//                                bookContextMenu.setPosition( applicationMenuButton.x + applicationMenuButton.width / 2  , mapToItem( window_content_topitem, window_content_topitem.width / 2, applicationMenuButton.y + applicationMenuButton.height ).y )
                                bookContextMenu.setPosition( applicationMenuButton.x + applicationMenuButton.width / 2  , topDecorationHeight - applicationMenuButton.height / 3 )
                                bookContextMenu.show()
                            }
                        }

                        ContextMenu{
                            id: bookContextMenu

                            fogMaskVisible: false
                            forceFingerMode: 2

                            content:  ActionMenu{
                                id: bookMenu

                                onTriggered: {
                                    if(automaticBookSwitching ) {
                                        switchBook( payload[index] )
                                    }
                                    else {
                                        bookMenuTriggered( payload[index] )
                                    }

                                    bookContextMenu.hide()
                                }
                            }
                        }
                    } //end applicationMenuButton

                    Image {
                        id: spacer2

                        anchors.right: windowMenuButton.left
                        visible: windowMenuButton.visible
                        source: "image://themedimage/widgets/common/toolbar/toolbar-item-separator"
                    }

                    //the window menu is used to perform actions on the current page
                    Image {
                        id: windowMenuButton

                        anchors.right: parent.right
                        visible: actionMenu.height > 0 || customActionMenu  // hide action button when actionMenu is empty

                        source: if( windowMenuButtonMouseArea.pressed || window.actionMenuPresent) {
                            "image://themedimage/images/icn_toolbar_applicationpage_menu_dn"
                        } else {
                            "image://themedimage/images/icn_toolbar_applicationpage_menu_up"
                        }

                        MouseArea {
                            id: windowMenuButtonMouseArea

                            anchors.fill: parent
                            onClicked: {

                                actionMenuIconClicked( windowMenuButton.x + windowMenuButton.width / 2, topDecorationHeight - windowMenuButton.height / 3 )

                                if( !customActionMenu ){
                                    pageContextMenu.setPosition( windowMenuButton.x + windowMenuButton.width / 2, topDecorationHeight - windowMenuButton.height / 3 )
                                    pageContextMenu.show()
                                }
                            }
                        }

                        ContextMenu {
                            id: pageContextMenu

                            fogMaskVisible: false
                            forceFingerMode: 2

                            onVisibleChanged: {
                                window.actionMenuPresent = visible
                            }

                            content:  ActionMenu {
                                id: actionMenu

                                onTriggered: {
                                    window.actionMenuTriggered( payload[index] )
                                    pageContextMenu.hide()
                                }
                            }
                        }

                    } //end windowMenuButton


                } //end titleBar
            } //end toolBar
        }

        //add a page stack to manage pages
        PageStack {
            id: pageStack
            anchors { top: clipBox.bottom; bottom: parent.bottom; left: parent.left; right: parent.right }
        }

        Item {
            id: overlayArea
            anchors { top: clipBox.bottom; bottom: parent.bottom; left: parent.left; right: parent.right }
        }

        state: if(isActiveWindow){
                   if(lockOrientationIn != "landscape" && lockOrientationIn != "invertedLandscape"
                           && lockOrientationIn != "portrait" && lockOrientationIn != "invertedPortrait")
                       scene.orientationString
                   else{
                       lockOrientationIn
                   }
               }
               else{
                   "windowHasNoFocus"
               }

        states:  [
            State {
                name: "windowHasNoFocus"
                when: (!isActiveWindow)
            },
            State {
                name: "landscape"                

                PropertyChanges {
                    target: window_content_topitem
                    rotation: 0
                    width: parent.width
                    height: parent.height
                }
            },
            State {
                name: "invertedLandscape"

                PropertyChanges {
                    target: window_content_topitem
                    rotation: 180
                    width: parent.width
                    height: parent.height
                }
            },
            State {
                name: "portrait"                

                PropertyChanges {
                    target: window_content_topitem
                    rotation: -90
                    width: parent.height
                    height: parent.width
                }
            },
            State {
                name: "invertedPortrait"

                PropertyChanges {
                    target: window_content_topitem
                    rotation: 90
                    width: parent.height
                    height: parent.width
                }
            }
        ] // end states

        transitions: Transition {
            SequentialAnimation {
                ScriptAction {
                    script: {
                        window.orientationChangeFinished( window_content_topitem.oldState, window_content_topitem.state )
                        window.orientationChangeStarted()
                    }
                }
                ParallelAnimation {
                    PropertyAction {
                        target: statusBar;
                        property: "width";
                        value: window_content_topitem.width
                    }
                    RotationAnimation {
                        target: window_content_topitem
                        direction: RotationAnimation.Shortest;
                        duration: isActiveWindow ? theme.dialogAnimationDuration : 0
                    }
                    PropertyAnimation {
                        target: window_content_topitem
                        properties: "width,height"
                        duration: isActiveWindow ? theme.dialogAnimationDuration : 0
                        easing.type: "OutSine"
                    }
                }
                ScriptAction {
                    script: {
                        window.orientationChangeFinished( window_content_topitem.oldState, window_content_topitem.state )
                        window.orientationChanged()
                        window_content_topitem.oldState = window_content_topitem.state
                    }
                }
            }
        } // end transitions
    } // end window_content_topitem

    // repositions the context menu after orientation change
    onOrientationChangeFinished: {
        pageContextMenu.setPosition( windowMenuButton.x + windowMenuButton.width / 2, topDecorationHeight - applicationMenuButton.height / 3 )
        bookContextMenu.setPosition( applicationMenuButton.x + applicationMenuButton.width / 2  , topDecorationHeight - applicationMenuButton.height / 3 )
    }

    onInhibitScreenSaverChanged: { // to meego-qml-launcher
        try {
	    mainWindow.inhibitScreenSaver = inhibitScreenSaver            
        } catch (err) {        
	  console.log("mainWindow does not exist")
        }        
    }

    // Repositions the context menu after the windows width and/or height have changed.
    onWidthChanged: {
        pageContextMenu.setPosition( windowMenuButton.x + windowMenuButton.width / 2, topDecorationHeight - applicationMenuButton.height / 3 )
        bookContextMenu.setPosition( applicationMenuButton.x + applicationMenuButton.width / 2  , topDecorationHeight - applicationMenuButton.height / 3 )
    }

    onHeightChanged: {
        pageContextMenu.setPosition( windowMenuButton.x + windowMenuButton.width / 2, topDecorationHeight - applicationMenuButton.height / 3 )
        bookContextMenu.setPosition( applicationMenuButton.x + applicationMenuButton.width / 2  , topDecorationHeight - applicationMenuButton.height / 3 )
    }

    Connections {
        target: qApp

        onForegroundWindowChanged: {

            //FIXME what does onForegroundWindowChanged do
            isActiveWindow = (foregroundWindow != 0)
            qApp.orientationLock = scene.orientationLocked
            windowFocusChanged( isActiveWindow )

            statusBar.active = foreground
            console.log(" ----- " + foreground)

            if( isActiveWindow ) {
                scene.orientation = qApp.orientation;
            }
        }
        /* FIXME currently not available
        onOrientationLockChanged: {
            if( scene.orientationLocked != qApp.orientationLock )
            scene.orientationLocked = qApp.orientationLock
        } */

        onOrientationChanged: {
            scene.orientation = qApp.orientation;
        }
    }
}
