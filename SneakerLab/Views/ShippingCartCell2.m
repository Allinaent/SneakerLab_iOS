//
//  ShippingCartCell2.m
//  SneakerLab
//
//  Created by 郭隆基 on 2016/12/7.
//  Copyright © 2016年 Jason cao. All rights reserved.
//

#import "ShippingCartCell2.h"
#import "GShippingCartViewController.h"
#import "NSAttributedString+CommonSets.h"

@interface ShippingCartCell2 ()
@property (nonatomic, strong) UIImageView *headiv;
@property (nonatomic, strong) UILabel *namelb;

@property (nonatomic, strong) UILabel *highlb;
@property (nonatomic, strong) UILabel *lowlb;
@property (nonatomic, strong) UIStepper *numst;
@end

@implementation ShippingCartCell2

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *identifier = @"cell2";
    ShippingCartCell2 *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    [cell setBackgroundColor:[UIColor whiteColor]];
    if (cell == nil) {
        cell = [[ShippingCartCell2 alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createviews];
    }
    return self;
}

- (void)createviews {
    _headiv = [[UIImageView alloc] initWithFrame:CGRectMake(15, 18.5, 92, 92)];
    [self.contentView addSubview:_headiv];
    _namelb = [[UILabel alloc] initWithFrame:CGRectMake(120, 15.5, SCREEN_W-120-23, 31)];
    _namelb.numberOfLines = 0;
    _namelb.font = FONT_13;
    _namelb.textColor = COLOR_3;
    [self.contentView addSubview:_namelb];
    _colorL = [[UILabel alloc] initWithFrame:CGRectMake(120, 51.5, 50, 14)];
    _colorL.textColor = COLOR_9;
    _colorL.font = FONT_12;
    _colorL.text = @"color:";
    [_colorL sizeToFit];
    [self.contentView addSubview:_colorL];
    
    _colorlb = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_colorL.frame), 51.5, 100, 14)];
    _colorlb.textColor = [UIColor colorWithHexString:@"#2A2A2A"];
    _colorlb.font = FONT_12;
    [self.contentView addSubview:_colorlb];
    _sizeL = [[UILabel alloc] initWithFrame:CGRectMake(120, CGRectGetMaxY(_colorL.frame), 50, 14)];
    _sizeL.textColor = COLOR_9;
    _sizeL.font = FONT_12;
    _sizeL.text = @"size:";
    [_sizeL sizeToFit];
    [self.contentView addSubview:_sizeL];
    
    _sizelb = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_sizeL.frame), CGRectGetMaxY(_colorL.frame), 100, 14)];
    _sizelb.textColor = [UIColor colorWithHexString:@"#2A2A2A"];
    _sizelb.font = FONT_12;
    [self.contentView addSubview:_sizelb];
    
    _lowlb = [[UILabel alloc] initWithFrame:CGRectMake(120, 101, 100, 17.5)];
    _lowlb.textColor = COLOR_RED;
    _lowlb.font = FONT_15;
    [self.contentView addSubview:_lowlb];
    _highlb = [[UILabel alloc] initWithFrame:CGRectMake(231, 101, 100, 17.5)];
    _highlb.textColor = COLOR_9;
    _highlb.font = FONT_13;
    [self.contentView addSubview:_highlb];
    UIButton *del = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_W - 118-46, 155, 46, 25)];
    del.titleLabel.textColor = COLOR_6;
    [del setTitleColor:COLOR_6 forState:UIControlStateNormal];
    del.titleLabel.font = FONT_12;
    [del setTitle:@"Delete" forState:UIControlStateNormal];
    del.layer.borderWidth = 0.5;
    del.layer.borderColor = [COLOR_9 CGColor];
    [self.contentView addSubview:del];
    [del addTarget:self action:@selector(delButtonAction) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *later = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_W -15-88, 155, 88, 25)];
    later.titleLabel.textColor = COLOR_6;
    [later setTitleColor:COLOR_6 forState:UIControlStateNormal];
    later.titleLabel.font = FONT_12;
    [later setTitle:@"Move to cart" forState:UIControlStateNormal];
    later.layer.borderWidth = 0.5;
    later.layer.borderColor = [COLOR_9 CGColor];
    [self.contentView addSubview:later];
    [later addTarget:self action:@selector(moveButtonAction) forControlEvents:UIControlEventTouchUpInside];
}

- (void)delButtonAction {
    NSDictionary *dic = @{@"cart_back_id":_cart_id};
    [PHPNetwork PHPNetworkWithParam:dic andUrl:DELETECART_URL andSignature:YES andLogin:YES finish:^(NSURLSessionDataTask *task, id responseObject) {
        GShippingCartViewController *vc = (GShippingCartViewController *)[self LJContentController];
        vc.reloadBlock();
    } err:^(NSURLSessionDataTask *task, NSError *error) {
        //[MBManager showBriefAlert:@"Something wrong"];
    }];
}

- (void)moveButtonAction {
    NSDictionary *dic = @{@"cart_back_id":_cart_id};
    [PHPNetwork PHPNetworkWithParam:dic andUrl:MOVETOCART_URL andSignature:YES andLogin:YES finish:^(NSURLSessionDataTask *task, id responseObject) {
        GShippingCartViewController *vc = (GShippingCartViewController *)[self LJContentController];
        vc.reloadBlock();
    } err:^(NSURLSessionDataTask *task, NSError *error) {
        //[MBManager showBriefAlert:@"Something wrong"];
    }];
}

- (void)setName:(NSString *)name {
    _name = name;
    _namelb.text = name;
}

- (void)setHead:(NSString *)head {
    _head = head;
    [_headiv setPHPImageUrl:_head];
}

- (void)setColor:(NSString *)color {
    _color = color;
    _colorlb.text = color;
}

- (void)setSize:(NSString *)size {
    _size = size;
    _sizelb.text = size;
}

- (void)setHighprice:(NSString *)highprice {
    _highprice = highprice;
    _highlb.attributedText = [NSAttributedString ls_attributedStringWithString:[NSString stringWithFormat:@"%@", highprice] andFont:FONT_13 andColor:COLOR_9];
    _highlb.frame = CGRectMake(CGRectGetMaxX(_lowlb.frame)+17.5, 102, 100, 17.5);
    [_highlb sizeToFit];
}

- (void)setLowprice:(NSString *)lowprice {
    _lowprice = lowprice;
    _lowlb.text = lowprice;
    [_lowlb sizeToFit];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
}

@end
