import QtQuick
import QtQuick.Controls
import QtQuick.Dialogs
import QtQuick.Layouts
import MyNetWork 1.0
import "."

Item {

    id:board
    property color lightcolor: manage.lightcolor
    property color darkcolor: manage.darkcolor


    Page {
        id:page
        width: app.width
        height: app.height
        visible: true
        title: qsTr("hello, world")

        property int fromX: -1
        property int fromY: -1
        property int toX: -1
        property int toY: -1
        Ipv4{
            id:ip
            send: _inToSend.text
            onReciveChanged: {
                page.splitAndConvert(ip.recive)
                console.log("ip4收到了  "+ip.recive)
                if(_inToRecive.num1===-1)//第一次接收,拒绝连接
                    { manage.goBack();netChessBoard.reset()}
                else if(_inToRecive.num1===-2)//第一次接收，成功连接
                    {
                    console.log("已经被连接")
                    waitLink.visible=false
                    }
                else{
                    if(_inToRecive.num5===1)//悔棋
                        { netChessBoard.regretChess()}
                    else if(_inToRecive.num5===2)//重开
                        {netChessBoard.reset()}
                    else if(_inToRecive.num5===3)//退出
                        { manage.goBack();netChessBoard.reset()}
                    else{//移动
                    netChessBoard.setBlackPlayer()
                    netChessBoard.move(_inToRecive.num1,_inToRecive.num2,_inToRecive.num3,_inToRecive.num4)
                    netChessBoard.setWhitePlayer()
                         turnText.text = qsTr(netChessBoard.getTurn() + " turn")
                    }
                }
            }
        }
        //等待ip连接
        Dialog{
            id:waitLink

            visible:false
            width: parent.width
            height: parent.height
            anchors.centerIn: parent
            Image {
                id: waitpic
                source: "qrc:/img/wait.png"
                anchors.fill: parent
            }
            modal: true
            Text {
                anchors.centerIn: parent
                text: qsTr("等待黑方连接中...")
            }
        }
        //输入对方ip
        Dialog{
            id: importIp
            width: parent.width
            height: parent.height
            visible: true
            Image {
                id: textpoc
                source: "qrc:/img/link.webp"
                anchors.fill:parent
            }
            TextField {
                    id: _textField
                    width: 220
                    height: 50
                    z:2
                    placeholderText: "请输入对方的ipv4地址..."
                    anchors.centerIn: parent

                    // 添加一个按钮来触发获取文本的操作
                    Button {
                        id: okButton
                        text: "OK"
                        anchors.top: _textField.bottom
                        anchors.right: _textField.right
                        onClicked: {
                            ip.myip4=_textField.text
                            _inToSend.num2=-2
                            console.log(ip.myip4)
                            ip.sendMessage()
                            importIp.visible=false
                            waitLink.visible=true
                            if(_inToRecive.num1===-2)
                            waitLink.visible=false
                            boardchess.visible=true
                            grid.visible=true
                        }
                    }
                    Button {
                        id: cancelButton
                        text: "cancel"
                        anchors.top: _textField.bottom
                        anchors.left: _textField.left
                        onClicked: {
                            console.log(ip.send+"   "+ip.recive)
                            manage.goBack()
                        }
                    }
                }
        }

        //记录发送数据
        Text{
            id:_inToSend
            visible: false
            property int num1: -1
            property int num2: -1
            property int num3: -1
            property int num4: -1
             property int num5: 0
            text:num1+" "+num2+" "+num3+" "+num4+" "+num5
        }
        //记录处理后的接收数据
        Text {
            id: _inToRecive
            visible: false
            property int num1: -1
            property int num2: -1
            property int num3: -1
            property int num4: -1
            property int num5: 0
        }
        // 棋盘
        Rectangle {
            id: boardchess
            width: parent.width
            height: parent.width
            anchors.centerIn: parent
            visible: false
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
                            return ((rows + cols) % 2 === 0) ? lightcolor : darkcolor
                        }
                    }
                }
            }
        }

        // 显示可以走的位置
        function getMoves(x, y) {
            var movelist = netChessBoard.possibleMoves(x, y);

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
            var movelist = netChessBoard.possibleMoves(x, y);

            for(var i = 0; i < movelist.length; i++) {
                console.log("清除color：" + movelist[i]);
                if(gridRep.itemAt(movelist[i]).children.length > 0) {
                    gridRep.itemAt(movelist[i]).children[1].visible = false
                    gridRep.itemAt(movelist[i]).children[1].z = -1
                }
            }
        }
        // 将字符串分割成单个字符的数组
        function splitAndConvert(inputString) {
            var numbers = inputString.split(" ")
            _inToRecive.num1=numbers[0];
            _inToRecive.num2=numbers[1];
            _inToRecive.num3=numbers[2];
            _inToRecive.num4=numbers[3];
            _inToRecive.num5=numbers[4];
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
                   text: qsTr(netChessBoard.getTurn() + " turn")
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
                       netChessBoard.reset();
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
                       netChessBoard.reset();
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
                               netChessBoard.setPromotion("queen")
                               netChessBoard.changeType(page.toX, page.toY)
                               promote.close();
                               promoteMask.visible = false
                           }
                       }
                       Button {
                           id: rook
                           text: qsTr("晋升成车")
                           onClicked: {
                               // console.log("promote rook");
                               netChessBoard.setPromotion("rook")
                               netChessBoard.changeType(page.toX, page.toY)
                               promote.close();
                               promoteMask.visible = false
                           }
                       }
                       Button {
                           id: knight
                           text: qsTr("晋升成马")
                           onClicked: {
                               // console.log("promote knight");
                               netChessBoard.setPromotion("knight")
                               netChessBoard.changeType(page.toX, page.toY)
                               promote.close();
                               promoteMask.visible = false
                           }
                       }
                       Button {
                           id: bishop
                           text: qsTr("晋升成象")
                           onClicked: {
                               // console.log("promote bishop");
                               netChessBoard.setPromotion("bishop")
                               netChessBoard.changeType(page.toX, page.toY)
                               promote.close();
                               promoteMask.visible = false
                           }
                       }
                   }
               }
           }


           Connections {
               target: netChessBoard
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
            visible: false

            Repeater {
                id: gridRep
                model: netChessBoard

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
                                _inToSend.num3=page.toX
                                _inToSend.num4=page.toY
                                console.log("fromX:" + page.fromX + " fromY:" + page.fromY+" toX:"+page.toX+" toY:"+page.toY)
                                netChessBoard.move(page.fromX, page.fromY, page.toX, page.toY)
                                ip.sendMessage()
                                console.log("发送："+ip.send)
                                netChessBoard.setWaitPlayer()
                                turnText.text = qsTr(netChessBoard.getTurn() + " turn")
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
                                _inToSend.num1=page.fromX
                                _inToSend.num2=page.fromY
                                page.getMoves(page.fromX, page.fromY);
                            }
                        }
                    }
                }
            }
        }
        footer:
            ToolBar {
                height: 55
                background:
                    Rectangle {
                        color: darkcolor
                    }
                    Row {
                        anchors.centerIn: parent
                        spacing: 55

                        ToolButton {
                            text: qsTr("退出")
                            onClicked: {
                                _inToSend.num5=3
                                ip.sendMessage()
                                _inToSend.num5=0
                                manage.goBack()
                                netChessBoard.reset()
                            }
                        }

                        ToolButton {
                            text: qsTr("重开")
                            onClicked: {
                                netChessBoard.reset()
                                _inToSend.num5=2
                                ip.sendMessage()
                                _inToSend.num5=0
                            }
                        }

                        ToolButton {
                            id: regret
                            text: qsTr("撤回")
                            //撤回操作
                            onClicked:{
                                netChessBoard.regretChess()
                                _inToSend.num5=1
                                ip.sendMessage()
                                _inToSend.num5=0
                            }
                        }
                        ToolButton {
                            text: qsTr("帮助")
                            onClicked: manage.modes.set('help')
                        }
                    }
            }
    }
}
