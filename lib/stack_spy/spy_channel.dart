/*
 * Created with Android Studio.
 * User: whqfor
 * Date: 12/1/20
 * Time: 4:11 PM
 * target: Spy channel
 */

import 'dart:async';
import 'package:flutter/services.dart';


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