/*
 * Copyright 2011 Intel Corporation.
 *
 * This program is licensed under the terms and conditions of the
 * LGPL, version 2.1.  The full text of the LGPL Licence is at
 * http://www.gnu.org/licenses/lgpl.html
 */

/*!
  \qmlclass ExpandingBox
  \title ExpandingBox
  \section1 ExpandingBox
  This is a box which can be given any content and adapts its size accordingly.
  The default state of the box only show a header line and an icon which
  indicates if the box is expanded or not. Clicking on the header expands the
  box and shows the content.

  The behaviour isn't final because detailed specifications are missing.

  \section2 API properties
  \qmlproperty bool expanded
  \qmlcm true if the box is currently expanded

  \qmlproperty alias iconRow
  \qmlcm area that can hold a set of icons

  \qmlproperty alias titleText
  \qmlcm sets the text shown on the header

  \qmlproperty alias titleTextColor
  \qmlcm sets the color of the text shown on the header

  \qmlproperty Component detailsComponent
  \qmlcm contains the content to be shown when the box is expanded

  \qmlproperty Item detailsItem
  \qmlcm stores the contents when created

  \section2 Signals
  \qmlproperty [signal] expandingChanged
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
import MeeGo.Ux.Gestures 0.1
import MeeGo.Ux.Components.Common 0.1

Item {
    id: expandingBox

    property bool expanded: false
    property alias titleText: titleText.text
    property alias titleTextColor: titleText.color
    property Component detailsComponent: null
    property Item detailsItem: null
    property alias iconRow: iconArea.children
    property int buttonHeight

    signal expandingChanged( bool expanded )

    width: parent.width
    height: 20 + ( ( titleText.font.pixelSize > expandButton.height ) ? titleText.font.pixelSize : expandButton.height ) //pulldownImage.height

    // if new content is set, destroy any old content and create the new one
    onDetailsComponentChanged: {
        if( detailsItem ) detailsItem.destroy();
        detailsItem = detailsComponent.createObject( boxDetailsArea )
    }

    // if content has been set, destroy any old content and create the new one
    Component.onCompleted: {
        buttonHeight = height
        if( detailsComponent ) {
            if ( detailsItem ) detailsItem.destroy();
            detailsItem = detailsComponent.createObject( boxDetailsArea )
        }
    }

    // if the expanded state changes, propagate the change via signal
    onExpandedChanged: {
        if(expanded){
            buttonHeight = height
        }
        expandingBox.expandingChanged( expanded );
    }

    Theme { id: theme }

    // the border image is the background graphic for the header and the content
    ThemeImage {
        id: pulldownImage

        border.right: 75

        height: header.height
        width: parent.width

        source: "image://themedimage/widgets/common/combobox/combobox-background"

        // the header item contains the title, the image for the button which indicates
        // the expanded state and a MouseArea to change the expanded state on click
        Item {
            id: header

            // the header adapts its height to the height of the title and the button plus some space
            height: buttonHeight//expandingBox.height //20 + ( ( titleText.font.pixelSize > expandButton.height ) ? titleText.font.pixelSize : expandButton.height )
            width: parent.width
            anchors.top:  parent.top

            Row {
                id: iconArea

                anchors { left: parent.left; top: parent.top; bottom: parent.bottom; margins: 5; }
                spacing: anchors.margins
            }

            Text {
                id: titleText

                font.pixelSize: theme.fontPixelSizeLarge
                color: theme.fontColorHighlight
                elide: Text.ElideRight
                anchors.left: iconArea.right
                anchors.right: expandButton.left
                anchors.leftMargin: 5
                anchors.verticalCenter: expandButton.verticalCenter
            }

            ThemeImage {
                id: expandButton

                anchors.right: parent.right
                anchors.rightMargin: 6
                anchors.verticalCenter: parent.verticalCenter
                source:expandingBox.expanded ? "image://themedimage/images/settings/pulldown_arrow_up" : "image://themedimage/images/settings/pulldown_arrow_dn"
            }

            GestureArea {
                anchors.fill: parent
                
                Tap{
                    onFinished: { expanded = !expanded }
		}
            }
        }

        // this item is used when creating the content in the detailsItem to set some general properties
        Item {
            id: boxDetailsArea

            property int itemMargins: 10

            clip:  true
            visible: expandingBox.expanded
            anchors { top: header.bottom; bottom: parent.bottom; left: parent.left; right: parent.right; margins: itemMargins }
        }
    }

    states: [
        State {
            name: "expanded"

            PropertyChanges {
                target: pulldownImage
                height: header.height + detailsItem.height + boxDetailsArea.itemMargins * 2
            }
            PropertyChanges {
                target: expandingBox
                height: header.height + detailsItem.height + boxDetailsArea.itemMargins * 2
            }

            PropertyChanges {
                target: boxDetailsArea
                visible: true
                opacity: 1.0
            }

            when: { expandingBox.expanded }
        },
        State {
            name: "normal"

            PropertyChanges {
                target: pulldownImage
                height: header.height
            }

            PropertyChanges {
                target: boxDetailsArea
                visible: false
                opacity: 0
            }

            when: { !expandingBox.expanded }
        }
    ]

    property bool toast: true

    transitions: [
        Transition {
           SequentialAnimation {
               onStarted:{ expandingBox.toast = false }
                NumberAnimation {
                    properties: "height"
                    duration: 200
                    easing.type: Easing.InCubic
                }
                NumberAnimation {
                    properties: "opacity"
                    duration: 350
                    easing.type: Easing.OutCubic
                }
                onCompleted:{ expandingBox.toast = true}
            }
        }
    ]
}
