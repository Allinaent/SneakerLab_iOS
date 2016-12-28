//
//  PHPNetwork.m
//  SneakerLab
//
//  Created by 郭隆基 on 16/11/4.
//  Copyright © 2016年 Jason cao. All rights reserved.
//

#import "PHPNetwork.h"
#import "AppDelegate.h"
#import "SignInController.h"
#import "MenuController.h"

@implementation PHPNetwork

+ (void)PHPNetworkWithParam:(NSDictionary *)params andUrl:(NSString *)interfaceUrl andSignature:(BOOL)has andLogin:(BOOL)need finish:(RequestFinish)finish err:(RequestError)err
{
    NSString *time = [self getCurrentTimestamp];
    NSMutableArray *arr;
    if (need) {
        arr = [NSMutableArray arrayWithObjects:@"appKey",@"apiKey",@"timestamp",@"equipment_id",@"email", @"token", nil];
    }else{
        arr = [NSMutableArray arrayWithObjects:@"appKey",@"apiKey",@"timestamp",@"equipment_id", nil];
    }
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    if (params!=nil) {
        NSArray *addItems = [params allKeys];
        for (id item in addItems) {
            [arr addObject:item];
            if (params!=nil) {
                [dic setObject:[params objectForKey:item] forKey:item];
            }
        }
    }
    [dic setObject:APPKEY forKey:@"appKey"];
    [dic setObject:APIKEY forKey:@"apiKey"];
    [dic setObject:MYDEVICEID forKey:@"equipment_id"];
    [dic setObject:time forKey:@"timestamp"];
    if (CWEMAIL!=nil) {
        [dic setObject:CWEMAIL forKey:@"email"];
        [dic setObject:CWTOKEN forKey:@"token"];
    }
    NSArray *sortedArray = [arr sortedArrayUsingSelector:@selector(compare:)];
    NSMutableString *str = [[NSMutableString alloc] init];
    for ( int i = 0; i < sortedArray.count; i++)
    {
        [str appendString:sortedArray[i]];
        [str appendString:[dic objectForKey:sortedArray[i]]];
    }
    NSMutableDictionary *parameters = [dic mutableCopy];
    if (has) {
        NSString *strMD5 = [str md5_32bit];
        NSString *signature = [strMD5 sha1];
        [parameters setObject:signature forKey:@"signature"];
    }
    [parameters removeObjectForKey:@"appKey"];
    [[CWAPIClient sharedClient] POSTRequest:interfaceUrl parameters:parameters progress:nil success:^(NSURLSessionDataTask *task, id responseObject)
     {
         if ([responseObject isKindOfClass:[NSDictionary class]]) {
             NSString *status_code = [responseObject valueForKey:@"status_code"];
             NSLog(@"%@", responseObject);
             NSLog(@"%@", [responseObject valueForKey:@"message"]);
             if ([status_code integerValue]!=0&&[status_code integerValue]!=1004) {
//                 SignInController *vc = [[SignInController alloc] init];
//                 AppDelegate *tempAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
//                 [tempAppDelegate.mainNavigationController pushViewController:vc animated:YES];
                 AppDelegate *tempAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
                 MenuController *menu = tempAppDelegate.LeftSlideVC.leftVC;
                 [menu logoutAction];
                 return;
             }
         }
         finish(task, responseObject);
     } failure:^(NSURLSessionDataTask *task, NSError *error)
     {
         err(task, error);
     }];
}

+ (void)uploadImageWithImageData:(NSData *)imageData andUrl:(NSString *)interfaceUrl progress:(Progress)progress finish:(RequestFinish)finish err:(RequestError)need {
    NSString *time = [self getCurrentTimestamp];
    NSMutableArray *arr = [NSMutableArray arrayWithObjects:@"appKey",@"apiKey",@"timestamp",@"equipment_id",@"email", @"token", nil];
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:APPKEY forKey:@"appKey"];
    [dic setObject:APIKEY forKey:@"apiKey"];
    [dic setObject:MYDEVICEID forKey:@"equipment_id"];
    [dic setObject:time forKey:@"timestamp"];
    if (CWEMAIL!=nil) {
        [dic setObject:CWEMAIL forKey:@"email"];
        [dic setObject:CWTOKEN forKey:@"token"];
    }
    NSArray *sortedArray = [arr sortedArrayUsingSelector:@selector(compare:)];
    NSMutableString *str = [[NSMutableString alloc] init];
    for ( int i = 0; i < sortedArray.count; i++)
    {
        [str appendString:sortedArray[i]];
        [str appendString:[dic objectForKey:sortedArray[i]]];
    }
    NSMutableDictionary *parameters = [dic mutableCopy];
    NSString *strMD5 = [str md5_32bit];
    NSString *signature = [strMD5 sha1];
    [parameters setObject:signature forKey:@"signature"];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //formData: 专门用于拼接需要上传的数据,在此位置生成一个要上传的数据体
    [manager POST:interfaceUrl parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        // 在网络开发中，上传文件时，是文件不允许被覆盖，文件重名
        // 要解决此问题
        // 可以在上传时使用当前的系统事件作为文件名
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        // 设置时间格式
        formatter.dateFormat = @"yyyyMMddHHmmss";
        NSString *str = [formatter stringFromDate:[NSDate date]];
        NSString *fileName = [NSString stringWithFormat:@"%@.png", str];
        //上传
        /*
         此方法参数
         1. 要上传的[二进制数据]
         2. 对应网站上[upload.php中]处理文件的[字段"file"]
         3. 要保存在服务器上的[文件名]
         4. 上传文件的[mimeType]
         */
        [formData appendPartWithFileData:imageData name:@"file" fileName:fileName mimeType:@"image/png"];
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        progress(uploadProgress);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        finish(task, responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        finish(task, error);
    }];
}

+ (NSString*)getCurrentTimestamp
{
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval a=[dat timeIntervalSince1970];
    NSString*timeString = [NSString stringWithFormat:@"%0.f", a];
    return timeString;
}

+ (void)PHPNetworkWithUrl:(NSString *)url finish:(RequestFinish)finish err:(RequestError)need {
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"signInSuccessful"] boolValue]==YES) {
        NSString *time = [self getCurrentTimestamp];
        NSArray *arr = @[@"appKey",@"apiKey",@"timestamp",@"equipment_id",@"email",@"token"];
        NSDictionary *dic = @{@"appKey" : APPKEY,
                              @"apiKey" : APIKEY,
                              @"equipment_id" : MYDEVICEID,
                              @"timestamp" : time,
                              @"email" : CWEMAIL,
                              @"token" : CWTOKEN
                              };
        NSArray *sortedArray = [arr sortedArrayUsingSelector:@selector(compare:)];
        NSMutableString *str = [[NSMutableString alloc] init];
        for ( int i = 0; i < sortedArray.count; i++)
        {
            [str appendString:sortedArray[i]];
            [str appendString:[dic objectForKey:sortedArray[i]]];
        }
        NSString *strMD5 = [str md5_32bit];
        NSString *signature = [strMD5 sha1];
        NSMutableDictionary *parameters = [dic mutableCopy];
        [parameters setObject:signature forKey:@"signature"];
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        manager.requestSerializer = [AFHTTPRequestSerializer serializer];
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/json",@"text/html",@"application/json",@"text/plain",nil];
        [manager POST:url parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            //NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
            NSString *str = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
            finish(task, str);
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            need(task,error);
        }];
    }
}

@end
