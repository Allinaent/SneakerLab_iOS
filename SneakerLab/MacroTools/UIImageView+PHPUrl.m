//
//  UIImageView+PHPUrl.m
//  SneakerLab
//
//  Created by 郭隆基 on 2016/11/26.
//  Copyright © 2016年 Jason cao. All rights reserved.
//

#import "UIImageView+PHPUrl.h"

@implementation UIImageView (PHPUrl)

- (void)setPHPImageUrl:(NSString *)url {
    NSString *imgStr = [url gtm_stringByUnescapingFromHTML];
    NSString *encodedString = (NSString *)
    CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)imgStr, (CFStringRef)@"!$&'()*+,-./:;=?@_~%#[]", NULL, kCFStringEncodingUTF8));
    [self sd_setImageWithURL:[NSURL URLWithString:encodedString]];
}

- (void)setPHPImageUrl:(NSString *)url placeholder:(NSString *)placeholder {
    NSString *imgStr = [url gtm_stringByUnescapingFromHTML];
    NSString *encodedString = (NSString *)
    CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)imgStr, (CFStringRef)@"!$&'()*+,-./:;=?@_~%#[]", NULL, kCFStringEncodingUTF8));
    [self sd_setImageWithURL:[NSURL URLWithString:encodedString] placeholderImage:[UIImage imageNamed:placeholder]];
}

@end
