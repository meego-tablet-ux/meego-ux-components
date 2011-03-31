/*
 * Copyright 2011 Intel Corporation.
 *
 * This program is licensed under the terms and conditions of the
 * LGPL, version 2.1.  The full text of the LGPL Licence is at
 * http://www.gnu.org/licenses/lgpl.html
 */

/*!
    \page PhotosView
    \title  MeeGo-Ux-App-Photos - PhotosView
    \qmlclass PhotosView.qml
    \section1 PhotosView.qml

    The PhotosView shows a grid which displays a set of photos via preview thumbnail.

    A theme supplies access to common attributes
    \qml
    Theme { id: theme }
    \endqml

    The PhotosView can have a header text which per default is set to invisible. It draws properties from the theme.
    \qml
    Text {
        id: header

        font.pixelSize: theme.fontPixelSizeLargest
        color: theme.fontColorNormal
        visible: false
        anchors { top: parent.top; topMargin: 5; left: parent.left }
    }
    \endqml

    A MediaGridView is created to display the photos as thumbnails in a grid. The width of the grid
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

    When a thumbnail image of a photo is clicked and the selectionMode is false, meaning single selection,
    the clicked photo is set as the currently selected item and the openPhoto signal is emitted which will
    start a viewer showing a big version of the photo. If selectionMode is true, meaning multiple selection,
    the clicked photo is marked as selected if it wasn't selected before or unselects it if it was selected.
    The IDs and URIs of all selected photos are stored in lists.
    \qml
        onClicked: {
            if (container.selectionMode)
            {
                view.currentIndex = payload.mindex;
                var itemSelected = !view.model.isSelected(payload.mitemid)
                view.model.setSelected(payload.mitemid, itemSelected);
                container.toggleSelectedPhoto(payload.muri, itemSelected)
                selected = view.model.getSelectedIDs();
                thumburis = view.model.getSelectedURIs();
            }
            else
            {
                view.currentIndex = payload.mindex;
                container.openPhoto(payload, false, false);
            }
        }
    \endqml

    When a thumbnail image of a photo is long pressed, and the selectionMode is false, meaning single selection,
    the pressAndHold signal is emitted which initializes a context menu to show up at the position given by the
    mouse coordinates, displaying the payload. If selectionMode is true, meaning multiple selection, and at least
    one photo was selected, dragging of a according stack of thumbnails is started.
    After a dragging was initialized, the positionChanged signal is used to update the position of the dragged
    items with the mouse movements.

    \qml
    onReleased: {
        view.interactive = true
        if( container.selectionMode && selected.length > 0 ) {
            var map = mapToItem( container, mouseX, mouseY );
            container.dragEnd( map.x, map.y );
        }
    }
    onPositionChanged: {
        if( !view.interactive && container.selectionMode && selected.length > 0 ) {
            var map = mapToItem( container, mouseX, mouseY );
            container.drag( map.x, map.y );
        }
    }
    onLongPressAndHold: {
        view.interactive = false;
        if( container.selectionMode ) {
            if( container.selected.length > 0 ) {
                var map = mapToItem( container, mouseX, mouseY );
                container.dragStart( selected,thumburis, map.x, map.y );
            }
        }else {
            container.pressAndHold( mouseX, mouseY, payload );
        }
    }
    \endqml

    If the selectionMode is changed, the lists storing the selections are cleared as well as the selection in the model.
    \qml
    onSelectionModeChanged: {
        selected = [];
        thumburis = [];
        model.clearSelected();
    }
    \endqml
*/

import Qt 4.7
import MeeGo.Media 0.1 as Models
import MeeGo.Components 0.1

