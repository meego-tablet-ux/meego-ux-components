/*
 * Copyright 2011 Intel Corporation.
 *
 * This program is licensed under the terms and conditions of the
 * LGPL, version 2.1.  The full text of the LGPL Licence is at
 * http://www.gnu.org/licenses/lgpl.html
 */

/*!
  \qmlclass PopupList
  \title PopupList
  \section1 PopupList
  The PopupList component contains a button which opens a spinnable list
  of entries when clicked. The list of entries as well as the
  number of entries displayed at a time can be set. The entries will
  adapt their size to the given height, but the width must be set big
  enough to allow the tags in your model to be displayed without being
  cut at their sides.

  \section2 API Properties
    \qmlproperty alias pathItemCount
    \qmlcm sets the number of items displayed at the same time in the spinner

    \qmlproperty alias fontSize
    \qmlcm sets the size in pixels for non-highlighted entries in the spinner.
           Changes to smaller size automatically if the entry's height is
           insufficient for the chosen size.

    \qmlproperty model popupListModel
    \qmlcm PathView.model, sets the model used for the list entries

    \qmlproperty variant value
    \qmlcm sets the value which will be used in the function reInit() to set the
           spinners' focus at

  \section2 Private Properties

    \qmlproperty real itemHeight
    \qmlcm height of entries in the PathView, adapts to number of items and available space

    \qmlproperty int count
    \qmlcm the number of items in the model

    \qmlproperty bool allowSignal
    \qmlcm used to block selection change signals while reInit() is running

  \section2 Signals
    \qmlsignal valueSelected
    \qmlcm propagates that a value has been selected
    \param  int index
    \qmlpcm the index of the entry in the model \endparam
    \param variant tag
    \qmlpcm the value of the selected entry \endparam

  \section2 Functions
    \qmlfn getCurrentIndex
    \qmlcm returns the model index of the current value
    \retval index \qmlpcm the current index \endretval

  \section2 Example
  \qml
  AppPage {
       property variant myModel: [ "1", "2", "3", "4", "5" ]

       PopupList {
           id: popup

           width:  150
           height: 200
           popupListModel: myModel
           onValueSelected: {
                // do something
           }
       }
  }
  \endqml
*/
import Qt 4.7

Item {
    id: outer

    property alias pathItemCount: view.pathItemCount
    property int fontSize: theme.fontPixelSizeNormal
    property variant popupListModel
    property real itemHeight: height / ( view.pathItemCount + 1 )
    property variant value
    property int count: popupListModel.count
    property variant selectedValue: view.currentIndex

    property bool allowSignal: true
    signal valueSelected ( int index )

    function reInit() {
        allowSignal = false

        var focusIndex = 0;
        for ( var i = 0; i < view.model.count; i++ ) {
            if ( view.model.get(i).tag == outer.value ) {
                focusIndex = i;
            }
        }

        view.currentIndex = focusIndex;

        allowSignal = true
    }

    // find the current index matching the value of the button
    function getCurrentIndex() {
        var i
        for ( i = 0; i < view.model.count; i++ ) {
            if ( view.model.get(i).tag == value ) {
                return i
            }
        }
        return 0
    }

    Theme { id: theme }

    Component {
        id: tsdelegate

        Text {
           id: delegateText

           property bool isSelected: index == view.currentIndex

           font.pixelSize: if( outer.fontSize < height - 4 ) {
                               return outer.fontSize
                           }else{
                               return height - 4
                           }

           height: itemHeight
           text: ( tag == undefined ) ? index : tag
           color: "#A0A0A0"
           font.bold: isSelected
           verticalAlignment: "AlignVCenter"

           MouseArea {
               id: delegateArea

               height:  parent.height
               width: spinnerRect.width
               anchors.centerIn: parent

               onClicked: {
                   view.currentIndex = index
                   if( outer.allowSignal ) {
                       outer.valueSelected( view.currentIndex )
                   }
               }
           }

           states: [
               State {
                   name: "active"
                   when:  index == view.currentIndex

                   PropertyChanges {
                       target: delegateText;
                       font.bold: true;
                       color: theme.fontColorNormal;

                       //adapt the font size to the available space to avoid overlapping
                       font.pixelSize: if( theme.fontPixelSizeLargest3 < height - 4 ) {
                                           return theme.fontPixelSizeLargest3
                                       }else if( theme.fontPixelSizeLargest2 < height - 4 ) {
                                           return theme.fontPixelSizeLargest2
                                       }else if( theme.fontPixelSizeLargest < height - 4 ) {
                                           return theme.fontPixelSizeLargest
                                       }else {
                                           return height - 4
                                       }

                       height: itemHeight * 2
                   }
               }
           ]
        }
    }

    Item {
        id: spinnerRect

        focus: true
        clip: true
        anchors.fill: parent

        BorderImage {
            id: spinner

            source: "image://themedimage/pickers/timespinbg"
            opacity: 0.5
            anchors.fill: parent
        }

        PathView {
            id: view

            anchors.fill: spinnerRect
            model: popupListModel

            pathItemCount: 3
            preferredHighlightBegin: 0.5
            preferredHighlightEnd: 0.5
            dragMargin: view.width/2
            delegate: tsdelegate

            onMovementEnded: {
                if( outer.allowSignal ) {
                    outer.valueSelected( currentIndex )
                }
            }

            path: Path {
                startX: view.width/2; startY: 0

                PathLine {
                    x: view.width/2;
                    y: view.height
                }
            }

            BorderImage {
                id: innerBgImage

                source:"image://themedimage/pickers/timespinhi"
                anchors.fill: parent
                opacity: 0.25
            }

            Component.onCompleted: {
                var focusIndex = 0;
                for ( var i = 0; i < view.model.count; i++ ) {
                    if ( view.model.get(i).tag == outer.value ) {
                        focusIndex = i;
                    }
                }
            }
        }
    }//end spinnerRect
}//end Item

