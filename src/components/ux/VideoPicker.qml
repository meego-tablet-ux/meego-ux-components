/*
 * Copyright 2011 Intel Corporation.
 *
 * This program is licensed under the terms and conditions of the
 * LGPL, version 2.1.  The full text of the LGPL Licence is at
 * http://www.gnu.org/licenses/lgpl.html
 */

/*!
  \qmlclass VideoPicker
  \title VideoPicker
  \section1 VideoPicker
  The VideoPicker provides a modal dialog in which the user can choose an
  album or video. The 'Ok' button is disabled until a selection was made.
  On 'Ok'-clicked, depending on the selection mode, the fitting signal is
  emitted which provides the selected item's data. Multi selection of items
  is possible by setting set multiSelection to true.

  \section2 API Properties

  \qmlproperty bool albumSelectionMode
  \qmlcm if true, selects albums instead of videos.

 \section2 Private Properties
 \qmlnone

  \section2 Signals

  \qmlsignal videoSelected
  \qmlcm triggered on accpeted if albumSelectionMode is false
    \param string itemid
    \qmlpcm  ID of the selected video. \endparam
    \param string uri
    \qmlpcm  path to the selected video. \endparam
    \param string itemtitle
    \qmlpcm  title of the selected video. \endparam

  \qmlsignal albumSelected
  \qmlcm triggered on accpeted if albumSelectionMode is true
    \param string albumid
    \qmlpcm ID of the selected photo album. \endparam
    \param string title
    \qmlpcm title of the selected photo album. \endparam

  \qmlsignal accepted
  \qmlcm emitted on 'OK' clicked.

  \qmlsignal rejected
  \qmlcm emitted on 'Cancel' clicked.

  \section2 Functions
  \qmlfn show
  \qmlcm fades the picker in, inherited from ModalFog.

  \qmlfn hide
  \qmlcm fades the picker out, inherited from ModalFog.

  \section2  Example
  \code
     AppPage{
        VideoPicker {
            id: pickerExample

            onVideoSelected: {
                // itemid, itemtitle and uri are available, picker dialog hidden
            }

            onRejected: {
                // cancel was clicked, picker dialog hidden and no photo selected
            }
        }

        Component.onCompleted: {
            pickerExample.show();
        }
     }
  \endcode
*/
import Qt 4.7
import MeeGo.Components 0.1
import "pickerArray.js" as PickerArray

ModalDialog {
    id: videoPicker

    property bool albumSelectionMode: false
    property bool multiSelection: false

        // ###
    property real topHeight: (topItem.topItem.height - topItem.topDecorationHeight) * 0.95   // maximum height relativ to top item height

    signal videoSelected( string itemid, string itemtitle, string uri, string thumbUri )
    signal multipleVideosSelected( variant ids, variant titles, variant uris, variant thumbUris )
    signal albumSelected( string itemid, string title )
    signal multipleAlbumsSelected( variant ids, variant titles )

    //ids, titles, uris
    onAccepted: {
        if( PickerArray.ids.length > 0 && PickerArray.titles.length > 0 ) {
            if( albumSelectionMode ) {
                if( multiSelection ) {
                    multipleAlbumsSelected( PickerArray.ids, PickerArray.titles )
                }else {
                    albumSelected( PickerArray.ids[0], PickerArray.titles[0] )
                }
            }else if( PickerArray.uris.length > 0 ) {
                if( multiSelection ) {
                    multipleVideosSelected( PickerArray.ids, PickerArray.titles, PickerArray.uris, PickerArray.thumbUris )
                }else {
                    videoSelected( PickerArray.ids[0], PickerArray.titles[0], PickerArray.uris[0], PickerArray.thumbUris[0] )
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

    //use nearly the whole screen
    width: topItem.topItem.width * 0.95
    height:  if(gridView.estimateHeight + decorationHeight > topHeight ){
                 topHeight
             } else {
                 if( gridView.estimateHeight + decorationHeight > gridView.cellWidth ){
                     gridView.estimateHeight + decorationHeight
                 }
                else{
                     gridView.cellWidth + decorationHeight
                 }
             }

    title: qsTr("Pick a video")

    content: MediaGridView {
        id: gridView

        // the MediaGridView needs a width to be centered correctly inside its parent. To achieve this the estimateColumnCount computes
        // the the number of columns and the width is then set to estimateColumnCount x cellWidth. Unfortunately, the pickers width is needed
        // for this, a value which can't be retrieved via parent.width. So the computation has to be in the picker.

        property int estimateHeight: Math.ceil( model.count / estimateColumnCount ) * cellHeight
        property int estimateColumnCount: Math.floor( ( videoPicker.width - videoPicker.leftMargin - videoPicker.rightMargin ) / cellWidth )
        property string selectedItem: ""

        model: allAlbumsListModel

        anchors.top: parent.top
        anchors.bottom: parent.bottom

        width: cellWidth * estimateColumnCount
        anchors.horizontalCenter: parent.horizontalCenter

        cellWidth: (topItem.topWidth > topItem.topHeight) ? Math.floor((parent.width-1)  / theme.thumbColumnCountLandscape) - 2
                                                  : Math.floor((parent.width-1) / theme.thumbColumnCountPortrait) - 2

        //if an item is clicked, update the current data with that item's data
        onClicked: {
            if( videoPicker.multiSelection ) {
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
                videoPicker.acceptButtonEnabled = true; //enable OK button
            }else {
                model.setSelected( selectedItem, false ); //deselect the former selected item
                PickerArray.clear(); //use clear to delete the entry, so we don't have to store the title and thumburi all the time

                model.setSelected( payload.mitemid, true ); //select the clicked item
                PickerArray.push( payload.mitemid, "ids" );
                PickerArray.push( payload.mtitle, "titles" );
                PickerArray.push( payload.mthumburi, "thumbUris" );
                PickerArray.push( payload.muri, "uris" );

                selectedItem = payload.mitemid; //memorize the newly selected item
                videoPicker.acceptButtonEnabled = true; //enable OK button
            }
        }
    }

    TopItem{ id: topItem }
    Theme { id: theme }

    VideoListModel {
        id: allAlbumsListModel

        type: VideoListModel.ListofVideos
        limit: 0
        sort: VideoListModel.SortByTitle
    }
}

