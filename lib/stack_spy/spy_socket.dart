/*
 * Created with Android Studio.
 * User: whqfor
 * Date: 12/7/20
 * Time: 10:36 AM
 * target: socket通信
 */

import 'dart:async';
import 'dart:io';

import 'package:d_stack_spy/stack_spy/spy.dart';
import 'package:d_stack_spy/stack_spy/spy_observer.dart';

class SpySocket {
  WebSocket socket;

  Future<WebSocket> initSocket() async {
    // Dart client
    // ws://10.29.13.38:4041/ws
    print('spy initSocket');

    WebSocket _socket = await WebSocket.connect('ws://10.29.118.14:4041/ws');
    socket = _socket;
    print('spy initSocket done');

    Future.delayed(Duration(milliseconds: 3000), () {

      Timer.periodic(Duration(milliseconds: 300), (timer) {
        var sentStr =  DSpyNodeObserver.instance.firstNodeString();
        if (sentStr != null) {
          print('sentSocket');
          sentNodeToServer(sentStr);
        }
      });

    });

    return _socket;
  }

  void listenSocket() {
    socket.listen((event) {
      print('event $event');
      // 接受到截图消息准备native截图
      // 处理好格式后发给native
      Map action = event;
      DStackSpy.instance.channel
          .sendScreenShotActionToNative({'target': action['target']});
    });
  }

  void sentNodeToServer(String jsonString) {
    socket.add(jsonString);
  }
}
