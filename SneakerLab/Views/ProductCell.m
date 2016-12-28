//
//  ProductCell.m
//  caowei
//
//  Created by Jason cao on 2016/9/19.
//  Copyright © 2016年 Jason cao. All rights reserved.
//

#import "ProductCell.h"

@implementation ProductCell
- (instancetype)initWithFrame:(CGRect)frame
{
    if ( self = [super initWithFrame:frame])
    {
        [self createUI];
    }
    return self;
}

- (void)createUI
{
//    self.selectedBackgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"对"]];
    _imageView = [FactoryUI createImageViewWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.width) imageName:nil];
    [self.contentView addSubview:_imageView];
    
    _nameLabel = [FactoryUI createLabelWithFrame:CGRectMake(10, self.frame.size.width + 17, self.frame.size.width - 20, 26) text:@"name" textColor:[UIColor colorWithHexString:@"#333333"] font:[UIFont systemFontOfSize:11]];
    _nameLabel.numberOfLines = 0;
    [self.contentView addSubview:_nameLabel];
    
    _priceLabel1 = [FactoryUI createLabelWithFrame:CGRectMake(10, self.frame.size.width + 49, 55, 15) text:@"special_price" textColor:[UIColor colorWithHexString:@"#333333"] font:[UIFont systemFontOfSize:11]];
    [self.contentView addSubview:_priceLabel1];
    
    _priceLabel2 = [FactoryUI createLabelWithFrame:CGRectMake(55,  self.frame.size.width + 49, 55, 15) text:@"original_price" textColor:[UIColor blackColor] font:[UIFont systemFontOfSize:10]];
    [self.contentView addSubview:_priceLabel2];
    
    //_viewLabel = [FactoryUI createLabelWithFrame:CGRectMake(10, self.frame.size.width + 66.5, 85, 15) text:@"views" textColor:[UIColor colorWithHexString:@"#999999"] font:[UIFont systemFontOfSize:10]];
    //[self.contentView addSubview:_viewLabel];
    self.layer.borderColor=[UIColor colorWithHexString:@"#E5E5E5"].CGColor;
    self.layer.borderWidth=0.5;
}

- (void)refreshUI:(ProductModel *)model
{
    //bug修改，2016-11-03 11:55:34，郭隆基
    NSString *encodedString = (NSString *)
    CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)model.image, (CFStringRef)@"!$&'()*+,-./:;=?@_~%#[]", NULL, kCFStringEncodingUTF8));
    
    [_imageView sd_setImageWithURL:[NSURL URLWithString:encodedString] placeholderImage:loadFailImg options:SDWebImageRetryFailed];
    _nameLabel.text = model.name;
    _priceLabel1.text =[NSString stringWithFormat:@"$%@",model.special_price];
    NSAttributedString *attrStr =
    [[NSAttributedString alloc]initWithString:[NSString stringWithFormat:@"$%@",model.original_price]
                                   attributes:
     @{NSFontAttributeName:[UIFont systemFontOfSize:10],
       NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#999999"],
       NSStrikethroughStyleAttributeName:@(NSUnderlineStyleSingle|NSUnderlinePatternSolid),
       NSStrikethroughColorAttributeName:[UIColor colorWithHexString:@"#999999"]}];
    _priceLabel2.attributedText = attrStr;
    
    //_viewLabel.text = [NSString stringWithFormat:@"%@ bought this",model.viewed];
}

@end
