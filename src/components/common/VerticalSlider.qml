/*
 * Copyright 2011 Intel Corporation.
 *
 * This program is licensed under the terms and conditions of the
 * LGPL, version 2.1.  The full text of the LGPL Licence is at
 * http://www.gnu.org/licenses/lgpl.html
 */

/*!
  \qmlclass VerticalSlider
  \title VerticalSlider
  \section1 VerticalSlider

  Displays a slider which can be used as input element. For example a volume control. The slider
  also has a progess bar.

  \section2 API properties
    \qmlproperty int min
    \qmlcm minimum value of the slider

    \qmlproperty int max
    \qmlcm maximum value of the slider

    \qmlproperty int value
    \qmlcm current value ot the slider

    \qmlproperty real percentage
    \qmlcm used to calculate the width of the progress bar

    \qmlproperty bool textOverlayVertical
    \qmlcm used to check if the textoverlay needs to be laid out vertically or horizontally

    \qmlproperty bool textOverlayVisible
    \qmlcm makes te text overlay visible or invisible.

    \qmlproperty alias markerSize
    \qmlcm sets the width and height of the position marker. Default value is the size of
           the image used for the marker.

  \section2 Signals
    \qmlproperty [signal] sliderChanged
    \qmlcm is emitted when the value of the sliders changed
        \param int value
        \qmlpcm the new value \endparam

  \section2 Functions
  \qmlnone

  \section2 Example
  \qml
    VerticalSlider {
        id: mySlider

        min: 0
        max: 100
        value: 50

    }
  \endqml

*/

import Qt 4.7
import MeeGo.Ux.Gestures 0.1
import MeeGo.Ux.Components.Common 0.1

Item {
    id: container

    property int min: 0
    property int max: 100
    property int value: 0
    property real percentage: 0
    property bool textOverlayVertical: false
    property bool textOverlayVisible: true
    property bool textOverlayAlwaysVisible: false
    property alias markerSize: marker.width
    property bool pressed: false

    signal sliderChanged(int sliderValue)

    onValueChanged: {
        if(value < min)
            value = min
        if(value > max)
            value = max
        centerItem.x = ((value - min) / (max - min)) * (fillArea.width - container.height / 4)
    }

    width: 200
    height: 40

    onWidthChanged: {
        if(value < min)
            value = min
        if(value > max)
            value = max
        centerItem.x = ((value - min) / (max - min)) * (fillArea.width - container.height / 4)
    }

    ThemeImage {
        id: fillArea

        function setPosition( delta ) {

            var newCenterItem = centerItem.x + delta

            if( newCenterItem < 0)
                newCenterItem = 0

            if(newCenterItem > fillArea.width - container.height / 4) {
                newCenterItem = fillArea.width - container.height / 4
            }
            centerItem.x = newCenterItem
            value = min + (centerItem.x / (fillArea.width - container.height / 4)) * (max - min)
            container.sliderChanged( value )
        }

        rotation: -90
        source: "image://themedimage/widgets/common/slider/slider-background"

        anchors.left: parent.left
        anchors.leftMargin: marker.width / 4
        anchors.right: parent.right
        anchors.rightMargin: marker.width / 4
        anchors.verticalCenter: parent.verticalCenter

        ThemeImage {
            id: progressBar

            anchors.left: parent.left
            anchors.verticalCenter: parent.verticalCenter

            width: if( percentage < border.left + border.right ) {
                       return border.left + border.right
                   }else if( percentage > 100 ) {
                       return parent.width
                   }else {
                       return parent.width * percentage / 100
                   }


            source: "image://themedimage/widgets/common/slider/slider-bar"
            opacity: 0.5
        }

        //bar growing/shrinking with the marker to hightlight the range selected by the slider
        ThemeImage {
            id: sliderFill

            source: "image://themedimage/widgets/common/slider/slider-bar"
            anchors.left: parent.left
            anchors.verticalCenter: parent.verticalCenter
            width: marker.x + marker.width * 0.5
        }

        Item {
            id: centerItem

            width: parent.height
            height: parent.height
            anchors.verticalCenter: parent.verticalCenter
        }

        //marks the actual position on the slider
        Image {
            id: marker

            anchors.centerIn: centerItem
            source: "image://themedimage/widgets/common/slider/slider-handle" //"image://themedimage/widgets/common/scrub_head_lrg"
            width: sourceSize.width
            height: width
            smooth: true

            GestureArea {
                id: gestureArea

                anchors.fill: parent

                Pan {
                    onStarted: {
                        container.pressed = true
                    }
                    onUpdated: {
                        fillArea.setPosition( gesture.delta.y * -1 )
                    }
                    onFinished: {
                        fillArea.setPosition( gesture.delta.y * -1 )
                        container.pressed = false
                    }
                    onCanceled: {
                        fillArea.setPosition( gesture.delta.y * -1 )
                        container.pressed = false
                    }
                }
            }
        }

        //shows the selected value while the slider is dragged or clicked
        Item {
            id: textoverlay

            anchors { bottom: marker.top; bottomMargin: 5; horizontalCenter: marker.horizontalCenter }
            width: overlaytext.height * 1.25
            height: overlaytext.width * 1.25
            visible: textOverlayAlwaysVisible
            opacity: (textOverlayVisible || textOverlayAlwaysVisible) ? 1 : 0 // Workaround: setting visible to textOverlayVisible in state has repaints issues

            rotation: container.textOverlayVertical? 90 : 0

            Rectangle {
                id: overlaybackground

                /* chose a radius smaller than rect size to avoid bug mentioned at sliderFill.
                   Didn't apply sliderFill solution since overlaybackground is outside of the
                   slider and therefore has a varying background color shining through the
                   opacity ( = impossible to set a color without opacity which has the same
                   visual appearance everywhere. Decision on how to deal with this is up to
                   the design team I think. */
                radius: container.textOverlayVertical ? height * 0.25 : width * 0.25  //5
                anchors.fill: parent
                color: "#68838B"
            }

            Text {
                id: overlaytext

                rotation: fillArea.rotation * -1
                anchors.centerIn: overlaybackground
                text: value
            }
        }
    }


    states: [
        State {
            name: "marker"
            PropertyChanges {
                target: textoverlay
                visible: true
            }
            when: container.pressed
        }
    ]
}
