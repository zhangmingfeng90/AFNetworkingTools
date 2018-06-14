//
//  AFNetworkTool.m
//  NetworkingRequestDemo
//
//  Created by 张明峰 on 2018/6/14.
//  Copyright © 2018年 张明峰. All rights reserved.
//

#import "AFNetworkTool.h"
#import "ShakeLogManager.h"
#import <AFHTTPRequestOperationManager+Synchronous.h>
#import "SFAppContext.h"
#import "NSObject+MJKeyValue.h"
#import "SFUserDataStore.h"
#import "SFUserDataStore.h"
@implementation AFNetworkTool

#pragma mark 检测网路状态
+ (void)netWorkStatus
{
    
    /**
     AFNetworkReachabilityStatusUnknown          = -1,  // 未知
     AFNetworkReachabilityStatusNotReachable     = 0,   // 无连接
     AFNetworkReachabilityStatusReachableViaWWAN = 1,   // 3G 花钱
     AFNetworkReachabilityStatusReachableViaWiFi = 2,   // WiFi
     */
    // 如果要检测网络状态的变化,必须用检测管理器的单例的startMonitoring
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    
    // 检测网络连接的单例,网络变化时的回调方法
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        NSLog(@"%ld", (long)status);
    }];
}

#pragma mark - JSON方式获取数据
+ (void)JSONDataWithUrl:(NSString *)url success:(void (^)(id json))success fail:(void (^)())fail;
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSDictionary *dict = @{@"format": @"json"};
    // 网络访问是异步的,回调是主线程的,因此程序员不用管在主线程更新UI的事情
    [manager GET:url parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@", error);
        if (fail) {
            fail();
        }
    }];
}

#pragma mark - xml方式获取数据
+ (void)XMLDataWithUrl:(NSString *)urlStr success:(void (^)(id xml))success fail:(void (^)())fail
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    //    // 返回的数据格式是XML
    manager.responseSerializer = [AFXMLParserResponseSerializer serializer];
    
    NSDictionary *dict = @{@"format": @"xml"};
    
    // 网络访问是异步的,回调是主线程的,因此程序员不用管在主线程更新UI的事情
    [manager GET:urlStr parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        
        
        if (success) {
            success(responseObject);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@", error);
        if (fail) {
            fail();
        }
    }];
}

#pragma mark - JSON方式post提交数据
+ (void)postJSONWithUrl:(NSString *)urlStr parameters:(id)parameters success:(void (^)(id responseObject))success fail:(void (^)())fail
{
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    // 设置请求格式
    manager.requestSerializer.timeoutInterval = 10.f;
    //设置头部信息
    [manager.requestSerializer setValue:[SFUserDataStore getUserInfo].token forHTTPHeaderField:@"token"];
    [manager.requestSerializer setValue:@"application/x-www-form-urlencoded; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    
    // 设置返回格式
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [manager POST:urlStr parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *resultDic = [NSDictionary dictionary];
        NSString *jsonStr = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        resultDic = [jsonStr mj_JSONObject];
        NSLog(@"%@?%@:%@", urlStr, parameters, resultDic);
        [[ShakeLogManager sharedInstance] addLogMessage:[NSString stringWithFormat:@"%@?%@:%@", urlStr, parameters, resultDic]];
        
        if (success) {
            NSDictionary * responseDict = (NSDictionary *)resultDic;
            if([responseDict[@"code"] isKindOfClass:[NSString class]]&& [responseDict[@"code"] isEqualToString:@"-999"]){
                [SFUserDataStore saveUserInfo:nil];
                AppDelegate * appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
                [appDelegate showLoginView:nil];
            }else{
                success(resultDic);
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [NSObject showHudTipError:error];
        NSHTTPURLResponse *urlResponse = (NSHTTPURLResponse *)operation.response;
        if (urlResponse.statusCode == 502) {//token失效，重新登录
            [[NSNotificationCenter defaultCenter] postNotificationName:REQUEST_LOGOUT_ACCOUNT_RESPONSE object:nil];
        }
        NSLog(@"%@:%@",urlStr,error);
        [[ShakeLogManager sharedInstance] addLogMessage:[NSString stringWithFormat:@"%@:%@",urlStr,error]];
        if (fail) {
            fail(error);
        }
    }];
    
}

//JSON方式get提交数据
+(void)get:(NSString *)url parameters:(NSDictionary *)parameters success:(void (^)(id json))success failure:(void (^)(NSError *error))failure {
    
    //显示状态栏的网络指示器
    //    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    // 设置请求格式
    //       manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.requestSerializer.timeoutInterval = NETWORK_REQUEST_TIMEOUT_TIME;
    
    //设置头部信息
    [manager.requestSerializer setValue:[SFUserDataStore getUserInfo].token forHTTPHeaderField:@"token"];
    [manager.requestSerializer setValue:@"application/x-www-form-urlencoded; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    
    // 设置返回格式
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [manager GET:url parameters:parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        NSDictionary *resultDic = [NSDictionary dictionary];
        NSString *jsonStr = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        resultDic = [jsonStr mj_JSONObject];
        DDLogVerbose(@"%@?%@:%@", url, parameters, resultDic);
        success(resultDic);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [NSObject showHudTipError:error];
        NSHTTPURLResponse *urlResponse = (NSHTTPURLResponse *)task.response;
        if (urlResponse.statusCode == 502) {//token失效，重新登录
            [[NSNotificationCenter defaultCenter] postNotificationName:REQUEST_LOGOUT_ACCOUNT_RESPONSE object:nil];
        }
        DDLogError(@"%@:错误信息：%@", url, error);
        failure(error);
    }];
    
    
}


//同步
+ (void)postJSONWithSyncUrl:(NSString *)URLString
                     params:(NSDictionary *)params
                    success:(void (^)(id result))success
                     failue:(void (^)(NSError *error))failure
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer.timeoutInterval = NETWORK_REQUEST_TIMEOUT_TIME;
    
    //设置头部信息
    [manager.requestSerializer setValue:[SFUserDataStore getUserInfo].token forHTTPHeaderField:@"token"];
    
    //设置返回格式
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    NSError *error = nil;
    NSData *result = [manager syncGET:URLString
                           parameters:params
                            operation:NULL
                                error:&error];
    
    NSDictionary *resultDic = [NSDictionary dictionary];
    NSString *jsonStr = [[NSString alloc] initWithData:result encoding:NSUTF8StringEncoding];
    resultDic = [jsonStr mj_JSONObject];
    DDLogVerbose(@"%@?%@:%@", URLString, params, jsonStr);
    success(resultDic);
}


#pragma mark - Session 下载下载文件
+ (void)sessionDownloadWithUrl:(NSString *)urlStr success:(void (^)(NSURL *fileURL))success fail:(void (^)())fail
{
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:config];
    
    NSString *urlString = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    NSURLSessionDownloadTask *task = [manager downloadTaskWithRequest:request progress:nil destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
        // 指定下载文件保存的路径
        //        NSLog(@"%@ %@", targetPath, response.suggestedFilename);
        // 将下载文件保存在缓存路径中
        NSString *cacheDir = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0];
        NSString *path = [cacheDir stringByAppendingPathComponent:response.suggestedFilename];
        
        // URLWithString返回的是网络的URL,如果使用本地URL,需要注意
        //        NSURL *fileURL1 = [NSURL URLWithString:path];
        NSURL *fileURL = [NSURL fileURLWithPath:path];
        
        //        NSLog(@"== %@ |||| %@", fileURL1, fileURL);
        if (success) {
            success(fileURL);
        }
        
        return fileURL;
    } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
        NSLog(@"%@ %@", filePath, error);
        if (fail) {
            fail();
        }
    }];
    
    [task resume];
}


