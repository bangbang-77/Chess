import QtQuick
import QtQuick.Controls
import QtQuick.Dialogs
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
            if(gridRep.itemAt(movelist[i]).children.length > 0) {
                gridRep.itemAt(movelist[i]).children[1].visible = false
                gridRep.itemAt(movelist[i]).children[1].z = -1
            }
        }
    }

    Rectangle {
        width: 100
        height: 50
        anchors.horizontalCenter: parent.horizontalCenter
        border.color: "lightgreen"
        border.width: 3
        Text {
            id: turnText
            color: "red"
            anchors.centerIn: parent
            text: qsTr(chessBoard.getTurn() + " turn")
        }
    }

    // 模态遮罩层(游戏结束)
    Rectangle {
        id: gameEndMask
        anchors.fill: parent
        visible: false
        z: -6
        color: "transparent"

        MouseArea {
            anchors.fill: parent
            onClicked: {
                gameEnd.visible = true
                // 跳转回主界面...
            }
        }

        // 游戏结束弹窗
        MessageDialog {
            id: gameEnd
            title: "游戏结束"
            text: ""
            onAccepted: {
                console.log("end弹窗被接受");
                gameEnd.close();
                // 跳转回主界面...
            }
        }
    }

    // 模态遮罩层(兵升变提示)
    Rectangle {
        id: promoteMask
        anchors.fill: parent
        visible: false
        z: -6
        color: "transparent"

        MouseArea {
            anchors.fill: parent
            onClicked: {
                promote.visible = true
            }
        }

        // 晋升弹窗
        Dialog {
            id: promote
            title: "兵升变"
            width: 250
            height: 350
            modal: true
            anchors.centerIn: parent

            Text {
                anchors.horizontalCenter: parent.horizontalCenter
                text: qsTr("必须晋升（强制)")
                color: "red"
            }

            spacing: 5

            GridLayout {
                columns: 2
                rows: 2
                anchors.centerIn: parent
                columnSpacing: 5
                rowSpacing: 5

                Button {
                    id: queen
                    text: qsTr("晋升成后")
                    onClicked: {
                        // console.log("promote queen");
                        chessBoard.setPromotion("queen")
                        chessBoard.changeType(toX, toY)
                        promote.close();
                        promoteMask.visible = false
                    }
                }
                Button {
                    id: rook
                    text: qsTr("晋升成车")
                    onClicked: {
                        // console.log("promote rook");
                        chessBoard.setPromotion("rook")
                        chessBoard.changeType(toX, toY)
                        promote.close();
                        promoteMask.visible = false
                    }
                }
                Button {
                    id: knight
                    text: qsTr("晋升成马")
                    onClicked: {
                        // console.log("promote knight");
                        chessBoard.setPromotion("knight")
                        chessBoard.changeType(toX, toY)
                        promote.close();
                        promoteMask.visible = false
                    }
                }
                Button {
                    id: bishop
                    text: qsTr("晋升成象")
                    onClicked: {
                        // console.log("promote bishop");
                        chessBoard.setPromotion("bishop")
                        chessBoard.changeType(toX, toY)
                        promote.close();
                        promoteMask.visible = false
                    }
                }
            }
        }
    }


    Connections {
        target: chessBoard
        function onWhiteWin() {
            console.log("Received signal in QML, White Win");
            gameEndMask.visible = true
            gameEndMask.z = 999999
            gameEnd.text = "White Win!"
            gameEnd.visible = true
        }
        function onBlackWin() {
            console.log("Received signal in QML, Black Win");
            gameEndMask.visible = true
            gameEndMask.z = 999999
            gameEnd.text = "Black Win!"
            gameEnd.visible = true
        }
        function onPromote() {
            console.log("晋升弹窗提示")
            promoteMask.visible = true
            promoteMask.z = 999999
            promote.visible = true
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
                            turnText.text = qsTr(chessBoard.getTurn() + " turn")
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
