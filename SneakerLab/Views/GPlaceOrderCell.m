//
//  GPlaceOrderCell.m
//  SneakerLab
//
//  Created by 郭隆基 on 2016/12/7.
//  Copyright © 2016年 Jason cao. All rights reserved.
//

#import "GPlaceOrderCell.h"
#import "NSAttributedString+CommonSets.h"

@interface GPlaceOrderCell ()
@property (nonatomic, strong) UIImageView *headiv;
@property (nonatomic, strong) UILabel *namelb;
@property (nonatomic, strong) UILabel *colorlb;
@property (nonatomic, strong) UILabel *sizelb;
@property (nonatomic, strong) UILabel *highlb;
@property (nonatomic, strong) UILabel *lowlb;
@property (nonatomic, strong) UILabel *numlb;
@end

@implementation GPlaceOrderCell

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
    static NSString *identifier = @"cell1";
    GPlaceOrderCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    [cell setBackgroundColor:[UIColor whiteColor]];
    if (cell == nil) {
        cell = [[GPlaceOrderCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createviews];
    }
    return self;
}

- (void)createviews {
    _headiv = [[UIImageView alloc] initWithFrame:CGRectMake(15, 23, 92, 92)];
    [self.contentView addSubview:_headiv];
    _namelb = [[UILabel alloc] initWithFrame:CGRectMake(120, 19, SCREEN_W-120-19.5, 31)];
    _namelb.numberOfLines = 0;
    _namelb.font = FONT_13;
    _namelb.textColor = COLOR_3;
    [self.contentView addSubview:_namelb];
    _colorL = [[UILabel alloc] initWithFrame:CGRectMake(120, 57, 50, 14)];
    _colorL.textColor = COLOR_9;
    _colorL.font = FONT_12;
    _colorL.text = @"color:";
    [_colorL sizeToFit];
    [self.contentView addSubview:_colorL];
    
    _colorlb = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_colorL.frame)+10, 57, 100, 14)];
    _colorlb.textColor = [UIColor colorWithHexString:@"#2A2A2A"];
    _colorlb.font = FONT_12;
    [self.contentView addSubview:_colorlb];
    _sizeL = [[UILabel alloc] initWithFrame:CGRectMake(120, CGRectGetMaxY(_colorL.frame), 50, 14)];
    _sizeL.textColor = COLOR_9;
    _sizeL.font = FONT_12;
    _sizeL.text = @"size:";
    [_sizeL sizeToFit];
    [self.contentView addSubview:_sizeL];
    
    _sizelb = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_sizeL.frame)+10, CGRectGetMaxY(_colorL.frame), 100, 14)];
    _sizelb.textColor = [UIColor colorWithHexString:@"#2A2A2A"];
    _sizelb.font = FONT_12;
    [self.contentView addSubview:_sizelb];
    
    _lowlb = [[UILabel alloc] initWithFrame:CGRectMake(120, 102, 100, 17.5)];
    _lowlb.textColor = COLOR_RED;
    _lowlb.font = FONT_15;
    [_lowlb sizeToFit];
    [self.contentView addSubview:_lowlb];
    _highlb = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_lowlb.frame)+17.5, 102, 100, 17.5)];
    _highlb.textColor = COLOR_9;
    _highlb.font = FONT_13;
    [_highlb sizeToFit];
    [self.contentView addSubview:_highlb];
    _numlb = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_W -22-50, 102, 97, 17.5)];
    _numlb.font = FONT_15;
    _numlb.textColor = COLOR_9;
    [self.contentView addSubview:_numlb];
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
    _highlb.attributedText = [NSAttributedString ls_attributedStringWithString:[NSString stringWithFormat:@"$%@", highprice] andFont:FONT_13 andColor:COLOR_9];
    [_highlb sizeToFit];
    _highlb.frame = CGRectMake(CGRectGetMaxX(_lowlb.frame)+17.5, 102, 100, 17.5);
}

- (void)setLowprice:(NSString *)lowprice {
    _lowprice = lowprice;
    _lowlb.text = [NSString stringWithFormat:@"$%@", lowprice];
    [_lowlb sizeToFit];
}

- (void)setNum:(NSString *)num {
    _num = num;
    _numlb.text = [NSString stringWithFormat:@"x%@", num];
}

@end
