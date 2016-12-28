//
//  NSString+YCI.m
//  SneakerLab
//
//  Created by 郭隆基 on 16/11/4.
//  Copyright © 2016年 Jason cao. All rights reserved.
//

#import "NSString+YCI.h"
#import <objc/runtime.h>


@implementation NSString (YCI)

static void *strKey = &strKey;


+ (NSString *)JoinedWithSubStrings:(NSString *)firstStr,...NS_REQUIRES_NIL_TERMINATION
{
    NSMutableArray *array = [NSMutableArray new];
    va_list args;
    if(firstStr){
        [array addObject:firstStr];
        va_start(args, firstStr);
        id obj;
        while ((obj = va_arg(args, NSString* )))
        {
            [array addObject:obj];
        }
        va_end(args);
    }
    return [array componentsJoinedByString:@""];
}

+ (NSString *)phpStr:(NSString *)str {
    NSString *imgStr = [str gtm_stringByUnescapingFromHTML];
    NSString *encodedString = (NSString *)
    CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)imgStr, (CFStringRef)@"!$&'()*+,-./:;=?@_~%#[]", NULL, kCFStringEncodingUTF8));
    return encodedString;
}

- (void)setNoNull:(NSString *)noNull {
    objc_setAssociatedObject(self, &strKey, noNull, OBJC_ASSOCIATION_COPY);
}

- (NSString *)noNull {
    // 转换空串
    NSString *str = self;
    if ([self isEqual:[NSNull null]])
    {
        str = @"0";
    }
    else if ([self isKindOfClass:[NSNull class]])
    {
        str = @"0";
    }
    else if (self==nil){
        str = @"0";
    }
    
    return objc_getAssociatedObject(str, &strKey);
}

+ (NSString *)mapToJson:(id)map
{
    
    NSError *parseError = nil;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:map options:NSJSONWritingPrettyPrinted error:&parseError];
    
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}

@end
