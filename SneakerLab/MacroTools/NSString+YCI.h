//
//  NSString+YCI.h
//  SneakerLab
//
//  Created by 郭隆基 on 16/11/4.
//  Copyright © 2016年 Jason cao. All rights reserved.
//

#import <Foundation/Foundation.h>

#define YCIJoinStrings(firstStr,...) [NSString JoinedWithSubStrings:firstStr,__VA_ARGS__,nil]
@interface NSString (YCI)
@property (nonatomic, strong) NSString *noNull;
+ (NSString *)JoinedWithSubStrings:(NSString *)firstStr,...NS_REQUIRES_NIL_TERMINATION;

+ (NSString *)phpStr:(NSString *)str;
- (void)setNoNull:(NSString *)noNull;
- (NSString *)noNull;
+ (NSString *)mapToJson:(id)map;
@end
