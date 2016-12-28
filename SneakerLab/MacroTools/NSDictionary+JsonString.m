//
//  NSDictionary+JsonString.m
//  SneakerLab
//
//  Created by 郭隆基 on 2016/12/12.
//  Copyright © 2016年 Jason cao. All rights reserved.
//

#import "NSDictionary+JsonString.h"

@implementation NSDictionary (JsonString)
+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString {
    if (jsonString == nil) {
        return nil;
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err) {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}
@end
