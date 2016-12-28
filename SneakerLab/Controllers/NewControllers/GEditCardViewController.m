//
//  GEditCardViewController.m
//  SneakerLab
//
//  Created by 郭隆基 on 2016/12/8.
//  Copyright © 2016年 Jason cao. All rights reserved.
//

#import "GEditCardViewController.h"
#import "LJButton.h"
#import <ZYKeyboardUtil/ZYKeyboardUtil.h>
#import "ZHPickView.h"
#import "GPlaceOrderViewController.h"

@interface GEditCardViewController ()
@property (nonatomic, strong) UITextField *card;
@property (nonatomic, strong) UITextField *code;
@property (nonatomic, strong) UITextField *zip;
@property (nonatomic, strong) UIButton *month;
@property (nonatomic, strong) UIButton *year;
@property (nonatomic, strong) LJButton *paypal;
@property (nonatomic, strong) UIImageView *lock;
@property (nonatomic, strong) ZYKeyboardUtil *keyboardUtil;
@end

@implementation GEditCardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Edit Payment Method";
    self.keyboardUtil = [[ZYKeyboardUtil alloc] init];
    __weak typeof(GEditCardViewController) *weakSelf = self;
    [_keyboardUtil setAnimateWhenKeyboardAppearAutomaticAnimBlock:^(ZYKeyboardUtil *keyboardUtil) {
        [keyboardUtil adaptiveViewHandleWithController:weakSelf adaptiveView:weakSelf.view, nil];
    }];
    SET_NAV_MIDDLE
    UIBarButtonItem *cancel = [[UIBarButtonItem alloc] initWithTitle:@"cancel" style:UIBarButtonItemStylePlain target:self action:@selector(cancelItemAction)];
    self.navigationItem.rightBarButtonItem = cancel;
    self.view.backgroundColor = [UIColor whiteColor];
    UIView *head = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, 56.5)];
    head.backgroundColor = COLOR_FA;
    [self.view addSubview:head];
    
    UIImageView *guard = [[UIImageView alloc] initWithFrame:CGRectMake(18, 15.5, 21, 23)];
    guard.image = [UIImage imageNamed:@"盾牌"];
    [head addSubview:guard];
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(51.5, 9.5, SCREEN_W-23.5-51.5, 45)];
    title.numberOfLines = 0;
    title.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
    title.text = @"Any information about your credit card will be stored only in your phone and will be encrypted strictly.";
    title.textColor = [UIColor colorWithHexString:@"#FF8922"];
    [head addSubview:title];
    UIImageView *img1 = [[UIImageView alloc] initWithFrame:CGRectMake(14, 71.5, 35.5, 19)];
    img1.image = [UIImage imageNamed:@"visa2"];
    [self.view addSubview:img1];
    
    UIImageView *img2 = [[UIImageView alloc] initWithFrame:CGRectMake(54.5, 71.5, 35.5, 19)];
    img2.image = [UIImage imageNamed:@"mastercard"];
    [self.view addSubview:img2];
    
    UIImageView *img3 = [[UIImageView alloc] initWithFrame:CGRectMake(95, 71.5, 35.5, 19)];
    img3.image = [UIImage imageNamed:@"jcb"];
    [self.view addSubview:img3];
    
    UIImageView *img4 = [[UIImageView alloc] initWithFrame:CGRectMake(135, 71.5, 35.5, 19)];
    img4.image = [UIImage imageNamed:@"ame"];
    [self.view addSubview:img4];
    
    UIImageView *img5 = [[UIImageView alloc] initWithFrame:CGRectMake(175, 71.5, 35.5, 19)];
    img5.image = [UIImage imageNamed:@"dis"];
    [self.view addSubview:img5];
    
    _card = [[UITextField alloc] initWithFrame:CGRectMake(15, 97.5, SCREEN_W-30, 40)];
    _card.layer.borderWidth = 0.5;
    _card.layer.borderColor = [COLOR_D CGColor];
    _card.leftView = [[UIView alloc] initWithFrame:CGRectMake(42.5, 0, 42.5, 42.5)];
    _card.leftViewMode = UITextFieldViewModeAlways;
    _lock = [[UIImageView alloc] initWithFrame:CGRectMake(9.5, 8.5, 23, 23)];
    _lock.backgroundColor = COLOR_9;
    _lock.layer.cornerRadius = 11.5;
    _lock.layer.masksToBounds = YES;
    if (_card.text.length==0) {
        _lock.image = [UIImage imageNamed:@"锁 copy"];
    }else{
        _lock.image = [UIImage imageNamed:@"锁子"];
    }
    [_card.leftView addSubview:_lock];
    [_card addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    _card.placeholder = @"Card number";
    _card.font = FONT_14;
    [self.view addSubview:_card];
    UILabel *security = [[UILabel alloc] initWithFrame:CGRectMake(15.5, 150, 100, 14)];
    security.textAlignment = 0;
    security.textColor = COLOR_3;
    security.font = FONT_12;
    security.text = @"Security Code";
    [self.view addSubview:security];
    
    _code = [[UITextField alloc] initWithFrame:CGRectMake(15, 169, SCREEN_W-30, 40)];
    _code.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 6.5, 40)];
    _code.leftViewMode = UITextFieldViewModeAlways;
    _code.placeholder = @"CVV";
    _code.font = FONT_14;
    _code.rightView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    _code.rightViewMode = UITextFieldViewModeAlways;
    UIImageView *icon = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    icon.image = [UIImage imageNamed:@"安全码"];
    icon.contentMode = UIViewContentModeCenter;
    [_code.rightView addSubview:icon];
    _code.layer.borderWidth = 0.5;
    _code.layer.borderColor = [COLOR_D CGColor];
    [self.view addSubview:_code];
    
    UILabel *date = [[UILabel alloc] initWithFrame:CGRectMake(15, 224, 100, 14)];
    date.textAlignment = 0;
    date.textColor = COLOR_3;
    date.font = FONT_12;
    date.text = @"Expiry Date";
    [self.view addSubview:date];
    
    _month = [[UIButton alloc] initWithFrame:CGRectMake(15, 243, (SCREEN_W-30-40)/2, 40)];
    _month.titleLabel.textAlignment = 0;
    [_month setTitleColor:COLOR_3 forState:UIControlStateNormal];
    _month.layer.borderWidth = 0.5;
    _month.layer.borderColor = [COLOR_D CGColor];
    _month.titleLabel.font = FONT_14;
    [_month addTarget:self action:@selector(chooseMonthAction) forControlEvents:UIControlEventTouchUpInside];
    UIImageView *down = [[UIImageView alloc] initWithFrame:CGRectMake((SCREEN_W-30-40)/2-35, 0, 30, 40)];
    down.image = [UIImage imageNamed:@"下拉"];
    down.contentMode = UIViewContentModeCenter;
    [_month addSubview:down];
    [self.view addSubview:_month];
    
    _year = [[UIButton alloc] initWithFrame:CGRectMake(15+(SCREEN_W-30-40)/2+40, 243, (SCREEN_W-30-40)/2, 40)];
    _year.titleLabel.textAlignment = 0;
    [_year setTitleColor:COLOR_3 forState:UIControlStateNormal];
    _year.layer.borderWidth = 0.5;
    _year.layer.borderColor = [COLOR_D CGColor];
    _year.titleLabel.font = FONT_14;
    [_year addTarget:self action:@selector(chooseYearAction) forControlEvents:UIControlEventTouchUpInside];
    
    UIImageView *down2 = [[UIImageView alloc] initWithFrame:CGRectMake((SCREEN_W-30-40)/2-35, 0, 30, 40)];
    down2.image = [UIImage imageNamed:@"下拉"];
    down2.contentMode = UIViewContentModeCenter;
    [_year addSubview:down2];
    [self.view addSubview:_year];
    
    UILabel *zip = [[UILabel alloc] initWithFrame:CGRectMake(15, 299, 150, 14)];
    zip.textAlignment = 0 ;
    zip.font = FONT_12;
    zip.textColor = COLOR_3;
    zip.text = @"Zip/Postal Code";
    [self.view addSubview:zip];
    
    _zip = [[UITextField alloc] initWithFrame:CGRectMake(15, 318, SCREEN_W - 30, 40)];
    _zip.font = FONT_14;
    _zip.placeholder = @"Zip/Postal Code";
    _zip.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 7, 40)];
    _zip.leftViewMode = UITextFieldViewModeAlways;
    _zip.layer.borderWidth = 0.5;
    _zip.layer.borderColor = [COLOR_D CGColor];
    [self.view addSubview:_zip];
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 373, SCREEN_W, 42.5)];
    view.backgroundColor = COLOR_FA;
    [self.view addSubview:view];
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(15, 24, SCREEN_W-30, 0.5)];
    line.backgroundColor = COLOR_9;
    [view addSubview:line];
    UILabel *the = [[UILabel alloc] initWithFrame:CGRectMake((SCREEN_W-150)/2, 15, 150, 17)];
    the.font = FONT_15;
    the.textColor = COLOR_9;
    the.backgroundColor = COLOR_FA;
    the.text = @"The other method";
    [view addSubview:the];
    
    _paypal = [[LJButton alloc] initWithFrame:CGRectMake(0, 415, SCREEN_W, 42.5)];
    [self.view addSubview:_paypal];
    UIImageView *right = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_W - 15-20.5, 15, 20.5, 20.5)];
    right.image = [UIImage imageNamed:@"xuanzhong"];
    [_paypal addTapBlock:^(UIButton *btn) {
        if (!btn.selected) {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"If you choose to continue with paypal then any information about your credit card will be deleted."
                                                                           message:nil
                                                                    preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK"
                                                             style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                                                                 btn.selected = YES;
                                                                 [btn addSubview:right];
                                                                 weakSelf.card.text = @"";
                                                                 [weakSelf.year setTitle:@"" forState:UIControlStateNormal];
                                                                 [weakSelf.month setTitle:@"" forState:UIControlStateNormal];
                                                                 weakSelf.code.text = @"";
                                                                 weakSelf.zip.text = @"";
                                                                 //发送请求
                                                                 [weakSelf changePaymentMethod:@"1"];
                                                             }];
            [alert addAction:action];
            UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"cancel"
                                                             style:UIAlertActionStyleCancel
                                                           handler:nil];
            [alert addAction:cancel];
            [weakSelf presentViewController:alert animated:YES completion:nil];
        }else{
            btn.selected = NO;
            [right removeFromSuperview];
            //发送请求
            [weakSelf changePaymentMethod:@"2"];
        }
    }];
    UIImageView *pay = [[UIImageView alloc] initWithFrame:CGRectMake(23.5, 13.5, 23, 23)];
    pay.image = [UIImage imageNamed:@"WechatIMG7"];
    [_paypal addSubview:pay];
    UILabel *payPal = [[UILabel alloc] initWithFrame:CGRectMake(56.5, 17.5, 50, 15.5)];
    [payPal sizeToFit];
    payPal.text = @"PayPal";
    payPal.font = FONT_13;
    payPal.textColor = COLOR_3;
    [_paypal addSubview:payPal];
    
    UIView *aview = [[UIView alloc] initWithFrame:CGRectMake(0, 415.5+50, SCREEN_W, 31.5)];
    aview.backgroundColor = COLOR_FA;
    [self.view addSubview:aview];
    
    UIView *bottom = [[UIView alloc] initWithFrame:CGRectMake(0, 497, SCREEN_W, SCREEN_H-64-49-497)];
    bottom.backgroundColor = [UIColor colorWithHexString:@"#EEEEEE"];
    [self.view addSubview:bottom];
    
    UILabel *trust = [[UILabel alloc] initWithFrame:CGRectMake(21.5, 18.5, SCREEN_W-43, 18.5)];
    trust.textColor = COLOR_6;
    trust.text = @"Trusted by over 11 million shoppers in fifteen countries.";
    trust.font = FONT_13;
    [bottom addSubview:trust];
    
    UIImageView *flower = [[UIImageView alloc] initWithFrame:CGRectMake(11.5, 470, 59.5, 59.5)];
    flower.image = [UIImage imageNamed:@"圆章"];
    [self.view addSubview:flower];
    
    UIButton *save = [[UIButton alloc] initWithFrame:CGRectMake(0, SCREEN_H - 64-49, SCREEN_W, 49)];
    save.backgroundColor = COLOR_RED;
    [save setTitle:@"Save" forState:UIControlStateNormal];
    if (_next) {
        [save setTitle:@"Save the info and continue" forState:UIControlStateNormal];
    }
    save.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:15];
    [save addTarget:self action:@selector(saveButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:save];
    
    if (self.add==NO) {
        [self getdata];
    }
}

