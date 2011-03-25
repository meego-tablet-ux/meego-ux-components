import Qt 4.7
import MeeGo.Components 0.1

/* MeeGo-Components tutorial - step 3 */
AppPage {
    id: page1

    Rectangle {
        anchors.fill: parent
        anchors.margins: 30

        color: "red"

        Button {
            anchors.centerIn: parent
            text: "NextPage"
        }
    }
}
