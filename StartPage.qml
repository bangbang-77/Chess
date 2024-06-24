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

    Column{
        anchors.centerIn: parent
        spacing:20

        Button {
            text: "双人单机对战"

            width:150;
            height:100;

            onClicked: stackView.push("Board.qml")
        }
        Button {
            text: "联机对战白棋"

            width:150;
            height:100;

            onClicked: stackView.push("NetWorkWhite.qml")
        }
        Button {
            text: "联机对战黑棋"

            width:150;
            height:100;

            onClicked: stackView.push("NetWorkBlack.qml")
        }

    }


}
