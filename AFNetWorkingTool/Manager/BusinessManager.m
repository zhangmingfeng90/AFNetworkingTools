//
//  BusinessManager.m
//  NetworkRequestDemo
//
//  Created by 张明峰 on 2018/6/13.
//  Copyright © 2018年 张明峰. All rights reserved.
//

#import "BusinessManager.h"

@implementation BusinessManager
@synthesize  systemAccountManager = m_SystemAccountManager;


+ (BusinessManager *)sharedManager {
    static BusinessManager *sharedManager = nil;
    if (sharedManager) {
        return sharedManager;
    }
    sharedManager = [[BusinessManager alloc] init];
    return sharedManager;
}

- (void)initBusiness {
    BusinessFactory * busFactory = [[BusinessFactory alloc] init];
    m_SystemAccountManager = [busFactory createSystemAccountManager];
    
}

- (void)destroyBusiness {
    m_SystemAccountManager          = nil;
    
}


- (id)init {
    if (self = [super init]) {
        [self initBusiness];
    }
    return self;
}

- (void)dealloc {
    [self destroyBusiness];
}
@end
