/*
 * Copyright 2011 Intel Corporation.
 *
 * This program is licensed under the terms and conditions of the
 * LGPL, version 2.1.  The full text of the LGPL Licence is at
 * http://www.gnu.org/licenses/lgpl.html
 */

/*!
  \qmlclass Spinner
  \title Spinner
  \section1 Spinner
  \qmlcm

  \section2  API Properties
  \qmlnone
  \section2 Private Properties
  \qmlnone

  \section2 Signals
  \qmlnone

  \section2  Functions

  \qmlfn show
  \qmlcm starts the animation and fades the Spinner in

  \qmlfn hide
  \qmlcm fades the Spinner out and stops the animation

  \section2 Example
  \qmlnone

*/

import Qt 4.7
import MeeGo.Components 0.1

ModalFog {
    id: spinnerBox

    property int interval: 100

    autoCenter: true
    fogClickable: false

    modalSurface: Item{
        id: spinner

        anchors.centerIn: parent

        clip: true

        width:  spinnerImage.height
        height:  spinnerImage.height

        Timer {
            id: spinnerTimer
            interval: spinnerBox.interval
            repeat: true
            onTriggered: {
                spinnerImage.x = (spinnerImage.x - spinnerImage.height) % - (spinnerImage.height * 11)
            }
        }

        Image {
            id: spinnerImage

            x: 0

            source: "image://themedimage/widgets/common/spinner/spinner"
            width: sourceSize.width
            height: sourceSize.height
            smooth: true
        }
    }

    onFogHideFinished: { spinnerTimer.running = false }

    onShowCalled: { spinnerTimer.running = true }
}
