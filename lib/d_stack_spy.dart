export 'd_spy_observer.dart';

import 'dart:async';

import 'package:d_stack_spy/d_spy_channel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class DStackSpy {
  static final DStackSpy _singleton = DStackSpy._internal();
  factory DStackSpy() => _singleton;
  static DStackSpy get instance => _singleton;

  GlobalKey get boundaryKey => _boundaryKey;
  static GlobalKey _boundaryKey;

  DChannel get channel => _stackChannel;
  static DChannel _stackChannel;

  DStackSpy._internal() {
    print('DStackSpy instance');
    final MethodChannel _methodChannel = MethodChannel("d_stack_spy");
    _stackChannel = DChannel(_methodChannel);
    _boundaryKey = GlobalKey();
    print('_boundaryKey $_boundaryKey');

    // spySocket();
  }

  static Future<String> get platformVersion async {
    final String version =
        await _stackChannel.invokeMethod('getPlatformVersion');
    print('spy $version');
    return version;
  }
}
