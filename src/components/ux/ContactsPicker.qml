/*
 * Copyright 2011 Intel Corporation.
 *
 * This program is licensed under the terms and conditions of the
 * LGPL, version 2.1.  The full text of the LGPL Licence is at
 * http://www.gnu.org/licenses/lgpl.html
 */

/*!
  \qmlclass ContactsPicker
  \title ContactsPicker
  \section1 ContactsPicker

  Display the list of current to select one. Alternatively
  a new contact can be created.

  \section2  API properties
  \qmlproperty string promptString
  \qmlcm sets the top label of the ContactsPicker

  \qmlproperty string subString
  \qmlcm sets the second label of the ContactsPicker

  \qmlproperty string contactString
  \qmlcm sets the label for the button which initializes the creation of a new contact

  \qmlproperty int filterFlags
  \qmlcm union of data types to filter by { Name=0, Phone, Email, IM }

  \qmlproperty real width
  \qmlcm the width of the ContactsPicker dialog

  \qmlproperty real height
  \qmlcm the height of the ContactsPicker dialog

  \section2  Private Properties
  \qmlnone

  \section2  Signals
  \qmlsignal contactSelected
  \qmlcm triggered on accepted
    \param variant contact
    \qmlpcm selected contact object \endparam

  \section2 Functions
  \qmlnone

  \section2  Example
  \qml
    //a ContactsPicker which prints the name of the selected contact to the console
    ContactsPicker {
        id: contactsPicker

        onContactSelected: {
            console.log( contact.name.firstName + " " + contact.name.lastName )
        }
    }
  \endqml
*/

import Qt 4.7
import MeeGo.Components 0.1
import QtMobility.contacts 1.1