#pragma mark - 文件上传 自己定义文件名
+ (void)postUploadWithUrl:(NSString *)urlStr fileUrl:(NSURL *)fileURL fileName:(NSString *)fileName fileType:(NSString *)fileTye success:(void (^)(id responseObject))success fail:(void (^)())fail
{
    // 本地上传给服务器时,没有确定的URL,不好用MD5的方式处理
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    //设置头部信息
    [manager.requestSerializer setValue:[SFUserDataStore getUserInfo].token forHTTPHeaderField:@"token"];
    
    [manager POST:urlStr parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
        
        //@"image/png"
        [formData appendPartWithFileURL:fileURL name:@"uploadFile" fileName:fileName mimeType:fileTye error:NULL];
        
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (fail) {
            fail();
        }
    }];
}

#pragma mark - POST上传文件
// 上传二维码图片（支付宝，微信）
+ (void)postUploadCodeImgWithUrl:(NSString *)urlStr parameters:(id)parameters fileName:(NSString *)name fileData:(NSData *)data success:(void (^)(id responseObject))success fail:(void (^)())fail {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager.requestSerializer setValue:[SFUserDataStore getUserInfo].token forHTTPHeaderField:@"token"];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager POST:urlStr parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        // 将本地的文件上传至服务器
        NSLog(@"-----parameters:%@-----", parameters);
        [formData appendPartWithFileData:data name:parameters[@"type"] fileName:[NSString stringWithFormat:@"%@%@",parameters[@"payimg"],@".jpeg"] mimeType:@"image/jpeg"];
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"错误 %@", error.localizedDescription);
        if (fail) {
            fail();
        }
    }];
}

// 上传图片
+ (void)postUploadWithUrl:(NSString *)urlStr parameters:(id)parameters fileName:(NSString *)name fileData:(NSData *)data success:(void (^)(id responseObject))success fail:(void (^)())fail {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager.requestSerializer setValue:[SFUserDataStore getUserInfo].token forHTTPHeaderField:@"token"];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager POST:urlStr parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        // 将本地的文件上传至服务器
        [formData appendPartWithFileData:data name:parameters[@"name"] fileName:[NSString stringWithFormat:@"%@%@",parameters[@"fileName"],@".jpeg"] mimeType:@"image/jpeg"];
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"错误 %@", error.localizedDescription);
        if (fail) {
            fail();
        }
    }];
}

@end

