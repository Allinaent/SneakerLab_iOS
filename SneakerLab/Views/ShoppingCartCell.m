//
//  ShoppingCartCell.m
//  caowei
//
//  Created by Jason cao on 16/9/8.
//  Copyright © 2016年 Jason cao. All rights reserved.
//

#import "ShoppingCartCell.h"
#import "popViewController.h"
#import "UIView+YZTCView.h"
#import "ShopViewController.h"
#import "MyPickView.h"
@implementation ShoppingCartCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createUI];
    }
    return self;
}

- (void)createUI
{
    _ImageView = [FactoryUI createImageViewWithFrame:CGRectMake(10, 20, 120, 120) imageName:nil];
    _ImageView.layer.borderWidth = 0.5;
    _ImageView.layer.borderColor = [UIColor colorWithHexString:@"#DDDDDD"].CGColor;
    [self.contentView addSubview:_ImageView];
    _starSView = [[MyStarView alloc] initWithFrame:CGRectMake(10, 146.5, 87.5, 12)];
    [self.contentView addSubview:_starSView];
    
    _reviewedLabel = [FactoryUI createLabelWithFrame:CGRectMake(90, 146.5, 35, 15) text:nil textColor:[UIColor colorWithHexString:@"#999999"] font:[UIFont systemFontOfSize:12]];
    _reviewedLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:_reviewedLabel];
    
    _nameLabel = [FactoryUI createLabelWithFrame:CGRectMake(140, 10, SCREEN_W - 140, 50) text:nil textColor:[UIColor colorWithHexString:@"#666666"] font:[UIFont systemFontOfSize:14]];
    _nameLabel.numberOfLines = 0;
    [self.contentView addSubview:_nameLabel];
    
    UILabel *size = [FactoryUI createLabelWithFrame:CGRectMake(140, 50, 40, 15) text:@"SIZE:" textColor:[UIColor colorWithHexString:@"#999999"] font:[UIFont systemFontOfSize:12]];
    _sizeLabel = [FactoryUI createLabelWithFrame:CGRectMake(180, 50, 100, 15) text:nil textColor:[UIColor blackColor] font:[UIFont systemFontOfSize:12]];
    // bug，什么破玩意，2016-11-21 11:29:41，郭隆基
    [self.contentView addSubview:_sizeLabel];
    [self.contentView addSubview:size];
    UILabel *quantity = [FactoryUI createLabelWithFrame:CGRectMake(140, 90, 70, 15) text:@"QUANTITY:" textColor:[UIColor colorWithHexString:@"#999999"] font:[UIFont systemFontOfSize:12]];
    _quantityLabel = [FactoryUI createLabelWithFrame:CGRectMake(210, 90, 100, 15) text:nil textColor:[UIColor blackColor] font:[UIFont systemFontOfSize:12]];
    [self.contentView addSubview:_quantityLabel];
    [self.contentView addSubview:quantity];
    
    _oldPriceLabel = [FactoryUI createLabelWithFrame:CGRectMake(200, 140, 60, 20) text:nil textColor:[UIColor blackColor] font:[UIFont systemFontOfSize:12]];
    _oldPriceLabel.yzCenterY = _starSView.yzCenterY;
    [self.contentView addSubview:_oldPriceLabel];
    
    _nowPriceLabel = [FactoryUI createLabelWithFrame:CGRectMake(140, 140, 60, 20) text:nil textColor:[UIColor blackColor] font:[UIFont systemFontOfSize:12]];
    _nowPriceLabel.yzCenterY = _starSView.yzCenterY;
    [self.contentView addSubview:_nowPriceLabel];
    
    UIButton *removeBtn = [FactoryUI createButtonWithFrame:CGRectMake(SCREEN_W - 100, 160, 50, 14) title:@"remove" titleColor:[UIColor colorWithHexString:@"#999999"] imageName:nil backgroundImageName:nil target:self selector:@selector(removeAction)];
    removeBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [self.contentView addSubview:removeBtn];
    
    UIButton *editBtn = [FactoryUI createButtonWithFrame:CGRectMake(SCREEN_W - 45, 160, 25, 14) title:@"edit" titleColor:[UIColor colorWithHexString:@"#999999"] imageName:nil backgroundImageName:nil target:self selector:@selector(edit)];
    editBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [self.contentView addSubview:editBtn];
}

- (void)refreshUI:(ShoppingCartModel *)model
{
    [_ImageView sd_setImageWithURL:[NSURL URLWithString:model.image]];
    [_starSView withStar:model.rating.floatValue:87.5 :12];
    _nameLabel.text = model.name;
    for (NSDictionary *dic in model.options) {
        if ([[dic valueForKey:@"name"] isEqualToString:@"size"]) {
            _sizeLabel.text = [dic valueForKey:@"value"];
        }
        if ([[dic valueForKey:@"name"] isEqualToString:@"color"]) {
            
        }
    }
    _quantityLabel.text = model.quantity;
    _reviewedLabel.text = [NSString stringWithFormat:@"(%@)",model.reward];
    NSAttributedString *attrStr =
    [[NSAttributedString alloc]initWithString:[NSString stringWithFormat:@"US$%@",model.original_price]
                                   attributes:
     @{NSFontAttributeName:[UIFont systemFontOfSize:12],
       NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#999999"],
       NSStrikethroughStyleAttributeName:@(NSUnderlineStyleSingle|NSUnderlinePatternSolid),
       NSStrikethroughColorAttributeName:[UIColor colorWithHexString:@"#999999"]}];
    _oldPriceLabel.attributedText = attrStr;
    _nowPriceLabel.text = [NSString stringWithFormat:@"US$%@",model.special_price];
    _cartId = model.cart_id;
    
}


- (void)removeAction
{
    if (self.deleteBlock)
    {
        self.deleteBlock(self);
    }
}

- (void)edit
{
    NSArray *dataarray = [[[NSArray alloc] initWithObjects:@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",nil] mutableCopy];
    zySheetPickerView *pickerView = [zySheetPickerView ZYSheetStringPickerWithTitle:dataarray andHeadTitle:@"edit" Andcall:^(zySheetPickerView *pickerView, NSString *choiceString) {
        self.quantityLabel.text = choiceString;
        [pickerView dismissPicker];
        //发送异步请求
        if (self.editBlock)
        {
            self.editBlock(self,[choiceString integerValue]);
        }
    }];
    [pickerView show];
}

@end
