#import "DStackSpyPlugin.h"
#import "DStackSpyPlugin+Capture.h"

typedef NSString *DStackSpyMethodChannelName;
DStackSpyMethodChannelName const DStackSpyPlatformVersion = @"getPlatformVersion";
DStackSpyMethodChannelName const  DStackSpySendScreenShotActionToNative = @"spySendScreenShotActionToNative";
DStackSpyMethodChannelName const  DStackSpyReceiveScreenShotFromNative = @"spyReceiveScreenShotFromNative";

@interface DStackSpyPlugin ()
@property (nonatomic, strong) FlutterMethodChannel *methodChannel;
@end

@implementation DStackSpyPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
    FlutterMethodChannel* channel = [FlutterMethodChannel
        methodChannelWithName:@"d_stack_spy"
              binaryMessenger:registrar.messenger];
    DStackSpyPlugin* instance = [DStackSpyPlugin sharedInstance];
    instance.methodChannel = channel;
    [registrar addMethodCallDelegate:instance channel:channel];
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
    if ([DStackSpyPlatformVersion isEqualToString:call.method]) {
      NSString *platform = [@"iOS " stringByAppendingString:[[UIDevice currentDevice] systemVersion]];
      result(platform);
  } if ([DStackSpySendScreenShotActionToNative isEqualToString:call.method]) {
      // 去截图
      
      NSDictionary *argu = call.arguments;
      NSString *base64 = [self base64WithScreenshot];
      if (!base64) {
          return;
      }
      NSDictionary *dict = @{@"target": argu[@"target"],
                             @"imageData": [@"data:image/png;base64," stringByAppendingString:base64]
                            };
      [self sendScreenshotToFlutter:dict];
  } else {
    result(FlutterMethodNotImplemented);
  }
}

- (void)sendScreenshotToFlutter:(NSDictionary *)screenshot
{
    NSLog(@"sendScreenshotToFlutter base64");
    [self invokeMethod:DStackSpyReceiveScreenShotFromNative arguments:screenshot result:nil];
}

- (void)invokeMethod:(NSString*)method
           arguments:(id _Nullable)arguments
              result:(FlutterResult _Nullable)callback
{
    DStackSpyPlugin *instance = [DStackSpyPlugin sharedInstance];
    [instance.methodChannel invokeMethod:method arguments:arguments result:callback];
}

+ (DStackSpyPlugin *)sharedInstance
{
    static id _instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [self.class new];
    });
    return _instance;
}

@end
