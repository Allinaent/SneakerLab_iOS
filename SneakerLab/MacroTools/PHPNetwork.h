//
//  PHPNetwork.h
//  SneakerLab
//
//  Created by 郭隆基 on 16/11/4.
//  Copyright © 2016年 Jason cao. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^RequestFinish)(NSURLSessionDataTask *task, id responseObject);
typedef void(^RequestError)(NSURLSessionDataTask *task, NSError *error);
typedef void(^Progress)(NSProgress *progress);
@interface PHPNetwork : NSObject

+ (void)PHPNetworkWithParam:(NSDictionary *)params andUrl:(NSString *)interfaceUrl andSignature:(BOOL)has andLogin:(BOOL)has finish:(RequestFinish)finish err:(RequestError)need;

+ (void)uploadImageWithImageData:(NSData *)imageData andUrl:(NSString *)interfaceUrl progress:(Progress)progress finish:(RequestFinish)finish err:(RequestError)need;
+ (void)PHPNetworkWithUrl:(NSString *)url finish:(RequestFinish)finish err:(RequestError)need;

@end
