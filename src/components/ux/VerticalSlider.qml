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

    \qmlproperty alias markerSize
    \qmlcm sets the width and height of the position marker. Default value is the size of
           the image used for the marker.

  \section2 Private Properties
  \qmlnone

  \section2 Signals
    \qmlsignal sliderChanged
    \qmlcm is emitted when the value of the sliders changed
        \param int value
        \qmlpcm the new value \endparam

  \section2 Functions
    \qmlfn moveSlider
    \qmlcm moves the slider to the position set by the parameter
      \param int value
      \qmlpcm The position the slider should have \endparam

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
import MeeGo.Components 0.1

Item {
    id: container

    property int min: 0
    property int max: 100
    property int value: 0
    property real percentage: 0
    property bool textOverlayVertical: false
    property alias markerSize: marker.width

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

    BorderImage {
        id: fillArea

        function setPosition(val) {
            var clamped = val - container.height / 4
            if(clamped < 0) {
                clamped = 0
            }
            if(clamped > fillArea.width - container.height / 4) {
                clamped = fillArea.width - container.height / 4
            }
            centerItem.x = clamped
            value = min + (clamped / (fillArea.width - container.height / 4)) * (max - min)
            container.sliderChanged( value )
        }

        rotation: -90
        source: "image://themedimage/slider/slider-background"
        border.left:  6
        border.right: 6
        anchors.left: parent.left
        anchors.leftMargin: marker.width / 4
        anchors.right: parent.right
        anchors.rightMargin: marker.width / 4
        anchors.verticalCenter: parent.verticalCenter

        BorderImage {
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

            border.left: 6
            border.right: 6
            source: "image://themedimage/slider/slider-bar"
            opacity: 0.5
        }

        //bar growing/shrinking with the marker to hightlight the range selected by the slider
        BorderImage {
            id: sliderFill

            border.left: 6
            border.right: 6
            source: "image://themedimage/slider/slider-bar"
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
            source: "image://themedimage/slider/slider-handle" //"image://themedimage/scrub_head_lrg"
            width: sourceSize.width
            height: width
            smooth: true
        }

        //shows the selected value while the slider is dragged or clicked
        Item {
            id: textoverlay

            anchors { bottom: marker.top; bottomMargin: 5; horizontalCenter: marker.horizontalCenter }
            width: overlaytext.height * 1.25
            height: overlaytext.width * 1.25
            visible: false

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

    MouseArea {
        id: mouseAreaFTW

        property int handleOffset: 0

        anchors.fill: parent
        rotation: fillArea.rotation

        onPressed: {
            if( mouseX >= centerItem.x && mouseX <= ( centerItem.x + container.height ) )
            {
                handleOffset = centerItem.x + container.height/4 - mouseX
            }
            fillArea.setPosition(mouseX + handleOffset)
        }
        onPositionChanged: {
            fillArea.setPosition(mouseX + handleOffset)
        }

//        onPressed: {
//            if(mouseY <= centerItem.x && mouseY >= (centerItem.x + container.height))
//            {
//                handleOffset = centerItem.x + container.width/2 - mouseY
//            }
//            fillArea.setPosition(mouseY)
//        }
//        onPositionChanged: {
//            fillArea.setPosition(mouseY)
//        }
        onReleased: handleOffset = 0
    }

    states: [
        State {
            name: "marker"
            PropertyChanges {
                target: textoverlay
                visible: true
            }
            when: mouseAreaFTW.pressed
        }
    ]
    transitions: [
        Transition {
            NumberAnimation { target: marker; property: "x"; duration: 1000 }
        }
    ]
}
