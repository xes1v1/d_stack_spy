/*
 * Created with Android Studio.
 * User: whqfor
 * Date: 12/7/20
 * Time: 10:36 AM
 * target: socket通信
 */

import 'dart:async';
import 'dart:io';

import 'package:d_stack_spy/stack_spy/spy_observer.dart';

class SpySocket {

  WebSocket socket;

  Future<WebSocket> initSocket() async {
    // Dart client
    // ws://10.29.13.38:4041/ws
    print('spy initSocket');
    WebSocket _socket = await WebSocket.connect('ws://10.29.13.38:4041/ws');
    socket = _socket;
    print('spy initSocket done');

    Timer.periodic(Duration(milliseconds: 300), (timer) {
      var sentStr =  DSpyNodeObserver.instance.firstNodeString();
      if (sentStr != null) {
        print('sentSocket $sentStr');
        sentSocket(sentStr);
      }
    });

    return _socket;
  }

  void listenSocket() {
    socket.listen((event) {
      print('event $event');
    });
  }

  void sentSocket(String jsonString) {
    socket.add(jsonString);
  }
}