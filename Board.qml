import QtQuick
import QtQuick.Controls
import QtQuick.Dialogs
import QtQuick.Layouts
import "."
Item{
    id:board
    Page {
        id:page
        width: app.width
        height: app.height
        visible: true
        title: qsTr("hello, world")

        //是否选择保存进度
        Button {
            id:back
            text: "Back"
            onClicked: saveOrNot.open()
        }
        Dialog {
            id: saveOrNot
            title: "进度缓存"
            width: 300
            height: 150
            anchors.centerIn: parent

            contentItem:
                Column {
                    spacing: 20
                    Text {
                        text: "你想要保存进度吗"
                        width: parent.width
                        color:"red"
                        horizontalAlignment: Text.AlignHCenter
                    }

                    Row {
                        spacing: 10
                        anchors.horizontalCenter: parent.horizontalCenter

                    Button {
                        text: "是的"
                        width: 100
                        height: 50
                        onClicked: {
                            manage.goBack()
                        }
                    }

                    Button {
                        text: "不是"
                        width: 100
                        height: 50
                        onClicked: {
                            manage.goBack()
                            chessBoard.reset()
                        }
                    }
                }
            }
        }

        // 棋盘
        Rectangle {
            id: boardchess
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
                        width: boardchess.width / 8
                        height: boardchess.height / 8
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
                    manage.goBack(); // 返回上一页
                    chessBoard.reset();
                    gameEnd.visible = false
                }
            }

            // 游戏结束弹窗
            MessageDialog {
                id: gameEnd
                title: "游戏结束"
                text: ""
                onAccepted: {
                    console.log("end弹窗被接受");
                    // 跳转回主界面...
                    manage.goBack(); // 返回上一页
                    chessBoard.reset();
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
                            chessBoard.changeType(page.toX, page.toY)
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
                            chessBoard.changeType(page.toX, page.toY)
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
                            chessBoard.changeType(page.toX, page.toY)
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
                            chessBoard.changeType(page.toX, page.toY)
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
                    width: boardchess.width / 8
                    height: boardchess.height / 8
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
                                page.clearColor(page.fromX, page.fromY)
                                page.toX = index % 8
                                page.toY = (index - page.toX) / 8
                                chessBoard.move(page.fromX, page.fromY, page.toX, page.toY)
                                turnText.text = qsTr(chessBoard.getTurn() + " turn")
                                page.fromX = -1
                                page.fromY = -1
                            }
                        }
                    }

                    TapHandler {
                        // target: girdImg
                        onTapped: {
                            page.clearColor(page.fromX, page.fromY)
                            page.fromX = index % 8
                            page.fromY = (index - page.fromX) / 8
                            console.log("x:" + page.fromX + " y:" + page.fromY);
                            if(model.pieceImg !== undefined) {
                                page.getMoves(page.fromX, page.fromY);
                            }
                        }
                    }
                }
            }
        }

        Button {
            id: regret
            text: "Regtet"
            anchors.bottom: parent.bottom
            onClicked: chessBoard.regretChess();
        }
    }
}
