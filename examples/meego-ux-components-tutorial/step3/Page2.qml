import Qt 4.7
import MeeGo.Components 0.1

/* MeeGo-Ux-Components tutorial - step 3 */
AppPage {
    id: page2

    pageTitle: "Page 1 of Book 2"
    anchors.fill: parent

    Button {
        anchors.centerIn: parent
        text: "NextPage"
        onClicked: { window.addPage( page2bComponent ) }
    }

    Component { id: page2bComponent; Page2b{} }
}
