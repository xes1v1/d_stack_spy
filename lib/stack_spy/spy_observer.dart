/*
 * Created with Android Studio.
 * User: whqfor
 * Date: 12/3/20
 * Time: 4:53 PM
 * target: 监听NavigatorObserver
 */


import 'package:d_stack/observer/d_node_observer.dart';

import 'package:d_stack_spy/stack_spy/spy_screenshot.dart';
import 'package:d_stack_spy/stack_spy/spy.dart';
import 'package:flutter/material.dart';

// spy节点监听
class DSpyNodeObserver extends DNodeObserver {

  static final DSpyNodeObserver _singleton = DSpyNodeObserver._internal();
  static DSpyNodeObserver get instance => _singleton;
  factory DSpyNodeObserver() => _singleton;
  DSpyNodeObserver._internal() {
    DStackSpy();
  }

  // 待发送节点队列
  List get nodes => _nodes;
  List<Map> _nodes = [];

  // 监听到栈变化加到队列中
  void addNode(Map node) {
    print('addNode $node');
    _nodes.add(node);
  }

  // 获取队列中第一个
  String firstNodeString() {
    if (_nodes.isNotEmpty) {
      Map firstNode = _nodes.removeAt(0);
      return firstNode.toString();
    } else {
      return null;
    }
  }

  @override
  void operationNode(Map node) {
    print('DSpyNodeObserver operationNode');
    this.addNode(node);
  }
}


// 路由监听
class DSpyNavigatorObserver extends NavigatorObserver {

  static final DSpyNavigatorObserver _singleton = DSpyNavigatorObserver._internal();
  factory DSpyNavigatorObserver() => _singleton;
  static DSpyNavigatorObserver get instance => _singleton;

  DSpyNavigatorObserver._internal() {
    print('DSpyNavigatorObserver instance');
  }

  @override
  void didPush(Route route, Route previousRoute) {
    super.didPush(route, previousRoute);
    print('spy didPush ${route.settings.name}');
    // SpyScreenshot.readImage64(route.settings.name);
  }


  @override
  void didReplace({Route newRoute, Route oldRoute}) {
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
    print('spy didReplace ${newRoute.settings.name}');
    // SpyScreenshot.readImage64(newRoute.settings.name);
  }


  @override
  void didPop(Route route, Route previousRoute) {
    print('spy didPop ${route.settings.name}');
    super.didPop(route, previousRoute);
  }
}