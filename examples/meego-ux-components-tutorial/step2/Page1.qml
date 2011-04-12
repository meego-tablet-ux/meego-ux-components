import Qt 4.7
import MeeGo.Components 0.1

/* MeeGo-Components tutorial - step 2 */
AppPage {
    id: page1

    pageTitle: "Page 1 of Book 1"
    anchors.fill: parent

    Rectangle {
        anchors.fill: parent
        anchors.margins: 30

        color: "red"

        Text {
            anchors.centerIn: parent
            text: "Content of Book1/Page1"
        }
    }
}
