//
//  NSObject+Common.m
//  LendStore
//
//  Created by iOS_Dev5 on 15/12/4.
//  Copyright © 2015年 AS Inc. All rights reserved.
//

#define kPath_UserInfo @"UserInfo"

#import "NSObject+Common.h"
#import "MBProgressHUD.h"
@implementation NSObject (Common)
+ (void)showHudTipError:(NSError *)tipError {
    [NSObject showHudTipStr:[NSObject tipFromError:tipError]];
}
+ (void)showHudTipStr:(NSString *)tipStr{
    [NSObject showHudTipStr:tipStr afterDelay:1.0];
}
+ (void)showHudDebugMsg:(NSString *)msg {
    NSString *bundle = [[NSBundle mainBundle] bundleIdentifier];
    if ([bundle isEqualToString:@"com.warmhome.tenement.test"]) {
        [NSObject showHudTipStr:msg afterDelay:1.0];
    }
}
+ (void)showHudTipStr:(NSString *)tipStr afterDelay:(NSTimeInterval)delay {
    if (tipStr && tipStr.length > 0) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:KEY_WINDOW animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.detailsLabelFont = [UIFont boldSystemFontOfSize:15.0];
        hud.detailsLabelText = tipStr;
        hud.margin = 10.f;
        hud.removeFromSuperViewOnHide = YES;
        [hud hide:YES afterDelay:delay];
    }
}
#pragma mark - Activity Indicator
+ (void) startActivityIndicatorInView:(UIView *)aView withMessage:(NSString*)aMessage
{
    MBProgressHUD *_hud = [MBProgressHUD showHUDAddedTo:aView animated:YES];
    if (aMessage) {
        _hud.labelText =  aMessage;
    }	
}
+ (void) stopActivityIndicatorInView:(UIView*)aView
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [MBProgressHUD hideHUDForView:aView animated:YES];
    });
    
}
+ (void) startActivityIndicatorInView:(UIView *)aView withMessage:(NSString*)aMessage afterDelay:(NSTimeInterval)delay {
    MBProgressHUD *_hud = [MBProgressHUD showHUDAddedTo:aView animated:YES];
    if (aMessage) {
        _hud.labelText =  aMessage;
    }
    [_hud hide:YES afterDelay:delay];
}
+ (NSString *)tipFromError:(NSError *)error{
    if (error && error.userInfo) {
        NSString *tipStr = nil;
        if ([error.userInfo objectForKey:@"error"]) {
            tipStr = [error.userInfo objectForKey:@"error"];
        }else{
            if ([error.userInfo objectForKey:@"NSLocalizedDescription"]) {
                tipStr = [error.userInfo objectForKey:@"NSLocalizedDescription"];
            }else{
                tipStr = [NSString stringWithFormat:@"ErrorCode%@",[error.userInfo objectForKey:@"code"]];
            }
        }
        return tipStr;
    }
    return nil;
}
+ (NSInteger)errorCodeFromError:(NSError *)error {
   return [[error.userInfo objectForKey:@"code"] integerValue];
}

//+ (id) loadLocalUserWithPath:(NSString *)requestPath{//返回一个NSDictionary类型的json数据
//    AVUser *loginUser = [AVUser currentUser];
//    if (!loginUser) {
//        return nil;
//    }
//    NSString *abslutePath = [NSString stringWithFormat:@"%@/%@.plist", [self pathInCacheDirectory:kPath_UserInfo], loginUser.objectId];
//    return [NSMutableDictionary dictionaryWithContentsOfFile:abslutePath];
//}
//
#pragma mark File M
//获取fileName的完整地址
+ (NSString* )pathInCacheDirectory:(NSString *)fileName
{
    NSArray *cachePaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *cachePath = [cachePaths objectAtIndex:0];
    return [cachePath stringByAppendingPathComponent:fileName];
}

//创建缓存文件夹
+ (BOOL) createDirInCache:(NSString *)dirName
{
    NSString *dirPath = [self pathInCacheDirectory:dirName];
    BOOL isDir = NO;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL existed = [fileManager fileExistsAtPath:dirPath isDirectory:&isDir];
    BOOL isCreated = NO;
    if ( !(isDir == YES && existed == YES) )
    {
        isCreated = [fileManager createDirectoryAtPath:dirPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    if (existed) {
        isCreated = YES;
    }
    return isCreated;
}

+ (NSData *)loadImageDataWithLocal:(NSString *)path {
    BOOL dirExisted = [[NSFileManager defaultManager] fileExistsAtPath:path];
    if (!dirExisted) {
        return NULL;
    }else {
        NSData *imageData = [NSData dataWithContentsOfFile:path];
        return imageData;
    }
}


//客户端提示信息
+(void)alert:(NSString *)title msg:(NSString *)msg
{
    UIAlertView *alter = [[UIAlertView alloc] initWithTitle:title message:msg delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
    
    [alter show];
}

@end
