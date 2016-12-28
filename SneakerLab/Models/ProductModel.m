//
//  ProductModel.m
//  caowei
//
//  Created by Jason cao on 2016/9/22.
//  Copyright © 2016年 Jason cao. All rights reserved.
//

#import "ProductModel.h"
#import "GTMNSString+HTML.h"

@implementation ProductModel

//防崩溃大法
-(void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    
}

//图片显示问题，bug修复，郭隆基
- (void)setValuesForKeysWithDictionary:(NSDictionary<NSString *,id> *)keyedValues {
    [super setValuesForKeysWithDictionary:keyedValues];
    NSString *imgStr = [keyedValues objectForKey:@"image"];
    self.image = [imgStr gtm_stringByUnescapingFromHTML];
    NSLog(@"%@", self.image);
}


@end
