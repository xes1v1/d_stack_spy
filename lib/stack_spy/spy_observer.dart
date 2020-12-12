/*
 * Created with Android Studio.
 * User: whqfor
 * Date: 12/3/20
 * Time: 4:53 PM
 * target: 监听NavigatorObserver
 */

import 'package:d_stack/observer/d_node_observer.dart';
import 'package:d_stack_spy/stack_spy/spy.dart';
import 'dart:convert' as convert;

// spy节点监听
class DSpyNodeObserver extends DNodeObserver {


  // 支持对单个页面特殊设置延迟时间
  // 使用方式 DSpyNodeObserver().milliseconds(2000);
  // 特殊设置后，需要自行恢复，仍调用此方法
  void milliseconds(int milliseconds) {
    DStackSpy.instance.milliseconds = milliseconds;
  }

  void ipAndPort(String ipAndPort) {
    DStackSpy.instance.ipAndPort = ipAndPort;
  }

  static final DSpyNodeObserver _singleton = DSpyNodeObserver._internal();
  factory DSpyNodeObserver() => _singleton;
  static DSpyNodeObserver get instance => _singleton;

  DSpyNodeObserver._internal() {
    print('milliseconds= $milliseconds');
    // 初始化DStackSpy
    DStackSpy();
    // 将根节点主动加到队列中
    // 因为native发送根节点可能在engine启动之前，这时候DNodeObserver队列收不到消息
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
    addStackNode(node);
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
      Future.delayed(Duration(milliseconds: DStackSpy.instance.milliseconds), () {
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

    if (node['target'] == '/') {
      // 上面已经手动添加，native再发送则不处理
      return;
    }
    this.addStackNode(node);
  }
}