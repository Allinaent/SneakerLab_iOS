//
//  EditCardTableViewCell.m
//  SneakerLab
//
//  Created by 郭隆基 on 2016/12/6.
//  Copyright © 2016年 Jason cao. All rights reserved.
//

#import "EditCardTableViewCell.h"
#import "GEditCardViewController.h"
#import "PaymentMethodViewController.h"

@interface EditCardTableViewCell ()
@property(nonatomic, strong) UILabel *visa;
@property(nonatomic, strong) UILabel *expires;
@property(nonatomic, strong) UILabel *cardLB;
@property(nonatomic, strong) UILabel *dateLB;
@property(nonatomic, strong) UIImageView *select;
@end

@implementation EditCardTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
    if (selected) {
        [self.contentView addSubview:_select];
        _visa.frame = CGRectMake(50, 15, 55, 16.5);
        [_visa sizeToFit];
        _expires.frame = CGRectMake(50, 38, 55, 16.5);
        _cardLB.frame = CGRectMake(155, 15, 100, 16.5);
        _dateLB.frame = CGRectMake(155, 38, 100, 16.5);
        _del.hidden = YES;
    }else{
        [_select removeFromSuperview];
        _visa.frame = CGRectMake(15, 15, 55, 16.5);
        [_visa sizeToFit];
        _expires.frame = CGRectMake(15, 38, 55, 16.5);
        _cardLB.frame = CGRectMake(120, 15, 100, 16.5);
        _dateLB.frame = CGRectMake(120, 38, 100, 16.5);
        _del.hidden = NO;
    }
}

- (void)setCard_number:(NSString *)card_number {
    _card_number = card_number;
    NSString *str;
    if (card_number.length>3) {
        NSRange ran = NSMakeRange(_card_number.length-4, 4);
        str = [card_number substringWithRange:ran];
    }else{
        str = card_number;
    }
    self.cardLB.text = [NSString stringWithFormat:@"****%@", str];
}

- (void)setCard_year:(NSString *)card_year {
    _card_year = card_year;
}

- (void)setIs_default:(NSString *)is_default {
    _is_default = is_default;
    if (is_default == 0) {
        self.selected = YES;
    }
}

- (void)setCard_month:(NSString *)card_month {
    _card_month = card_month;
    self.dateLB.text = [NSString stringWithFormat:@"%@/%@", card_month,_card_year];
}

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *identifier = @"cell";
    EditCardTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    [cell setBackgroundColor:[UIColor whiteColor]];
    if (cell == nil) {
        cell = [[EditCardTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        _select = [[UIImageView alloc] initWithFrame:CGRectMake(15, 15, 20.5, 20.5)];
        _select.image = [UIImage imageNamed:@"xuanzhong"];
        _visa = [[UILabel alloc] initWithFrame:CGRectMake(15, 15, 80, 16.5)];
        _visa.font = FONT_14;
        _visa.textColor = COLOR_3;
        _visa.text = @"credit card";
        [_visa sizeToFit];
        [self.contentView addSubview:_visa];
        
        _expires = [[UILabel alloc] initWithFrame:CGRectMake(15, 38, 55, 16.5)];
        _expires.font = FONT_14;
        _expires.textColor = COLOR_3;
        _expires.text = @"Expires";
        [self.contentView addSubview:_expires];
        
        _cardLB = [[UILabel alloc] initWithFrame:CGRectMake(120, 15, 100, 16.5)];
        _cardLB.font = FONT_14;
        _cardLB.textColor = COLOR_3;
        _cardLB.text = @"";
        [self.contentView addSubview:_cardLB];
        
        _dateLB = [[UILabel alloc] initWithFrame:CGRectMake(120, 38, 100, 16.5)];
        _dateLB.font = FONT_14;
        _dateLB.textColor = COLOR_3;
        _dateLB.text = @"";
        [self.contentView addSubview:_dateLB];
        
        _del = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_W-52.5-18, 41.5, 18, 18)];
        [_del setBackgroundImage:[UIImage imageNamed:@"删除"] forState:UIControlStateNormal];
        [_del addTarget:self action:@selector(delAction) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_del];
        
        UIButton *edit = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_W-15-17.5, 41.5, 18, 18)];
        [edit setBackgroundImage:[UIImage imageNamed:@"编辑 copy"] forState:UIControlStateNormal];
        [self.contentView addSubview:edit];
        [edit addTarget:self action:@selector(editButtonAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

- (void)delAction {
    NSDictionary *dict = @{@"credit_id":self.credit_id};
    [PHPNetwork PHPNetworkWithParam:dict andUrl:CARDDELETE_URL andSignature:YES andLogin:YES finish:^(NSURLSessionDataTask *task, id responseObject) {
        PaymentMethodViewController *vc = (PaymentMethodViewController *)[self LJContentController];
        [vc requestdatas];
    } err:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}

- (void)editButtonAction {
    GEditCardViewController *vc = [[GEditCardViewController alloc] init];
    vc.add = NO;
    vc.credit_id = self.credit_id;
    [[self LJContentController].navigationController pushViewController:vc animated:YES];
}

- (void)layoutSubviews {
    [super layoutSubviews];
}

@end
