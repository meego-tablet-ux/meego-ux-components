/*
 * Copyright 2011 Intel Corporation.
 *
 * This program is licensed under the terms and conditions of the
 * LGPL, version 2.1.  The full text of the LGPL Licence is at
 * http://www.gnu.org/licenses/lgpl.html
 */

/*!
\page PhotoDetailsView
\title  MeeGo-Ux-App-Photos - PhotoDetailsView
\qmlclass PhotoDetailsView.qml
\section1 PhotoDetailsView.qml

The PhotoDetailsView is an AppPage, which represents a page component within the book/page concept
of MeeGo-Components. An AppPage can have a title in the toolbar which can be set via pageTitle and will fill the
parent by default:
\qml
pageTitle: qsTr("Photos")
anchors.fill: parent
\endqml

The PhotoViewer is a local QML component which will show the MediaGrid of all Albums:
\qml
PhotoViewer {
    id: photoViewer
    anchors.fill: parent
    ///...
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
        updatePhotoModel()
        showPhotoAtIndex( settings.detailViewIndex )
        delayedComplete.start()
        console.log("PhotoDetailsView completed")
    }

    onActivated:  {
        console.log("PhotoDetailsView activated")
    }
\endqml
*/

import Qt 4.7
import MeeGo.Media 0.1 as Models
import MeeGo.Components 0.1

/* The AppPage represents one Page in the Book/Page concept of
 * MeeGo Components. */
AppPage {

    id: photoDetailsPage

    /* set your Page title here: */
    pageTitle: qsTr("Photos")

    property variant model: detailsPhotosModel

    // view modes
    // 0 - photo viewer with side bar and tool bar
    // 1 - photo viewer only
    // 2 - photo viewer with tool bar (GRG 1/20/11 - not using this atm afaik)
    property int viewMode: 0
    property bool startInFullscreen: false
    property bool startInSlideshow: false

    property alias currentItem: photoViewer.currentItem
    property alias toolbar: toolbar

    signal currentIndexChanged(int index)
    signal pressAndHoldOnPhoto(variant mouse, variant instance)
    signal enterSingleSelectionMode()

    function updatePhotoModel()
    {
        detailsPhotosModel.album = settings.selectedAlbumName
        if( settings.selectedAlbumName == "" ) {
            detailsPhotosModel.type =  Models.PhotoListModel.ListofPhotos
        } else {
            detailsPhotosModel.type = Models.PhotoListModel.PhotoAlbum
        }
    }

    function showPhotoAtIndex(index) {
        photoViewer.showPhotoAtIndex(index);
    }

    function activate() {
        viewMode = 0;
    }

    function startSlideshow() {
        viewMode = 1
        catchall.visible = true

        if (photoViewer.currentIndex == photoViewer.count - 1)
            photoViewer.currentIndex = 0

        timer.start()
    }

    function toggleFavorite() {
        model.setFavorite( settings.selectedElementid, toolbar.isFavorite);
    }

    Timer {
        id: delayedComplete
        interval: 50
        repeat: false
        onTriggered: {
            if (startInFullscreen)
                viewMode = 1
            if (startInSlideshow)
                startSlideshow()
        }
    }

    Component.onCompleted: {
        updatePhotoModel()
        showPhotoAtIndex( settings.detailViewIndex )
        delayedComplete.start()
        console.log("PhotoDetailsView completed")
    }

    onActivated:  {
        console.log("PhotoDetailsView activated")
    }
    Timer {
        id: timer
        interval: 3000
        repeat: true
        onTriggered: {
            var index = photoViewer.currentIndex;
            photoViewer.showNextPhoto();
            var newIndex = photoViewer.currentIndex;
            // stop timer when hit the end
            if (index == newIndex) {
                stop();
                viewMode = 0
            }
        }
    }

    PhotoViewer {
        id: photoViewer
        anchors.fill: parent
        model: photoDetailsPage.model

        onClickedOnPhoto: {
            if (viewMode == 0) {
                viewMode = 1;
            } else if (viewMode == 1) {
                viewMode = 0;
            } else if (viewMode == 2) {
                viewMode = 1;
            }
        }

        onPressAndHoldOnPhoto: {
            photoDetailsPage.pressAndHoldOnPhoto(mouse,instance);

        }

        onCurrentIndexChanged:{
            settings.selectedElementid = currentItem.pitemid;
            toolbar.isFavorite = currentItem.pfavorite;       
            photoDetailsPage.currentIndexChanged(photoViewer.currentIndex);
        }
    }

    PhotoToolbar {
        id: toolbar
        anchors.bottom: parent.bottom
        width: parent.width
     //   mode: photoDetailsPage.singleSelectionMode ? 2:0
        isFavorite: false
        opacity:   1
        mode: 0
        onPrev: photoViewer.showPrevPhoto();
        onNext: photoViewer.showNextPhoto();
        onPlay: photoDetailsPage.startSlideshow()
        onRotateRight: photoViewer.rotateRightward();
        onRotateLeft: photoViewer.rotateLeftward();
        onFavorite: photoDetailsPage.toggleFavorite();
    }

    MouseArea {
        id: catchall
        anchors.fill: parent
        onPressed: {
            visible = false
            timer.stop()
            mouse.accepted = false
        }
    }

    Models.PhotoListModel {
        id: detailsPhotosModel
        type: Models.PhotoListModel.ListofPhotos
        limit: 0
        album: windows.settings.selectedAlbumName
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
                detailViewIndex = index;
                labelSinglePhoto = title;
            }
        }
    }


    state:"origin"
    states: [
        State {
            name: "origin"
            when: viewMode == 0
            // stop the slide show timer
            PropertyChanges {
                target: timer
                running: false
            }
        },
        State {
            name: "fullscreenMode"
            when: viewMode == 1
        }
    ]

    transitions: [
        Transition {
            reversible: true
            ParallelAnimation{
                PropertyAnimation {
                    target:toolbar
                    property: "anchors.bottomMargin"
                    duration: 250

                }

                PropertyAnimation {
                    target: toolbar
                    property: "opacity"
                    duration: 250
                }
            }
        }
    ]
}
