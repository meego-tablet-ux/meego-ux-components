import Qt 4.7
import MeeGo.Components 0.1

/* MeeGo-Components tutorial - step 5 */
AppPage {
    id: page1

    function doActionOne() {
        area.color = "lightgreen"
    }
    function doActionTwo() {
        area.color = "lightblue"
    }

    pageTitle: "ActionMenu Test"

    anchors.fill: parent

    actionMenuModel: [ qsTr("Make it green"), qsTr("Make it blue") ]

    actionMenuPayload: [ 1 , 2 ]

    actionMenuTitle: qsTr("ActionMenu")

    onActionMenuTriggered: {
        if( selectedItem == 1 ) {
            doActionOne()
        } else if( selectedItem == 2 ) {
            doActionTwo()
        }
    }

    Rectangle {
        id: area

        anchors.fill: parent
        anchors.margins: 30
        color: "lightgrey"
    }
}
