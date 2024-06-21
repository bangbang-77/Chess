import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Page {
    title: "More"

    background: Image {
        source: "qrc:/img/start.png"
        opacity: 0.5
        fillMode: Image.Stretch
        anchors.fill: parent
        onStatusChanged: {
            if (status === Image.Error) {
                console.log("Image load error:", source)
            }
        }
    }

    Column{
        anchors.horizontalCenter: parent
        spacing: 40
        Button {
            id:back
            text: "Back"
            onClicked: stackView.pop() // 返回上一页
        }
        RowLayout {
            width: 400
            anchors.left: parent.left;anchors.leftMargin: 20


            Text {
                text: qsTr("声音：")
                Layout.alignment: Qt.AlignVCenter
                Layout.preferredWidth: 60 // 设置一个合适的宽度
                font.pixelSize: 20
            }

            Slider {
                Layout.fillWidth: true
                to: 1.0
                value: audio.volume
                onMoved: audio.volume = value
            }
        }
        Text{
            text:qsTr("国际象棋介绍：")
            font.pixelSize: 20
            anchors.left: parent.left;anchors.leftMargin: 20
        }
        Rectangle{
            id:intro
            width: 400
            height:500
            border.color:"blue"
            color: "transparent"
            anchors.left: parent.left;anchors.leftMargin: 20
            SwipeView {
                id: view
                anchors.fill: parent
                Rectangle
                {
                    color: "transparent"
                    Text{
                        text: qsTr("没想好怎么排版")
                        anchors.fill: parent
                        color: "white"
                        font.pointSize: 24
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                    }
                }
                Rectangle
                {
                    color: "transparent"
                    Text{
                        text: qsTr("总介绍")
                        anchors.fill: parent
                        color: "white"
                        font.pointSize: 24
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                    }
                }
                Rectangle
                {
                    color: "transparent"
                    Text{
                        text: qsTr("总介绍")
                        anchors.fill: parent
                        color: "white"
                        font.pointSize: 24
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                    }
                }
            }
        }
    }
}
