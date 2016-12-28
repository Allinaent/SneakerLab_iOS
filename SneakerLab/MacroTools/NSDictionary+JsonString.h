//
//  NSDictionary+JsonString.h
//  SneakerLab
//
//  Created by 郭隆基 on 2016/12/12.
//  Copyright © 2016年 Jason cao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (JsonString)
+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString;
@end
