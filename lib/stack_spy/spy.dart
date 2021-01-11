/*
 * Created with Android Studio.
 * User: whqfor
 * Date: 12/7/20
 * Time: 11:04 AM
 * target: spy
 */

import 'dart:async';

import 'package:d_stack_spy/d_stack_spy.dart';

import 'spy_channel.dart';
import 'package:flutter/services.dart';
import 'spy_socket.dart';


class DStackSpy {
  static final DStackSpy _singleton = DStackSpy._internal();
  factory DStackSpy() => _singleton;
  static DStackSpy get instance => _singleton;


  DChannel get channel => _stackChannel;
  static DChannel _stackChannel;

  void ipAndPort(String ipAndPort) {
    SpySocket().initSocket(ipAndPort);
  }

  int milliseconds;
  DSpyNodeObserver nodeObserver;

  DStackSpy._internal() {
    print('DStackSpy instance');
    final MethodChannel _methodChannel = MethodChannel("d_stack_spy");
    _stackChannel = DChannel(_methodChannel);
  }

  static Future<String> get platformVersion async {
    final String version =
    await _stackChannel.invokeMethod('getPlatformVersion');
    print('spy $version');
    return version;
  }
}