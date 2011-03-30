/*
 * Copyright 2011 Intel Corporation.
 *
 * This program is licensed under the terms and conditions of the
 * LGPL, version 2.1.  The full text of the LGPL Licence is at
 * http://www.gnu.org/licenses/lgpl.html
 */

/*!
  \qmlclass MediaGridView
  \title MediaGridView
  \section1 MediaGridView
  Displays a given set of images representing videos, folders or image files in a grid view.

  \section2  API properties

  \qmlproperty int spacing
  \qmlcm the border margin of the items.

  \qmlproperty string defaultThumbnail
  \qmlcm the default image for the items.

  \qmlproperty int frameBorderWidth
  \qmlcm margin of the selection overlay.

  \qmlproperty bool selectionMode
  \qmlcm on true the selected item is highlighted, on false only a pressed state is provided.

  \qmlproperty int type
  \qmlcm the internal type. See the private properties for details.

  \section2 Private properties

  \qmlproperty int musictype
  \qmlcm provide an enum for musictype

  \qmlproperty int videotype
  \qmlcm provide an enum for videotype

  \qmlproperty int phototype
  \qmlcm provide an enum for phototype

  \qmlproperty int photoalbumtype
  \qmlcm provide an enum for photoalbumtype

  \section2 Signals
  \qmlsignal clicked
  \qmlcm emitted when an item was clicked.
       \param int mouseX
       \qmlpcm position of the click event. \endparam
       \param int mouseY
       \qmlpcm position of the click event. \endparam
       \param int payload
       \qmlpcm the clicked item. \endparam

  \qmlsignal longPressAndHold
  \qmlcm emitted when an item was long pressed.
       \param int mouseX
       \qmlpcm position of the click event. \endparam
       \param int mouseY
       position of the click event. \endparam
       \param variant payload
       \qmlpcm variant, the clicked item. \endparam

  \qmlsignal doubleClicked
  \qmlcm emitted when an item was double clicked. Note that a 'clicked' for the first click is emitted as well.
       \param int mouseX
       \qmlpcm position of the click event. \endparam
       \param int mouseY
       \qmlpcm position of the click event. \endparam
       \param variant payload
       \qmlpcm the clicked item. \endparam

  \qmlsignal released
  \qmlcm emitted when the left mouse button was released.
       \param int mouseX
       \qmlpcm position of the click event. \endparam
       \param int mouseY
       \qmlpcm position of the click event. \endparam
       \param variant payload
       \qmlpcm the clicked item. \endparam

  \qmlsignal positionChanged
  \qmlcm emitted when the mouse moves above the item.
       \param int mouseX
       \qmlpcm position of the click event. \endparam
       \param int mouseY
       \qmlpcm position of the click event. \endparam
       \param int payload
       \qmlpcm the hovered item. \endparam

  \section2 Functions
  \qmlfn formatMinutes
  \qmlcm provides functionality to calculate hours and minutes. Only for qml internal use.
       \param object time
       \qmlpcm for internal use only  \endparam
  \section2 Example
   \code
       MediaGridView {
           id: gridView

           model: someModel

           anchors.top: parent.top
           anchors.bottom: parent.bottom

           type: 2

           width: 400

           onClicked: {
               // selected item and click position
           }
       }
   \endcode
*/

import Qt 4.7
import MeeGo.Components 0.1

