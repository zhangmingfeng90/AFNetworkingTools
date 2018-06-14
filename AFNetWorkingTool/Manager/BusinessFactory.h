//
//  BusinessFactory.h
//  NetworkRequestDemo
//
//  Created by 张明峰 on 2018/6/13.
//  Copyright © 2018年 张明峰. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Business.h"

@interface BusinessFactory : NSObject

//创建系统账号业务管理类
- (SystemAccountManager *)createSystemAccountManager;

@end
