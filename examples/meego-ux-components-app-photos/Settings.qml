/*
 * Copyright 2011 Intel Corporation.
 *
 * This program is licensed under the terms and conditions of the
 * LGPL, version 2.1.  The full text of the LGPL Licence is at
 * http://www.gnu.org/licenses/lgpl.html
 */

/*!
    \page Settings
    \title  MeeGo-Ux-Components-App-Photos - Settings
    \qmlclass Settings.qml
    \section1 Settings.qml

    Settings provides some properties for global access in the application. These
    properties mainly concern the currently selected photo and/or album. This
    component is created in the main window so it won't get destroyed by page changes.

    The reset function resets all properties to their default values.
    \qml
    function reset() {
        selectedAlbumName = ""
        selectedPhotoName = ""
        detailViewIndex = -1
        detailViewIndex = undefined
    }
    \endqml

    The function sendSelectedAlbumNameChanged can be used to emit the signal
    selectedAlbumNameChanged which informs other users of the Settings object
    that the properties have changed.
    \qml
    signal selectedAlbumNameChanged;

    function sendSelectedAlbumNameChanged() {
        selectedAlbumNameChanged();
    }
    \endqml
*/

import Qt 4.7
import MeeGo.Components 0.1

Item {
    id: settings

    property string selectedAlbumName: ""
    property string selectedPhotoName: ""
    property int detailViewIndex: -1
    property variant selectedElementid: undefined
    property bool albumBook: false

    signal selectedAlbumNameChanged;

    function sendSelectedAlbumNameChanged() {
        selectedAlbumNameChanged();
    }

    function reset() {
        selectedAlbumName = ""
        selectedPhotoName = ""
        detailViewIndex = -1
        detailViewIndex = undefined
    }
    //ck todo a save and load for session would be helpfull here
}
