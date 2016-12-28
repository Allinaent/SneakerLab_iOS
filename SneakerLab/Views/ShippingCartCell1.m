//
//  ShippingCartCell1.m
//  SneakerLab
//
//  Created by 郭隆基 on 2016/12/7.
//  Copyright © 2016年 Jason cao. All rights reserved.
//

#import "ShippingCartCell1.h"
#import "NBCountView.h"
#import "GShippingCartViewController.h"
#import "NSAttributedString+CommonSets.h"

@interface ShippingCartCell1 ()<NBCountViewDelegate>
@property (nonatomic, strong) UIImageView *headiv;
@property (nonatomic, strong) UILabel *namelb;

@property (nonatomic, strong) UILabel *highlb;
@property (nonatomic, strong) UILabel *lowlb;
@property (nonatomic, strong) NBCountView *numcv;
@end

@implementation ShippingCartCell1

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
    ShippingCartCell1 *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    [cell setBackgroundColor:[UIColor whiteColor]];
    if (cell == nil) {
        cell = [[ShippingCartCell1 alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
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
    _numcv = [[NBCountView alloc] initWithFrame:CGRectMake(15.5, 150, 97, 30)];
    self.numcv.delegate = self;
    _numcv.allowEdit = NO;
    [_numcv setBorderColor:COLOR_9];
    _numcv.layer.cornerRadius = 1;
    _numcv.number = 1;
    _numcv.minNumber = self.minimum;
    [self.contentView addSubview:_numcv];
    
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
    [later setTitle:@"Save for later" forState:UIControlStateNormal];
    later.layer.borderWidth = 0.5;
    later.layer.borderColor = [COLOR_9 CGColor];
    [self.contentView addSubview:later];
    [later addTarget:self action:@selector(laterButtonAction) forControlEvents:UIControlEventTouchUpInside];
}

- (void)delButtonAction {
    NSDictionary *dic = @{@"cart_id":_cart_id};
    [PHPNetwork PHPNetworkWithParam:dic andUrl:DELETESHOPPINGCART_URL andSignature:YES andLogin:YES finish:^(NSURLSessionDataTask *task, id responseObject) {
        GShippingCartViewController *vc = (GShippingCartViewController *)[self LJContentController];
        vc.reloadBlock();
    } err:^(NSURLSessionDataTask *task, NSError *error) {
        //[MBManager showBriefAlert:@"Something wrong"];
    }];
}

- (void)laterButtonAction {
    //测试用例
    /*
    NSString *time = [self getCurrentTimestamp];
    NSArray *arr = @[@"appKey",@"apiKey",@"timestamp",@"equipment_id",@"email",@"token",@"cart_id"];
    NSDictionary *dict = @{@"appKey" : APPKEY,
                          @"apiKey" : APIKEY,
                          @"equipment_id" : MYDEVICEID,
                          @"timestamp" : time,
                          @"email" : CWEMAIL,
                          @"token" : CWTOKEN,
                          @"cart_id":_cart_id
                          };
    NSArray *sortedArray = [arr sortedArrayUsingSelector:@selector(compare:)];
    NSMutableString *str = [[NSMutableString alloc] init];
    for ( int i = 0; i < sortedArray.count; i++)
    {
        [str appendString:sortedArray[i]];
        [str appendString:[dict objectForKey:sortedArray[i]]];
    }
    NSString *strMD5 = [str md5_32bit];
    NSString *signature = [strMD5 sha1];
    NSMutableDictionary *parameters = [dict mutableCopy];
    [parameters setObject:signature forKey:@"signature"];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/json",@"text/html",@"application/json",@"text/plain",nil];
    [manager POST:MOVETEMP_URL parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        DebugLog(@"%@", dic);
        NSString *str = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        DebugLog(@"%@", str);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
     */
    NSDictionary *dic = @{@"cart_id":_cart_id};
    [PHPNetwork PHPNetworkWithParam:dic andUrl:MOVETEMP_URL andSignature:YES andLogin:YES finish:^(NSURLSessionDataTask *task, id responseObject) {
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

- (void)setNum:(NSString *)num {
    if ([num integerValue] < self.minimum) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Tip" message:[NSString stringWithFormat:@"At least %ld", self.minimum] delegate:self cancelButtonTitle:@"Confirm" otherButtonTitles:nil];
        alert.tag = 100;
        [alert show];
    }
    _numcv.minNumber = self.minimum;
    _num = num;
    _numcv.number = [num integerValue];
}

- (void)countView:(NBCountView *)countView number:(NSInteger)value {
    _num = [NSString stringWithFormat:@"%ld", value];
    [self starButtonClicked:_num];
}

- (void)countviewButtonActionWithNum:(NSString *)num {
    NSDictionary *dic = @{@"cart_id":_cart_id,@"quantity":num};
    [PHPNetwork PHPNetworkWithParam:dic andUrl:EDITSHOPPING_URL andSignature:YES andLogin:YES finish:^(NSURLSessionDataTask *task, id responseObject) {
        GShippingCartViewController *vc = (GShippingCartViewController *)[self LJContentController];
        [vc requestdatas];
    } err:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
    
}

- (void)starButtonClicked:(id)sender
{
    //先将未到时间执行前的任务取消。
    [[self class] cancelPreviousPerformRequestsWithTarget:self selector:@selector(countviewButtonActionWithNum:) object:sender];
    [self performSelector:@selector(countviewButtonActionWithNum:) withObject:sender afterDelay:1.0f];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
}

@end
