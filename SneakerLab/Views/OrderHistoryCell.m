//
//  OrderHistoryCell.m
//  caowei
//
//  Created by Jason cao on 2016/9/9.
//  Copyright © 2016年 Jason cao. All rights reserved.
//

#import "OrderHistoryCell.h"
#import "UIView+YZTCView.h"
#import "OptionModel.h"
@interface OrderHistoryCell()
{
    UILabel *_line;
    UILabel *_orderPlace;
    UILabel *_widthLabel;
    NSArray *_array ;
}
@end


@implementation OrderHistoryCell

+(instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *identifier = @"cell";
    //从缓存池中找
    OrderHistoryCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    //设置背景色
    [cell setBackgroundColor:[UIColor clearColor]];
    
    if (cell == nil) {
        cell = [[OrderHistoryCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        [self createUI];
    }
    return self;
}

- (void)createUI
{
    _ImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 20, 90, 100)];
    [self.contentView addSubview:_ImageView];
    _nameLabel = [FactoryUI createLabelWithFrame:CGRectMake(120, 20, SCREEN_W - 40, 16) text:nil textColor:[UIColor colorWithHexString:@"#999999"]font:[UIFont systemFontOfSize:13]];
    [self.contentView addSubview:_nameLabel];
    _quantityLabel = [FactoryUI createLabelWithFrame:CGRectMake(120, _nameLabel.yzBottom+7.5, 65, 15) text:@"Quantity" textColor:[UIColor colorWithHexString:@"#999999"] font:[UIFont systemFontOfSize:12]];
    [self.contentView addSubview:_quantityLabel];
    _quantityLabel1 = [FactoryUI createLabelWithFrame:CGRectMake(_quantityLabel.yzRight, _nameLabel.yzBottom+7.5, 65, 15) text:nil textColor:[UIColor blackColor] font:[UIFont systemFontOfSize:12]];
    [self.contentView addSubview:_quantityLabel1];
    _colorLabel = [[UILabel alloc] init];
    [self.contentView addSubview:_colorLabel];
    [_colorLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(120);
        make.top.equalTo(_quantityLabel.mas_bottom).with.offset(7.5);
        make.size.equalTo(CGSizeMake(65, 15));
    }];
    _colorLabel.text = @"Color";
    _colorLabel.textColor = COLOR_9;
    _colorLabel.font = [UIFont systemFontOfSize:12];
    
    _colorLabel1 = [[UILabel alloc] init];
    [self.contentView addSubview:_colorLabel1];
    [_colorLabel1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(155);
        make.top.equalTo(_quantityLabel.mas_bottom).with.offset(7.5);
        make.size.equalTo(CGSizeMake(100, 15));
    }];
    _colorLabel1.textColor = [UIColor blackColor];
    _colorLabel1.font = [UIFont systemFontOfSize:12];
    _sizeLabel = [[UILabel alloc] init];
    [self.contentView addSubview:_sizeLabel];
    [_sizeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(120);
        make.top.equalTo(_colorLabel.mas_bottom).with.offset(7.5);
        make.size.equalTo(CGSizeMake(65, 15));
    }];
    _sizeLabel.textColor = COLOR_9;
    _sizeLabel.text = @"Size";
    _sizeLabel.font = [UIFont systemFontOfSize:12];
    
    _sizelabel1 = [[UILabel alloc] init];
    [self.contentView addSubview:_sizelabel1];
    [_sizelabel1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(155);
        make.top.equalTo(_colorLabel.mas_bottom).with.offset(7.5);
        make.size.equalTo(CGSizeMake(100, 15));
    }];
    _sizelabel1.textColor = [UIColor blackColor];
    _sizelabel1.font = [UIFont systemFontOfSize:12];
    [self.contentView setNeedsLayout];
    [self.contentView layoutIfNeeded];
    _priceLabel = [[UILabel alloc] init];
    [self.contentView addSubview:_priceLabel];
    [_priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(120);
        make.top.equalTo(_sizeLabel.bottom).with.offset(10);
        make.size.equalTo(CGSizeMake(100, 15));
    }];
    _priceLabel.font = [UIFont systemFontOfSize:13];
    _priceLabel.textColor = [UIColor blackColor];
    [self.contentView setNeedsLayout];
    [self.contentView layoutIfNeeded];
}

- (void)showDetail
{
    
}

-(void)setModel:(OrderProduct *)model{
    _model = model;
    [self createUI];
    //[_ImageView sd_setImageWithURL:[NSURL URLWithString:model.image]];
    [_ImageView setPHPImageUrl:model.image];
    DebugLog(@"%@", model.image);
    _nameLabel.text = model.name;
    _priceLabel.text = [NSString stringWithFormat:@"$%@",model.price];
    _quantityLabel1.text = model.quantity;
    for (NSDictionary *dic in model.option) {
        if ([[dic valueForKey:@"name"] isEqualToString:@"size"]) {
            _sizelabel1.text = [dic valueForKey:@"value"];
        }else{
            _sizeLabel.frame = CGRectZero;
            _sizelabel1.frame = CGRectZero;
        }
        if ([[dic valueForKey:@"name"] isEqualToString:@"color"]) {
            _colorLabel.text = [dic valueForKey:@"value"];
        }else{
            [_colorLabel remakeConstraints:^(MASConstraintMaker *make) {
                make.size.equalTo(CGSizeZero);
                make.top.equalTo(_quantityLabel.bottom).with.offset(0);
            }];
            [_colorLabel1 remakeConstraints:^(MASConstraintMaker *make) {
                make.size.equalTo(CGSizeZero);
                make.top.equalTo(_quantityLabel.bottom).with.offset(0);
            }];
        }
    }
    [self.contentView setNeedsLayout];
    [self.contentView layoutIfNeeded];
    // 自适应高度
    self.cellheight = MAX(120, CGRectGetMaxY(_priceLabel.frame)+10);
    //[UIView showViewFrames:_priceLabel];
    //[UIView showViewFrames:_ImageView];
}

-(void)setSizeName:(NSString *)sizeName{
    _sizeName = sizeName;
    _sizelabel1.text = _sizeName;
}

@end
