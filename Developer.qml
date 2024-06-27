import QtQuick
import QtQuick.Controls

Item {
    id: developer

    Page {
        visible: true
        width: app.width
        height: app.height
        background: Image {
            source: "qrc:/img/start.png"
            fillMode: Image.Stretch
            anchors.fill: parent
            opacity: 0.5
            onStatusChanged: {
                if (status === Image.Error) {
                    console.log("Image load error:", source)
                }
            }
        }
        Button {
            id: back
            text: "Back"
            onClicked: manage.goBack() // 返回上一页
        }
    }
}
