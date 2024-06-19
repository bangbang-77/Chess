import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

ApplicationWindow {
    width: 480
    height: 640
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
                        var rows = (index - cols) / 8 //行 (减去cols再除，得到整数)
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

                property int fromX: -1
                property int fromY: -1

                function getMoves(x, y) {
                    var movelist = chessBoard.possibleMoves(x, y);

                    for(var i = 0; i < movelist.length; i++) {
                        console.log("可走位置：" + movelist[i]);
                    }
                }

                Text {
                    z: 999
                    text: index
                }

                TapHandler {
                    onTapped: {
                        fromX = index % 8
                        fromY = (index - fromX) / 8
                        console.log("x:" + fromX + " y:" + fromY);
                        getMoves(fromX, fromY);

                    }
                }

            }

        }
    }
}
