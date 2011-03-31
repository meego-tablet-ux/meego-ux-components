/*
 * Copyright 2011 Intel Corporation.
 *
 * This program is licensed under the terms and conditions of the
 * LGPL, version 2.1.  The full text of the LGPL Licence is at
 * http://www.gnu.org/licenses/lgpl.html
 */

/*!
  \qmlclass PhotoPicker
  \title PhotoPicker
  \section1 PhotoPicker
  The PhotoPicker provides a modal dialog in which the user can choose an
  album or photo. The 'OK' button is disabled until a selection was made.
  On 'Ok'-clicked, depending on the selection mode, the fitting signal is
  emitted which provides the selected item's data. Multiselection of items
  is possible by setting multiSelection to true.

  \section2 API Properties

  \qmlproperty bool albumSelectionMode
  \qmlcm selects albums instead of photos if true.

  \section2 Private Properties
  \qmlnone

  \section2 Signals

  \qmlsignal photoSelected
  \qmlcm propagates data for the selected photo. Triggered if multiSelection is false.
    \param variant photoid
    \qmlpcm ID of the selected photo. \endparam
    \param string title
    \qmlpcm title of the selected photo. \endparam
    \param string uri
    \qmlpcm path to the photo. \endparam
    \param string thumbUri
    \qmlpcm path to the photo thumbnail. \endparam

  \qmlsignal multiplePhotosSelected
  \qmlcm propagates data for the selected photos. Triggered if multiSelection is true.
    \param variant photoids
    \qmlpcm ID of the selected photos. \endparam
    \param string titles
    \qmlpcm title of the selected photos. \endparam
    \param string uris
    \qmlpcm path to the photos. \endparam
    \param string thumbUris
    \qmlpcm path to the photo thumbnails. \endparam


  \qmlsignal  albumSelected
  \qmlcm propagates data of the selected album. Triggered if albumSelectionMode is true and multiSelection is false.
    \param variant albumid
    \qmlpcm ID of the selected photo album. \endparam
    \param string title
    \qmlpcm title of the selected photo album. \endparam

  \qmlsignal  multipleAlbumsSelected
  \qmlcm propagates data of the selected albums. Triggered if albumSelectionMode and multiSelection is true.
    \param variant albumids
    \qmlpcm ID of the selected photo albums. \endparam
    \param string titles
    \qmlpcm title of the selected photo albums. \endparam

  \qmlsignal accepted
  \qmlcm emitted on 'OK' clicked.

  \qmlsignal rejected
  \qmlcm emitted on 'Cancel' clicked.

  \section2 Functions

  \qmlfn  show
  \qmlcm fades the picker in, inherited from ModalFog.

  \qmlfn  hide
  \qmlcm fades the picker out, inherited from ModalFog.

  \section2 Example
  \qml
     AppPage{
        PhotoPicker {
            id: pickerExample

            onPhotoSelected: {
                // photoid, title and uri are available, picker dialog hidden
            }
            onRejected: {
                // cancel was clicked, picker dialog hidden and no photo selected
            }
        }

        Component.onCompleted: {
            pickerExample.show();
        }
     }
   \endqml
*/

import Qt 4.7
import MeeGo.Media 0.1 as Models
import MeeGo.Components 0.1
import "pickerArray.js" as PickerArray

