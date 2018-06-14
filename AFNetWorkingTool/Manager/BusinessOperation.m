//
//  BusinessOperation.m
//  NetworkingRequestDemo
//
//  Created by 张明峰 on 2018/6/14.
//  Copyright © 2018年 张明峰. All rights reserved.
//

#import "BusinessOperation.h"
#import "BaseAccessor.h"

@implementation BusinessOperation
@synthesize target=_target, object=_object, selector=_selector;

- (void)dealloc
{
    _target=nil;
    _object=nil;
}

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"

- (void)main
{
    [[BaseAccessor sharedBaseAccessor] mergeChangesManagerObjectsOnCurrentThread];
    
    [self.target performSelector:self.selector withObject:self.object];
}

@end
