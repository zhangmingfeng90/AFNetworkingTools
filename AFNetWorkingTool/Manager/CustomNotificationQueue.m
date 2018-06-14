//
//  CustomNotificationQueue.m
//  NetworkRequestDemo
//
//  Created by 张明峰 on 2018/6/13.
//  Copyright © 2018年 张明峰. All rights reserved.
//

#import "CustomNotificationQueue.h"

@implementation CustomNotificationQueue

+ (CustomNotificationQueue *)sharedCustomNotificationQueue
{
    static CustomNotificationQueue  *sharedQueue = nil;
    if(sharedQueue) return sharedQueue;
    
    sharedQueue = [[CustomNotificationQueue alloc] initWithNotificationCenter:[NSNotificationCenter defaultCenter]];
    
    return sharedQueue;
    
}

@end
