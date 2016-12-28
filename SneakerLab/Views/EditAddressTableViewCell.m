//
//  EditAddressTableViewCell.m
//  SneakerLab
//
//  Created by 郭隆基 on 2016/12/8.
//  Copyright © 2016年 Jason cao. All rights reserved.
//

#import "EditAddressTableViewCell.h"
#import "GEditAddressViewController.h"
#import "GShippingAddressViewController.h"

@interface EditAddressTableViewCell ()
@property(nonatomic, strong) UILabel *namelb;
@property(nonatomic, strong) UILabel *phonelb;
@property(nonatomic, strong) UILabel *addresslb;
@property(nonatomic, strong) UIImageView *select;
@end

@implementation EditAddressTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    if (selected) {
        [self.contentView addSubview:_select];
        _namelb.frame = CGRectMake(50, 15.5, 100, 16.5);
        [_namelb sizeToFit];
        _phonelb.frame = CGRectMake(MAX(CGRectGetMaxX(_namelb.frame)+15,135), 15.5, 100, 16.5);
        _addresslb.frame = CGRectMake(50, 47, 200, 60);
        _del.hidden = YES;
    }else{
        [_select removeFromSuperview];
        _namelb.frame = CGRectMake(15, 15.5, 100, 16.5);
        [_namelb sizeToFit];
        _phonelb.frame = CGRectMake(MAX(CGRectGetMaxX(_namelb.frame)+15,100), 15.5, 100, 16.5);
        _addresslb.frame = CGRectMake(15, 47, 200, 60);
        _del.hidden = NO;
    }
    
}

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *identifier = @"cell";
    EditAddressTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    [cell setBackgroundColor:[UIColor whiteColor]];
    if (cell == nil) {
        cell = [[EditAddressTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
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
        _del = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_W-52.5-18, 90, 18, 18)];
        [_del setBackgroundImage:[UIImage imageNamed:@"删除"] forState:UIControlStateNormal];
        [_del addTarget:self action:@selector(delAction) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_del];
        
        UIButton *edit = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_W-15-17.5, 90, 18, 18)];
        [edit setBackgroundImage:[UIImage imageNamed:@"编辑 copy"] forState:UIControlStateNormal];
        [self.contentView addSubview:edit];
        [edit addTarget:self action:@selector(editButtonAction) forControlEvents:UIControlEventTouchUpInside];
        _namelb = [[UILabel alloc] initWithFrame:CGRectMake(15, 15.5, 100, 16.5)];
        _namelb.font = FONT_14;
        _namelb.textColor = COLOR_3;
        [_namelb sizeToFit];
        [self.contentView addSubview:_namelb];
        _phonelb = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_namelb.frame)+15, 15.5, 100, 16.5)];
        _phonelb.font = FONT_14;
        _phonelb.textColor = COLOR_3;
        [_phonelb sizeToFit];
        [self.contentView addSubview:_phonelb];
        
        _addresslb = [[UILabel alloc] initWithFrame:CGRectMake(15, 47, 200, 60)];
        _addresslb.numberOfLines = 3;
        _addresslb.font = FONT_14;
        _addresslb.textColor = COLOR_3;
        [self.contentView addSubview:_addresslb];
    }
    return self;
}

- (void)setName:(NSString *)name {
    _name = name;
    _namelb.text = name;
}

- (void)setPhone:(NSString *)phone {
    _phone = phone;
    self.phonelb.text = phone;
}

- (void)setCountry:(NSString *)country {
    _country = country;
    _addresslb.text = [NSString stringWithFormat:@"%@\n%@\n%@", _street, _city, _country];
    //一定要最后把值赋给country
}

- (void)delAction {
    NSDictionary *dict = @{@"address_id":self.address_id};
    [PHPNetwork PHPNetworkWithParam:dict andUrl:ADDRESSDELETE_URL andSignature:YES andLogin:YES finish:^(NSURLSessionDataTask *task, id responseObject) {
        [MBManager showBriefAlert:@"success"];
        GShippingAddressViewController *vc = (GShippingAddressViewController *)[self LJContentController];
        [vc requestdatas];
    } err:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}

- (void)editButtonAction {
    GEditAddressViewController *vc = [[GEditAddressViewController alloc] init];
    vc.add = NO;
    vc.address_id = self.address_id;
    [[self LJContentController].navigationController pushViewController:vc animated:YES];
}

@end
