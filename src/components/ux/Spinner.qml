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
  \qmlcm creates the Spinner and fades the Spinner in

  \qmlfn hide
  \qmlcm fades the Spinner out and destroys the Spinner

  \section2 Example
  \qmlnone

*/

import Qt 4.7
import MeeGo.Components 0.1

ModalFog {
    id: spinner

    autoCenter: true

    modalSurface: Image {
        id: spinnerImage
        source: "image://theme/widgets/common/spinner"
        width: 40
        height: 40
        smooth: true
        visible: spinner.visible
    }
}
