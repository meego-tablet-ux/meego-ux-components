/*
 * Copyright 2011 Intel Corporation.
 *
 * This program is licensed under the terms and conditions of the
 * LGPL, version 2.1.  The full text of the LGPL Licence is at
 * http://www.gnu.org/licenses/lgpl.html
 */

/*!
    \page AlbumPage
    \title  Meego-Ux-Components-App-Photos - Album Page
    \qmlclass AlbumPage.qml
    \section1 AlbumPage.qml

    The AlbumPage is an AppPage, which represents a page component within the book/page concept
    of MeeGo-Ux-Components.

    An AppPage can have a title in the toolbar which can be set via pageTitle and will fill the
    parent by default:
    \qml
    pageTitle: qsTr("Albums")
    anchors.fill: parent
    \endqml

    The AlbumsView is a local QML component which will show the MediaGrid of all Albums:
    \qml
    AlbumsView {

        id: allAlbumsView
        anchors.fill: parent
        model: allAlbumsModel
        ///...
    }
    \endqml

    A ContextMenu is created in order to have a ContextMenu on the photos of the Albums:
    \qml
    ContextMenu {
        id: allAlbumsContextMenu

        property alias payload: albumActionMenu.payload

        content: ActionMenu{
            id: albumActionMenu
            model: [ labelOpen, labelShare ]

            property variant payload: undefined

            onTriggered: {
                if (model[index] == labelOpen) {
                    // Open the album
                    allAlbumsView.openAlbum(payload.mitemid, payload.mtitle, false)
                }
                allAlbumsContextMenu.hide()
            }
        }
    }
    \endqml

    An AppPage can have child Pages. These Pages can be created in the parent AppPage as a
    Components. By adding the Page to the window the Component will be created.
    \qml
    Component {
        id: photoPageComponents;
        MainPage {}
    }
    \endqml

    Each AppPage will get an activated signal if the AppPage comes back to the screen:
    \qml
    onActivated: {
        settings.selectedAlbumName = "";
        console.log("AlbumPage activated")
    }
    \endqml

    The completed and the dectruction signals can be used to change properties of the Application:
    \qml
    Component.onCompleted: {
        settings.albumBook = true
        console.log("AlbumPage completed")
    }
    Component.onDestruction: {
        settings.albumBook = false
        settings.selectedAlbumName = ""
        settings.sendSelectedAlbumNameChanged();
        console.log("AlbumPage destructed")
    }
    \endqml
*/

import Qt 4.7
import MeeGo.Media 0.1 as Models
import MeeGo.Components 0.1

/* The AppPage represents one Page in the Book/Page concept of MeeGo Components. */
AppPage {
    id: allAlbumsPage

    property string labelOpen: qsTr("Open")
    property string labelPlay: qsTr("Play slideshow")
    property string labelShare: qsTr("Share")
    property string labelFavorite: qsTr("Favorite");
    property string labelUnfavorite: qsTr("Unfavorite");
    property string labelAddToAlbum: qsTr("Add to album");
    property string labelDelete: qsTr("Delete")
    property string labelMultiSelMode: qsTr("Select multiple photos")
    property string labelAll: qsTr("Show All")
    property string labelRecentlyAdded: qsTr("Recently added")
    property string labelFavorites: qsTr("Favorites")
    property string labelRecentlyViewed: qsTr("Recently viewed")

     /* Set your Page title here: */
    pageTitle: qsTr("Albums")

    /* A Page fills the window by default */
    anchors.fill: parent

    /* Meego-Ux unrelated components - the business logic of the AppPage*/
    AlbumsView {

        id: allAlbumsView
        anchors.fill: parent
        model: allAlbumsModel

        Connections{
            target: window
            onOrientationChanged: {
                allAlbumsView.contentX = 0;
                allAlbumsView.contentY = 0;
            }
        }

        onOpenAlbum: {
            // [GRG] this case is where openPhoto is called
            settings.detailViewIndex = currentIndex;
            settings.selectedAlbumName = title;
            /* Add the next page */
            window.addPage( photoPageComponents )
        }
        onPressAndHold: {
            /* Open up the ContextMenu */
            var map = payload.mapToItem(topItem.topItem, x, y);
            allAlbumsContextMenu.payload = payload;
            allAlbumsContextMenu.setPosition( map.x, map.y );
            allAlbumsContextMenu.show();
        }

        TopItem { id: topItem }

    }

    /* Models for the business logic */
    Models.PhotoListModel {
        id: allAlbumsModel
        type: Models.PhotoListModel.ListofAlbums
        limit: 0
        sort:Models.PhotoListModel.SortByDefault

        onItemAvailable: {
            console.log("Item Available: " + urn);
            console.log("album loaded");            
        }
    }

    /* A ContextMenu is created here in order to have a ContextMenu on the photos */
    ContextMenu {
        id: allAlbumsContextMenu

        property alias payload: albumActionMenu.payload

        content: ActionMenu{
            id: albumActionMenu
            model: [ labelOpen, labelShare ]

            property variant payload: undefined

            /* Implement your Actions for the Context Menu here */
            onTriggered: {
                if (model[index] == labelOpen) {
                    // Open the album
                    allAlbumsView.openAlbum(payload.mitemid, payload.mtitle, false)
                }
                else if (model[index] == labelShare) {
                    // Share; NOTE: without access to mail, this option can't be used. So for this example app it's not integrated
                   // shareAlbum(payload.mitemid, payload.mtitle,
                   //            contextInstance.menuX, contextInstance.menuY)
                }
                allAlbumsContextMenu.hide()
            }
        }
    }

    /* An AppPage can have child Pages. These Pages can be
     * created in the parent AppPage as a Components. By adding the
     * Page to the window the Component will be created. */
    Component {
        id: photoPageComponents;
        MainPage {} /* AppPage */
    }

    /* If the Page comes back into focus, the Activation signal
       will be triggered */
    onActivated: {
        settings.selectedAlbumName = "";
        console.log("AlbumPage activated")
    }

    /* On completion of the AppPage the title of the window can be changed */
    Component.onCompleted: {
        settings.albumBook = true
        console.log("AlbumPage completed")
    }
    Component.onDestruction: {
        settings.albumBook = false
        settings.selectedAlbumName = ""
        settings.sendSelectedAlbumNameChanged();
        console.log("AlbumPage destructed")
    }
}
