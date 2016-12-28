//
//  NSAttributedString+CommonSets.m
//  SneakerLab
//
//  Created by 郭隆基 on 2016/12/16.
//  Copyright © 2016年 Jason cao. All rights reserved.
//

#import "NSAttributedString+CommonSets.h"

@implementation NSAttributedString (CommonSets)
+ (NSAttributedString *)ls_attributedStringWithString:(NSString *)string andFont:(UIFont *)font andColor:(UIColor *)color {
    NSAttributedString *attrStr =
    [[NSAttributedString alloc]initWithString:string
                                   attributes:
     @{NSFontAttributeName:font,
       NSForegroundColorAttributeName:color,
       NSStrikethroughStyleAttributeName:@(NSUnderlineStyleSingle|NSUnderlinePatternSolid),
       NSStrikethroughColorAttributeName:color}];
    return attrStr;
}
@end
