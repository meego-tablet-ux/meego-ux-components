/*
 * Copyright 2011 Intel Corporation.
 *
 * This program is licensed under the terms and conditions of the
 * LGPL, version 2.1.  The full text of the LGPL Licence is at
 * http://www.gnu.org/licenses/lgpl.html
 */

/*!
    \page AlbumsView
    \title  MeeGo-Ux-App-Photos - AlbumsView
    \qmlclass AlbumsView.qml
    \section1 AlbumsView.qml

    The AlbumsView shows a grid which displays a set of albums via preview thumbnail.

    A theme supplies access to common attributes
    \qml
    Theme { id: theme }
    \endqml

    The AlbumsView can have a header text which per default is set to invisible. It draws properties from the theme.
    \qml
    Text {
        id: header

        font.pixelSize: theme.fontPixelSizeLargest
        color: theme.fontColorNormal
        visible: false
        anchors { top: parent.top; left: parent.left; topMargin: 5; }
    }
    \endqml


    A MediaGridView is created to display the albums as thumbnails in a grid. The width of the grid
    cells is calculated to fit six thumbnails in landscape mode and three in portrait mode.
    \qml
    MediaGridView {
        id: view
        ...
        cellHeight: cellWidth
        cellWidth: {
            // for now, prefer portrait - later pull from platform setting
            var preferLandscape = false
            var preferPortrait = true

            // find cell size for at least six wide in landscape, three in portrait
            var sizeL = Math.floor(Math.max(window.width, window.height) / 6)
            var sizeP = Math.floor(Math.min(window.width, window.height) / 3)

            // work around bug in MediaGridView
            sizeP -= 1

            if (preferPortrait)
                return sizeP
            else if (preferLandscape)
                return sizeL
            else return Math.min(sizeP, sizeL)
        }
        ...
    }
    \endqml

    When a thumbnail image of an album is clicked, it's set as the currently selected item
    and the openAlbum signal is emitted which will start a viewer showing the contents
    of the album through its id and title.
    \qml
    onClicked: {
        view.currentIndex = payload.mindex;
        openAlbum(payload.mitemid, payload.mtitle, false);
    }
    \endqml

    When a thumbnail image of an album is long pressed, the pressAndHold signal is emitted
    which initializes a context menu to show up at the position given by the mouse coordinates,
    displaying the payload.
    \qml
    onLongPressAndHold: {
        var map = payload.mapToItem(window, mouseX, mouseY);
        container.pressAndHold(mouseX, mouseY, payload)
    }
    \endqml

*/

import Qt 4.7
import MeeGo.Components 0.1

Item {
    id: container

    property int labelHeight: 20
    property color cellBackgroundColor: "black"
    property color cellTextColor: theme.fontColorHighlight
    property int cellTextPointSize: theme.fontPixelSizeMedium

    property alias model: view.model
    property alias currentItem: view.currentItem
    property alias view: view
    property alias currentIndex: view.currentIndex
    property alias highlightItem: view.highlightItem

    property alias showHeader: header.visible
    property alias headerText: header.text

    signal openAlbum(variant elementid, string title, bool fullscreen)
    signal shareAlbum(variant albumid, string title, int mouseX, int mouseY)
    signal pressAndHold(int x, int y, variant payload)

    function indexAt(x,y) {
        return view.indexAt(x,y);
    }

    Theme { id: theme }

    Text {
        id: header

        font.pixelSize: theme.fontPixelSizeLargest
        color: theme.fontColorNormal
        visible: false
        anchors { top: parent.top; left: parent.left; topMargin: 5; }
    }

    MediaGridView {
        id: view

        property int parentWidth: -1

        function setMargins() {
            var columns = Math.floor(parent.width / cellWidth)
            var gridWidth = columns * cellWidth
            var remain = parent.width - gridWidth
            // workaound MediaGridView miscalculation with +1 below
            anchors.leftMargin = Math.floor(remain / 2) + 1
            header.anchors.leftMargin = anchors.leftMargin
        }

        type: photoalbumtype
        defaultThumbnail: "image://themedimage/media/photo_thumb_default"

        anchors.top: header.visible ? header.bottom : parent.top
        anchors.topMargin: header.visible ? 5 : 0
        anchors { bottom: parent.bottom; left: parent.left; right: parent.right; leftMargin: 0; rightMargin: 0 }
        spacing: 2
        cellHeight: cellWidth
        clip:true

        cellWidth: {
            // for now, prefer portrait - later pull from platform setting
            var preferLandscape = false
            var preferPortrait = true

            // find cell size for at least six wide in landscape, three in portrait
            var sizeL = Math.floor(Math.max(window.width, window.height) / 6)
            var sizeP = Math.floor(Math.min(window.width, window.height) / 3)

            // work around bug in MediaGridView
            sizeP -= 1

            if (preferPortrait)
                return sizeP
            else if (preferLandscape)
                return sizeL
            else return Math.min(sizeP, sizeL)
        }

        Connections {
            target: parent

            onWidthChanged: {
                // adjust margin during orientation change
                if (width < 0) {
                    view.parentWidth = -1
                    return
                }
                if (width == view.parentWidth)
                    return
                view.parentWidth = width
                view.setMargins()
            }
        }

        onClicked: {
            view.currentIndex = payload.mindex;
            openAlbum(payload.mitemid, payload.mtitle, false);
        }
        onLongPressAndHold: {
            var map = payload.mapToItem(window, mouseX, mouseY);
            container.pressAndHold(mouseX, mouseY, payload)
        }
        Component.onCompleted: setMargins()
    }
}
