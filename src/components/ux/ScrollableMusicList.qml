/*
 * Copyright 2011 Intel Corporation.
 *
 * This program is licensed under the terms and conditions of the
 * LGPL, version 2.1.  The full text of the LGPL Licence is at
 * http://www.gnu.org/licenses/lgpl.html
 */

/*!
  \qmlclass ScrollableMusicList
  \title ScrollableMusicList
  \section1 ScrollableMusicList
  This component presents a list of songs, given by a model.
  
  \section2 API Properties
  
  \qmlproperty string selectedSong
  \qmlcm song which is currentlist selected
  
  \qmlproperty bool highlightVisible
  \qmlcm determines if the highlighted component is shown or not
  
  \qmlproperty int textPixelSize 
  \qmlcm size of text in pixels
      
  \section2 Private Properties
  
  \qmlproperty string labelUnknownArtist ("unknown artist")
  \qmlcm standard label string
  
  \qmlproperty string labelUnknownAlbum ("unknown album")
  \qmlcm standard label string
  
  \qmlproperty int highlightDuration
  \qmlcm duration of the highlith in milliseconds. Default 300.

  \qmlproperty int highlightSpeed
  \qmlcm speed of the highlith in milliseconds. Default 400
  
  \section2 Signals
  
  \qmlsignal listItemSelected
  \qmlcm emitted if an item was selected
    \param variant itemid
    \qmlpcm id of the mediaitem \endparam
    \param string title
    \qmlpcm title of the mediaitem \endparam
    \param int type
    \qmlpcm type of the mediaitem \endparam
  
  \section2 Functions
  \qmlnone
  
  \section2 Example
  \qml
      ScrollableMusicList {
            id: musicListView
	  
            visible: true
            opacity: 1
            anchors.fill: parent
            
            model: songsFromAlbum // your model

            onListItemSelected: {
                // your implementation
            }
        }
     
  \endqml
*/

import Qt 4.7
import MeeGo.Components 0.1

Item {
    id: grid

    property int estimatedHeight: listView.count * ( textPixelSize + 21 )
    property alias model: listView.model
    property alias index: listView.currentIndex
    property string selectedSong: ""
    property Item selectedItem//: ""

    property string labelUnknownArtist: qsTr("unknown artist")
    property string labelUnknownAlbum: qsTr("unknown album")

    property int textPixelSize: theme.fontPixelSizeLarge

    property bool highlightVisible: false

    property int highlightDuration: 300
    property int highlightSpeed: 400

    signal listItemSelected (variant itemid, string title, string uri, int type )

    anchors.fill: parent

    ListView {
        id: listView

        focus: true
        spacing: 1

        anchors.fill: parent;

        Component.onCompleted: currentIndex = -1

        highlight: Rectangle {
            opacity: 0.5

            visible: highlightVisible
            color: listView.currentItem.selected ? "white" : "red"
            border.color: "black"
            border.width: 1

            z: 100
            width: parent.width - 1
        }

        highlightFollowsCurrentItem: true
        highlightMoveDuration: highlightDuration
        highlightMoveSpeed: highlightSpeed

        interactive: contentHeight > height

        delegate: Item {
            id: songDelegate

            width: parent.width
            height: trackTitle.font.pixelSize + 20

            property string mtitle: title
            property string muri: uri
            property bool mfavorite: favorite
            property string mitemid: itemid
            property int mitemtype: itemtype

            property bool selected: index == listView.currentIndex

            Text {
                id: trackTitle
                text: title

                height: parent.height
                width: parent.width/3

                verticalAlignment: Text.AlignVCenter
                horizontalAlignment:Text.AlignLeft

                anchors.left: parent.left
                anchors.leftMargin:10

                elide: Text.ElideRight
                font.bold: true
                font.pixelSize: textPixelSize
            }

            Text {
                id:trackArtist

                text: {
                    artist[0] == undefined ? labelUnknownArtist : artist[0];
                }

                height: parent.height
                width: parent.width/6

                anchors.left: trackTitle.right
                anchors.top:parent.top
                anchors.leftMargin:15

                verticalAlignment: Text.AlignVCenter
                horizontalAlignment:Text.AlignLeft

                elide: Text.ElideRight
                font.pixelSize: textPixelSize
            }

            Text {
                id:trackLength

                function formatTime(time){
                    var min = parseInt(time/60);
                    var sec = parseInt(time%60);
                    return min+ (sec<10 ? ":0":":") + sec
                }

                text: formatTime(length)
                height: parent.height
                width: parent.width/10

                anchors.left: trackArtist.right
                anchors.top:parent.top
                anchors.leftMargin: 15

                verticalAlignment: Text.AlignVCenter
                horizontalAlignment:Text.AlignLeft

                elide: Text.ElideRight
                font.pixelSize: textPixelSize
            }

            Text {
                id:trackAlbum

                text: {
                    album == "" ? labelUnknownAlbum : album;
                }

                height: parent.height
                width: parent.width/6

                anchors.left: trackLength.right
                anchors.right: parent.right
                anchors.top:parent.top
                anchors.leftMargin: 10

                verticalAlignment: Text.AlignVCenter
                horizontalAlignment:Text.AlignLeft

                elide: Text.ElideRight
                font.pixelSize: textPixelSize
            }

            MouseArea {
                anchors.fill: parent

                onClicked: {
                    if( !grid.highlightVisible ) {
                        // this code lets the highlight appear on the initial clicked position
                        grid.highlightDuration = 0
                        grid.highlightSpeed = -1

                        listView.currentIndex = index;

                        // reactivate the highlight animation
                        grid.highlightVisible = true
                        grid.highlightDuration = 300
                        grid.highlightSpeed = 400
                    }
                    else {
                        listView.currentIndex = index;
                    }

                    selectedSong = title;
                    listItemSelected(mitemid, mtitle, muri, mitemtype)
                }
            }
        }

        SystemPalette { id: activePalette }

        Theme{ id: theme }
    }
}
