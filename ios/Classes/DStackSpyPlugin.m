#import "DStackSpyPlugin.h"

typedef NSString *DStackSpyMethodChannelName;
DStackSpyMethodChannelName const DStackSpyPlatformVersion = @"getPlatformVersion";
DStackSpyMethodChannelName const DStackSpySendNodeToFlutter = @"spySentNodeToFlutter";

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
  } else {
    result(FlutterMethodNotImplemented);
  }
}

- (void)sentNodeToFlutter:(NSString *)node
{
    NSLog(@"sentNodeToFlutter node %@", node);
    [self invokeMethod:DStackSpySendNodeToFlutter arguments:node result:nil];
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
