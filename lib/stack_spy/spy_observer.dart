/*
 * Created with Android Studio.
 * User: whqfor
 * Date: 12/3/20
 * Time: 4:53 PM
 * target: 监听NavigatorObserver
 */

import 'dart:io';

import 'package:d_stack/observer/d_node_observer.dart';
import 'package:d_stack_spy/stack_spy/spy.dart';
import 'package:flutter/material.dart';
import 'dart:convert' as convert;

// spy节点监听
class DSpyNodeObserver extends DNodeObserver {


  int milliseconds;

  static final DSpyNodeObserver _singleton = DSpyNodeObserver._internal();
  factory DSpyNodeObserver() => _singleton;
  static DSpyNodeObserver get instance => _singleton;

  DSpyNodeObserver._internal() {
    print('milliseconds= $milliseconds');
    DStackSpy();
    if (Platform.isIOS) {
      Map node = {
        // stack发送给NodeObserver的数据
        'action': 'push',
        'pageType': 'Flutter', // Flutter、Native
        'target': '/', //页面路由
        'params': {},
        'isFlutterHomePage': false, // true false
        'boundary': false, // true false
        'isRootPage': true, // true false
        'animated': false, // true false
        'identifier': '' // 页面唯一id
      };
      this.operationNode(node);
    }
  }

  // 待发送节点队列
  List<Map> _messageQueue = [];

  // 监听到栈节点变化加到队列中
  void addStackNode(Map node) {
    print('addStackNode $node');
    Map stackNode = {};
    stackNode['socketClient'] = 'app';
    stackNode['messageType'] = 'node'; // node、screenshot 消息类型
    stackNode['data'] = node;
    _messageQueue.add(stackNode);

    String action = node['action'];
    // 只有打开新页面才需要截图
    if (action == 'push' || action == 'present' || action == 'replace') {
      Future.delayed(Duration(milliseconds: milliseconds), () {
        DStackSpy.instance.channel
            .sendScreenShotActionToNative({'target': node['target']});
      });
    }
  }

  // 队列中添加截图数据
  void addScreenshotNode(Map node) {
    print('addScreenshotNode $node');
    Map screenshotNode = {};
    screenshotNode['socketClient'] = 'app';
    screenshotNode['messageType'] = 'screenshot';
    screenshotNode['data'] = node;
    _messageQueue.add(screenshotNode);
  }

  // 获取队列中第一个
  String firstNodeString() {
    if (_messageQueue.isNotEmpty) {
      Map firstNode = _messageQueue.removeAt(0);
      String messageStr = convert.jsonEncode(firstNode);
      return messageStr;
    } else {
      return null;
    }
  }

  @override
  void operationNode(Map node) {
    print('DSpyNodeObserver operationNode');
    this.addStackNode(node);
  }
}




// 路由监听 准备废弃
class DSpyNavigatorObserver extends NavigatorObserver {
  static final DSpyNavigatorObserver _singleton =
      DSpyNavigatorObserver._internal();

  factory DSpyNavigatorObserver() => _singleton;

  static DSpyNavigatorObserver get instance => _singleton;

  DSpyNavigatorObserver._internal() {
    print('DSpyNavigatorObserver instance');
  }

  @override
  void didPush(Route route, Route previousRoute) {
    super.didPush(route, previousRoute);
    print('spy didPush ${route.settings.name}, previousRoute ${previousRoute?.settings?.name}');
    // SpyScreenshot.readImage64(route.settings.name);

    // Future.delayed(Duration(milliseconds: 1000), () {
    //   DStackSpy.instance.channel
    //       .sendScreenShotActionToNative({'target': route.settings.name});
    // });
  }

  @override
  void didReplace({Route newRoute, Route oldRoute}) {
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
    print('spy didReplace ${newRoute.settings.name} oldRoute ${oldRoute?.settings?.name}');
    // SpyScreenshot.readImage64(newRoute.settings.name);

    // Future.delayed(Duration(milliseconds: 1000), () {
    //   DStackSpy.instance.channel
    //       .sendScreenShotActionToNative({'target': newRoute.settings.name});
    // });
  }

  @override
  void didPop(Route route, Route previousRoute) {
    print('spy didPop ${route.settings.name}');
    super.didPop(route, previousRoute);
  }
}
