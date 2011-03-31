/*
* Copyright 2011 Intel Corporation.
 *
 * This program is licensed under the terms and conditions of the
 * LGPL, version 2.1.  The full text of the LGPL Licence is at
 * http://www.gnu.org/licenses/lgpl.html
 */

/*!
\qmlclass DropDown
  \title DropDown
  \section1 DropDown
  This is a box which can be given any content and adapts its size accordingly.
  The default state of the box only show a header line and an icon which
  indicates if the box is expanded or not. Clicking on the header expands the
  box and shows the content.

  The behaviour isn't final because detailed specifications are missing.

  \section2 API properties
  \qmlproperty bool expanded
  \qmlcm true if the box is currently expanded

  \qmlproperty alias iconContent
  \qmlcm area to put a row of icons

  \qmlproperty string titleText
  \qmlcm sets the text shown on the header

  \qmlproperty string titleTextColor
  \qmlcm sets the color of the text shown on the header

  \qmlproperty component detailsComponent
  \qmlcm contains the content to be created

  \qmlproperty item detailsItem
  \qmlcm stores the contents when created

  \section2  Private properties
  \qmlnone

  \section2 Signals
  \qmlsignal expandingChanged
  \qmlcm emitted if the box switches between expanded and not expanded
        \param bool expanded
        \qmlpcm indicates if the box is expanded or not \endparam

  \section2 Functions
  \qmlnone

  \section2 Example
  \qml
      ExpandingBox {
          id: expandingBox

          width: 200
          titleText: "ExpandingBox"
          titleTextColor: "black"
          anchors.centerIn:  parent
          detailsComponent: expandingBoxComponent

          Component {
              id: expandingBoxComponent

              Rectangle {
                   id: rect;

                   color: "blue";
                   height: 30; width: parent.width;
                   anchors.centerIn: parent
              }
          }
      }
  \endqml
*/

import Qt 4.7
import MeeGo.Components 0.1

ExpandingBox {
    id: dropDown

    property alias model: actionMenu.model
    property alias payload: actionMenu.payload

    signal triggered( int index )

    detailsItem: Item {
        id: menuContainer

        anchors.fill: parent

        height: actionMenu.height + 5
        width: actionMenu.width + 5

        ActionMenu {
            id: actionMenu
//            anchors.fill: parent

            onTriggered: {
                dropDown.titleText = actionMenu.model[index]
                dropDown.state = "normal"
                dropDown.triggered( index )
            }
        }
    }
}
