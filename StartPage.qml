import QtQuick
import QtQuick.Controls

Page {
    title: "Start Page"

    background:
        Image {
            source: "qrc:/img/start.png"
            fillMode: Image.Stretch
            anchors.fill: parent
            onStatusChanged: {
                    if (status === Image.Error) {
                        console.log("Image load error:", source)
                    }
                }
        }

    Row{
        anchors.centerIn: parent
        spacing:20

        Button {
            text: "双人联机对战"

            width:150;
            height:100;

            onClicked: stackView.push("board.qml")
        }
        Button {
            text: "双人单机对战"

            width:150;
            height:100;

            onClicked: stackView.push("board.qml")
        }
    }


}
