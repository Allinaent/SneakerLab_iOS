//
//  FooterView.m
//  caowei
//
//  Created by Jason cao on 16/9/6.
//  Copyright © 2016年 Jason cao. All rights reserved.
//

#import "FooterView.h"

@implementation FooterView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        [self createUI];
    }
    return self;
}

- (void)createUI
{
    UILabel *sizeLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 10, SCREEN_W, 15)];
    sizeLabel.text = @"SIZE";
    sizeLabel.font = [UIFont systemFontOfSize:12];
    sizeLabel.textAlignment = NSTextAlignmentLeft;
    sizeLabel.textColor = [UIColor colorWithHexString:@"#666666"];
    
    UILabel *showSizeLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 30, SCREEN_W, 15)];
    showSizeLabel.text = @"43 43 43 43 43";
    showSizeLabel.numberOfLines = 0;
    showSizeLabel.font = [UIFont systemFontOfSize:12];
    showSizeLabel.textColor = [UIColor colorWithHexString:@"#333333"];
    showSizeLabel.textAlignment = NSTextAlignmentLeft;
    
    UILabel *timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 60, 130, 15)];
    timeLabel.text = @"ESTIMATED ARRIVAL";
    timeLabel.font = [UIFont systemFontOfSize:12];
    timeLabel.textAlignment = NSTextAlignmentLeft;
    timeLabel.textColor = [UIColor colorWithHexString:@"#666666"];
    
    UILabel *showTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 80, SCREEN_W, 15)];
    showTimeLabel.text = @"7 ~ 15 DAYS";
    showTimeLabel.font = [UIFont systemFontOfSize:12];
    showTimeLabel.textAlignment = NSTextAlignmentLeft;
    showTimeLabel.textColor = [UIColor colorWithHexString:@"#333333"];
    
    UILabel *postageLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 110, 130, 15)];
    postageLabel.text = @"ESTIMATED SHIPPING";
    postageLabel.font = [UIFont systemFontOfSize:12];
    postageLabel.textAlignment = NSTextAlignmentLeft;
    postageLabel.textColor = [UIColor colorWithHexString:@"#666666"];
    
    UILabel *showPostageLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 130, SCREEN_W, 15)];
    showPostageLabel.text = @"$0";
    showPostageLabel.font = [UIFont systemFontOfSize:12];
    showPostageLabel.textAlignment = NSTextAlignmentLeft;
    showPostageLabel.textColor = [UIColor colorWithHexString:@"#333333"];
    
    UIButton *detailBtn1 = [FactoryUI createButtonWithFrame:CGRectMake(155, 60, 60, 15) title:@"Detail" titleColor:[UIColor colorWithHexString:@"#666666"] imageName:nil backgroundImageName:nil target:self selector:@selector(shippingInfoDetail)];
    detailBtn1.titleLabel.font = [UIFont systemFontOfSize:12];
    
    UIButton *detailBtn2 = [FactoryUI createButtonWithFrame:CGRectMake(155, 110, 60, 15) title:@"Detail" titleColor:[UIColor colorWithHexString:@"#666666"] imageName:nil backgroundImageName:nil target:self selector:@selector(shippingInfoDetail)];
    detailBtn2.titleLabel.font = [UIFont systemFontOfSize:12];
    
    [self addSubview:detailBtn1];
    [self addSubview:detailBtn2];
//    UIImageView *image = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"邮戳"]];
//    image.center = CGPointMake(40, 330);
//    
//    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(80, 300, SCREEN_W - 80, 60)];
//    label.textAlignment = NSTextAlignmentLeft;
//    label.font = [UIFont systemFontOfSize:14];
//    label.textColor = [UIColor blackColor];
//    label.text = @"We guarantee a safe and secure shopping exprience so you never have to worry";
//    label.numberOfLines = 0;
    
//    [self addSubview:image];
//    [self addSubview:label];
    [self addSubview:showPostageLabel];
    [self addSubview:postageLabel];
    [self addSubview:showTimeLabel];
    [self addSubview:timeLabel];
    [self addSubview:showSizeLabel];
    [self addSubview:sizeLabel];
}

- (void)shippingInfoDetail
{
    if (self.footerBlock)
    {
        [self footerBlock];
    }
}
@end
