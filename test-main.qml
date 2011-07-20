import Qt 4.7
import MeeGo.Components 0.1

Window {
    id: window

    bookMenuModel: ["MainPage"]
    bookMenuPayload: [mainPage]
    
    Component.onCompleted: {
        switchBook(mainPage)
    }

    Rectangle {
        anchors.fill: parent
        color: "green"
        z: -4
    }

    Component {
        id: mainPage
        Item {
            anchors.fill: parent
            Rectangle {
                width: label.width + 2*10
                height: label.height + 2*10
                anchors.centerIn: parent
                color: "blue"
    
                Text {
                    id: label
                    text: "Click to change orientation<br>Note that while rotating,<br>the background is white and the corners are black."
                    anchors.centerIn: parent
                    width: paintedWidth
                    height: paintedHeight
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }

                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        if (orientation != 1)
                            orientation = 1
                        else
                            orientation = 2
                    }
                }
            }    
        }
    }  
}
