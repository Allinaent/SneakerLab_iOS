//
//  Processing.m
//  SneakerLab
//
//  Created by edz on 2016/11/1.
//  Copyright © 2016年 Jason cao. All rights reserved.
//

#import "Processing.h"
#import "UIView+YZTCView.h"
@interface Processing()
{
    NSString * _order_status;
    UILabel *_line;
    UILabel *_orderPlace;
    UILabel *_widthLabel;
    NSArray *_array ;
}
@property (nonatomic , strong) UILabel *OrderPlaced;
@property (nonatomic , strong) UILabel *timeLabel;
@property (nonatomic , strong) UIImageView *ImageView;
@property (nonatomic , strong) UILabel *nameLabel;
@property (nonatomic , strong) UILabel *sizeLabel;
@property (nonatomic , strong) UILabel *quantityLabel;
@property (nonatomic , strong) UILabel *priceLabel;
@property (nonatomic , strong) UIButton *statusBtn;

@end
@implementation Processing

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        [self creatUI];
    }
    
    return self;
    
}
-(void)creatUI{
    _widthLabel = [FactoryUI createLabelWithFrame:CGRectMake(0, 0, SCREEN_W, 10) text:nil textColor:nil font:nil];
    _widthLabel.backgroundColor = [UIColor colorWithHexString:@"#F2F2F2"];
    [self addSubview:_widthLabel];
    _statusBtn = [FactoryUI createButtonWithFrame:CGRectMake(300, _widthLabel.yzBottom+10, 100, 15) title:@"Processing"titleColor:[UIColor redColor] imageName:nil backgroundImageName:nil target:self selector:nil];
    [self addSubview:_statusBtn];
    
    _line = [[UILabel alloc] initWithFrame:CGRectMake(15, _statusBtn.yzBottom+ 7, SCREEN_W - 30, 0.5)];
    _line.backgroundColor = [UIColor lightGrayColor];
    [self addSubview:_line];
    _orderPlace = [FactoryUI createLabelWithFrame:CGRectMake(15, _line.yzBottom+10, 80, 15) text:@"Order Placed" textColor:[UIColor colorWithHexString:@"#999999"] font:[UIFont systemFontOfSize:12]];
    [self addSubview:_orderPlace];
    
    _timeLabel = [FactoryUI createLabelWithFrame:CGRectMake(15,_orderPlace.yzBottom +2, 80, 17) text:@"Sep6,2016" textColor:[UIColor colorWithHexString:@"#666666"] font:[UIFont systemFontOfSize:14]];
    [self addSubview:_timeLabel];
    
    _ImageView = [FactoryUI createImageViewWithFrame:CGRectMake(15, _timeLabel.yzBottom +26 , 90, 100) imageName:@"背景图"];
    [self addSubview:_ImageView];
    _nameLabel = [FactoryUI createLabelWithFrame:CGRectMake(120, _ImageView.yzRight+5, SCREEN_W - 40, 16) text:@"adidas yezzy 350" textColor:[UIColor colorWithHexString:@"#999999"]font:[UIFont systemFontOfSize:13]];
    [self addSubview:_nameLabel];
    
    _quantityLabel = [FactoryUI createLabelWithFrame:CGRectMake(120, _nameLabel.yzBottom+7.5, 65, 15) text:@"Quantity" textColor:[UIColor colorWithHexString:@"#999999"] font:[UIFont systemFontOfSize:12]];
    [self addSubview:_quantityLabel];
    
    _sizeLabel = [FactoryUI createLabelWithFrame:CGRectMake(120, _quantityLabel.yzBottom +7.5, SCREEN_W - 50, 15) text:@"Size" textColor:[UIColor colorWithHexString:@"#999999"] font:[UIFont systemFontOfSize:12]];
    [self addSubview:_sizeLabel];
    
    _priceLabel = [FactoryUI createLabelWithFrame:CGRectMake(120, _sizeLabel.yzBottom + 10, 60, 15) text:@"$1501.0" textColor:[UIColor colorWithHexString:@"#555555"] font:[UIFont systemFontOfSize:13]];
    [self addSubview:_priceLabel];
    
    UIButton *detail = [FactoryUI createButtonWithFrame:CGRectMake(320, 260, 65, 35) title:@"Detail" titleColor:[UIColor colorWithHexString:@"#666666"] imageName:nil backgroundImageName:nil target:self selector:@selector(showDetail)];
    
    detail.layer.cornerRadius = 8;
    detail.backgroundColor = [UIColor colorWithHexString:@"#E7E7E7"];
    [self addSubview:detail];
    UIButton *Cancel = [FactoryUI createButtonWithFrame:CGRectMake(15,detail.yzTop , 60, 40) title:nil titleColor:[UIColor lightGrayColor] imageName:nil backgroundImageName:nil target:self selector:@selector(cancel)];
        NSMutableAttributedString *str1 = [[NSMutableAttributedString alloc] initWithString:@"Cancel"];
        NSRange strRange1 = {0,[str1 length]};
        [str1 addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:strRange1];
        [Cancel setAttributedTitle:str1 forState:UIControlStateNormal];
   
    
    [self addSubview:Cancel];
}

- (void)showDetail {
    
}

@end
