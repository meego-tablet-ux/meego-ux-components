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

 \qmlproperty bool disableToolBarSearch
 \qmlcm bool, set to false it the toolbar search modus should be functionable

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

 \qmlproperty alias bookMenuHighlightSelection
 \qmlcm bool, sets the highlightSelectedItem property of the book menu. See ActionMenu

 \qmlproperty int bookMenuSelectedIndex
 \qmlcm int, sets the selected index for the book menu.

 \qmlproperty bool bookMenuActive
 \qmlcm activates/deactivates the book menu

 \qmlproperty fullContent
 \qmlcm bool, hides the statusbar and the toolbar if true.

 \qmlproperty fullScreen
 \qmlcm bool, hides the statusbar if true.

 \qmlproperty bool isActiveWindow
 \qmlcm true if Window is on foreground

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

 \qmlproperty int sensorOrientation
 \qmlcm int, the orientation of the sensor. This property can not be set manualy.
 \qml
 1 = landscape
 2 = portrait
 3 = inverted landscape
 4 = inverted portrait
 \endqml

 \qmlproperty int orientationLock
 \qmlcm int, locks the orientation in the given mode.
 Possible values are:
 0: no lock
 1: lock in landscape
 2: lock in portrait
 3: lock in invertedLandscape
 4: lock in invertedPortrait
 5: lock to both landscapes
 6: lock to both portraits

 \qmlproperty bool isOrientationLocked
 \qmlcm bool, indicates if oriention was locked. Read-only.

 \qmlproperty bool inLandscape
 \qmlcm bool, true if the current orientation is landscape

 \qmlproperty bool inPortrait
 \qmlcm bool, true if the current orientation is portrait

 \qmlproperty bool inInvertedLandscape
 \qmlcm bool, true if the current orientation is inverted landscape

 \qmlproperty bool inInvertedPortrait
 \qmlcm bool, true if the current orientation is inverted portrait

 \qmlproperty bool blockOrientationWhenInactive
 \qmlcm book, by default true, defines wheater the orientation will be processed while app is inactive, in the background

 \qmlproperty bool inhibitScreenSaver
 \qmlcm bool, inhibits activation of the screen saver.

 \qmlproperty bool backButtonLocked
 \qmlcm bool, If true, inhibits if the backButton from changing the pacge stack.

 \qmlproperty Item content
 \qmlcm the content area where the AppPages are shown. By default the PageStack and the overlayArea are
 children of the content.

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

  \qmlproperty [signal] searchExtended
  \qmlcm Signal that fires when the searchbar is extending.

  \qmlproperty [signal] searchRetracted
  \qmlcm Signal that fires when the searchbar retracted.

  \qmlproperty [signal] search
   \qmlcm indicates that a search was started
   \param string needle
    \qmlpcm The text that was typed into the searchbar. This signal is sent for every key pressed. \endparam

  \qmlproperty [signal] actionMenuIconClicked
   \qmlcm provides the action menu context menu coordinate
    for custom action menus created by AppPages

  \qmlproperty [signal] bookMenuTriggered
   \param int index
    \qmlpcm selected index of the BookMenu. This is only sent when automaticBookSwitching
     is set to false. \endparam

  \qmlproperty [signal] actionMenuTriggered( variant selectedItem )
   \param variant selectItem
    \qmlpcm selected payload item of the ActionMenu \endparam

  \qmlproperty [signal] actionMenuIconClicked
   \param int mouseX
    \qmlpcm x position of the mouse \endparam
     \param int mouseY
      \qmlpcm x position of the mouse \endparam

  \qmlproperty [signal] orientationChangeAboutToStart
   \qmlcm Signals that a orientation change will come
        \param string newOrientation
        \qmlpcm provides the new orientation \endparam
        \param string oldOrientation
        \qmlpcm provides the old orientation \endparam

  \qmlproperty [signal] orientationChangeStarted
   \qmlcm Signals the start of the orientation change

  \qmlproperty [signal] orientationChangeFinished
   \qmlcm Signales the end of the orientationChange
        \param string newOrientation
        \qmlpcm provides the new orientation \endparam
        \param string oldOrientation
        \qmlpcm provides the old orientation \endparam

  \qmlproperty [signal] orientationChanged
   \qmlcm obsolete signal, will be triggered just as orientationChangeFinished.

  \section1  Functions
  \qmlfn  setBookMenuData
  \qmlcm sets model and payload at once.
        \param variant model
        \qmlpcm sets the book menus model \endparam
        \param variant payload
        \qmlpcm sets the book menus payload \endparam

  \qmlfn switchBook
  \qmlcm clears the page stack and loads the page or page array given as parameter.
                    Usually you don't need to call that function at all if you just
                    hand a proper model and payload to the bookContextMenu. But
                    if you want to switch between books by other means, you can use
                    this function.
           \param AppPage/Array pageComponent
           \qmlpcm Either the first page of the selected book to switch to (in scalar context) or an ordered list of 
                   pages that make up a book to switch to.  The last page in the array will be visible.\endparam

  \qmlfn switchBookByIndex
  \qmlcm clears the page stack and loads the page given as parameter.
                    See also switchBook()
           \param int index
           \qmlpcm zero-based index in to the bookMenuPayload array \endparam

  \qmlfn addPage
  \qmlcm adds a page or array of pages to the page stack and changes the current page.
           \param  AppPage pageComponent
           \qmlpcm page which sould be added \endparam
           \qmlpcm Either a page that should be added or an array of pages to be added.  In either case, the last new 
                   page added will be visible.\endparam

  \qmlfn popPage
  \qmlcm pops a page to the page stack and sets the last page as the current page.

  \qmlfn replacePage
  \qmlcm replaces the top page of the page stack with the given page and sets the last page as the current page.

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
import MeeGo.Ux.Kernel 0.1
import MeeGo.Ux.Gestures 0.1
import MeeGo.Ux.Components.Common 0.1
import MeeGo.Ux.Components.Indicators 0.1
import MeeGo.Components 0.1

