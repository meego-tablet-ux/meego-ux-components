/*
 * Copyright 2011 Intel Corporation.
 *
 * This program is licensed under the terms and conditions of the
 * LGPL, version 2.1.  The full text of the LGPL Licence is at
 * http://www.gnu.org/licenses/lgpl.html
 */

/*!
    \page MeeGo-Ux-Components-App-Photos
    \title  MeeGo-Ux-Components-App-Photos
    \qmlclass MeeGo-Ux-Components-App-Photos
    \section1 MeeGo-Ux-Components-App-Photos

    This application's purpose is to provide examples on how to use the MeeGo-Components properly.

    \section2 main.qml

    The Window, which can be found in the main.qml, is the main component from MeeGo-Ux-Components.

    \qml
    Window {
        id: window
        //...
    }
    \endqml

    In order to add the books of the MeeGo-Ux-Components-App-Photo, two AppPages are created as component and
    added to the bookMenu model.

    \qml
    bookMenuModel: [ qsTr("All Photos") , qsTr("All Albums") ]
    bookMenuPayload: [ photosComponent,  albumsComponent ]
    //...
    Component { id: photosComponent; MainPage {} }
    Component { id: albumsComponent; AlbumPage {} }
    \endqml

    The onCompleted signal of Window can be used to switch to a book automatically:
    \qml
    Component.onCompleted: {
        console.log("load MainPage")
        switchBook( photosComponent )
    }
    \endqml

    The Settings Item is a simple separate Item, which contains all global properties from
    MeeGo-Ux-Components-App-Photos. This is needed because books and pages may become destroyed in an App
    with Book and Page concept and the local stored data can get lost on a book switch or a
    page change. See Settings.qml for the existing properties.

    \qml
    Settings {
        id: settings
    }
    \endqml
    
    \section2 Limitations
    
    MeeGo-Ux-Components-App-Photo does not support favorite handling due to a bug, which is not related to MeeGo
    Components.
    
    \section2 Pages of  MeeGo-Ux-Photo
    \list
    \o  AlbumPage
    \o  AlbumsView
    \o  DragItem
    \o  MainPage
    \o  PhotoDetailsView
    \o  PhotosView
    \o  PhotoToolbar
    \o  Settings
    \endlist

*/

import Qt 4.7
import MeeGo.Components 0.1

Window {
    id: window

    bookMenuModel: [ qsTr("All Photos") , qsTr("All Albums") ]
    bookMenuPayload: [ photosComponent,  albumsComponent ]

    /* This is just a plain property holder for global properties */
    Settings {
        id: settings
    }

    /* On completion, the window jumps to the mainPage */
    Component.onCompleted: {
        console.log("load MainPage")
        switchBook( photosComponent )
    }

    /* These Components are the first pages of the books, added into the bookMenuModel above */
    Component { id: photosComponent; MainPage {} }
    Component { id: albumsComponent; AlbumPage {} }

    /* If you have a global ActionMenu the signal must be catched here */
    onActionMenuTriggered: {
        // selectedItem contains the selected payload entry
    }

}
