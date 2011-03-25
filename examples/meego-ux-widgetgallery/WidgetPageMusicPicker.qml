/*
 * Copyright 2011 Intel Corporation.
 *
 * This program is licensed under the terms and conditions of the
 * LGPL, version 2.1.  The full text of the LGPL Licence is at
 * http://www.gnu.org/licenses/lgpl.html
 */

/* This pages opens the MusicPicker.qml and offers controls to manipulate it.
 */

import Qt 4.7
import MeeGo.Components 0.1

WidgetPage {
    id: widgetPage

    property string lastSignal: "none"
    property string pickedAlbum: "-"
    property string pickedTitle: "-"
    property string pickedItems: "-"
    property string pickedType: "-"

    pageTitle: "MusicPicker Testing"

    controlContent: [
        LabeledEntry {
            id: widthEntry

            label:  "width: "
            defaultValue: musicPicker.width

            onTextUpdated: {
                if( value >= 0 ){
                    musicPicker.width = value
                }
            }
        },

        LabeledEntry {
            id: heightEntry

            label:  "height: "
            defaultValue: musicPicker.height

            onTextUpdated: {
                if( value >= 0 ){
                    musicPicker.height = value
                }
            }
        },

        CheckBoxEntry {
            id: selectSongCheckBox

            label: "selectSongs"

            onCheckedChanged: {
                lastSignal = "none"
                pickedTitle = "-"
                pickedAlbum = "-"
                pickedItems = "-"
                pickedType = "-"
            }

            isChecked: false
        },

        CheckBoxEntry {
            id: selectAlbumCheckBox

            label: "selectAlbum:"

            onCheckedChanged: {
                lastSignal = "none"
                pickedTitle = "-"
                pickedAlbum = "-"
                pickedItems = "-"
                pickedType = "-"
            }

            isChecked: true
        },

        CheckBoxEntry {
            id: selectPlaylistCheckBox

            label: "selectPlaylist:"

            onCheckedChanged: {
                lastSignal = "none"
                pickedTitle = "-"
                pickedAlbum = "-"
                pickedItems = "-"
                pickedType = "-"
            }

            isChecked: true
        },

        CheckBoxEntry {
            id: selectMultiBox

            visible: false //deactivate for now, since behaviour specification is unclear
            label: "multiSelection:"

            onCheckedChanged: {
                lastSignal = "none"
                pickedTitle = "-"
                pickedAlbum = "-"
                pickedItems = "-"
                pickedType = "-"
            }
        }
    ]

    statusContent: [
        StatusEntry {
            id: lastSignalBox

            label: "Last signal sent:"
            value: lastSignal
        },

        StatusEntry {
            id: albumEntry

            label: "Album:"
            value: pickedAlbum
        },

        StatusEntry {
            id: titleEntry

            label: "Title:"
            value: pickedTitle
        },

        StatusEntry {
            id: typeEntry

            label: "Type:"
            value: pickedType
        },

        StatusEntry {
            id: itemsEntry

            label: "Selected items:"
            value: pickedItems
            visible: false
        }
    ]


    description: "The MusicPicker provides a modal dialog in which the user can choose an "
                 + "album, playlist or song. The 'Ok' button is disabled until a selection was made. "
                 + "On 'Ok'-clicked the signal albumOrPlaylistSelected is emitted which provides "
                 + "the selected item's data. A double click automatically closes the "
                 + "dialog and emits a selected signal. Multi selection of items "
                 + "is deactivated at the moment.<br>"
                 + "Dialogs are centered by default with a vertical offset to to keep the toolbar visible."


    widget: Button {
        id: button

        anchors.centerIn: parent
        width:  300
        height:  80
        text: "Show MusicPicker"

        onClicked: {
            musicPicker.show()
        }
    }

    MusicPicker {
        id: musicPicker

        multiSelection: selectMultiBox.isChecked

        selectSongs: selectSongCheckBox.isChecked
        showAlbums: selectAlbumCheckBox.isChecked
        showPlaylists: selectPlaylistCheckBox.isChecked

        onAlbumOrPlaylistSelected: {
            lastSignal = "albumOrPlaylistSelected()"
            pickedType = type
            pickedAlbum = title
        }
        onSongSelected: {
            lastSignal = "songSelected()"
            pickedType = type
            pickedTitle = title
            pickedAlbum = album
        }

        onMultipleSongsSelected: {
            lastSignal = "multipleSongsSelected()"
            pickedItems = titles.length
        }

        onRejected: {
            lastSignal = "rejected()"
            pickedType = "no signal sent"
            pickedTitle = "no signal sent"
            pickedAlbum = "no signal sent"
            pickedItems = "-"
        }
    }

    states: [
        State {
            name: "multiple"
            PropertyChanges {
                target: typeEntry
                visible: false
            }
            PropertyChanges {
                target: albumEntry
                visible: false
            }
            PropertyChanges {
                target: titleEntry
                visible: false
            }
            PropertyChanges {
                target:  itemsEntry
                visible: true
            }

            when: selectMultiBox.isChecked
        },

        State {
            name: "albumOrPlaylist"
            PropertyChanges {
                target: typeEntry
                visible: true
            }
            PropertyChanges {
                target: albumEntry
                visible: true
            }
            PropertyChanges {
                target: titleEntry
                visible: false
            }
            PropertyChanges {
                target:  itemsEntry
                visible: false
            }

            when: !selectSongCheckBox.isChecked
        },

        State {
            name: "song"
            PropertyChanges {
                target: typeEntry
                visible: true
            }
            PropertyChanges {
                target: albumEntry
                visible: true
            }
            PropertyChanges {
                target: titleEntry
                visible: true
            }
            PropertyChanges {
                target:  itemsEntry
                visible: false
            }

            when: selectSongCheckBox.isChecked
        }
    ]
}
