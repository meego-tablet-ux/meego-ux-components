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
 This component provides the main window for an meegoUx-components application.

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

 \qmlproperty alias actionMenuModel
 \qmlcm string list that sets the menu entry labels for the actionMenu

 \qmlproperty actionMenuPayload
 \qmlcm variant, sets payload for the actionMenu

 \qmlproperty fullscreen
 \qmlcm bool, sets if the statusbar is shown or not

 \qmlproperty bool actionMenuActive
 \qmlcm activates/deactivates the windowMenuButton

 \qmlproperty bool orientationLocked
 \qmlcm bool, indicates if oriention was

 \section1 Private Properties
 \qmlproperty pageStack, statusBar, toolBar and actionMenu are convenient properties if
 for example you want to anchor something to these items.
       - customActionMenu: if enabled the own action context menu is not shown and the
         signal actionMenuIconClicked emitted. This enables AppPages to use their
         completely own context menus.

  \section1  Signals:

  \qmlsignal search
   \qmlcm indicates that a search was started

  \qmlsignal actionMenuIconClicked
   \qmlcm provides the action menu context menu coordinate
    for custom action menus created by AppPages

  \qmlsignal actionMenuTriggered( variant selectedItem )
   \param variant selectItem
    \qmlpcm selected Item of the ActionMenu \endparam

  \qmlsignal actionMenuIconClicked
   \param int mouseX
    \qmlpcm x position of the mouse \endparam
     \param int mouseY
      \qmlpcm x position of the mouse \endparam

  \qmlsignal orientationChangeAboutToStart
   \qmlcm Signals that a orientation change will come

  \qmlsignal orientationChangeStarted
   \qmlcm Signals the start of the orientation change

  \qmlsignal orientationChangeFinished
   \qmlcm Signales the end of the orientationChange
        \param string newOrientation
        \qmlpcm provides the new orientation \endparam

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

  \section1  Example
   \qml
    Window {

    id: window

    bookMenuModel: [ qsTr("Page1") , qsTr("Page2") ]
    bookMenuPayload: [ book1Component,  book2Component ]

    Component.onCompleted: {
    console.log("load MainPage")
    switchBook( photosComponent )
    }

    Component { id: book1Component; Page1 {} }
    Component { id: book2Component; Page2 {} }

    onActionMenuTriggered: {
    // selectedItem contains the selected payload entry
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

    property alias actionMenuModel: actionMenu.model
    property alias actionMenuPayload: actionMenu.payload
    property alias actionMenuTitle: pageContextMenu.title

    property bool fullScreen: false
    property bool actionMenuPresent: false

    property bool inLandscape: true
    property bool inPortrait: false

    property alias orientation: window_content_topitem.currentOrientation
    property alias orientationLocked: window_content_topitem.orientationLocked

    property alias pageStack: pageStack
    property alias statusBar: statusBar
    property alias toolBar: toolBar

    property bool customActionMenu: false

    property int topDecorationHeight: toolBar.height + toolBar.offset + ( ( fullScreen ) ? 0 : statusBar.height )

    signal search(string needle)
    signal actionMenuTriggered( variant selectedItem )
    signal actionMenuIconClicked( int mouseX, int mouseY )
    signal orientationChangeAboutToStart
    signal orientationChangeStarted
    signal orientationChangeFinished(  string oldOrientation, string newOrientation )
    signal orientationChanged // obsolete

    //sets the content of the book menu
    function setBookMenuData( model, payload ) {
        bookMenu.model = model
        bookMenu.payload = payload
    }

    //switches between "books"
    function switchBook( pageComponent ) {
        if( !pageStack.busy ){
            //setActionMenu( null ); //remove the current ActionMenu
            pageStack.clear();  //first remove all pages from the stack
            pageStack.push( pageComponent ) //then add the new page
        }
    }

    //adds a new page of a "book"
    function addPage( pageComponent ) {
        if( !pageStack.busy ){ pageStack.push( pageComponent ) }//add the new page
    }

    width: { try { screenWidth; } catch (err) { 1024; } }
    height: { try { screenHeight;} catch (err) {  576; } }
    clip: true

    Theme { id: theme }

    //how does that work? needed here?
    Translator {
        catalog: "meego-tablet-components"
    } // Translator

    Item {
        id: window_content_topitem

        property bool orientationLocked: false

        property int apiOrientation: 1
        property int appOrientation: 1
        property int currentOrientation: 1

        property string oldOrientation
        property bool setFromQApp: false

        function setOrientation( orientationInt ) {
            appOrientation = orientationInt
            if( !orientationLocked) {
                setFromQApp = true
                if( currentOrientation != orientationInt) {
                    oldOrientation = state
                    currentOrientation = appOrientation
                    apiOrientation = appOrientation
                }
            } else if ( (appOrientation == 1 && currentOrientation == 3) ||
                        (appOrientation == 3 && currentOrientation == 1) ) {
                currentOrientation == appOrientation
                apiOrientation == appOrientation
            } else if ( (appOrientation == 0 && currentOrientation == 2) ||
                        (appOrientation == 2 && currentOrientation == 0) ) {
                currentOrientation == appOrientation
                apiOrientation == appOrientation
            }
        }

        Behavior on apiOrientation {
            ScriptAction {
                script: {
                    if(!setFromQApp) {
                        if( apiOrientation < 0) {
                            orientationLocked = false
                            currentOrientation = appOrientation
                        } else {
                            orientationLocked = true
                            currentOrientation = apiOrientation

                        }
                    }
                    setFromQApp = false
                }
            }
        }


        anchors.centerIn: parent

        width: (rotation == 90 || rotation == -90) ? parent.height : parent.width
        height: (rotation == 90 || rotation == -90) ? parent.width : parent.height

        StatusBar {
            id: statusBar

            x: 0
            y: 0
            width: window_content_topitem.width
            height: 30
            z: 1

            states: [
                State {
                    name: "fullscreen"
                    when: window.fullScreen

                    PropertyChanges {
                        target: statusBar
                        y: - statusBar.height
                    }
                }
            ]

            transitions: [
                Transition {
                    from: ""
                    to: "fullscreen"
                    reversible: true

                    PropertyAnimation {
                        properties: "y"
                        duration: 250
                        easing.type: "OutSine"
                    }
                }
            ]
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
                    duration: 200
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

                Behavior on anchors.topMargin {
                    NumberAnimation{
                        duration: 200
                    }
                }

                Image {
                    id: searchTitleBar

                    height: 50
                    width: parent.width
                    source: "image://themedimage/titlebar_l"
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
                    source: "image://themedimage/titlebar_l"

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
                        source: if( backButtonMouseArea.pressed ) {
                                    "image://themedimage/icn_toolbar_back_button_dn"
                                } else {
                                    "image://themedimage/icn_toolbar_back_button_up"
                                }
                        visible: toolBar.showBackButton

                        MouseArea {
                            id: backButtonMouseArea

                            anchors.fill: parent
                            onClicked: { if( !pageStack.busy ){ pageStack.pop() } }
                        }
                    }

                    Image {
                        id: spacer

                        visible: backButton.visible
                        anchors.left: backButton.right
                        source: "image://themedimage/icn_toolbar_button_divider"
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
                        source: "image://themedimage/icn_toolbar_button_divider"
                    }

                    //the application menu is used to switch between "books"
                    Image {
                        id: applicationMenuButton

                        anchors.right: spacer2.left
                        visible: true
                        source: if( applicationMenuButtonMouseArea.pressed || bookContextMenu.visible ) {
                                    "image://themedimage/icn_toolbar_view_menu_dn"
                                } else {
                                    "image://themedimage/icn_toolbar_view_menu_up"
                                }

                        MouseArea {
                            id: applicationMenuButtonMouseArea

                            anchors.fill: parent
                            onClicked: {
                                bookContextMenu.setPosition( applicationMenuButton.x + applicationMenuButton.width / 2  , mapToItem( window_content_topitem, window_content_topitem.width / 2, applicationMenuButton.y + applicationMenuButton.height ).y )
                                bookContextMenu.show()
                            }
                        }

                        ModalContextMenu{
                            id: bookContextMenu

                            fogMaskVisible: false
                            forceFingerMode: 2

                            content:  ActionMenu{
                                id: bookMenu

                                onTriggered: {
                                    switchBook( payload[index] )
                                    bookContextMenu.hide()
                                }
                            }
                        }
                    } //end applicationMenuButton

                    Image {
                        id: spacer2

                        anchors.right: windowMenuButton.left
                        visible: windowMenuButton.visible
                        source: "image://themedimage/icn_toolbar_button_divider"
                    }

                    //the window menu is used to perform actions on the current page
                    Image {
                        id: windowMenuButton

                        anchors.right: parent.right
                        visible: actionMenu.height > 0 || customActionMenu  // hide action button when actionMenu is empty

                        source: if( windowMenuButtonMouseArea.pressed || window.actionMenuPresent) {
                                    "image://themedimage/icn_toolbar_applicationpage_menu_dn"
                                } else {
                                    "image://themedimage/icn_toolbar_applicationpage_menu_up"
                                }

                        MouseArea {
                            id: windowMenuButtonMouseArea

                            anchors.fill: parent
                            onClicked: {
                                if( customActionMenu ){
                                    actionMenuIconClicked( windowMenuButton.x + windowMenuButton.width / 2, topDecorationHeight )
                                }
                                else{
                                    pageContextMenu.setPosition( windowMenuButton.x + windowMenuButton.width / 2, topDecorationHeight )
                                    pageContextMenu.show()
                                }
                            }
                        }

                        ModalContextMenu {
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

        states:  [
            State {
                name: "landscape"
                when: (window_content_topitem.currentOrientation == 1)
                PropertyChanges {
                    target: window
                    inLandscape: true
                    inPortrait: false
                }
                PropertyChanges {
                    target: window_content_topitem
                    rotation: 0
                    width: parent.width
                    height: parent.height
                }
            },
            State {
                name: "invertedlandscape"
                when: (window_content_topitem.currentOrientation == 3)
                PropertyChanges {
                    target: window
                    inLandscape: true
                    inPortrait: false
                }
                PropertyChanges {
                    target: window_content_topitem
                    rotation: 180
                    width: parent.width
                    height: parent.height
                }
            },
            State {
                name: "portrait"
                when: (window_content_topitem.currentOrientation == 2)
                PropertyChanges {
                    target: window
                    inLandscape: false
                    inPortrait: true
                }
                PropertyChanges {
                    target: window_content_topitem
                    rotation: -90
                    width: parent.height
                    height: parent.width
                }
            },
            State {
                name: "invertedportrait"
                when: (window_content_topitem.currentOrientation == 0)
                PropertyChanges {
                    target: window
                    inLandscape: false
                    inPortrait: true
                }
                PropertyChanges {
                    target: window_content_topitem
                    rotation: 90
                    width: parent.height
                    height: parent.width
                }
            }
        ] // end states

        transitions: Transition {
            from: "*"
            to: "*"
            reversible: true

            SequentialAnimation {
                ScriptAction {
                    script: {
                        window.orientationChangeAboutToStart()
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
                        duration: 220
                    }
                    PropertyAnimation {
                        target: window_content_topitem
                        properties: "width,height"
                        duration: 220
                        easing.type: "OutSine"
                    }
                }
                ScriptAction {
                    script: {
                        window.orientationChangeFinished( window_content_topitem.oldOrientation, window_content_topitem.state );
                        window.orientationChanged();
                    }
                }
            }
        } // end transitions
    } // end window_content_topitem

    // repositions the context menu after orientation change
    onOrientationChangeFinished: {
        pageContextMenu.setPosition( windowMenuButton.x + windowMenuButton.width / 2, topDecorationHeight )
        bookContextMenu.setPosition( applicationMenuButton.x + applicationMenuButton.width / 2  , topDecorationHeight )
    }

    // Repositions the context menu after the windows width and/or height have changed.
    onWidthChanged: {
        pageContextMenu.setPosition( windowMenuButton.x + windowMenuButton.width / 2, topDecorationHeight )
        bookContextMenu.setPosition( applicationMenuButton.x + applicationMenuButton.width / 2  , topDecorationHeight )
    }

    onHeightChanged: {
        pageContextMenu.setPosition( windowMenuButton.x + windowMenuButton.width / 2, topDecorationHeight )
        bookContextMenu.setPosition( applicationMenuButton.x + applicationMenuButton.width / 2  , topDecorationHeight )
    }

    Component.onCompleted: {
        try {
            window_content_topitem.currentOrientation = qApp.orientation;
            window_content_topitem.setOrientation(  window_content_topitem.currentOrientation )
        } catch (err) {
            window_content_topitem.currentOrientation = 1
            window_content_topitem.setOrientation( window_content_topitem.currentOrientation )
        }
    }
    Connections {
        target: qApp
        onOrientationChanged: {
            window_content_topitem.currentOrientation = qApp.orientation;
            window_content_topitem.setOrientation( window_content_topitem.currentOrientation )
        }
    }
}
