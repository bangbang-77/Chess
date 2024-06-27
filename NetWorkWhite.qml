import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Dialogs
import MyNetWork 1.0
import "."
Item {
    id:white

    property color lightcolor: manage.lightcolor
    property color darkcolor: manage.darkcolor
       Page {
           id:_white_page
           width: app.width
           height: app.height
           visible: true



           Ipv4{id:ip;
               send: _inToSend.text;
               onReciveChanged: {
               _white_page.splitAndConvert(ip.recive);
               console.log("ip4  "+ip.recive)
                   if(_inToRecive.num5===1){ chessBoard.regretChess()}
                   else{
                       chessBoard.setBlackPlayer()
                       chessBoard.move(_inToRecive.num1,_inToRecive.num2,_inToRecive.num3,_inToRecive.num4)
                       chessBoard.setWhitePlayer()
                   }

               }
           }


           Dialog {
               id: ipDialog
               title: "输入IPv4地址"
               standardButtons: Dialog.Ok | Dialog.Cancel
               width: 300
               height: 200
               visible: false
               anchors.centerIn: parent

               ColumnLayout {
                   anchors.fill: parent
                   TextField {
                       id: ipAddress
                       Layout.fillWidth: true
                       placeholderText: "请输入对方的IPv4地址..."
                       onTextChanged: ipDialog.standardButton(Dialog.Ok).enabled = ipAddress.text.trim().length > 0
                   }
               }

               onAccepted: {
                   if (ipAddress.text.trim().length > 0) {
                       ip.myip4 = ipAddress.text
                       console.log(ip.myip4)
                       chessBoard.setWaitPlayer()
                       ipDialog.close()
                   }else{
                       worryInfo.open()
                   }
               }

               onRejected: {
                   console.log("取消输入IP地址")
                   manage.goBack()
               }
           }
           MessageDialog {
               id: worryInfo
               text: "输入不可为空！"
               onAccepted: {
                   console.log("end弹窗被接受");
                   // 跳转回主界面...
                   manage.goBack(); // 返回上一页
               }
           }
           Component.onCompleted: {
               ipDialog.open()
           }

              property int fromX: -1
              property int fromY: -1
              property int toX: -1
              property int toY: -1

              Text{
                  id:_inToSend
                  visible: false
                  property int num1: -1
                  property int num2: -1
                  property int num3: -1
                  property int num4: -1
                  property int num5: 0
                  text:num1+" "+num2+" "+num3+" "+num4
              }
              function splitAndConvert(inputString) {
                      var numbers = inputString.split(" ")  // 将字符串分割成单个字符的数组
                      _inToRecive.num1=numbers[0];
                      _inToRecive.num2=numbers[1];
                      _inToRecive.num3=numbers[2];
                      _inToRecive.num4=numbers[3];
                      _inToRecive.num5=numbers[4];
              }

              Text {
                  id: _inToRecive
                  //记录处理后的接收数据
                  visible: false
                  property int num1: -1
                  property int num2: -1
                  property int num3: -1
                  property int num4: -1
                  property int num5: 0
              }

           // 返回
           Row{

               Button {
                   text: "Back"
                   onClicked: manage.goBack() // 返回上一页
               }
           }

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
                               return ((rows + cols) % 2 === 0) ? lightcolor : darkcolor
                           }
                       }
                   }
               }
           }



           // 显示可以走的位置
           function getMoves(x, y) {
               var movelist = chessBoard.possibleMoves(x, y);

               for(var i = 0; i < movelist.length; i++) {
                   console.log("可走位置：" + movelist[i]);
                   // rec.visible  = true
                   if(gridRep.itemAt(movelist[i]).children.length > 0) {
                       gridRep.itemAt(movelist[i]).children[1].visible = true
                       gridRep.itemAt(movelist[i]).children[1].z = 1
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
                       width: board.width / 8
                       height: board.height / 8
                       fillMode: Image.PreserveAspectFit
                       source: model.pieceImg !== undefined ? model.pieceImg : ""

                       Text {
                           z: 1
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
                               id:taphandler

                               onTapped: {

                                   _white_page.clearColor(_white_page.fromX, _white_page.fromY)
                                   _white_page.toX = index % 8
                                   _white_page.toY = (index - _white_page.toX) / 8
                                    _inToSend.num3 = _white_page.toX
                                    _inToSend.num4 = _white_page.toY
                                   console.log(".fromX:" + _white_page.fromX + " fromY:" + _white_page.fromY+" toX:"+_white_page.toX+" toY:"+_white_page.toY);
                                   chessBoard.move(_white_page.fromX, _white_page.fromY, _white_page.toX, _white_page.toY)
                                    ip.sendMessage()
                                    console.log("发送："+ip.send)
                                   chessBoard.setWaitPlayer()
                               }
                           }
                       }

                       TapHandler {
                           id:taphandler1
                           onTapped: {
                               console.log("tap1")
                                _white_page.clearColor(_white_page.fromX, _white_page.fromY)
                               _white_page.fromX = index % 8
                               _white_page.fromY = (index - _white_page.fromX) / 8
                                _inToSend.num1 = _white_page.fromX
                                _inToSend.num2 = _white_page.fromY
                                _white_page.getMoves(_white_page.fromX, _white_page.fromY);
                           }
                       }
                   }
               }
           }
           //悔棋按键
           Button {
               id: regret
               text: "Regtet"
               anchors.bottom: parent.bottom
               onClicked:{
                   chessBoard.regretChess()
                   _inToSend.num5=1
                   ip.sendMessage()
                   _inToSend.num5=0
               }

           }
       }
}