Item {
    id: container

    property alias cellWidth: view.cellWidth
    property alias cellHeight: view.cellHeight
    property color cellBackgroundColor: selectionMode ? "#5f5f5f" : "black"
    property color cellTextColor: "white"

    property bool selectionMode: false
    //  property bool singleSelectionMode: false

    property bool selectAll: false
    property variant selected: []
    property variant thumburis: []

    property alias model: view.model
    property alias currentItem: view.currentItem
    property alias currentIndex: view.currentIndex
    property alias flow: view.flow
    property alias contentX: view.contentX
    property alias contentY: view.contentY

    property alias showHeader: header.visible
    property alias headerText: header.text

    signal enteredSingleSelectMode()
    signal toggleSelectedPhoto(string uri, bool selected)
    signal openPhoto(variant item, bool fullscreen, bool startSlideshow)
    signal dragStart(variant elements, variant thumbs, int dragX, int dragY)
    signal drag(int dragX, int dragY)
    signal dragEnd(int dragX, int dragY)
    signal pressAndHold(int x, int y, variant payload)

    function nextPhoto() {
        if (view.currentIndex > view.count - 1 || view.currentIndex == -1)
            view.currentIndex = 0;
        else
            view.currentIndex++
                    return view.currentItem;
    }

    function prevPhoto() {
        if (view.currentIndex == 0 || view.currentIndex == -1)
            view.currentIndex = view.count - 1;
        else
            view.currentIndex--
                    return view.currentItem;
    }

    Theme{ id: theme }

    Text {
        id: header

        font.pixelSize: theme.fontPixelSizeLargest
        color: theme.fontColorNormal
        visible: false
        anchors { top: parent.top; topMargin: 5; left: parent.left }
    }

    MediaGridView {
        id: view

        property int estimateColumnCount: Math.floor( ( container.width ) / cellWidth )
        property int parentWidth: -1

        function setMargins() {
            var columns = Math.floor(parent.width / cellWidth)
            var gridWidth = columns * cellWidth
            var remain = parent.width - gridWidth
            // workaound MediaGridView miscalculation with +1 below
            anchors.leftMargin = Math.floor(remain / 2) + 1
            header.anchors.leftMargin = anchors.leftMargin
        }

        type: phototype
        selectionMode: container.selectionMode
        defaultThumbnail: "image://themedimage/media/photo_thumb_default"

        anchors.top: header.visible ? header.bottom : parent.top
        anchors.topMargin: header.visible ? 5 : 0
        anchors { bottom: parent.bottom; leftMargin: 0; rightMargin: 0; horizontalCenter: parent.horizontalCenter }

        width: cellWidth * estimateColumnCount
        clip: true
        spacing: 2

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

        Connections {
            target: parent

            onWidthChanged: {
                // adjust margin during orientation change
                if( width < 0 ) {
                    view.parentWidth = -1
                    return
                }
                if( width == view.parentWidth )
                    return
                view.parentWidth = width
                view.setMargins()
            }
        }

        Component.onCompleted: setMargins()

        onClicked: {
            if (container.selectionMode) {
                view.currentIndex = payload.mindex;
                var itemSelected = !view.model.isSelected( payload.mitemid )
                view.model.setSelected( payload.mitemid, itemSelected );
                container.toggleSelectedPhoto( payload.muri, itemSelected )
                selected = view.model.getSelectedIDs();
                thumburis = view.model.getSelectedURIs();
            }
            else {
                view.currentIndex = payload.mindex;
                container.openPhoto( payload, false, false );
            }
        }
        onReleased: {
            view.interactive = true
            if( container.selectionMode && selected.length > 0 ) {
                var map = mapToItem( container, mouseX, mouseY );
                container.dragEnd( map.x, map.y );
            }
        }
        onPositionChanged: {
            if( !view.interactive && container.selectionMode && selected.length > 0 ) {
                var map = mapToItem(container, mouseX, mouseY);
                container.drag(map.x, map.y);
            }
        }

        onLongPressAndHold: {
            view.interactive = false;
            if( container.selectionMode ) {
                if( container.selected.length > 0 ) {
                    var map = mapToItem( container, mouseX, mouseY );
                    container.dragStart( selected,thumburis, map.x, map.y );
                }
            }else {
                container.pressAndHold( mouseX, mouseY, payload );
            }
        }
    }

    onSelectionModeChanged: {
        selected = [];
        thumburis = [];
        model.clearSelected();
    }
}

