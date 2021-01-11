//
//  DStackSpyPlugin+Capture.h
//  d_stack_spy
//
//  Created by whqfor on 2020/12/7.
//

#import "DStackSpyPlugin.h"

NS_ASSUME_NONNULL_BEGIN

@interface DStackSpyPlugin (Capture)

/**
 *  返回截取到的图片
 *
 *  @return UIImage *
 */
- (UIImage *)imageWithScreenshot;

/**
 *  返回截取到的图片的base64编码
 *
 *  @return NSString *
 */
- (NSString *)base64WithScreenshot;
 
/**
 *  截取当前屏幕
 *
 *  @return NSData *
 */
- (NSData *)dataWithScreenshotInPNGFormat;

@end

NS_ASSUME_NONNULL_END
