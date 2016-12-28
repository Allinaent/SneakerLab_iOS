//
//  DetailProcessTableViewCell.m
//  SneakerLab
//
//  Created by edz on 2016/11/7.
//  Copyright © 2016年 Jason cao. All rights reserved.
//

#import "DetailProcessTableViewCell.h"
#import "UIView+YZTCView.h"
@implementation DetailProcessTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        [self CreatUI];
    }
    return self;
}

-(void)CreatUI {
    _ImageView = [FactoryUI createImageViewWithFrame:CGRectMake(15, 20 , 90, 100) imageName:nil];
    [self.contentView addSubview:_ImageView];
    _nameLabel = [FactoryUI createLabelWithFrame:CGRectMake(120, 20, SCREEN_W - 40, 16) text:nil textColor:[UIColor colorWithHexString:@"#999999"]font:[UIFont systemFontOfSize:13]];
    [self.contentView addSubview:_nameLabel];
    _quantityLabel = [FactoryUI createLabelWithFrame:CGRectMake(120, _nameLabel.yzBottom+7.5, 65, 15) text:@"Quantity" textColor:[UIColor colorWithHexString:@"#999999"] font:[UIFont systemFontOfSize:12]];
    [self.contentView addSubview:_quantityLabel];
    _quantityLabel1 = [FactoryUI createLabelWithFrame:CGRectMake(_quantityLabel.yzRight, _nameLabel.yzBottom+7.5, 65, 15) text:nil textColor:[UIColor blackColor] font:[UIFont systemFontOfSize:12]];
    [self.contentView addSubview:_quantityLabel1];
    _sizeLabel = [FactoryUI createLabelWithFrame:CGRectMake(120, _quantityLabel.yzBottom +7.5, SCREEN_W - 50, 15) text:@"Size" textColor:[UIColor colorWithHexString:@"#999999"] font:[UIFont systemFontOfSize:12]];
    [self.contentView addSubview:_sizeLabel];
    _sizelabel1 = [FactoryUI createLabelWithFrame:CGRectMake(155, _quantityLabel1.yzBottom +4,SCREEN_W - 50, 20) text:nil textColor:[UIColor blackColor] font:[UIFont systemFontOfSize:12]];
    [self.contentView addSubview:_sizelabel1];
    _priceLabel = [FactoryUI createLabelWithFrame:CGRectMake(120, _sizeLabel.yzBottom + 10, 60, 15) text:nil textColor:[UIColor blackColor] font:[UIFont systemFontOfSize:13]];
    [self.contentView addSubview:_priceLabel];
}

-(void)setModel:(OrderProduct *)model{
    _model = model;
    NSString *encodedString = (NSString *)
    CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)model.image, (CFStringRef)@"!$&'()*+,-./:;=?@_~%#[]", NULL, kCFStringEncodingUTF8));
    [_ImageView  sd_setImageWithURL:[NSURL URLWithString:encodedString]];
    _nameLabel.text = model.name;
    _priceLabel.text = [NSString stringWithFormat:@"$%@",model.price];
    _quantityLabel1.text = model.quantity;
}

@end
