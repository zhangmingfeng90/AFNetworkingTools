//
//  BusinessFactory.m
//  NetworkRequestDemo
//
//  Created by 张明峰 on 2018/6/13.
//  Copyright © 2018年 张明峰. All rights reserved.
//

#import "BusinessFactory.h"

@implementation BusinessFactory

//创建系统账号业务管理类
- (SystemAccountManager *)createSystemAccountManager {
    return [[SystemAccountManager alloc] init];
}

@end
