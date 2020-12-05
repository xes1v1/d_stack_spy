#import <Flutter/Flutter.h>

@interface DStackSpyPlugin : NSObject<FlutterPlugin>

+ (DStackSpyPlugin *)sharedInstance;
- (void)sentNodeToFlutter:(NSString *)node;

@end