Item {
    id: window
    objectName: "window"

    property alias toolBarTitle: toolBar.title
    property alias showToolBarSearch: toolBar.showSearch
    property alias disableToolBarSearch: toolBar.disableSearch
    property alias actionMenuActive: toolBar.appFilterMenuActive

    property variant bookMenuModel: []
    property alias bookMenuPayload: bookMenu.payload
    property alias bookMenuTitle: bookContextMenu.title
    property alias bookMenuHighlightSelection: bookMenu.highlightSelectedItem
    property alias bookMenuSelectedIndex: bookMenu.selectedIndex
    property bool  bookMenuActive: true

    property alias actionMenuModel: actionMenu.model
    property alias actionMenuPayload: actionMenu.payload
    property alias actionMenuTitle: pageContextMenu.title
    property alias actionMenuHighlightSelection: actionMenu.highlightSelectedItem
    property alias actionMenuSelectedIndex: actionMenu.selectedIndex

    property bool fullContent: false
    property bool fullScreen: false

    property bool actionMenuPresent: false

    property string lockOrientationIn: "noLock" // deprecated see orientationLock

    property alias isActiveWindow: scene.isActiveScene
    property alias orientation: scene.orientation
    property alias sensorOrientation: scene.sensorOrientation
    property alias blockOrientationWhenInactive: scene .blockOrientationWhenInactive
    property alias orientationLock: scene.orientationLock
    property alias isOrientationLocked: scene.orientationLocked
    property alias lockCurrentOrientation: scene.lockCurrentOrientation     // deprecated
    property alias inhibitScreenSaver: scene.inhibitScreenSaver
    property alias inLandscape: scene.inLandscape
    property alias inPortrait: scene.inPortrait
    property alias inInvertedLandscape: scene.inInvertedLandscape
    property alias inInvertedPortrait: scene.inInvertedPortrait
    property alias orientationString: scene.orientationString

    property bool backButtonLocked: false

    property alias content: window_content_topitem
    property alias overlayItem: overlayArea.children    
    property alias pageStack: pageStack
    property alias statusBar: statusBar
    property alias toolBar: toolBar
    property bool automaticBookSwitching: true
    property bool customActionMenu: false

    // height of tool and status bar plus the searchbar. This is needed for dialogs and context menus to compute their max sizes.
    property int topDecorationHeight: toolBar.height + toolBar.y + statusBar.height  + statusBar.y

    // height of tool and status bar. This is needed for the AppPages and overlayItem to compute their size
    property int barsHeight: titleBar.height + statusBar.height + statusBar.y

    // this shifts the content if a text input would be covered by the visual keyboard
    property real contentVerticalShift: 0

    //private properties for virtual keyboard shifting
    property int currentVkbHeight: 0
    property int currentVkbWidth:  0

    //: page switch direction. Don't translate to other languages, instead change the string to "right-to-left" for languages where right to left reading directions are desired
    property string pageSwitchDirection: qsTr("left-to-right")

    // DEPRECATED - Functionality replaced by switchBook(Array) and addPage(Array)
    property bool fastPageSwitch: false

    signal searchExtended()
    signal searchRetracted()
    signal search( string needle )

    signal bookMenuTriggered( int index )
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
        bookMenuModel = model
        bookMenuPayload = payload
    }

    //switches between "books"
    function switchBook( pageComponent ) {
        pageStack.clear()  //first remove all pages from the stack
        addPage(pageComponent)
    }

    function switchBookByIndex( index ) {
        bookMenu.selectedIndex = index
        sideBar.selectedIndex = index
        switchBook(bookMenuPayload[index])
    }

    //adds a new page of a "book"
    function addPage( pageComponent ) {
        if (Array.prototype.isPrototypeOf(pageComponent)) {
            // function was called with an array of page components
            for (page in pageComponent) {
                pageStack.push( page )
            }
        }
        else {
            // function was called with a single page (or at least it wasn't an array)
            pageStack.push( pageComponent ) //then add the new page
        }
    }

    // pop the current Page from the stack
    function popPage() {
        pageStack.pop()
    }

    function replacePage(page) {
        pageStack.replace(page)
    }

    //called by a TextEntry or TextField when the virtual keyboard comes up. Shifts the content up
    //if the TextEntry/TextField would be covered by the VKB.
    function adjustForVkb( textItemBottom, vkbWidth, vkbHeight ) {
        var offset
        if( vkbHeight < vkbWidth ) {
            offset = vkbHeight - ( window_content_topitem.height - textItemBottom + contentVerticalShift )
        } else {
            offset = vkbWidth - ( window_content_topitem.height - textItemBottom + contentVerticalShift )
        }

        if( offset > 0 ) {
            contentVerticalShift = -offset
        } else {
            contentVerticalShift = 0
        }
    }

    function updateVkbShift( textItemBottom ) {
        if( currentVkbHeight > 0 ) {
            var offset
            if( currentVkbHeight < currentVkbWidth ) {
                offset = currentVkbHeight - ( window_content_topitem.height - textItemBottom + contentVerticalShift )
            }else {
                offset = currentVkbWidth - ( window_content_topitem.height - textItemBottom + contentVerticalShift )
            }

            if( offset > 0 ) {
                contentVerticalShift = -offset
            }else {
                contentVerticalShift = 0
            }
        }
    }

    visible: ( isActiveWindow || pageStack.depth == 0 )
    width: { try { screenWidth; } catch (err) { 1024; } }
    height: { try { screenHeight;} catch (err) {  576; } }
    clip: true

    onSearchRetracted: {
        searchBox.text = ""
        if( mainWindow ) {
            mainWindow.dismissKeyboard()
        }
    }

    Theme { id: theme }

    Translator {
        id: translator
        catalog: "meego-ux-components"
    }

    Rectangle {
        id: nonRotatingBackground
        anchors.fill: parent
        color: "black"
        visible: false
        Connections {
            target: window
            onOrientationChangeFinished: {
                nonRotatingBackground.visible = false
            }
            onOrientationChangeStarted: {
                nonRotatingBackground.visible = (pageStack.depth > 0)
            }
        }
    }

    // For BMC#20259 (bugs.meego.com/show_bug.cgi?id=20259)
    // Work around for Qt Gestures bug.  If there is no Gesture area to capture
    // an event, then the next event is lost also.
    GestureArea {
        anchors.fill: parent
        Pan {}
        Tap {}
        TapAndHold{}
        Pinch{}
        Swipe{}
    }

    Item {
        id: window_content_topitem

        Rectangle {
            id: rotatingBackground
            anchors.fill: parent
            color: "white"
            visible: false
            z: -3
            Connections {
                target: window
                onOrientationChangeFinished: {
                    rotatingBackground.visible = false
                }
                onOrientationChangeStarted: {
                    rotatingBackground.visible = (pageStack.depth > 0)
                }
            }
        }

        property string oldState: ""

        anchors.centerIn: parent

        width: (rotation == 90 || rotation == -90) ? parent.height : parent.width
        height: (rotation == 90 || rotation == -90) ? parent.width : parent.height


        StatusBar {
            id: statusBar

            x: 0
            y: if( fullScreen ){
                   - statusBar.height - clipBox.height
               }
               else if( fullContent ){
                   - statusBar.height
               }
               else{
                   0
               }
            width: window_content_topitem.width
            height: 30

            active: window.isActiveWindow

            Behavior on y {
                PropertyAnimation {
                    duration: theme.dialogAnimationDuration
                    easing.type: "OutSine"
                }
            }

            function estimateVisibility() {
                if( fullScreen || fullContent) {
                    hide();
                } else {
                    show();
                }
            }

            Connections {
                target: window
                onFullScreenChanged: {
                    statusBar.estimateVisibility()
                }
                onFullContentChanged: {
                    statusBar.estimateVisibility()
                }
            }

            Component.onCompleted: {
                statusBar.estimateVisibility()
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
            Behavior on anchors.topMargin {
                NumberAnimation{
                    duration: theme.dialogAnimationDuration
                }
            }

            Item {
                id: toolBar

                property string title: ""   //title shown in the toolBar
                property bool showSearch: false //search bar visible?
                property bool disableSearch: true  //search bar interactive?
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

                    GestureArea {
                        id: titleBarArea
                        anchors.fill: parent

                        Pan {
                            onUpdated: {
                                if( gesture.offset.y > 20 ) {
                                    if( !toolBar.disableSearch ) {
                                        toolBar.showSearch = true
                                    }
                                } else if ( gesture.offset.y < 20 ) {
                                    toolBar.showSearch = false
                                }
                            }
                        }
                    }

                    IconButton {
                        id: backButton

                        anchors.left:  parent.left
                        visible:  bookMenuActive && (pageStack.depth > 1)

                        icon: "image://themedimage/icons/toolbar/go-back"
                        iconDown: "image://themedimage/icons/toolbar/go-back-selected"

                        bgSourceDn: "image://themedimage/widgets/common/toolbar-item/toolbar-item-background-active"
                        bgSourceUp: ""

                        onClicked: {
                            if( !pageStack.busy ) {
                                window.backButtonPressed( window.backButtonLocked )
                                if( !window.backButtonLocked ) {
                                    pageStack.pop()
                                }
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
                    IconButton {
                        id: applicationMenuButton

                        anchors.right: spacer2.left
                        visible: bookMenuActive && (bookMenu.height > 0)
                        opacity: visible ? 1 : 0    // force repaint

                        icon: bookContextMenu.visible? "image://themedimage/icons/toolbar/view-change-selected" : "image://themedimage/icons/toolbar/view-change"
                        iconDown: "image://themedimage/icons/toolbar/view-change-selected"

                        bgSourceDn: "image://themedimage/widgets/common/toolbar-item/toolbar-item-background-active"
                        bgSourceUp: bookContextMenu.visible? "image://themedimage/widgets/common/toolbar-item/toolbar-item-background-active" : ""

                        onClicked: {
                            bookContextMenu.setPosition( applicationMenuButton.x + applicationMenuButton.width / 2  , topDecorationHeight - applicationMenuButton.height / 10 )
                            bookContextMenu.show()
                        }

                        ContextMenu{
                            id: bookContextMenu

                            fogMaskVisible: false
                            forceFingerMode: 2

                            content:  ActionMenu{
                                id: bookMenu

                                model: bookMenuActive ? bookMenuModel : 0
                                highlightSelectedItem: true

                                onTriggered: {
                                    if(automaticBookSwitching ) {
                                        switchBook( payload[index] )
                                    }
                                    else {
                                        bookMenuTriggered( index )
                                    }

                                    bookContextMenu.hide()
                                }

                                //TODO: Move this higher up in the hierarchy; 
                                // but only when we have a better idea of what to save and not to save

                                SaveRestoreState {
                                    id: saveRestoreBookMenu
                                    onSaveRequired: {
                                        setValue("meego.ux.components.bookMenu.visible", bookMenu.visible);
                                        sync();
                                    }
                                }

                                Component.onCompleted: {
                                    if(saveRestoreBookMenu.restoreRequired &&
                                       (saveRestoreBookMenu.value("meego.ux.components.bookMenu.visible") == "true")) {
                                        bookContextMenu.show();
                                    }
                                }

                            }
                        }
                    } //end applicationMenuButton

                    Image {
                        id: spacer2

                        anchors.right: windowMenuButton.left
                        visible: bookMenuActive && (windowMenuButton.visible || applicationMenuButton.visible)
                        source: "image://themedimage/widgets/common/toolbar/toolbar-item-separator"
                    }

                    //the window menu is used to perform actions on the current page
                    IconButton {
                        id: windowMenuButton

                        anchors.right: parent.right
                        visible: bookMenuActive && (actionMenu.height > 0 || customActionMenu)  // hide action button when actionMenu is empty
                        opacity: visible ? 1 : 0    // force repaint

                        icon: window.actionMenuPresent? "image://themedimage/icons/toolbar/view-actions-selected" : "image://themedimage/icons/toolbar/view-actions"
                        iconDown: "image://themedimage/icons/toolbar/view-actions-selected"

                        bgSourceDn: "image://themedimage/widgets/common/toolbar-item/toolbar-item-background-active"
                        bgSourceUp: window.actionMenuPresent? "image://themedimage/widgets/common/toolbar-item/toolbar-item-background-active" : ""

                        onClicked: {
                            actionMenuIconClicked( windowMenuButton.x + windowMenuButton.width / 2, topDecorationHeight - windowMenuButton.height / 10 )

                            if( !customActionMenu ){
                                pageContextMenu.setPosition( windowMenuButton.x + windowMenuButton.width / 2, topDecorationHeight - windowMenuButton.height / 10 )
                                pageContextMenu.show()
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

                    states: [
                        State {
                            name: "rightToLeft"
                            PropertyChanges {
                                target: backButton
                                rotation: 180
                            }
                            AnchorChanges {
                                target: backButton
                                anchors.left: undefined
                                anchors.right: parent.right
                            }
                            AnchorChanges {
                                target: spacer
                                anchors.left: undefined
                                anchors.right: backButton.left
                            }
                            AnchorChanges {
                                target: menuSpacer
                                anchors.right: undefined
                                anchors.left: applicationMenuButton.right
                            }
                            AnchorChanges {
                                target: applicationMenuButton
                                anchors.right: undefined
                                anchors.left: spacer2.right
                            }
                            AnchorChanges {
                                target: spacer2
                                anchors.right: undefined
                                anchors.left: windowMenuButton.right
                            }
                            AnchorChanges {
                                target: windowMenuButton
                                anchors.right: undefined
                                anchors.left: parent.left
                            }
                            when: window.pageSwitchDirection == "right-to-left"
                        }
                    ]

                } //end titleBar
            } //end toolBar
        } //end clipBox

        Item {
            id: contentBackground
            visible: !bookMenuActive

            z: -2

            anchors {
                top:  clipBox.bottom
                bottom: parent.bottom
                left: parent.left
                right: parent.right
            }

            ThemeImage {
                anchors.fill:  parent
                source: "image://themedimage/widgets/common/backgrounds/global-background-texture"
                horizontalTileMode: BorderImage.Repeat
                verticalTileMode: BorderImage.Repeat
            }
            ThemeImage {
                anchors.fill:  parent
                source: "image://themedimage/widgets/common/backgrounds/global-background-gradient"
            }

            Flickable {
                id: sideBarFlick

                anchors {
                    top:  parent.top
                    bottom: parent.bottom
                    left:  parent.left
                    topMargin: window.contentVerticalShift
                    bottomMargin: -window.contentVerticalShift
                }

                //visible: width>0
                width: (! bookMenuActive && ! fullScreen) ? (sideBarBackground.width + 10) : 0
                contentHeight: sideBarBackground.height + 10*2

                onContentHeightChanged: {
                    if(contentHeight <= height) {
                        contentY = 0
                    }
                }

                Behavior on width {
                    NumberAnimation { duration: theme.dialogAnimationDuration }
                }

                interactive: contentHeight > height
                clip: true
                flickDeceleration: 250

                ThemeImage {
                    id: sideBarBackground

                    anchors {
                        top:  parent.top
                        left:  parent.left
                        topMargin: 10
                        leftMargin: 10
                        bottomMargin: 10
                    }
                    width:  sideBarInnerBackground.width + 2*2
                    height: Math.max(contentBackground.height - 10*2, sideBarInnerBackground.height + 2*2)

                    source: "image://themedimage/widgets/common/backgrounds/content-background"

                    Item {
                        id: sideBarInnerBackground
                        anchors {
                            top:  parent.top
                            left:  parent.left
                            margins: 2
                        }
                        width:  sideBar.width
                        height:  sideBar.height

                        //color: "red"
                        //opacity: 0.3

                        WindowSideBar {
                            id: sideBar

                            anchors.top: parent.top
                            anchors.left: parent.left
                            // height is determined by the contents
                            width: (contentBackground.width - 10*3) / 3

                            Behavior on width {
                                NumberAnimation { duration: theme.dialogAnimationDuration }
                            }

                            selectedIndex: bookMenuSelectedIndex
                            model: bookMenuModel ? bookMenuModel : 0

                            onTriggered: {
                                selectedIndex = index;
                                if(automaticBookSwitching ) {
                                    if( bookMenuPayload ){
                                        switchBook( bookMenuPayload[index] )
                                    }
                                }
                                else {
                                    bookMenuTriggered( index )
                                }
                           }

                        } //end sideBar
                    } //end sideBarInnerBackground
                } //end  sideBarBackground
            } //end sideBarFlick

            Flickable {
                id: pageFlick

                anchors {
                    top: parent.top
                    bottom: parent.bottom
                    left: sideBarFlick.right
                    right: parent.right
                    topMargin: window.contentVerticalShift
                    bottomMargin: -window.contentVerticalShift
                }

                onContentHeightChanged: {
                    if( contentHeight <= height ) {
                        contentY = 0
                    }
                }

                contentWidth: width
                contentHeight: pageBackground.height + 10*2

                interactive: contentHeight > height
                clip: true
                flickDeceleration: 250

                ThemeImage {
                    id: pageBackground

                    anchors {
                        top: parent.top
                        left: parent.left
                        right: parent.right
                        topMargin: 10
                        leftMargin: 10
                        rightMargin: 10
                    }
                    height: Math.max(contentBackground.height - 10*2, pageInnerBackground.height + 2*2)

                    source: "image://themedimage/widgets/common/backgrounds/content-background"

//                    Rectangle {color:"red";anchors.fill: parent; opacity: 0.3; z:99}

                    Item {
                        id: pageInnerBackground
                        clip: true
                        anchors {
                            top: parent.top
                            left: parent.left
                            right: parent.right
                            topMargin: 2
                            bottomMargin: 2
                            rightMargin: 2
                            leftMargin: 2
                        }
                        height: pageTitleBar.height + pageStack.height + 2*2

                        Item  {
                            id: pageTitleBar

                            anchors.top:  parent.top
                            anchors.left: parent.left
                            anchors.right: parent.right
                            visible: ! bookMenuActive && ! fullScreen
                            height: visible ? pageTitleBackButton.height : 0

                            IconButton {
                                id: pageTitleBackButton

                                anchors.left:  parent.left
                                visible:  pageStack.depth > 1

                                icon: "image://themedimage/icons/toolbar/content-back"
                                iconDown: "image://themedimage/icons/toolbar/content-back-active"

                                bgSourceDn: "image://themedimage/widgets/common/action-item/action-item-content-background-back-active"
                                bgSourceUp: ""

                                onClicked: {
                                    if( !pageStack.busy ) {
                                        window.backButtonPressed( window.backButtonLocked )
                                        if( !window.backButtonLocked ) {
                                            pageStack.pop()
                                        }
                                    }
                                }
                            }

                            Image {
                                id: pageTitleSpacer

                                visible: pageStack.depth > 1
                                anchors.left: pageTitleBackButton.right
                                source: "image://themedimage/widgets/common/toolbar/toolbar-item-separator"
                                height: pageTitleBackButton.height
                            }

                            Text {
                                id: pageToolbarTitleLabel

                                anchors {
                                    top:  parent.top
                                    bottom:  parent.bottom
                                    left: (pageStack.depth > 1) ? pageTitleSpacer.left : pageTitleBar.left
                                    right: parent.right
                                    leftMargin: 10
                                    rightMargin: 10
                                }

                                text: "Book Title Goes Here"

                                color: "black"
                                font.pixelSize: theme.fontPixelSizeLarge
                                elide: Text.ElideRight
                                verticalAlignment: Text.AlignVCenter
                                horizontalAlignment: Text.AlignLeft  // TODO: right-to-left text
                            }
                        } //end pageTitleBar

                        Item {
                            id: pageStackContainerLandscape

                            //property bool pageUsingFullScreen: currentPage ? currentPage.pageUsingFullScreen : false
                            //z: -2
                            //y: pageUsingFullScreen ? window.contentVerticalShift : window.contentVerticalShift + topDecorationHeight - barsHeight

                            anchors {
                                top: pageTitleBar.bottom
                                left:  parent.left
                                right: parent.right
                            }
                            height: pageStack.height
                        }  //pageStackContainerLandscape
                    }

                } //end pageParent
            } //end pageFlick

        } //end contentBackground

        Item {
            id: pageStackContainerOriginal

            property bool pageUsingFullScreen: pageStack.currentPage ? pageStack.currentPage.pageUsingFullScreen : false
            z: -2
            y: pageUsingFullScreen ? window.contentVerticalShift : window.contentVerticalShift + topDecorationHeight - barsHeight

            width: parent.width
            height: parent.height

        }  //pageStackContainerOriginal

        //add a page stack to manage pages
        PageStack {
            id: pageStack
            bookMenuActive: window.bookMenuActive
            parent: bookMenuActive ? pageStackContainerOriginal : pageStackContainerLandscape

            pageSwitchDirection: window.pageSwitchDirection

            onNewPageTitle: {
                if (bookMenuActive) {
                    window.toolBarTitle = newPageTitle
                }
                else {
                    pageToolbarTitleLabel.text = newPageTitle
                }
            }

            onCurrentPageChanged: { // if a new page appears, reset scrolling
                if(!bookMenuActive){
                    pageFlick.contentY = 0
                }
            }

            onNewFullScreen: window.fullScreen = newFullScreen
            onNewFullContent: window.fullContent = newFullContent
            onNewActionMenuOpen: window.actionMenuPresent = newActionMenuOpen
            onNewActionMenuSelectedIndex: window.actionMenuSelectedIndex = newActionMenuSelectedIndex
            onNewActionMenuModel: window.actionMenuModel = newActionMenuModel
            onNewActionMenuPayload: window.actionMenuPayload = newActionMenuPayload
            onNewActionMenuTitle:  window.actionMenuTitle = newActionMenuTitle
            onNewBackButtonLocked: window.backButtonLocked = newBackButtonLocked
        }  //end pageStack

        Item {
            id: overlayArea
            z: -1
            y: pageStack.pageUsingFullScreen ? pageStack.y : pageStack.y + window.barsHeight

            width: parent.width
            height: pageStack.pageUsingFullScreen ? pageStack.height : pageStack.height - window.barsHeight
        } //end overlayArea

        states:  [            
            State {
                name: "landscape"                
                when: ( scene.orientationString == "landscape")

                PropertyChanges {
                    target: window_content_topitem
                    rotation: 0
                    width: parent.width
                    height: parent.height
                }

            },
            State {
                name: "invertedLandscape"
                when: ( scene.orientationString == "invertedLandscape")

                PropertyChanges {
                    target: window_content_topitem
                    rotation: 180
                    width: parent.width
                    height: parent.height
                }
            },
            State {
                name: "portrait"                
                when: ( scene.orientationString == "portrait")

                PropertyChanges {
                    target: window_content_topitem
                    rotation: -90
                    width: parent.height
                    height: parent.width
                }
            },
            State {
                name: "invertedPortrait"
                when: ( scene.orientationString == "invertedPortrait")

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
                        duration: scene.isActiveScene ? theme.dialogAnimationDuration : 0
                    }
                    PropertyAnimation {
                        target: window_content_topitem
                        properties: "width,height"
                        duration: scene.isActiveScene ? theme.dialogAnimationDuration : 0
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

        Item {
            id: debugInfo

            anchors.left: parent.left
            anchors.top: parent.top
            width: debugInfoText.width
            height: debugInfoText.height

            Rectangle {
                anchors.fill: parent
                color: "white"
                opacity: 0.5
            }
            Text {
                id: debugInfoText

                anchors.left: parent.left
                anchors.top:  parent.top
                width: (text.length > 0) ? (paintedWidth + 3*2) : 0
                height: paintedHeight + 3*2

                color: "purple"
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
                text: mainWindow.debugInfo
            } //debugInfo
        }

    } // end window_content_topitem

    // repositions the context menu after orientation change
    onOrientationChangeFinished: {
        if(pageContextMenu.visible){
            pageContextMenu.setPosition( windowMenuButton.x + windowMenuButton.width / 2, topDecorationHeight - windowMenuButton.height / 10 )
        }
        if(bookContextMenu.visible){
            bookContextMenu.setPosition( applicationMenuButton.x + applicationMenuButton.width / 2  , topDecorationHeight - applicationMenuButton.height / 10 )
        }
    }

    // Repositions the context menu after the windows width and/or height have changed.
    onWidthChanged: {
        if(pageContextMenu.visible){
            pageContextMenu.setPosition( windowMenuButton.x + windowMenuButton.width / 2, topDecorationHeight - windowMenuButton.height / 10 )
        }
        if(bookContextMenu.visible){
            bookContextMenu.setPosition( applicationMenuButton.x + applicationMenuButton.width / 2  , topDecorationHeight - applicationMenuButton.height / 10 )
        }
    }

    onHeightChanged: {
        if(pageContextMenu.visible){
            pageContextMenu.setPosition( windowMenuButton.x + windowMenuButton.width / 2, topDecorationHeight - applicationMenuButton.height / 10 )
        }
        if(bookContextMenu.visible){
            bookContextMenu.setPosition( applicationMenuButton.x + applicationMenuButton.width / 2  , topDecorationHeight - applicationMenuButton.height / 10 )
        }
    }

    onLockOrientationInChanged: { // deprecated!

        if( lockOrientationIn == "landscape" ) {
            scene.orientationLock = 1;
        } else if( lockOrientationIn == "portrait" ) {
            scene.orientationLock = 2;
        } else if( lockOrientationIn == "invertedLandscape" ) {
            scene.orientationLock = 3;
        } else if( lockOrientationIn == "invertedPortrait" ) {
            scene.orientationLock = 4;
        } else if( lockOrientationIn == "allLandscape" ) {
            scene.orientationLock = 5;
        } else if( lockOrientationIn == "allPortrait" ) {
            scene.orientationLock = 6;
        } else if( lockOrientationIn == "noLock" ) {
            scene.orientationLock = 0;
        }
    }

    onActionMenuTriggered: {
        pageStack.emitActionMenuTriggered( selectedItem )
    }

    onActionMenuIconClicked: {
        pageStack.emitActionMenuIconClicked( mouseX, mouseY )
    }

    //    onSearch: if( pageActive ) appPage.search( needle )
    //    onSearchExtended: if( pageActive ) appPage.searchExtended()
    //    onSearchRetracted: if( pageActive ) appPage.searchRetracted()

    // Meego-qml-launcher handling
    Scene {
        id: scene
        onOrientationChanged: {
            if( mainWindow.actualOrientation != scene.orientation)
                mainWindow.actualOrientation = scene.orientation;
        }
        onOrientationLockChanged: {
            if( qApp.orientationLocked != orientationLocked ) {
                qApp.orientationLocked = scene.orientationLocked
            }
        }
        onInhibitScreenSaverChanged: {
            mainWindow.inhibitScreenSaver = scene.inhibitScreenSaver
        }
        Component.onCompleted: {
            scene.winId       = mainWindow.winId;
            scene.activeWinId = qApp.foregroundWindow;
            scene.orientation = qApp.orientation;           
        }
    }

    Connections {
        target: qApp
        onForegroundWindowChanged: {
            scene.winId = mainWindow.winId;
            if( scene.activeWinId != qApp.foregroundWindow ) {
                if( scene.winId == qApp.foregroundWindow )
                    scene.orientation = qApp.orientation
                scene.activeWinId = qApp.foregroundWindow
            }
        }
        onOrientationChanged: {
            scene.orientation = qApp.orientation
        }
    }
    Connections {
        target: mainWindow
        onWinIdChanged: {
            scene.winId = mainWindow.winId;
        }
        onVkbHeight: {
            currentVkbHeight = height;
            currentVkbWidth = width;
            if( height == 0 ) {
                contentVerticalShift = 0;
            }
        }
    }
}
