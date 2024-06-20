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

    property int fromX: -1
    property int fromY: -1
    property int toX: -1
    property int toY: -1

    // 显示可以走的位置
    function getMoves(x, y) {
        var movelist = chessBoard.possibleMoves(x, y);

        for(var i = 0; i < movelist.length; i++) {
            console.log("可走位置：" + movelist[i]);
            // rec.visible  = true
            if(gridRep.itemAt(movelist[i]).children.length > 0) {
                gridRep.itemAt(movelist[i]).children[1].visible = true
                gridRep.itemAt(movelist[i]).children[1].z = 999999
            }
        }
    }

    // 清除可以走的位置
    function clearColor(x, y) {
        var movelist = chessBoard.possibleMoves(x, y);

        for(var i = 0; i < movelist.length; i++) {
            console.log("清除color：" + movelist[i]);
            // rec.visible = false
            if(gridRep.itemAt(movelist[i]).children.length > 0) {
                gridRep.itemAt(movelist[i]).children[1].visible = false
                gridRep.itemAt(movelist[i]).children[1].z = -1
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
            id: gridRep
            model: chessBoard

            Image {
                id: girdImg
                width: board.width / 8
                height: board.height / 8
                fillMode: Image.PreserveAspectFit
                source: model.pieceImg !== undefined ? model.pieceImg : ""

                Text {
                    z: 999
                    text: index
                }

                Rectangle {
                    id: rec
                    anchors.fill: parent
                    color: "lightgreen"
                    opacity: 0.8
                    visible: false
                    z: -1

                    TapHandler {
                        // target: rec
                        onTapped: {
                            clearColor(fromX, fromY)
                            toX = index % 8
                            toY = (index - toX) / 8
                            chessBoard.move(fromX, fromY, toX, toY)
                        }
                    }
                }

                TapHandler {
                    // target: girdImg
                    onTapped: {
                        clearColor(fromX, fromY)
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
