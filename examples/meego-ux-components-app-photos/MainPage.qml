/*
 * Copyright 2011 Intel Corporation.
 *
 * This program is licensed under the terms and conditions of the
 * LGPL, version 2.1.  The full text of the LGPL Licence is at
 * http://www.gnu.org/licenses/lgpl.html
 */

/*!
    \page MainPage
    \title  MeeGo-Ux-Components-App-Photos - Main Page
    \qmlclass MainPage.qml
    \section1 MainPage.qml

    The MainPage is an AppPage, which represents a page component within the book/page concept
    of MeeGo-Components.

    An AppPage can have a title in the toolbar which can be set via pageTitle and will fill the
    parent by default:
    \qml
    pageTitle: qsTr("Photos")
    anchors.fill: parent
    \endqml

    Each AppPage can have its own ActionMenu which consists of a model and its payload. In case
    of the AlbumPage, the ActionMenu is filled with different items. The signal actionMenuTriggered
    can be used to get a result from a ActionItem selection back to the AppPage:

    \qml
    actionMenuModel: [ labelAll, labelRecentlyAdded, labelFavorites, labelRecentlyViewed ]
    actionMenuPayload: [ labelAll, labelRecentlyAdded, labelFavorites, labelRecentlyViewed ]
    onActionMenuTriggered: {
        if (selectedItem == labelAll) {
            allPhotosModel.filter = 0
        }
        else if (selectedItem == labelRecentlyAdded) {
            allPhotosModel.filter = 3
        }
        else if (selectedItem == labelFavorites) {
            allPhotosModel.filter = 1
        }
        else if (selectedItem == labelRecentlyViewed) {
            allPhotosModel.filter = 2
        } else {
            console.log("Unexpected index triggered from action menu")
        }
    }
    \endqml

    The PhotosView is a local QML component which will show the MediaGrid of all Albums:
    \qml
    PhotosView {
        id: allPhotosView

        anchors.fill: parent
        ///...
    }
    \endqml


    The PhotoPicker is created here for selection of an album:
    \qml
    PhotoPicker {
        id: myPhotoPicker

        // custom property:
        property variant payload: []

        albumSelectionMode: true
        onAlbumSelected: {
            // save the payload and trigger another function
            console.log( "save to album")
            albumEditorModel.album = title
            albumEditorModel.addItemsOverrideVirtual( myPhotoPicker.payload, 1 )
        }
    }
    \endqml

    A ContextMenu is created in order to have a ContextMenu on the photos of the Albums:
    \qml
    ContextMenu {
        id: allPhotosContextMenu

        property alias payload: photoActionMenu.payload

        content: ActionMenu {
            id: photoActionMenu
            model: [labelOpen, labelPlay, labelFavorite, labelShare, labelAddToAlbum, labelMultiSelMode, labelDelete]

            property variant payload: undefined

            onTriggered: {
                // context menu handler for all photos page
                if (index == 0)
                {
                    console.log("0 - open photo")
                    // Open the photo
                    allPhotosView.currentIndex = payload.mindex;
                    allPhotosView.openPhoto(payload, false, false);
                }
                else if (index == 1)
                {
                    console.log("1 - play slideshow")
                    // Kick off slide show starting with this photo
                    allPhotosView.currentIndex = payload.mindex;
                    allPhotosView.openPhoto(payload, true, true)
                }
                else if (index == 2)
                {
                    console.log("2 - favorite")
                    // Mark as a favorite
                    allPhotosView.model.setFavorite(payload.mitemid, !payload.mfavorite)
                }
                else if (index == 3)
                {
                    // Share
                    console.log("3 - share")
                }
                else if (index == 4)
                {
                    console.log("4 - add to album")
                    allPhotosView.selected =  [payload.mitemid] ;
                    allPhotosView.thumburis =  [payload.mthumburi] ;
                    allPhotosView.currentIndex = payload.mindex;

                    console.log( payload.mthumburi )
                    // Open up the PhotoPicker
                    myPhotoPicker.payload = [payload.mitemid];
                    myPhotoPicker.show()
                }
                else if (index == 5)
                {
                    console.log("5 - multiselection")
                    allPhotosView.selectionMode = !allPhotosView.selectionMode;
                }
                else if (index == 6)
                {
                    console.log("6 - delete")
                    // Delete
                    // deleteItems(allPhotosPage, allPhotosModel, labelDeletePhotoText,
                    // [ payload.mitemid ], false)
                }
                allPhotosContextMenu.hide()
            }
        }
    }
    \endqml

    An AppPage can have child Pages. These Pages can be created in the parent AppPage as a
    Components. By adding the Page to the window the Component will be created.
    \qml
    Component {
        id: photoDetailsViewComponent;
        PhotoDetailsView { id: photoDetailsPage } // AppPage
    }
    \endqml

    Each AppPage will get an activated signal if the AppPage comes back to the screen:
    \qml
    onActivated: {
        updatePhotoModel();
        console.log("MainPage activated")
    }
    \endqml

    The completed and the dectruction signals can be used to change properties of the Application:
    \qml
    Component.onCompleted: {
        settings.albumBook = true
        console.log("AlbumPage completed")
    }
    Component.onDestruction: {
        updatePhotoModel();
        console.log("MainPage completed")
    }
    \endqml
*/

