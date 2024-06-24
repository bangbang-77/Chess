import QtQuick
import QtQuick.Controls
import "."
Item{
    id: start
    anchors.fill: parent
    Page {
        width: app.width
        height: app.height

        background: Image {
            source: "qrc:/img/start.png"
            fillMode: Image.Stretch
            anchors.fill: parent
            onStatusChanged: {
                if (status === Image.Error) {
                    console.log("Image load error:", source)
                }
            }
        }

        Button {
            text: "关于"
            width: 80
            height: 40
            onClicked: manage.modes.set('about')
        }

        Column {
            anchors.centerIn: parent
            spacing: 20

            Button {
                text: "双人单机对战"
                width: 150
                height: 100
                onClicked: manage.modes.set('board')
                background: Rectangle {
                    anchors.fill: parent
                    color: "gray"
                    opacity: 0.5
                    radius: 5
                }
            }
            Button {
                text: "双人单机对战"
                width: 150
                height: 100
                onClicked: manage.modes.set('board')
                background: Rectangle {
                    anchors.fill: parent
                    color: "gray"
                    opacity: 0.5
                    radius: 5
                }
            }
            Button {
                text: "双人单机对战"
                width: 150
                height: 100
                onClicked: manage.modes.set('board')
                background: Rectangle {
                    anchors.fill: parent
                    color: "gray"
                    opacity: 0.5
                    radius: 5
                }
            }
        }
    }
}