#pragma mark - 修改支付方式
- (void)changePaymentMethod:(NSString *)method {
    NSDictionary *dict = @{@"payment":method};
    [PHPNetwork PHPNetworkWithParam:dict andUrl:SETPAYMENT_URL andSignature:YES andLogin:YES finish:^(NSURLSessionDataTask *task, id responseObject) {
        
    } err:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}

- (void)getdata {
    if (self.credit_id.length==0) {
        return;
    }
    NSDictionary *dict = @{@"credit_id":self.credit_id};
    [PHPNetwork PHPNetworkWithParam:dict andUrl:CARDINFO_URL andSignature:YES andLogin:YES finish:^(NSURLSessionDataTask *task, id responseObject) {
        NSDictionary *dict = [responseObject valueForKey:@"data"];
        _card.text = [dict valueForKey:@"card_number"];
        [_year setTitle:[dict valueForKey:@"card_year"] forState:UIControlStateNormal];
        [_month setTitle:[dict valueForKey:@"card_month"] forState:UIControlStateNormal];
        _code.text = [dict valueForKey:@"card_cvv"];
        _zip.text = [dict valueForKey:@"zip_code"];
    } err:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}

- (void)textFieldDidChange:(UITextField *)text {
    if (text.text.length==0) {
        _lock.image = [UIImage imageNamed:@"锁 copy"];
    }else{
        _lock.image = [UIImage imageNamed:@"锁子"];
    }
}

- (void)saveButtonAction {
    if (_paypal.selected) {
        GPlaceOrderViewController *vc = [[GPlaceOrderViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }
    if (_card.text.length!=0&&_code.text.length!=0&&_year.titleLabel.text.length!=0&&_month.titleLabel.text.length!=0&&_zip.text.length!=0) {
        if (_add) {
            [self addCard];
        }else{
            [self editCard];
        }
    }else{
        [MBManager showBriefAlert:@"Please complete all the information"];
    }
}

- (void)addCard {
    NSString *time = [self getCurrentTimestamp];
    NSArray *arr = @[@"appKey",@"apiKey",@"timestamp",@"token",@"email",@"equipment_id",@"card_number",@"card_month",@"card_year",@"card_cvv",@"zip_code",@"set_default"];
    NSDictionary *dic = @{@"email" : CWEMAIL,
                          @"appKey" : APPKEY,
                          @"apiKey" : APIKEY,
                          @"equipment_id" : MYDEVICEID,
                          @"timestamp" : time,
                          @"token" : CWTOKEN,
                          @"card_number" : _card.text,
                          @"card_month" : _month.titleLabel.text,
                          @"card_year" :_year.titleLabel.text,
                          @"card_cvv": _code.text,
                          @"zip_code":_zip.text,
                          @"set_default":@"1"
                          };
    NSArray *sortedArray = [arr sortedArrayUsingSelector:@selector(compare:)];
    NSMutableString *str = [[NSMutableString alloc] init];
    for ( int i = 0; i < sortedArray.count; i++)
    {
        [str appendString:sortedArray[i]];
        [str appendString:[dic objectForKey:sortedArray[i]]];
    }
    NSString *strMD5 = [str md5_32bit];
    NSString *signature = [strMD5 sha1];
    
    NSMutableDictionary *parameters = [dic mutableCopy];
    [parameters setObject:signature forKey:@"signature"];
    
    [[CWAPIClient sharedClient] POSTRequest:ADDCREDITCART_URL parameters:parameters progress:nil success:^(NSURLSessionDataTask *task, id responseObject)
     {
         GPlaceOrderViewController *vc = [[GPlaceOrderViewController alloc] init];
         if (_next) {
             vc.from = EDITCART;
             [self changePaymentMethod:@"2"];
         }
         [self.navigationController pushViewController:vc animated:YES];
     } failure:^(NSURLSessionDataTask *task, NSError *error)
     {
         LJLog(@"%@",error);
     }];
}

- (void)editCard {
    NSString *time = [self getCurrentTimestamp];
    NSArray *arr = @[@"appKey",@"apiKey",@"timestamp",@"token",@"email",@"equipment_id",@"card_number",@"card_month",@"card_year",@"card_cvv",@"zip_code",@"set_default"];
    NSDictionary *dic = @{@"email" : CWEMAIL,
                          @"appKey" : APPKEY,
                          @"apiKey" : APIKEY,
                          @"equipment_id" : MYDEVICEID,
                          @"timestamp" : time,
                          @"token" : CWTOKEN,
                          @"card_number" : _card.text,
                          @"card_month" : _month.titleLabel.text,
                          @"card_year" :_year.titleLabel.text,
                          @"card_cvv": _code.text,
                          @"zip_code":_zip.text,
                          @"set_default":@"1"
                          };
    NSArray *sortedArray = [arr sortedArrayUsingSelector:@selector(compare:)];
    NSMutableString *str = [[NSMutableString alloc] init];
    for ( int i = 0; i < sortedArray.count; i++)
    {
        [str appendString:sortedArray[i]];
        [str appendString:[dic objectForKey:sortedArray[i]]];
    }
    NSString *strMD5 = [str md5_32bit];
    NSString *signature = [strMD5 sha1];
    
    NSMutableDictionary *parameters = [dic mutableCopy];
    [parameters setObject:signature forKey:@"signature"];
    
    [[CWAPIClient sharedClient] POSTRequest:EDITCREDitCART_URL parameters:parameters progress:nil success:^(NSURLSessionDataTask *task, id responseObject)
     {
         GPlaceOrderViewController *vc = [[GPlaceOrderViewController alloc] init];
         [self.navigationController pushViewController:vc animated:YES];
     } failure:^(NSURLSessionDataTask *task, NSError *error)
     {
         LJLog(@"%@",error);
     }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)cancelItemAction {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

- (void)chooseMonthAction {
    NSDate *date =[NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    
    [formatter setDateFormat:@"yyyy"];
    NSInteger currentYear=[[formatter stringFromDate:date] integerValue];
    [formatter setDateFormat:@"MM"];
    NSInteger currentMonth=[[formatter stringFromDate:date] integerValue];
    NSMutableArray *arr = [NSMutableArray array];
    if (currentYear == [_year.titleLabel.text integerValue]) {
        for (NSInteger i = currentMonth; i < 13; i++) {
            [arr addObject:[NSString stringWithFormat:@"%ld", i]];
        }
    }else{
        arr = [@[@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"11",@"12"] mutableCopy];
    }
    NSArray *array = [arr copy];
    ZHPickView *pickView = [[ZHPickView alloc] init];
    [pickView setDataViewWithItem:array title:@"Month"];
    [pickView showPickView:self];
    pickView.block = ^(NSString *month){
        [_month setTitle:[NSString stringWithFormat:@"%@", month] forState:UIControlStateNormal];
    };
    [self.view endEditing:YES];
}

- (void)chooseYearAction {
    NSDate *date =[NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy"];
    NSInteger currentYear=[[formatter stringFromDate:date] integerValue];
    ZHPickView *pickView = [[ZHPickView alloc] init];
    NSMutableArray *arr = [NSMutableArray array];
    for (int i = 0; i < 20; i++) {
        [arr addObject:[NSString stringWithFormat:@"%ld", (currentYear + i)]];
    }
    NSArray *array = [arr copy];
    [pickView setDataViewWithItem:array title:@"Year"];
    [pickView showPickView:self];
    pickView.block = ^(NSString *year){
        NSRange range = NSMakeRange(2, 2);
        NSString *str = [year substringWithRange:range];
        [_year setTitle:[NSString stringWithFormat:@"%@", str] forState:UIControlStateNormal];
    };
    [self.view endEditing:YES];
}


@end
