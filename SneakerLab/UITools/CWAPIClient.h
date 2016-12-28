//
//  CWAPIClient.h
//  caowei
//
//  Created by Jason cao on 2016/9/18.
//  Copyright © 2016年 Jason cao. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>

@interface CWAPIClient : AFHTTPSessionManager
+ (instancetype)sharedClient;

- (void)POSTRequest:(NSString *)URLString
                    parameters:(id)parameters
                    progress:(void (^)(NSProgress *uploadProgress))uploadProgress
                    success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                    failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure;

@end
