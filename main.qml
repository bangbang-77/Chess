import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

ApplicationWindow {
    width: 640
    height: 480
    visible: true
    title: qsTr("hello, world")

    // 棋盘
    Rectangle {
        id: board
        width: parent.width
        height: parent.width
        anchors.centerIn: parent
        z: -1

        Grid {
            rows: 8
            columns: 8
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter

            Repeater {
                model: 8 * 8

                Rectangle {
                    width: board.width / 8
                    height: board.height / 8
                    color: {
                        var cols = index % 8 //列
                        var rows = (index - cols) / 8 //行
                        return ((rows + cols) % 2 === 0) ? "white" : "gray"
                    }
                }
            }
        }
    }

    // 棋子
    Grid {
        id: grid
        rows: 8
        columns: 8
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter

        Repeater {
            model: chessBoard

            Image {
                width: board.width / 8
                height: board.height / 8
                fillMode: Image.PreserveAspectFit
                source: model.pieceImg !== undefined ? model.pieceImg : ""
            }
        }
    }

}
