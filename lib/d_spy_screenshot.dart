/*
 * Created with Android Studio.
 * User: whqfor
 * Date: 12/3/20
 * Time: 4:21 PM
 * target: Flutter页面截图并转码为base64
 */

import 'package:d_stack_spy/d_stack_spy.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'dart:ui' as ui;
import 'dart:convert';

class SpyScreenshot {
  static void readImage64(String route) {

    // read(route);
    // Future.delayed(Duration(milliseconds: 300), () {
    //   read(route);
    // });
    _getRenderBox(_) async {
      print('boundaryKey ${DStackSpy.instance.boundaryKey}');
      BuildContext context = DStackSpy.instance.boundaryKey.currentContext;
      print('currentContext🍌 $context');
      RenderBox renderBox = context.findRenderObject();
      print('_getRenderBox🍌 $renderBox');
    }
    WidgetsBinding.instance.addPostFrameCallback(_getRenderBox);
  }

  static void read(String route) async {
    print('read0🍌');
    print('boundaryKey ${DStackSpy.instance.boundaryKey}');
    BuildContext context = DStackSpy.instance.boundaryKey.currentContext;
    print('currentContext $context');
    RenderRepaintBoundary boundary = context.findRenderObject();
    print('read1🍌 $boundary');
    if (route == '/') return Future.value();
    Future.delayed(Duration(milliseconds: 500), () async {
      ui.Image image = await boundary.toImage();
      print('read2🍌 $image');
      ByteData byteData =
          await image.toByteData(format: ui.ImageByteFormat.png);
      print('read3🍌');
      final uInt8List = byteData.buffer
          .asUint8List(byteData.offsetInBytes, byteData.lengthInBytes);
      String readImage64 = base64Encode(uInt8List);
      print('readImage64 success🍌🍌');
    });

    // return readImage64;
  }
}