ModalDialog {
    id: photoPicker

    property bool albumSelectionMode: false
    property bool multiSelection: false

    property real topHeight: (topItem.topItem.height - topItem.topDecorationHeight) * 0.95  // maximum height relativ to top item height

    signal photoSelected( variant photoid, string title, string uri, string thumbUri )
    signal multiplePhotosSelected( variant ids, variant titles, variant uris, variant thumbUris )
    signal albumSelected( variant albumid, string title )
    signal multipleAlbumsSelected( variant ids, variant titles )

    title: albumSelectionMode ? qsTr("Pick an album") : qsTr("Pick a photo")

    width:  topItem.topItem.width * 0.95
    height:  if( gridView.estimateHeight + decorationHeight > topHeight ){
                 topHeight
             } else {
                 if( gridView.estimateHeight + decorationHeight > gridView.cellWidth ){
                     gridView.estimateHeight + decorationHeight
                 }
                else{
                     gridView.cellWidth + decorationHeight
                 }
             }

    onAccepted:{
        if( PickerArray.ids.length > 0 && PickerArray.titles.length > 0 ) {
            if( albumSelectionMode ) {
                if( multiSelection ) {
                    multipleAlbumsSelected( PickerArray.ids, PickerArray.titles )
                }else {
                    albumSelected( PickerArray.ids[0], PickerArray.titles[0] )
                }
            }else if( PickerArray.uris.length > 0 ) {
                if( multiSelection ) {
                    multiplePhotosSelected( PickerArray.ids, PickerArray.titles, PickerArray.uris, PickerArray.thumbUris )
                }else {
                    photoSelected( PickerArray.ids[0], PickerArray.titles[0], PickerArray.uris[0], PickerArray.thumbUris[0] )
                }
            }
        }
    }

    onShowCalled: {     // reset MediaGridView on show
        gridView.positionViewAtIndex( 0, GridView.Beginning )

        for( var i = 0; i < PickerArray.ids.length; i++ ) {
            gridView.model.setSelected( PickerArray.ids[i], false )
        }

        PickerArray.clear();

        if( gridView.selectedItem != "" )
            gridView.model.setSelected( gridView.selectedItem, false )

        acceptButtonEnabled = false
    }

    content: MediaGridView {
        id: gridView

        // the MediaGridView needs a width to be centered correctly inside its parent. To achieve this the estimateColumnCount computes
        // the the number of columns and the width is then set to estimateColumnCount x cellWidth. Unfortunately, the pickers width is needed
        // for this, a value which can't be retrieved via parent.width. So the computation has to be in the picker.

        property int estimateHeight: Math.ceil( model.count / estimateColumnCount ) * cellHeight
        property int estimateColumnCount: Math.floor( ( photoPicker.width - photoPicker.leftMargin - photoPicker.rightMargin ) / cellWidth )
        property string selectedItem: ""

        model: theModel
        type: albumSelectionMode ? photoalbumtype : phototype

        anchors.top: parent.top
        anchors.bottom: parent.bottom

        height: cellWidth
        width: cellWidth * estimateColumnCount
        anchors.horizontalCenter: parent.horizontalCenter

        cellWidth: (topItem.topWidth > topItem.topHeight) ? Math.floor((parent.width-1)  / theme.thumbColumnCountLandscape) - 2
                                                  : Math.floor((parent.width-1) / theme.thumbColumnCountPortrait) - 2

        onClicked: {
            if( photoPicker.multiSelection ) {
                var itemSelected = !model.isSelected( payload.mitemid ); //if the item was already selected, set itemSelected to false
                model.setSelected( payload.mitemid, itemSelected ); //set the selected state of the item according to itemSelected
                if( itemSelected ){
                    PickerArray.push( payload.mitemid, "ids" );
                    PickerArray.push( payload.mtitle, "titles" );
                    PickerArray.push( payload.muri, "uris" );
                    PickerArray.push( payload.mthumburi, "thumbUris" );
                }else {
                    PickerArray.remove( payload.mitemid, "ids" );
                    PickerArray.remove( payload.mtitle, "titles" );
                    PickerArray.remove( payload.muri, "uris" );
                    PickerArray.remove( payload.mthumburi, "thumbUris" );
                }
                photoPicker.acceptButtonEnabled = true; //enable OK button
            }else {
                model.setSelected( selectedItem, false ); //deselect the former selected item
                PickerArray.clear(); //use clear to delete the entry, so we don't have to store the title and thumburi all the time

                model.setSelected( payload.mitemid, true ); //select the clicked item
                PickerArray.push( payload.mitemid, "ids" );
                PickerArray.push( payload.mtitle, "titles" );
                PickerArray.push( payload.muri, "uris" );
                PickerArray.push( payload.mthumburi, "thumbUris" );

                selectedItem = payload.mitemid; //memorize the newly selected item
                photoPicker.acceptButtonEnabled = true; //enable OK button
            }
        }

        //reset selections when selection mode is changed
        onSelectionModeChanged: {
            PickerArray.clear();
            selectedItem = "";
            photoPicker.acceptButtonEnabled = false;
        }
    }

    TopItem { id: topItem }
    Theme { id: theme }

    Models.PhotoListModel {
        id: theModel

        limit: 0
        sort: Models.PhotoListModel.SortByDefault

        type: photoPicker.albumSelectionMode ? Models.PhotoListModel.ListofAlbums : Models.PhotoListModel.ListofPhotos
    }
}

