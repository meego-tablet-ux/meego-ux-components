/*
 * Copyright 2011 Intel Corporation.
 *
 * This program is licensed under the terms and conditions of the
 * LGPL, version 2.1.  The full text of the LGPL Licence is at
 * http://www.gnu.org/licenses/lgpl.html
 */

/*!
    \page DragItem
    \title  MeeGo-Ux-App-Photos - DragItem
    \qmlclass DragItem.qml
    \section1 DragItem.qml

    This component draws a stack of thumbnails for dragging when initialized in
    the PhotosView.

    The move function is used to update the position of the dragged items with
    the given x and y coordinates.
    \qml
    function move(x, y) {
        posX = x;
        posY = y;
    }
    \endqml

    A repeater is used to draw the thumbnails supplied by a model.
    \qml
    property variant model
    ...
    onModelChanged: {
        repeater.model = model.slice( 0, thumbcount );
    }

    Repeater {
        id: repeater

        Rectangle {
            id: dragRect
            ...
            Image {
                anchors.fill:parent
                source: modelData
                fillMode:Image.PreserveAspectCrop
                z: parent.z + 1
            }
            ...
        }
    }
    \endqml
*/

import Qt 4.7

Item {
    id: thumbs

    property int thumbwidth: 100
    property int thumbheight: 100
    property int thumbcount: 10

    property variant model
    property variant elements

    property int posX: 0
    property int posY: 0
    property real zoom: 1.0

    signal scaleAnimationFinished()

    function move(x, y) {
        posX = x;
        posY = y;
    }

    width: thumbwidth
    height: thumbheight

    onModelChanged: {
        repeater.model = model.slice( 0, thumbcount );
    }

    Repeater {
        id: repeater

        Rectangle {
            id: dragRect

            width: thumbs.thumbwidth
            height: thumbs.thumbheight
            opacity: 1 - index * 1 / thumbs.thumbcount
            clip:true
            scale: Math.max( 0, zoom - index * 0.04 )
            transformOrigin: Item.TopLeft

            z: thumbs.thumbcount - index
            x: {
                if ( index == 0 ) {
                    posX
                }else {
                    posX + scale*index *11

                }
            }
            Behavior on x  {
                SmoothedAnimation {
                    duration: 100 * index + 100
                }
            }

            y: {
                if ( index == 0 ){
                    posY
                }else {
                    posY - scale*index * 4
                }
            }
            Behavior on y {
                SmoothedAnimation {
                    duration: 100 * index + 100
                }
            }

            Image {
                anchors.fill:parent
                source: modelData
                fillMode:Image.PreserveAspectCrop
                z: parent.z + 1
            }

            onScaleChanged: {
                if( index == repeater.model.length - 1 && scale == 0 ) {
                    thumbs.scaleAnimationFinished();
                }
            }

            Behavior on scale {
                NumberAnimation{
                    duration: 50 * index + 100
                }
            }
        }
    }
}
