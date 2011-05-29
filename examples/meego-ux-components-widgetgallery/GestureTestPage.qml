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
                margins: 10
            }

            GestureArea {
                id: gestureArea

                anchors.fill: parent

                Tap {
                    onStarted: {
                        tabDot.centerX = gesture.position.x
                        tabDot.centerY = gesture.position.y
                        pageGesture.tapped = true
                    }
                    onUpdated: {
                        tabDot.centerX = gesture.position.x
                        tabDot.centerY = gesture.position.y
                    }
                    onCanceled: {
                        pageGesture.tapped  = false
                    }
                    onFinished: {
                        pageGesture.tapped = false
                    }
                }

                TapAndHold {
                    onStarted: {
                        tabAndHoldDot.centerX = gesture.position.x
                        tabAndHoldDot.centerY = gesture.position.y
                        pageGesture.holded = true
                    }
                    onUpdated: {
                        tabAndHoldDot.centerX = gesture.position.x
                        tabAndHoldDot.centerY = gesture.position.y
                    }
                    onCanceled: {
                        pageGesture.holded = false
                    }
                    onFinished: {
                        pageGesture.holded = false
                    }
                }

                Pan {
                    onStarted: {
                       pageGesture.panned = true
                       panStartDot.centerX = tabDot.centerX
                       panStartDot.centerY = tabDot.centerY
                       panCurrentDot.centerX = tabDot.centerX
                       panCurrentDot.centerY = tabDot.centerX
                    }
                    onUpdated: {
                        panCurrentDot.centerX = panStartDot.centerX + gesture.offset.x
                        panCurrentDot.centerY =  panStartDot.centerY + gesture.offset.y
                    }
                    onCanceled: {
                        pageGesture.panned = false
                    }
                    onFinished: {
                        pageGesture.panned = false
                    }
                }

                Swipe {
                    onStarted: {
                       pageGesture.swiped = true
                       swipeDot.centerX = tabDot.centerX
                       swipeDot.centerY = tabDot.centerX
                       console.log( gesture.swipeAngle)
                    }
                    onUpdated: {
                       console.log( gesture.swipeAngle)
                       swipeArrow.rotation = gesture.swipeAngle * -1
                    }
                    onCanceled: {
                        pageGesture.swiped = false
                    }
                    onFinished: {
                        pageGesture.swiped = false
                    }
                }

                Pinch {
                    onStarted: {
                       pageGesture.pinched = true
                       pinchStartCenter.centerX = gesture.startCenterPoint.x
                       pinchStartCenter.centerY = gesture.startCenterPoint.y
                       pinchCenter.centerX = gesture.centerPoint.x
                       pinchCenter.centerY = gesture.centerPoint.y

                    }
                    onUpdated: {
                        pinchCenter.centerX = gesture.centerPoint.x
                        pinchCenter.centerY = gesture.centerPoint.y
                    }
                    onCanceled: {
                        pageGesture.pinched = false
                    }
                    onFinished: {
                        pageGesture.pinched = false
                    }
                }
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
                width: 250
                height: 100
                color: "white"
                border.color: "black"

                Label {
                    anchors.horizontalCenter: parent.horizontalCenter
                    id: tappedLabel
                    text: qsTr("Tapped")
                    visible: pageGesture.tapped
                }
            }
            Rectangle {
                width: 250
                height: 100
                color: "white"
                border.color: "black"

                Label {
                    anchors.horizontalCenter: parent.horizontalCenter
                    id: holdLabel
                    text: qsTr("Holded")
                    visible: pageGesture.holded
                }
            }
            Rectangle {

                width: 250
                height: 100
                color: "white"
                border.color: "black"

                Label {
                    anchors.horizontalCenter: parent.horizontalCenter
                    id: swipeLabel
                    text: qsTr("Swipped")
                    visible: pageGesture.swiped
                }
            }
            Rectangle {
                width: 250
                height: 100
                color: "white"
                border.color: "black"
                Label {
                    anchors.horizontalCenter: parent.horizontalCenter
                    id: panLabel
                    text: qsTr("Panned")
                    visible: pageGesture.panned
                }
            }
            Rectangle {
                width: 250
                height: 100
                color: "white"
                border.color: "black"
                Label {
                    anchors.horizontalCenter: parent.horizontalCenter
                    id: pinchLabel
                    text: qsTr("Pinched")
                    visible: pageGesture.pinched
                }
            }
            Button {
                id: back
                width: 250
                height: 80
                text: qsTr("back")
                onClicked: {
                    pageGesture.clicked();
                }
            }
        }

        Dot {
            id: swipeDot
            color: "green"
            radius: 15
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
            radius: 10
            visible: tapped
        }

        Dot {
            id: tabAndHoldDot
            color: "blue"
            radius: 15
            visible: holded
        }



        Dot {
            id: panStartDot
            color: "yellow"
            radius: 10
            visible: panned
        }

        Dot {
            id: panCurrentDot
            color: "yellow"
            radius: 10
            visible: panned
        }

        Dot {
            id: pinchCenter
            color: "red"
            radius: 10
            visible: pinched
        }

        Dot {
            id: pinchStartCenter
            color: "red"
            radius: 10
            opacity: 0.5
            visible: pinched
        }

    }

}


