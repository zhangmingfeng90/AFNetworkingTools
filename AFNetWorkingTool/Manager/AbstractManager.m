//
//  AbstractManager.m
//  NetworkRequestDemo
//
//  Created by 张明峰 on 2018/6/13.
//  Copyright © 2018年 张明峰. All rights reserved.
//

#import "AbstractManager.h"

@implementation AbstractManager
@synthesize operationQueue=_operationQueue;


- (id)init
{
    if (self = [super init])
    {
        _operationQueue = [CustomOperationQueue sharedCustomOperationQueue];
        notifyQueue = [CustomNotificationQueue sharedCustomNotificationQueue];
        
    }
    return self;
}

- (void)notifyUIDoSomething:(NSNotification *)notification
{
    [self postNotificationName:notification.name object:notification.object userInfo:notification.userInfo];
}

//在主线程中抛出通知
- (void)postNotificationOnMainThreadName:(NSString *)notificationName object:(id)notificationSender userInfo:(NSDictionary *)userInfo
{
    NSNotification *notification = [NSNotification notificationWithName:notificationName
                                                                 object:notificationSender
                                                               userInfo:userInfo];
    
    [self performSelectorOnMainThread:@selector(notifyUIDoSomething:) withObject:notification waitUntilDone:NO];
}

//此函数将把消息加到消息队列，并执行相同消息名、相同Sender过滤
//即多个相同消息名、多个相同sender的的消息将变为一个
//此函数一般用在manager抛出消息给界面，让界面列表刷新
//注意：如果消息带有参数，这个函数将不合并消息，等主线程空闲时抛出消息
//     此消息队列的消息是在主线程中抛出的，需要调用者自己考虑抛出的通知是否会阻塞界面
- (void)postNotificationName:(NSString *)notificationName object:(id)notificationSender userInfo:(NSDictionary *)userInfo
{
    
    if([NSThread currentThread] == [NSThread mainThread])
    {//在主线程中抛出的通知，进行过滤处理
        NSNotification *notify = [NSNotification notificationWithName:notificationName
                                                               object:notificationSender
                                                             userInfo:userInfo];
        
        if([userInfo count] <= 0)
        {//没参数，进行合并消息
            [notifyQueue enqueueNotification:notify postingStyle:NSPostWhenIdle];
        }
        else
        {//有参数，不合并，但在主线程空闲时抛出通知
            [notifyQueue enqueueNotification:notify postingStyle:NSPostWhenIdle coalesceMask:NSNotificationNoCoalescing forModes:nil];
        }
    }
    else
    {//在线程中，不过滤了，直接抛出
        [[NSNotificationCenter defaultCenter] postNotificationName:notificationName
                                                            object:notificationSender
                                                          userInfo:userInfo];
    }
    
}
@end
