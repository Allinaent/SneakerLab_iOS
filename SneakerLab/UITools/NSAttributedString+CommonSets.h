//
//  NSAttributedString+CommonSets.h
//  SneakerLab
//
//  Created by 郭隆基 on 2016/12/16.
//  Copyright © 2016年 Jason cao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSAttributedString (CommonSets)

/**
 create a string with a strike line

 @param string      string text
 @param font        string font
 @param color       string color
 @return            attributedstring
 */
+ (NSAttributedString *)ls_attributedStringWithString:(NSString *)string andFont:(UIFont *)font andColor:(UIColor *)color;
@end
