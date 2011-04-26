import Qt 4.7
import MeeGo.Components 0.1

/* MeeGo-Components tutorial - step 2 */
AppPage {
    id: page2

    pageTitle: "Page 1 of Book 2"

    Rectangle {
        anchors.fill: parent
        anchors.margins: 30
        color: "lightgreen"

        Text {
            anchors.centerIn: parent
            text: "Content of Book2/Page1"
        }
    }
}
