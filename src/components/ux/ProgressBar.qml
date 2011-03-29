/*
 * Copyright 2011 Intel Corporation.
 *
 * This program is licensed under the terms and conditions of the
 * LGPL, version 2.1.  The full text of the LGPL Licence is at
 * http://www.gnu.org/licenses/lgpl.html
 */

/*!
   \qmlclass ProgressBar
   \title ProgressBar
   \section1 ProgressBar
   This is a progress bar with a customizable size to show the progress of a running process.

   \section2 API properties

      \qmlproperty real percentage
      \qmlcm sets the text displayed on the button.

  \section2 Private properties
  \qmlnone

  \section2 Signals
  \qmlnone

  \section2 Functions
  \qmlnone

  \section2 Example
  \qml
      ProgressBar {
         id: progressBar

         percentage: 50.5
      }
  \endqml
*/

import Qt 4.7

//Rectangle {
BorderImage{
    id: container

    property real percentage: 50

    width: 210
    height: 60

    clip:  true
//    color: "white"
//    radius: 3

//    border.width: 1
//    border.color: "#bbbbbb"

    border.left:   4
    border.top:    4
    border.bottom: 4
    border.right:  4

    source: "image://themedimage/progress-bar/progress-bar-backgound"

    Theme { id: theme }

//    Rectangle{
    BorderImage{
        id: progressBar

        property real progressPercentage: (container.percentage < 0) ? (0) : ( ( container.percentage > 100) ? 100 : container.percentage )

//        radius:  container.radius
        clip:  true
//        color: "#2fa7d4"

        border.left:   4
        border.top:    4
        border.bottom: 4
        border.right:  4

        source: "image://themedimage/progress-bar/progress-bar-fill"

        anchors { top: container.top; bottom: container.bottom; left: parent.left }

        width: parent.width * progressPercentage / 100

        z: 1

        Text {
            id: invertedText

            x: blueText.x
            y: blueText.y

            width: container.width
            height: container.height
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter

            font.pixelSize: theme.fontPixelSizeLarge
            color: "white"

            text: parseInt( progressBar.progressPercentage ) + "%"
        }
    }

    Text {
        id: blueText

        anchors.centerIn: container

        width: container.width
        height: container.height
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        z: 0

        font.pixelSize: theme.fontPixelSizeLarge
        color: "#2fa7d4"

        text: parseInt( progressBar.progressPercentage ) + "%"
    }
}
