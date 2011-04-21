import Qt 4.7
import MeeGo.Components 0.1

/* MeeGo-Components tutorial - step 3 */
AppPage {
    id: page1

    pageTitle: "Page 1 of Book 1"
    anchors.fill: parent

    Button {
        anchors.centerIn: parent
        text: "NextPage"
        onClicked: { window.addPage( page1bComponent ) }
    }

    Component { id: page1bComponent; Page1b{} }
}
