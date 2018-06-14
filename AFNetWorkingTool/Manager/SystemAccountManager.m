//
//  SystemAccountManager.m
//  NetworkRequestDemo
//
//  Created by 张明峰 on 2018/6/13.
//  Copyright © 2018年 张明峰. All rights reserved.
//

#import "SystemAccountManager.h"

@implementation SystemAccountManager
#pragma mark -网络请求（AFNetworking）

// 发送验证码
- (void)sendCodeRequest:(NSDictionary *)dictionary success:(void (^)(NSDictionary *dict))block
                failure:(void (^)(NSError *error))failure{
    NSString *url = [NSString stringWithFormat:@"%@%@", kServerRootURL, kForgetPassword];
    //    NSString *url = [NSString stringWithFormat:@"%@%@", kServerRootURL, kSendCode];
    [AFNetworkTool postJSONWithUrl:url parameters:dictionary success:^(id responseObject) {
        block(responseObject);
    } fail:^(NSError *error) {
        failure(error);
    }];
}
@end