import Qt 4.7
import MeeGo.Media 0.1 as Models
import MeeGo.Components 0.1

/* The AppPage represents one Page in the Book/Page concept of
 * MeeGo Components. */
AppPage {

    id: allPhotosPage

    /* MeeGo-Ux-Component unrelated properties */
    property alias model: allPhotosModel
    property string labelAll: qsTr("Show All")
    property string labelOpen: qsTr("Open")
    property string labelPlay: qsTr("Play slideshow")
    property string labelShare: qsTr("Share")
    property string labelFavorite: qsTr("Favorite");
    property string labelUnfavorite: qsTr("Unfavorite");
    property string labelAddToAlbum: qsTr("Add to album");
    property string labelDelete: qsTr("Delete")
    property string labelMultiSelMode: qsTr("Select multiple photos")
    property string labelRecentlyAdded: qsTr("Recently added")
    property string labelFavorites: qsTr("Favorites")
    property string labelRecentlyViewed: qsTr("Recently viewed")
    /* end MeeGo-Ux-Components unrelated properties */

    function updatePhotoModel()
    {
        allPhotosModel.album = settings.selectedAlbumName
        if( settings.selectedAlbumName == "" ) {
            allPhotosModel.type = Models.PhotoListModel.ListofPhotos
        } else {
            allPhotosModel.type = Models.PhotoListModel.PhotoAlbum
        }
    }

    /* set your Page title here: */
    pageTitle: qsTr("Photos")

    /* A Page fills the window by default */
    anchors.fill: parent

    /* The ActionMenu of the Page can be set by a model
     * and a payload array. Both can be changed on runtime if
     * needed.
     * If an item is selected, the payload item will be send by
     * the signal actionMenuTriggered.
     */
//    actionMenuModel: [ labelAll, labelRecentlyAdded, labelFavorites, labelRecentlyViewed ]
//    actionMenuPayload: [ labelAll, labelRecentlyAdded, labelFavorites, labelRecentlyViewed ]
    actionMenuModel: [ labelAll, labelRecentlyAdded, labelRecentlyViewed ]
    actionMenuPayload: [ labelAll, labelRecentlyAdded, labelRecentlyViewed ]
    onActionMenuTriggered: {
        if (selectedItem == labelAll) {
            allPhotosModel.filter = 0
        }
        else if (selectedItem == labelRecentlyAdded) {
            allPhotosModel.filter = 3
        }
//        else if (selectedItem == labelFavorites) {
//            allPhotosModel.filter = 1
//        }
        else if (selectedItem == labelRecentlyViewed) {
            allPhotosModel.filter = 2
        } else {
            console.log("Unexpected index triggered from action menu")
        }
    }

    /* MeeGo-Ux unrelated components - the business logic of the AppPage*/
    PhotosView {
        id: allPhotosView

        anchors.fill: parent

        model: allPhotosModel

        Connections {
            target: window
            onOrientationChanged: {
                allPhotosView.contentX = 0;
                allPhotosView.contentY = 0;
            }
        }

        onOpenPhoto: {
            console.log("0 - open photo")
            // [GRG] this case is where openPhoto is called
            settings.detailViewIndex = currentIndex;
            settings.selectedPhotoName = item.mtitle
            model.setViewed(item.elementid);

            /* Add a Page to the Book */
            window.addPage( photoDetailsViewComponent )
        }

        onEnteredSingleSelectMode: { }

        onToggleSelectedPhoto: { }

        onPressAndHold : {
            /* Open up the ContextMenu */
            var map = payload.mapToItem(topItem.topItem, x, y);
            allPhotosContextMenu.payload = payload;
            topItem.calcTopParent()
            allPhotosContextMenu.setPosition( map.x, map.y );
            allPhotosContextMenu.show();
        }

        TopItem { id: topItem }
    }

    PhotoToolbar {
        id: allPhotosToolbar

        anchors.bottom: parent.bottom
        width: parent.width

        mode:  allPhotosView.selectionMode ? 2 : 1

        onPlay: {
            // [GRG] this case is the play button being clicked in all photo view
            allPhotosView.currentIndex = 0;
            var item = allPhotosView.currentItem;
            allPhotosModel.setViewed(item.elementid);
            settings.selectedPhotoName = item.mtitle;
            settings.detailViewIndex = 0;
            window.addPage( photoDetailsViewComponent )
        }

        onAddToAlbum : {            
            /* Show the PhotoPicker */
            //myPhotoPicker.payload = [item.elementid];
            myPhotoPicker.payload = allPhotosView.selected
            myPhotoPicker.show();
        }

        onDeleteSelected: {
            if (allPhotosView.selected.length == 0) {
                return
            }
            //            var text = labelDeletePhotoText
            //            if (allPhotosView.selected.length != 1) {
            //                text = labelDeletePhotosText.arg(allPhotosView.selected.length)
            //            }
            //            deleteItems(allPhotosPage, allPhotosModel, text,
            //                        allPhotosView.selected, allPhotosModel.clearSelected)
        }

        onCancel: {
            allPhotosView.selectionMode = false;
        }
    }

    /* Models for the business logic */
    Models.PhotoListModel {

        id: allPhotosModel
        type: Models.PhotoListModel.ListofPhotos
        limit: 0       
        sort: Models.PhotoListModel.SortByDefault

        onItemAvailable: {
            console.log("Item Available: " + urn);
            var itemtype = allPhotosModel.getTypefromURN(urn);
            var title = allPhotosModel.getTitlefromURN(urn);
            var index = allPhotosModel.getIndexfromURN(urn);
            console.log("Photo Name: " + title);
            if (index == -1)
                return;
            if (itemtype == 0 ) {
                // [GRG] this case is where we load a photo passed on cmdline
                // photo
               console.log("photo loaded");
            }
        }
    }
    Models.PhotoListModel {
        id: albumEditorModel
        type: Models.PhotoListModel.PhotoAlbum
        limit: 1
        sort: Models.PhotoListModel.SortByDefault
    }
    /* End MeeGo-Ux unrelated components */
    /* A PhotoPicker is created here for selection of an
     * Album. */
    PhotoPicker {
        id: myPhotoPicker

        /* custom payload inserted.
         * Not part of meego-ux-components */
        property variant payload: []

        albumSelectionMode: true
        onAlbumSelected: {
            // save the payload and trigger another function
            console.log( "save to album")
            albumEditorModel.album = title
            albumEditorModel.addItemsOverrideVirtual( myPhotoPicker.payload, 1 )
        }
    }

    /* A ModalContextMnu is created here in order to have
       a ContextMenu on the photos */
    ContextMenu {
        id: allPhotosContextMenu

        property alias payload: photoActionMenu.payload

        content: ActionMenu {
            id: photoActionMenu
//            model: [labelOpen, labelPlay, labelFavorite, labelShare, labelAddToAlbum, labelMultiSelMode, labelDelete]
            model: [labelOpen, labelPlay, labelShare, labelAddToAlbum, labelMultiSelMode, labelDelete]

            property variant payload: undefined

            /* Implement your Actions for the Context
             * Menu here */
            onTriggered: {
                // context menu handler for all photos page
                if (index == 0)
                {
//                    console.log("0 - open photo")
                    // Open the photo
                    allPhotosView.currentIndex = payload.mindex;
                    allPhotosView.openPhoto(payload, false, false);
                }
                else if (index == 1)
                {
//                    console.log("1 - play slideshow")
                    // Kick off slide show starting with this photo
                    allPhotosView.currentIndex = payload.mindex;
                    allPhotosView.openPhoto(payload, true, true)
                }
//                else if (index == 2)
//                {
//                    console.log("2 - favorite")
//                    // Mark as a favorite
//                    allPhotosView.model.setFavorite(payload.mitemid, !payload.mfavorite)
//                }
                else if (index == 2)
                {
                    // Share
//                    console.log("3 - share")
                }
                else if (index == 3)
                {
//                    console.log("4 - add to album")
                    allPhotosView.selected =  [payload.mitemid] ;
                    allPhotosView.thumburis =  [payload.mthumburi] ;
                    allPhotosView.currentIndex = payload.mindex;

                    console.log( payload.mthumburi )
                    /* Open up the PhotoPicker */
                    myPhotoPicker.payload = [payload.mitemid];
                    myPhotoPicker.show()
                }
                else if (index == 4)
                {
//                    console.log("5 - multiselection")
                    allPhotosView.selectionMode = !allPhotosView.selectionMode;
                }
                else if (index == 5)
                {
//                    console.log("6 - delete")
                    // Delete
                    // deleteItems(allPhotosPage, allPhotosModel, labelDeletePhotoText,
                    // [ payload.mitemid ], false)
                }
                allPhotosContextMenu.hide()
            }
        }
    }

    /* an AppPage can have child Pages. These Pages can be
     * created in the parent AppPage as a Components. By adding the
     * Page to the window the Component will be created. */
    Component {
        id: photoDetailsViewComponent;
        PhotoDetailsView { id: photoDetailsPage } /* AppPage */
    }

    /* if the Page comes back into focus, the Activation signal
       will be triggered */
    onActivated:  {        
        updatePhotoModel();
        console.log("MainPage activated")
    }
    /* On completion of the AppPage the title of the window
     * can be changed */
    Component.onCompleted: {
        updatePhotoModel();
        console.log("MainPage completed")
    }

    Connections {
        target: settings
        onSelectedAlbumNameChanged:
        {
            console.log("SelectedAlbumName Changed")
            updatePhotoModel();
        }
    }
}
