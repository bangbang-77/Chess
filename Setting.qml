import QtQuick
import QtQuick.Controls

Item {
    id: setting

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
        Column {
            width: app.width
            height: app.height
            spacing: 50 // 设置列中各元素之间的间距

            Button {
                id: back
                text: "Back"
                onClicked: manage.goBack() // 返回上一页
            }

            Row {
                width: parent.width
                spacing: 20 // 设置行中各元素之间的间距

                Text {
                    text: qsTr("声音：")
                    font.pixelSize: 20
                    anchors.verticalCenter: parent.verticalCenter
                }

                Slider {
                    id: volumeSlider
                    width: app.width*0.7
                    from: 0
                    to: 1
                    value: 1
                    onValueChanged: {
                        musicPlayer.volume = value
                    }
                }
            }
        }
    }
}
