//
//  CustomOperationQueue.m
//  NetworkRequestDemo
//
//  Created by 张明峰 on 2018/6/13.
//  Copyright © 2018年 张明峰. All rights reserved.
//

#import "CustomOperationQueue.h"

@implementation CustomOperationQueue

//此方法暂时为私用
- (void)setCustomMaxConcurrentOperationCount:(NSInteger)cnt
{
    [super setMaxConcurrentOperationCount:cnt];
}

+ (CustomOperationQueue *) sharedCustomOperationQueue
{
    static CustomOperationQueue *coq = nil;
    if (coq){return coq;}
    
    coq = [[CustomOperationQueue alloc] init];
    [coq setCustomMaxConcurrentOperationCount:THREAD_CONCURRENT_OPERATION_COUNT];
    
    return coq;
}


//屏蔽业务逻辑层自己设置最大运行个数
- (void)setMaxConcurrentOperationCount:(NSInteger)cnt
{}

@end
