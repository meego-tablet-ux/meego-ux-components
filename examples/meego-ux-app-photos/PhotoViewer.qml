/*
 * Copyright 2011 Intel Corporation.
 *
 * This program is licensed under the terms and conditions of the
 * LGPL, version 2.1.  The full text of the LGPL Licence is at
 * http://www.gnu.org/licenses/lgpl.html
 */


import Qt 4.7
import MeeGo.Components 0.1

Item {
    id: photoViewer

    property alias model: photoListView.model
    property alias currentIndex: photoListView.currentIndex
    property alias currentItem: photoListView.currentItem
    property alias count: photoListView.count

    property bool fullscreen: false

    property variant rotationCombination1: [ 1, 6, 3, 8 ]
    property variant rotationCombination2: [ 2, 5, 4, 7 ]

    signal clickedOnPhoto()

    signal currentIndexChanged();

    signal pressAndHoldOnPhoto( variant mouse, variant instance );

    function showPhotoAtIndex( index ) {
        if ( index < photoListView.count ) {
            photoThumbnailView.positionViewAtIndex( index, ListView.Center );
            photoListView.positionViewAtIndex( index, ListView.Center );
            photoListView.currentIndex = index;
        }
    }

    function showNextPhoto() {
        photoListView.incrementCurrentIndex();
    }

    function showPrevPhoto() {
        photoListView.decrementCurrentIndex();
    }

    function rotateRightward() {
        photoListView.currentItem.photoRotate = ( photoListView.currentItem.photoRotate + 1 ) % 4;
    }

    function rotateLeftward() {
        photoListView.currentItem.photoRotate = ( photoListView.currentItem.photoRotate + 3 ) % 4;
    }

    function determineUsrOrientation(originalOrientation, rotation) {
        var index = rotationCombination1.indexOf( originalOrientation );
        if ( index != -1 ) {
            return rotationCombination1[ ( index + rotation ) % rotationCombination1.length ];
        }else {
            index = rotationCombination2.indexOf( originalOrientation );
            if ( index != -1 ) {
                return rotationCombination2[ ( index + rotation ) % rotationCombination2.length ];
            }
        }
        // give a default value;
        return 1;
    }

    anchors.centerIn: parent

    Rectangle {
        id: background
        anchors.fill: parent
        color: "black"
    }

    ListView {
        id: photoThumbnailView

        property bool show: false

        cacheBuffer: photoViewer.width / 3

        width: Math.min( 120 * count ,photoViewer.width )
        anchors.top: parent.top
        anchors.horizontalCenter: parent.horizontalCenter
        orientation: ListView.Horizontal
        height: 100

        focus: true
        clip: true
        z: 1000
        currentIndex: photoListView.currentIndex
        model: photoViewer.model
        spacing: 10
        opacity: 0
        highlightMoveDuration:200

        onShowChanged: {
            // start the timer
            if ( show == true ) {
                hideThumbnailTimer.start();
            } else {
                hideThumbnailTimer.stop();
            }
        }

        delegate: BorderImage {
            id: dinstance

            property int mindex: index

            width: 80
            height: 80
            y: 10
          //  fillMode:Image.PreserveAspectFit
            source: dinstance.ListView.isCurrentItem? "image://themedimage/media/photos_thumb_white_border":"image://themedimage/media/prv_thumb_sml"
            smooth: true
            clip: true

            Item {
                id: imageChopper

                anchors.horizontalCenter: parent.horizontalCenter
                anchors.top: parent.top
                width: parent.width - ( dinstance.ListView.isCurrentItem ? 6 : 2 )
                height: parent.height - ( dinstance.ListView.isCurrentItem ? 6 : 0 )
                clip: true
                z: -10

                Image {
                    id: thumbnail

                    source: thumburi
                    anchors.fill: parent
                    fillMode: Image.PreserveAspectCrop
                    clip: true
                }

            }
            MouseArea {
                anchors.fill: parent
                onClicked: {
                    photoListView.positionViewAtIndex( mindex,ListView.Center );
                    photoListView.currentIndex = mindex;
                    hideThumbnailTimer.restart();
                }
            }

        }

        onFlickStarted: {
            hideThumbnailTimer.restart();
        }

        states: [
            State {
                name: "fullscreen-mode"
                when: photoViewer.fullscreen
                PropertyChanges {
                    target: photoThumbnailView
                    anchors.topMargin: 5
                }
            },
            State {
                name: "toolbar-mode"
                when: !photoViewer.fullscreen
                PropertyChanges {
                    target: photoThumbnailView
                    anchors.topMargin: 32 //ck todo
                }
            }
        ]

        transitions: [
            Transition {
                from: "fullscreen-mode"
                to: "toolbar-mode"
                reversible: true
                PropertyAnimation {
                    property: "anchors.topMargin"
                    duration: 250
                    easing.type: "OutSine"
                }
            }
        ]
    }

    ListView {
        id: photoListView

        property variant previousTimestamp
        property int flickCount: 0
        property bool movementCausedByFlick: false
        property bool initialPhoto: true

        cacheBuffer: photoViewer.width
        anchors.fill: parent
        clip: true
        snapMode:ListView.SnapOneItem
        orientation: ListView.Horizontal
        highlightFollowsCurrentItem: true
        spacing: 30
        focus: true
        pressDelay: 0
        highlightMoveDuration: 300

        delegate: Flickable {
            id: dinstance

            property alias imageExtension: extension
            property variant centerPoint
            property int photoRotate:0

            property string ptitle: title
            property bool pfavorite: favorite
            property string pitemid: itemid
            property string pthumburi: thumburi
            property string pcreation: creationtime
            property string pcamera: camera
            property string puri: uri

            function restorePhoto() {
                //   image.sourceSize.width = 1024;
                //   image.scale = 1;
                if ( photoRotate == 0 || photoRotate == 2 ) {
                    image.width = dinstance.width;
                    image.height = dinstance.height;
                }else {
                    image.width = dinstance.height;
                    image.height = dinstance.width;
                }
            }

            width: photoViewer.width
            height: photoViewer.height
            clip: true

            onWidthChanged: {
                restorePhoto();
            }
            onHeightChanged: {
                restorePhoto();
            }

            contentWidth: {
                if ( photoRotate == 0 || photoRotate == 2 ) {
                    image.width * image.scale  > width ? image.width * image.scale : width
                }else {
                    image.height * image.scale  > width ? image.height * image.scale : width
                }
            }

            contentHeight:{
                if ( photoRotate == 0 || photoRotate == 2 ) {
                    image.height * image.scale > height ? image.height * image.scale : height
                }else {
                    image.width * image.scale > height ? image.width * image.scale : height
                }
            }

            Image {
                id: image

                function zoomIn( mouse ) {
                    image.sourceSize.width = image.sourceSize.width * 1.5;
                    image.width = image.width * 1.5;
                    image.height = image.height * 1.5;
                }

                source: uri
                anchors.centerIn: parent
                fillMode:Image.PreserveAspectFit
                sourceSize.width: window.width
                width: dinstance.width
                height: dinstance.height
                transformOrigin: Item.Center
                asynchronous: true

                transform: [
                    Rotation {
                        id: mirror
                        origin.x: image.width / 2;
                        origin.y: image.height / 2;
                        axis { x: 0; y: 0; z: 0 }
                    },
                    Rotation {
                        id: rotation
                        origin.x: image.width / 2;
                        origin.y: image.height / 2;
                        axis { x: 0; y: 0; z: 1 }
                    }
                ]
            }

            ImageExtension {
                id: extension

                source: uri
                usrOrientation: determineUsrOrientation( orientation, photoRotate )

                onOrientationChanged:{
                    switch( orientation ) {
                    case 1:{
                            mirror.angle = 0;
                            rotation.angle = 0;
                        }
                        break;
                    case 2:{
                            mirror.axis.x = 0;
                            mirror.axis.y = 1;
                            mirror.axis.z = 0;
                            mirror.angle = 180;

                            rotation.angle = 0;
                        }
                        break;
                    case 3:{
                            mirror.angle = 0;

                            rotation.angle = 180;
                        }
                        break;
                    case 4:{
                            mirror.angle = 180;
                            mirror.axis.x = 1;
                            mirror.axis.y = 0;
                            mirror.axis.z = 0;

                            rotation.angle = 0;
                        }
                        break;
                    case 5:{
                            mirror = 180;
                            mirror.axis.x = 0;
                            mirror.axis.y = 1;
                            mirror.axis.z = 0;

                            rotation.angle = 90;
                        }
                        break;
                    case 6: {
                            mirror.angle = 0;
                            rotation.angle = 90;
                        }
                        break;
                    case 7:{
                            mirror.angle = 180;

                            mirror.axis.x = 0;
                            mirror.axis.y = 1;
                            mirror.axis.z = 0;

                            rotation.angle = 270;
                        }
                        break;
                    case 8:{
                            mirror.angle = 0;
                            rotation.angle = 270;
                        }
                        break;
                    default:
                            break;
                    }
                }
            }

            Connections {
                target: photoListView
                onCurrentItemChanged: {
                   // image.width = dinstance.width;
                   // image.height = dinstance.height;
                   //  image.rotation = 0;
                   //  photoRotate = 0;
                    if( currentItem == dinstance ) {
                        photoViewer.model.setViewed( pitemid )
                    }
                }
            }

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    photoViewer.clickedOnPhoto();
                }
                onPressAndHold: {
                    photoViewer.pressAndHoldOnPhoto( mouse, dinstance );
                }
            }

            GestureArea {
                anchors.fill: parent
                onPinchGesture: {
                    var cw = dinstance.contentWidth;
                    var ch = dinstance.contentHeight;
                    image.scale *= gesture.scaleFactor;
                    dinstance.contentX =  ( dinstance.centerPoint.x + dinstance.contentX ) /cw * dinstance.contentWidth - dinstance.centerPoint.x;
                    dinstance.contentY = ( dinstance.centerPoint.y + dinstance.contentY ) / ch * dinstance.contentHeight - dinstance.centerPoint.y;

                }
                onGestureStarted: {
                     dinstance.interactive = false;
                     photoListView.interactive = false;
                    // dinstance.centerPoint = window.mapToItem(dinstance, gesture.centerPoint.x, gesture.centerPoint.y);
                }
                onGestureEnded: {
                    dinstance.interactive = true;
                    photoListView.interactive = true;
                }
            }

            states: [
                State {
                    name: "upright"
                    when: photoRotate == 0
                    PropertyChanges {
                        target: image
                        rotation: 0
                        width: dinstance.width
                        height: dinstance.height
                    }

                },
                State {
                    name: "rightward"
                    when: photoRotate == 1
                    PropertyChanges {
                        target: image
                        rotation: 90
                        width: dinstance.height
                        height: dinstance.width
                    }
                },
                State {
                    name: "upsidedown"
                    when: photoRotate == 2
                    PropertyChanges {
                        target: image
                        rotation: 180
                        width: dinstance.width
                        height: dinstance.height
                    }
                },
                State {
                    name: "leftward"
                    when: photoRotate == 3
                    PropertyChanges {
                        target: image
                        rotation: 270
                        width: dinstance.height
                        height: dinstance.width
                    }
                }
            ]

            transitions: [
                Transition {
                    reversible: true
                    ParallelAnimation {
                        PropertyAnimation {
                            properties: "width,height"
                            duration: 300
                        }

                        RotationAnimation {
                            id: rotateAnimation
                            direction: RotationAnimation.Shortest
                            duration: 300
                        }
                    }
                }
            ]
        }
        Component.onCompleted: {
            // start the timer the first time.
            hideThumbnailTimer.start();
        }

        onMovementStarted: {
            currentItem.imageExtension.saveInfo();
        }

        onFlickStarted: {
            var t = ( new Date() ).getTime();
            if ( t - previousTimestamp < 1000 ) {
                flickCount++;
                if ( flickCount > 2 )
                    photoThumbnailView.show = true;
            }
            else flickCount = 1

            previousTimestamp = t;
            movementCausedByFlick = true;
            if ( photoThumbnailView.show )
                hideThumbnailTimer.restart();
        }

        onMovementEnded: {
            if( !movementCausedByFlick ) {
                currentIndex = indexAt( contentX + width / 2, contentY + height / 2 );
            }else {
                if( horizontalVelocity == 0 )
                    return;
                var i = indexAt( contentX + width / 2, contentY + height / 2 );
                if( currentIndex != i ){
                    currentIndex = i;
                }
            }
            movementCausedByFlick = false;
        }

        onCurrentIndexChanged: {
            photoViewer.currentIndexChanged();
        }
    }

    Timer {
        id: hideThumbnailTimer;

        interval: 3000; running: false; repeat: false
        onTriggered: {
            photoThumbnailView.show = false;
        }
    }

    states: [
        State {
            name: "showThumbnail"
            when: photoThumbnailView.show
            PropertyChanges { target: photoThumbnailView; opacity: 1.0 }
        },
        State {
            name: "hideThumbnail"
            when: photoThumbnailView.show == false
            PropertyChanges { target: photoThumbnailView; opacity: 0 }
        }
    ]

    transitions: [
        Transition {
            PropertyAnimation {
                property:"opacity"
                duration: 400
            }
        }
    ]
}
