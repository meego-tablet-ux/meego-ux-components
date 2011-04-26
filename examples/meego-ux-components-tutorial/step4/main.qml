import Qt 4.7
import MeeGo.Components 0.1

/* MeeGo-Ux-Components tutorial - step 4 */
Window {
    id: window

    Component { id: page1; Page1{} }

    Component.onCompleted: switchBook( page1 )
}
