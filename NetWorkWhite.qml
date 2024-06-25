import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Dialogs
import MyNetWork 1.0
import "."
Item {

       Page {
           id:_white_page
           width: 450
           height: 800
           visible: true


           Ipv4{id:ip;
               send: _inToSend.text;
               onReciveChanged: {
               _white_page.splitAndConvert(ip.recive);
               console.log("ip4  "+ip.recive)
               chessBoard.setBlackPlayer()
               chessBoard.move(_inToRecive.num1,_inToRecive.num2,_inToRecive.num3,_inToRecive.num4)
               chessBoard.setWhitePlayer()
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
                  //记录发送数据
                  visible: false
                  property int num1: -1
                  property int num2: -1
                  property int num3: -1
                  property int num4: -1
                  text:num1+" "+num2+" "+num3+" "+num4
              }
              function splitAndConvert(inputString) {
                      var numbers = inputString.split(" ")  // 将字符串分割成单个字符的数组
                      _inToRecive.num1=numbers[0];
                      _inToRecive.num2=numbers[1];
                      _inToRecive.num3=numbers[2];
                      _inToRecive.num4=numbers[3];
                  }


              Text {
                  id: _inToRecive
                  //记录处理后的接收数据
                  visible: false
                  property int num1: -1
                  property int num2: -1
                  property int num3: -1
                  property int num4: -1
              }

              // Text {
              //     id:show
              //     text: "              收到了："+ip.recive+"  发送了："+ip.send
              //     width: 220
              //     height: 60
              // }


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
                               return ((rows + cols) % 2 === 0) ? "white" : "gray"
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
    }
}

