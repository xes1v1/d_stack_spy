/*
 * Created with Android Studio.
 * User: whqfor
 * Date: 12/3/20
 * Time: 4:53 PM
 * target: 监听NavigatorObserver
 */


import 'package:d_stack_spy/d_spy_screenshot.dart';
import 'package:flutter/material.dart';

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
    SpyScreenshot.readImage64(route.settings.name);
  }


  @override
  void didReplace({Route newRoute, Route oldRoute}) {
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
    print('spy🍎 didReplace ${newRoute.settings.name}');
    SpyScreenshot.readImage64(newRoute.settings.name);
  }


  @override
  void didPop(Route route, Route previousRoute) {
    print('spy🍎 didPop ${route.settings.name}');

    super.didPop(route, previousRoute);
  }
}