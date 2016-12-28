//
//  QFStarView.h
//  caowei
//
//  Created by Jason cao on 2016/9/18.
//  Copyright © 2016年 Jason cao. All rights reserved.
//

#import "CWStarView.h"

@interface CWStarView ()

/** 背景 */
@property (nonatomic, strong) UIImageView *background;

/** 前景 */
@property (nonatomic, strong) UIImageView *foregreoud;

@property (nonatomic , assign) float star;

@end

@implementation CWStarView

- (UIImageView *)background {
    if (!_background) {
        UIImage *image = [UIImage imageNamed:@"StarsBackground"];
        _background = [[UIImageView alloc] initWithImage:image];
        _background.frame = CGRectMake(0, 0, image.size.width, image.size.height);
        
        [self addSubview:_background];
    }
    return _background;
}

- (UIImageView *)foregreoud {
    if (!_foregreoud) {
        // 先添加背景
        [self background];
        UIImage *image = [UIImage imageNamed:@"StarsForeground"];
        _foregreoud = [[UIImageView alloc] initWithImage:image];
        _foregreoud.frame = CGRectMake(0, 0, image.size.width, image.size.height);
        // 设置超出部分裁剪
        _foregreoud.contentMode = UIViewContentModeLeft;
        _foregreoud.clipsToBounds = YES;
        [self addSubview:_foregreoud];
    }
    return _foregreoud;
}

- (void)withStar:(float)star :(float)w :(float)h
{
    _star = star;
    float totalWidth = w;
    // 得到宽度
    float width = totalWidth * star / 5.f;
    self.foregreoud.frame = CGRectMake(0, 0, width, h);
}

@end
