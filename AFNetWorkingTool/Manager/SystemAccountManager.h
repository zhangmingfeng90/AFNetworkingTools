//
//  SystemAccountManager.h
//  NetworkRequestDemo
//
//  Created by 张明峰 on 2018/6/13.
//  Copyright © 2018年 张明峰. All rights reserved.
//

#import "AbstractManager.h"

@interface SystemAccountManager : AbstractManager
#pragma mark -网络请求（AFNetworking）
/**
 // 发送验证码
 api_name    是    string    sendCode    无
 mobile    是    int    无    手机号码）
 */
- (void)sendCodeRequest:(NSDictionary *)dictionary success:(void (^)(NSDictionary *dict))block
                failure:(void (^)(NSError *error))failure;


@end
