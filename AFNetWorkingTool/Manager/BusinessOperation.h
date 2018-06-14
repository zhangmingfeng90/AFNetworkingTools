//
//  BusinessOperation.h
//  NetworkingRequestDemo
//
//  Created by 张明峰 on 2018/6/14.
//  Copyright © 2018年 张明峰. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BusinessOperation : NSOperation{
    id _target;
    SEL _selector;
    id _object;
}
@property (nonatomic, retain) id  target;
@property (nonatomic, retain) id  object;
@property (nonatomic, assign) SEL selector;

@end
