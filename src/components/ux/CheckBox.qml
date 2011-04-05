/*
 * Copyright 2011 Intel Corporation.
 *
 * This program is licensed under the terms and conditions of the
 * LGPL, version 2.1.  The full text of the LGPL Licence is at
 * http://www.gnu.org/licenses/lgpl.html
 */

/*!
   \qmlclass CheckBox
   \title CheckBox
   \section1 CheckBox
   This is a CheckBox.

   \section2 API properties
   \qmlproperty bool isChecked
   \qmlcm holds the currently checked state. By default false

   \section2 Private properties
   \qmlnone

   \section2 Signals
   \qmlsignal clicked
   \qmlcm Emitted if the CheckBox is checked
    \param bool checked
    \qmlcm true ich CheckBox is checked currently \endparam

   \section2 Functions
   \qmlnone
*/

import Qt 4.7

Item {
    id: checkBox

    property bool isChecked:false

    signal clicked( bool checked )

    // default size
    height: 25
    width: 25

    // checkbox' image
    Image {

        property string checkbox_background: "image://theme/widgets/common/checkbox/checkbox-background" // "image://theme/widgets/common/btn_tickbox_dn"
        property string checkbox_background_active: "image://theme/widgets/common/checkbox/checkbox-background-active"// "image://theme/widgets/common/btn_tickbox_up"

        id: checkIcon
        source: checkBox.isChecked ? checkbox_background_active : checkbox_background
        anchors.fill: parent

        smooth: true

        MouseArea {
            anchors.fill: parent
            onClicked: {
                checkBox.isChecked = !checkBox.isChecked;
                checkBox.clicked( checkBox.isChecked )
            }
        }
    }
}//end of checkbox
