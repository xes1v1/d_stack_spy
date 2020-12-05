/*
 * Created with Android Studio.
 * User: whqfor
 * Date: 12/1/20
 * Time: 4:11 PM
 * target: Spy channel
 */

import 'dart:async';
import 'package:flutter/services.dart';
import 'dart:io';

const String SpySentNodeToFlutter = 'spySentNodeToFlutter';

class DChannel {
  MethodChannel _methodChannel;

  DChannel(MethodChannel methodChannel) {
    _methodChannel = methodChannel;
    _methodChannel.setMethodCallHandler((MethodCall call) {
      // 处理Native发过来的消息
      print(
          'setMethodCallHandler method ${call.method}, arguments ${call.arguments}');
      if (SpySentNodeToFlutter == call.method) {
        print('arguments ${call.arguments}');
      }
      return Future.value();
    });
  }

  Future invokeMethod<T>(String method, [dynamic arguments]) async {
    return _methodChannel.invokeMethod(method, arguments);
  }
}

Future spySocket() async {
  // Dart client
  // ws://10.29.13.38:4041/ws
  WebSocket socket = await WebSocket.connect('ws://10.29.13.38:4041/ws');
  socket.listen((event) {
    print('event $event');
  });
  var count = 0;
  Timer.periodic(const Duration(seconds: 1), (Timer countDownTimer) {
    socket.add('${count++}');
  });
}