import Qt 4.7

Item {
    id: container

    property alias color: dot.color

    Rectangle {
        id: dot

        anchors.centerIn: parent

        width: 110
        height: 10

        border.color: "black"

    }
}
