import Qt 4.7

Item {
    id: container

    property int radius: 10

    property int centerX: 0
    property int centerY: 0

    property alias color: dot.color

    x: centerX - radius
    y: centerY - radius

    Rectangle {
        id: dot

        anchors.centerIn: parent

        width: container.radius * 2
        height:  container.radius * 2

        border.color: "black"

        radius: container.radius
    }
}