ModalDialog {
    id: contactsPicker

    property string promptString: qsTr( "Do you want to" )
    property string subString: qsTr( "Or add this number to one of your contacts?" )
    property string contactString: qsTr( "Create a new contact" )

    property int filterFlags: 0 //not implemented yet

    //property string dataType: "" //not implemented yet
    //property int dataIndex: 0 //not implemented yet

    signal contactSelected( variant contact )
    //signal dataSelected( string type, int dataIndex )

    width: height * 0.6
    height: (topItem.topItem.height - topItem.topDecorationHeight) * 0.95    // ###

    onAccepted: {
        contactsPicker.contactSelected( cardListView.currentContact )
        //contactsPicker.dataSelected( contactsPicker.dataType, contactsPicker.dataIndex )
    }

    onRejected: {

    }

    onShowCalled: {
        acceptButtonActive = false
    }

    content: BorderImage {
        id: inner

        anchors.fill: parent

        border.top: 14
        border.left: 20
        border.right: 20
        border.bottom: 20
        source: "image://themedimage/notificationBox_bg"

        Item {
            id: contactsView

            property int highlightHeight: 0
            property int highlightWidth: 0
            property int highlightX: 0
            property alias contactListView: cardListView

            anchors.fill: parent
            clip:  true

            Theme {
                id: theme
            }

            Component {
                id: cardHighlight

                Rectangle {
                    id: highlightRect

                    opacity: .5
                    color: "lightgrey"
                    y: cardListView.currentItem.y
                    width: contactsView.highlightWidth;
                    height: contactsView.highlightHeight
                    x: contactsView.highlightX
                    z: 2

                    Behavior on y { SmoothedAnimation { velocity: 5000 } }
                }
            }

            Column {
                id: pickerContents

                spacing: 5
   		height: parent.height
                width: parent.width

                Rectangle {
                    id: upperBox

                    height: 150
                    width: parent.width
                    color: "lightgrey"

                    Text {
                        id: titleBox

                        height: 30
                        width: parent.width
                        anchors { top: parent.top; left: parent.left; leftMargin: 10 }
                        text: contactsPicker.promptString
                        font.pixelSize: theme.fontPixelSizeLarge
                        verticalAlignment: "AlignVCenter"
                        color: theme.dialogTitleFontColor
                    }

                    Rectangle{
                        id: separatorOne

                        anchors { top: titleBox.bottom; left: parent.left }
                        width:  parent.width
                        height: 2
                        color: "black"
                    }

                    Button {
                        id: newContactButton

                        width:  parent.width * 0.5
                        anchors.centerIn: parent
                        text: contactsPicker.contactString
                        elideText: true
                    }

                    Rectangle{
                        id: separatorTwo

                        anchors { bottom: subBox.top; left: parent.left }
                        width:  parent.width
                        height: 2
                        color: "black"
                    }
                    Text {
                        id: subBox

                        height: 30
                        width: parent.width
                        anchors { bottom: parent.bottom; left: parent.left; leftMargin: 10 }
                        text: contactsPicker.subString
                        font.pixelSize: theme.fontPixelSizeLarge
                        verticalAlignment: "AlignVCenter"
                        color: theme.dialogTitleFontColor
                    }
                }

                Item {
                    id: groupedViewPortrait

                    width: parent.width
                    height: parent.height - titleBox.height - upperBox.height - 10 //where does -10 come from?

                    ListView {
                        id: cardListView

                        property Contact currentContact

                        height: parent.height
                        width: groupedViewPortrait.width
                        snapMode: ListView.SnapToItem
                        highlightFollowsCurrentItem: false
                        focus: true
                        keyNavigationWraps: false
                        clip: true
                        interactive: childrenRect.height > height

                        highlight: cardHighlight

                        //model: testModel

                        model: ContactModel {
                            id: contactModel

                            autoUpdate: true

                            Component.onCompleted : {
                                contactModel.sortOrders = sortFirstName;
                                contactModel.filter = allFilter;
                                if( manager == "tracker" ) {
                                    console.debug( "[contacts:myappallcontacts] tracker found for all contacts model" )
                                }
                            }
                        }

                        section.property: "Contact.Name.FirstName"
                        section.criteria: ViewSection.FirstCharacter
                        section.delegate: sectionHeading

                        delegate: Image {
                            id: contactCardPortrait

                            property string dataUuid: contact.guid.guid
                            property string dataFirst: contact.name.firstName
                            property string dataLast: contact.name.lastName
                            property string dataCompany: contact.organization.name
                            property string dataFavorite: contact.tag.tag
                            property int dataStatus: contact.presence.state
                            property string dataAvatar: contact.avatar.imageUrl

                            property int delegateMargins: 2

                            height: 50
                            width: parent.width
                            opacity: 1
                            source: "image://themedimage/contacts/contact_bg_portrait";

                            Image{
                                id: photo

                                fillMode: Image.PreserveAspectFit
                                smooth: true
                                width: 50
                                height: 50
                                source: ( dataAvatar ? dataAvatar : "image://themedimage/contacts/blank_avatar" )
                                anchors.left: parent.left
                            }

                            Text{
                                id: nameFirst

   			        height: 20
                                text: dataFirst
                                anchors { left: photo.right; top: photo.top; topMargin: delegateMargins; leftMargin: delegateMargins; }
                                font.pixelSize: theme.fontPixelSizeNormal
                                color: theme.fontColorNormal
                            }

                            Text {
                                id: nameLast

                                text: dataLast
                                anchors { left: nameFirst.right; top: nameFirst.top; leftMargin: delegateMargins; }
                                font.pixelSize: theme.fontPixelSizeNormal
                                color: theme.fontColorNormal
                            }

                            Image {
                                id: favorite

                                source: "image://themedimage/contacts/icn_fav_star"
				height: 10
				width: 10
                                opacity: ( dataFavorite == "Favorite" ? 1 : .2 )
                                anchors { right: parent.right; top: nameFirst.top; rightMargin: delegateMargins; }
                            }

                            Image {
                                id: statusIcon

				height: 10
 				width: 10

                                source: {
                                    if( dataStatus == Presence.Unknown ) {
                                        return "image://themedimage/contacts/status_idle";
                                    }else if ( dataStatus == Presence.Available ) {
                                        return "image://themedimage/contacts/status_available";
                                    }else if ( dataStatus == Presence.Busy ) {
                                        return "image://themedimage/contacts/status_busy_sml";
                                    }else {
                                        return "image://themedimage/contacts/status_idle";
                                    }
                                }
                                anchors { horizontalCenter: favorite.horizontalCenter; bottom: photo.bottom; bottomMargin: delegateMargins; rightMargin: delegateMargins; }
                            }

                            Text {
                                id: statusText

                                text: {
                                    if( dataStatus == Presence.Unknown ) {
                                        return "Idle";
                                    }else if ( dataStatus == Presence.Available ) {
                                        return "Available";
                                    }else if ( dataStatus == Presence.Busy ) {
                                        return "Busy";
                                    }else {
                                        return ""
                                    }
                                }
                                anchors { left: nameFirst.left; bottom: photo.bottom; bottomMargin: delegateMargins }
                                font.pixelSize: theme.fontPixelSizeSmall
                                color: theme.fontColorHighlight
                            }

                            Image {
                                id: contactDivider
                                source: "image://themedimage/contacts/contact_divider"
                                anchors { right: contactCardPortrait.right; bottom: contactCardPortrait.bottom; left: contactCardPortrait.left; }
                            }

                            MouseArea {
                                id: mouseArea

                                anchors.fill: parent

                                onClicked: {
                                    cardListView.currentContact = model.contact
                                    console.log( "contact clicked" + index )
                                    cardListView.currentIndex = index
                                    contactsView.highlightX = cardListView.currentItem.height // Assume image fills card height and is square
                                    contactsView.highlightWidth = parent.width - contactsView.highlightX
                                    contactsView.highlightHeight = contactsView.highlightX
                                    contactsPicker.acceptButtonActive = true
                                }
                            }

                        } // contactCardPortrait

                        SortOrder {
                            id: sortFirstName

                            detail: ContactDetail.Name
                            field: Name.FirstName
                            direction: Qt.AscendingOrder
                        }

                        IntersectionFilter {
                            id: allFilter
                        }

                        Component {
                            id: sectionHeading

                            Image {
                                id: header

                                width: cardListView.width
                                height: 30

                                //color: "darkgrey"
                                source: "image://themedimage/contacts/contact_btmbar_landscape";
                                clip: true

                                Text {
                                    id: title

                                    text: section
                                    anchors { fill: parent; rightMargin: 6; leftMargin: 20; topMargin: 6; bottomMargin: 6; }
                                    verticalAlignment: "AlignVCenter"
                                    font.pixelSize: theme.fontPixelSizeNormal
                                    color: theme.fontColorHighlight
                                }
                            }
                        }

                        Component.onCompleted: {
                            positionViewAtIndex( -1, ListView.Beginning );
                            cardListView.currentIndex = -1 // force to -1 since currentIndex inits with 0.
                        }
                    } // cardListView
                } // groupedViewPortrait
            } // pickerContents
        } // contactsView
    } // inner

    TopItem {
        id: topItem
    }

    ListModel {
        id: testModel

        ListElement{
            guid: "one"
            firstName: "Andy"
            lastName: "Ann"
            organizationName: "Bad Company"
            tag: "Favorite"
            state: Presence.Available
            url: ""
        }
        ListElement{
            guid: "two"
            firstName: "Charly"
            lastName: "Charles"
            organizationName: "Good Company"
            tag: ""
            state: Presence.Busy
            url: ""
        }
        ListElement{
            guid: "three"
            firstName: "Jonny"
            lastName: "John"
            organizationName: "Another Company"
            tag: ""
            state: Presence.Unknown
            url: ""
        }
        ListElement{
            guid: "four"
            firstName: "Marky"
            lastName: "Mark"
            organizationName: "This Company"
            tag: "Favorite"
            state: Presence.Available
            url: ""
        }
        ListElement{
            guid: "five"
            firstName: "Peter"
            lastName: "Pete"
            organizationName: "That Company"
            tag: ""
            state: Presence.Available
            url: ""
        }
    }
}//ContactPicker

