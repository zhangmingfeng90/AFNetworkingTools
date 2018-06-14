//
//  AbstractManager.h
//  NetworkRequestDemo
//
//  Created by 张明峰 on 2018/6/13.
//  Copyright © 2018年 张明峰. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CustomOperationQueue.h"
#import "CustomNotificationQueue.h"

@interface AbstractManager : NSObject{
    __unsafe_unretained CustomOperationQueue *_operationQueue;
    CustomNotificationQueue * notifyQueue;//通知队列，用在过滤多个消息名相同或者sender相同的消息为1个
}
@property (assign,readonly) CustomOperationQueue *operationQueue;


//在主线程中抛出通知
- (void)postNotificationOnMainThreadName:(NSString *)notificationName object:(id)notificationSender userInfo:(NSDictionary *)userInfo;


//此函数将把消息加到消息队列，并执行相同消息名、相同Sender过滤
//即多个相同消息名、多个相同sender的的消息将变为一个
//此函数一般用在manager抛出消息给界面，让界面列表刷新
//注意：如果消息带有参数，这个函数将不合并消息，等主线程空闲时抛出消息
//     此消息队列的消息是在主线程中抛出的，需要调用者自己考虑抛出的通知是否会阻塞界面
- (void)postNotificationName:(NSString *)notificationName object:(id)notificationSender userInfo:(NSDictionary *)userInfo;

@end
