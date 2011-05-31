/*
 * Copyright 2011 Intel Corporation.
 *
 * This program is licensed under the terms and conditions of the
 * LGPL, version 2.1.  The full text of the LGPL Licence is at
 * http://www.gnu.org/licenses/lgpl.html
 */

/* This file contains relativy empty pages and is meant to demonstrate the
   book/page concept */

import Qt 4.7
import MeeGo.Ux.Components.Common 0.1
import MeeGo.Ux.Gestures 0.1
AppPage {

    id: pageGesture
    pageTitle: "GestureTest"

    fullScreen: true

    property bool pinched: false
    property bool swiped: false
    property bool panned: false
    property bool tapped: false
    property bool holded: false

    signal clicked();

    Rectangle {
        anchors.fill: parent
        color: "slategrey"

        Rectangle {
            id: surface
            anchors {
                left: parent.left
                top: parent.top
                bottom: parent.bottom
                right: colcol.left
                margins: 15
            }


            GestureArea {
                id: gestureArea

                anchors.fill: parent

                absolute: false
                blockMouseEvents: false

                Tap {
                    onStarted: {
                        tabDot.centerX = gesture.position.x
                        tabDot.centerY = gesture.position.y
                        tapSignal.text = "started"
                        tapX.text = "X: " + gesture.position.x
                        tapY.text = "Y: " + gesture.position.y
                        pageGesture.tapped = true

                    }
                    onUpdated: {
                        tabDot.centerX = gesture.position.x
                        tabDot.centerY = gesture.position.y
                        tapSignal.text = "updated"
                        tapX.text = "X: " + gesture.position.x
                        tapY.text = "Y: " + gesture.position.y
                    }
                    onCanceled: {
                        pageGesture.tapped  = false
                        tapSignal.text = "canceled"
                    }
                    onFinished: {                        
                        pageGesture.tapped = false
                        tapSignal.text = "finished"
                    }
                }

                TapAndHold {
                    onStarted: {
                        tabAndHoldDot.centerX = gesture.position.x
                        tabAndHoldDot.centerY = gesture.position.y
                        holdX.text = "X: " + gesture.position.x;
                        holdY.text = "Y: " + gesture.position.y
                        pageGesture.holded = true
                        holdSignal.text = "s"
                    }
                    onUpdated: {
                        tabAndHoldDot.centerX = gesture.position.x
                        tabAndHoldDot.centerY = gesture.position.y
                        holdX.text = "X: " + gesture.position.x;
                        holdY.text = "Y: " + gesture.position.y
                        holdSignal.text = "updated"
                    }
                    onCanceled: {
                        pageGesture.holded = false
                        holdSignal.text = "canceled"
                    }
                    onFinished: {
                        pageGesture.holded = false
                        tabAndHoldDot.centerX = gesture.position.x
                        tabAndHoldDot.centerY = gesture.position.y
                        holdX.text = "X: " + gesture.position.x;
                        holdY.text = "Y: " + gesture.position.y
                        holdSignal.text = "finished"
                    }
                }

                Pan {
                    onStarted: {
                        pageGesture.panned = true
                        panStartDot.centerX = tabDot.centerX
                        panStartDot.centerY = tabDot.centerY
                        panCurrentDot.centerX = tabDot.centerX
                        panCurrentDot.centerY = tabDot.centerX
                        panSignal.text = "started"
                    }
                    onUpdated: {
                        panCurrentDot.centerX = panStartDot.centerX + gesture.offset.x
                        panCurrentDot.centerY =  panStartDot.centerY + gesture.offset.y
                        panX.text = "X: " + panCurrentDot.centerX
                        panY.text = "Y: " + panCurrentDot.centerX
                        panSignal.text = "updated"
                    }
                    onCanceled: {
                        pageGesture.panned = false
                        panSignal.text = "canceled"
                    }
                    onFinished: {
                        pageGesture.panned = false
                        panSignal.text = "finished"
                    }
                }

                Swipe {
                    onStarted: {
                        pageGesture.swiped = true
                        swipeDot.centerX = tabDot.centerX
                        swipeDot.centerY = tabDot.centerX
                        swipeSignal.text = "started"
                        swipeAngle.text = "angle: " + gesture.swipeAngle
                    }
                    onUpdated: {
                        swipeArrow.rotation = gesture.swipeAngle
                        swipeSignal.text = "updated"
                        swipeAngle.text = "angle: " + gesture.swipeAngle
                    }
                    onCanceled: {
                        pageGesture.swiped = false
                        swipeSignal.text = "canceled"
                        swipeAngle.text = "angle: "
                    }
                    onFinished: {
                        pageGesture.swiped = false
                        swipeSignal.text = "started"
                        swipeAngle.text = "angle: "
                    }
                }

                Pinch {
                    onStarted: {
                        pageGesture.pinched = true
                        pinchStartCenter.centerX = gesture.startCenterPoint.x
                        pinchStartCenter.centerY = gesture.startCenterPoint.y
                        pinchCenter.centerX = gesture.centerPoint.x
                        pinchCenter.centerY = gesture.centerPoint.y
                        pinchSignal.text = "started"
                    }
                    onUpdated: {
                        pinchCenter.centerX = gesture.centerPoint.x
                        pinchCenter.centerY = gesture.centerPoint.y
                        pinchSignal.text = "updated"
                    }
                    onCanceled: {
                        pageGesture.pinched = false
                        pinchSignal.text = "canceled"
                    }
                    onFinished: {
                        pageGesture.pinched = false
                        pinchSignal.text = "finished"
                    }
                }
            }

            MouseArea {

                id: mouseArea
                anchors.fill: parent



            }

            Dot {
                id: swipeDot
                color: "green"
                radius: 25
                visible: swiped
            }
            Arrow {
                id: swipeArrow
                color: "green"
                rotation: 0
                visible: swiped
                x: swipeDot.centerX
                y: swipeDot.centerY
            }
            Dot {
                id: tabDot
                color: "white"
                radius: 25
                visible: tapped
            }

            Dot {
                id: tabAndHoldDot
                color: "blue"
                radius: 25
                visible: holded
            }
            Dot {
                id: panStartDot
                color: "yellow"
                radius: 25
                visible: panned
            }

            Dot {
                id: panCurrentDot
                color: "yellow"
                radius: 25
                visible: panned
            }

            Dot {
                id: pinchStartCenter
                color: "red"
                radius: 40
                opacity: 0.2
                visible: pinched
            }

            Dot {
                id: pinchCenter
                color: "red"
                radius: 25
                visible: pinched
            }

            Dot {
                id: mouseDot
                color: "black"
                radius: 5
                opacity: 0.5
                centerX: mouseArea.mouseX
                centerY: mouseArea.mouseY
                visible: true
            }

        }

        Column {
            id: colcol

            anchors.top: parent.top
            anchors.bottom: parent.bottom
            anchors.right: parent.right
            anchors.topMargin: 10
            anchors.bottomMargin: 10
            spacing: 10

            Rectangle {
                width: 150
                height: 75
                color: "white"

                border.color: "black"

                Column {
                    anchors.fill: parent
                    anchors.margins: 5
                    spacing: 2
                    Text { text: "Tap"; font.pixelSize: 12 }
                    Text { id: tapSignal; text: ""; font.pixelSize: 12 }
                    Text { id: tapX; text: ""; font.pixelSize: 12 }
                    Text { id: tapY; text: ""; font.pixelSize: 12 }
                }

            }
            Rectangle {
                width: 150
                height: 75
                color: "white"
                border.color: "black"
                Column {
                    anchors.fill: parent
                    anchors.margins: 5
                    spacing: 2
                    Text { text: "TapAndHold"; font.pixelSize: 12 }
                    Text { id: holdSignal; text: ""; font.pixelSize: 12 }
                    Text { id: holdX; text: ""; font.pixelSize: 12 }
                    Text { id: holdY; text: ""; font.pixelSize: 12 }
                }
            }
            Rectangle {

                width: 150
                height: 75
                color: "white"
                border.color: "black"
                Column {
                    anchors.fill: parent
                    anchors.margins: 5
                    spacing: 2
                    Text { text: "Swipe"; font.pixelSize: 12 }
                    Text { id: swipeSignal; text: ""; font.pixelSize: 12 }
                    Text { id: swipeAngle; text: ""; font.pixelSize: 12 }
                }

            }
            Rectangle {
                width: 150
                height: 100
                color: "white"
                border.color: "black"

                Column {
                    anchors.fill: parent
                    anchors.margins: 5
                    spacing: 2
                    Text { text: "Pan"; font.pixelSize: 12 }
                    Text { id: panSignal; text: ""; font.pixelSize: 12 }
                    Text { id: panX; text: ""; font.pixelSize: 12 }
                    Text { id: panY; text: ""; font.pixelSize: 12 }
                    Text { id: panDelta; text: ""; font.pixelSize: 12 }
                    Text { id: panOffset; text: ""; font.pixelSize: 12 }
                }

            }
            Rectangle {
                width: 150
                height: 100
                color: "white"
                border.color: "black"
                Column {
                    anchors.fill: parent
                    anchors.margins: 4
                    spacing: 2
                    Text { text: "Pinch"; font.pixelSize: 12 }
                    Text { id: pinchSignal; text: ""; font.pixelSize: 12 }
                    Text { id: pinchDelta; text: ""; font.pixelSize: 12 }
                    Text { id: pinchOffset; text: ""; font.pixelSize: 12 }
                }

            }

            Rectangle {
                width: 150
                height: 220
                color: "white"
                border.color: "black"
                anchors.margins: 2

                Column {
                    anchors.fill: parent
                    anchors.margins: 4
                    spacing: 2
                    Text { text: "Mouse"; font.pixelSize: 12 }
                    Text { id: tmouseX; text: "X: " + mouseArea.mouseX; font.pixelSize: 12 }
                    Text { id: tmouseY; text: "Y: " + mouseArea.mouseY; font.pixelSize: 12 }
                    Text { id: deltaTapX; text: "tap delta X: " + ( mouseArea.mouseX - tabDot.centerX ); font.pixelSize: 12 }
                    Text { id: deltaTapY; text: "tap delta Y: " + ( mouseArea.mouseY - tabDot.centerY ); font.pixelSize: 12 }
                    Text { id: deltaholdX; text: "hold delta X: " + ( mouseArea.mouseX - tabAndHoldDot.centerX ); font.pixelSize: 12 }
                    Text { id: deltaholdY; text: "hold delta Y: " + ( mouseArea.mouseY - tabAndHoldDot.centerY ) ; font.pixelSize: 12 }
                    Text { id: deltapinchX; text: "pinch delta X: " + ( mouseArea.mouseX - pinchStartCenter.centerX ) ; font.pixelSize: 12 }
                    Text { id: deltapinchY; text: "pinch delta Y: " + ( mouseArea.mouseY - pinchStartCenter.centerY ) ; font.pixelSize: 12 }
                    Text { id: deltaPanX; text: "pan delta X: "+ ( mouseArea.mouseX - panStartDot.centerX ) ;font.pixelSize: 12 }
                    Text { id: deltaPanY; text: "pan delta Y: "+ ( mouseArea.mouseY - panStartDot.centerX ) ;font.pixelSize: 12 }
                }

            }

            Button {
                id: back
                width: 150
                height: 75
                text: qsTr("back")
                onClicked: {
                    pageGesture.clicked();
                }
            }
        }


    }
}


