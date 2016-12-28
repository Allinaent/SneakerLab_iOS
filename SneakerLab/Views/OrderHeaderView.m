//
//  OrderHeaderView.m
//  SneakerLab
//
//  Created by edz on 2016/11/2.
//  Copyright © 2016年 Jason cao. All rights reserved.
//

#import "OrderHeaderView.h"
#import "UIView+YZTCView.h"
#import "UILabel+ChangeDate.h"

@interface OrderHeaderView ()
{
    
}
@property (nonatomic , strong) UILabel *OrderPlaced;
@property (nonatomic , strong) UILabel *timeLabel;
@property (nonatomic , strong) UILabel *line;
@property (nonatomic , strong) UILabel *widthLabel;
@property (nonatomic ,  strong) UILabel *label;



@end

@implementation OrderHeaderView
-(instancetype)initWithFrame:(CGRect)frame{

    if (self = [super initWithFrame:frame]) {
        [self CreatUI];
    }
    return self;

}
-(void)CreatUI{
    self.backgroundColor = [UIColor whiteColor];
    _widthLabel = [FactoryUI createLabelWithFrame:CGRectMake(0, 0, SCREEN_W, 10) text:nil textColor:nil font:nil];
    _widthLabel.backgroundColor = [UIColor colorWithHexString:@"#F2F2F2"];
    [self addSubview:_widthLabel];
    _label = [FactoryUI createLabelWithFrame:CGRectMake(SCREEN_W-115, _widthLabel.yzBottom+10, 100, 15) text:nil textColor:[UIColor redColor] font:[UIFont systemFontOfSize:13]];
    _label.textAlignment = 2;
    [self addSubview:_label];
    _line = [[UILabel alloc] initWithFrame:CGRectMake(15, _label.yzBottom+ 7, SCREEN_W - 30, 0.5)];
    _line.backgroundColor = [UIColor lightGrayColor];
    [self addSubview:_line];
    _OrderPlaced = [FactoryUI createLabelWithFrame:CGRectMake(15, _line.yzBottom+10, 80, 15) text:@"Order Placed" textColor:[UIColor colorWithHexString:@"#999999"] font:[UIFont systemFontOfSize:12]];
    [self addSubview:_OrderPlaced];
    _timeLabel = [FactoryUI createLabelWithFrame:CGRectMake(15,_OrderPlaced.yzBottom +2, 150, 20) text:nil textColor:[UIColor colorWithHexString:@"#666666"] font:[UIFont systemFontOfSize:14]];
    [self addSubview:_timeLabel];
}

-(void)setModel:(OrderHistoryModel *)model{
    _model = model;
    _label.text = model.order_status;
    if ([_label.text isEqualToString:@"Canceled"]||[_label.text isEqualToString:@"Completed"]) {
        _label.textColor = COLOR_9;
    }
    [_timeLabel setLabelWithText:model.date_added inputFormat:@"yyyy-MM-dd HH:mm:ss" outputFormat:@"MMM d,yyyy"];
}
@end
