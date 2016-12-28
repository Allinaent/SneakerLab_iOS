//
//  CWAPIClient.m
//  caowei
//
//  Created by Jason cao on 2016/9/18.
//  Copyright © 2016年 Jason cao. All rights reserved.
//

#import "CWAPIClient.h"

@implementation CWAPIClient

+ (instancetype)sharedClient {
    static CWAPIClient *client = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        client = [[CWAPIClient alloc] init];
    });
    return client;
}

- (void)POSTRequest:(NSString *)URLString
         parameters:(id)parameters
           progress:(void (^)(NSProgress *uploadProgress))uploadProgress
            success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
            failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure
{
    self.requestSerializer = [AFHTTPRequestSerializer serializer];
    self.requestSerializer.timeoutInterval = 60.f;
    self.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/json",@"text/html",@"application/json",@"text/plain",nil];
    [self POST:URLString parameters:parameters progress:uploadProgress success:success failure:failure];
}

- (NSDictionary *)getNewParameters:(id)paramaters
{
    NSMutableDictionary *newParameters = [[NSMutableDictionary alloc] initWithDictionary:paramaters];
    NSString *timeinterval = [self getCurrentTimestamp];
    newParameters[@"timestamp"] = timeinterval;
    newParameters[@"apiKey"] = APIKEY;
    newParameters[@"equipment_id"] = MYDEVICEID;
    return newParameters;
}

-(NSString*)getCurrentTimestamp
{
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval a=[dat timeIntervalSince1970];
    NSString*timeString = [NSString stringWithFormat:@"%0.f", a];
    return timeString;
}

@end