GridView {
    id: gridView

    // apptype: 0=music, 1=video, 2=photo
    property int musictype: 0
    property int videotype: 1
    property int phototype: 2
    property int photoalbumtype: 0

    property int type: 0

    property int spacing: 1
    property bool selectionMode: true
    property int frameBorderWidth: 0
    property string defaultThumbnail: ""

    signal clicked(real mouseX, real mouseY, variant payload)
    signal longPressAndHold(real mouseX, real mouseY, variant payload)
    signal doubleClicked(real mouseX, real mouseY, variant payload)
    signal released(real mouseX, real mouseY, variant payload)
    signal positionChanged(real mouseX, real mouseY, variant payload)

    function formatMinutes(time){
        var min = parseInt( time / 60 );
        return min
    }

    clip:true
    cellWidth: theme.thumbSize
    cellHeight: cellWidth
    interactive: contentHeight > height

    cacheBuffer: 3000
    flickDeceleration: 250

    Component.onCompleted: gridView.currentIndex = 0

    delegate: BorderImage {
        id: dinstance

        property int mindex: index
        property string mtitle

        property string muri: uri
        property string murn: urn

        property string mthumburi
        property string mitemid
        property int mitemtype
        property bool mfavorite
        property int mcount
        property string martist

        width: gridView.cellWidth
        height: gridView.cellHeight
        asynchronous: true

//        source: "image://themedimage/media/photos_thumb_med"
        clip: true

        mtitle:{
            try {
                return title
            }
            catch(err){
                return ""
            }
        }

        mthumburi:{
            try {
                if (thumburi == "" | thumburi == undefined)
                    return defaultThumbnail
                else
                    return thumburi
            }
            catch(err){
                return defaultThumbnail
            }
        }

        mitemid:{
            try {
                return itemid;
            }
            catch(err) {
                return ""
            }
        }

        mitemtype:{
            try {
                return itemtype
            }
            catch(err) {
                return -1
            }
        }

        mfavorite: {
            try {
                return favorite;
            }
            catch(err) {
                return false
            }
        }

        mcount: {
            try {
                return tracknum;
            }
            catch(err) {
                return 0
            }
        }

        martist: {
            var a;
            try {
                a = artist
            }
            catch(err) {
                a = ""
            }
            a[0]== undefined ? "" : a[0]
        }

        Item {
            id: thumbnailClipper

            anchors.fill:parent
            anchors.margins: spacing

            Image {
                id: thumbnail

                anchors.fill: parent
                asynchronous: true
                fillMode: Image.PreserveAspectCrop
                source: dinstance.mthumburi
                smooth: true
                clip: true

                Rectangle {
                    id: fog

                    anchors.fill: parent
                    color: "white"
                    opacity: 0.25
                    visible: false
                }
            }

            Rectangle {
                id: textBackground

//                source: "image://themedimage/media/music_text_bg_med"
//                asynchronous: true

//                border{ left: 3; right: 3; top: 3; bottom: 3 }
                color:  "black"
                opacity: 0.7
                width: parent.width
                height: 63
                anchors.bottom: parent.bottom
                anchors.left: parent.left

                visible: (type != 2)

//                Text {
//                    id: titleText

//                    text: mtitle
//                    anchors.top: parent.top
//                    anchors.topMargin: 10
//                    anchors.left: parent.left
//                    anchors.leftMargin: 10
//                    width: parent.width - 20
//                    elide: Text.ElideRight
//                    font.pixelSize: theme.fontPixelSizeMedium
//                    font.bold: true
//                    color:theme.fontColorMediaHighlight
//                }

//                Text {
//                    id: artistText

//                    text: ( type == 1 ) ? ( ( formatMinutes( length ) == 1 ) ? qsTr( "%1 Minute" ).arg( formatMinutes( length ) ) : qsTr( "%1 Minutes").arg( formatMinutes( length ) ) ) : martist
//                    font.pixelSize: theme.fontPixelSizeMedium
//                    anchors.top: titleText.bottom
//                    anchors.topMargin: 4
//                    anchors.left: parent.left
//                    anchors.leftMargin: 10
//                    width: parent.width - 20
//                    elide: Text.ElideRight
//                    color:theme.fontColorMediaHighlight
//                    visible: text
//                }
            }

            Text {
                id: titleText

                text: mtitle
                anchors.top: textBackground.top
                anchors.topMargin: 10
                anchors.left: textBackground.left
                anchors.leftMargin: 10
                width: textBackground.width - 20
                elide: Text.ElideRight
                font.pixelSize: theme.fontPixelSizeMedium
                font.bold: true
                color:theme.fontColorMediaHighlight
                visible: textBackground.visible
            }

            Text {
                id: artistText

                text: ( type == 1 ) ? ( ( formatMinutes( length ) == 1 ) ? qsTr( "%1 Minute" ).arg( formatMinutes( length ) ) : qsTr( "%1 Minutes").arg( formatMinutes( length ) ) ) : martist
                font.pixelSize: theme.fontPixelSizeMedium
                anchors.top: titleText.bottom
                anchors.topMargin: 4
                anchors.left: textBackground.left
                anchors.leftMargin: 10
                width: textBackground.width - 20
                elide: Text.ElideRight
                color:theme.fontColorMediaHighlight
                visible: textBackground.visible
            }

            BorderImage {
                id: frame

                anchors.centerIn: parent
                asynchronous: true
                width: parent.width - 2 * frameBorderWidth
                height: parent.height - 2 * frameBorderWidth
                source: "image://themedimage/media/photos_selected_tick"
                visible: false
                smooth: true
            }
        }

        MouseArea {
            id: mouseArea

            anchors.fill:parent

            onClicked:{
                gridView.clicked(mouseX,mouseY, dinstance);
            }
            onPressAndHold: {
                gridView.longPressAndHold(mouseX,mouseY,dinstance);
            }
            onDoubleClicked: {
                gridView.doubleClicked(mouseX,mouseY,dinstance);
            }
            onReleased: {
                gridView.released(mouseX,mouseY,dinstance);
            }
            onPositionChanged: {
                gridView.positionChanged(mouseX,mouseY,dinstance);
            }
        }

        states: [
            State {
                name: "normal"
                when: !selectionMode && !mouseArea.pressed
                PropertyChanges {
                    target: frame
                    source: "image://themedimage/media/photos_thumb_med"
                }
            },
            State {
                name: "feedback"
                when: !selectionMode && mouseArea.pressed
                PropertyChanges {
                    target: fog
                    visible: true
                }
            },
            State {
                name: "selectionNotSelected"
                when: selectionMode && !gridView.model.isSelected(itemid)
                PropertyChanges {
                    target: frame
                    visible: false
                }
            },
            State {
                name: "selectionSelected"
                when: selectionMode && gridView.model.isSelected(itemid)
                PropertyChanges {
                    target: frame
                    visible: true
                }
            }
        ]
    }

    Theme{ id: theme }
}
