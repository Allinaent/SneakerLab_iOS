//
//  EditPayInfoView.m
//  SneakerLab
//
//  Created by Jason cao on 2016/10/10.
//  Copyright © 2016年 Jason cao. All rights reserved.
//

#import "EditPayInfoView.h"
#import "ShopViewController.h"
#import "ZHPickView.h"

@interface EditPayInfoView ()<UITextFieldDelegate>

@end

@implementation EditPayInfoView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        [self createUI];
        [self getData];
    }
    return self;
}

- (void)createUI
{
    self.backgroundColor = [UIColor whiteColor];
    
   UILabel *label1 = [FactoryUI createLabelWithFrame:CGRectMake(15, 15, 60, 20) text:@"Bill to:" textColor:[UIColor blackColor] font:[UIFont boldSystemFontOfSize:13]];
   [self addSubview:label1];
    
    UIButton *cancelBtn = [FactoryUI createButtonWithFrame:CGRectMake(SCREEN_W - 55, 15, 40, 20) title:@"cancel" titleColor:[UIColor colorWithRed:0.3 green:0.3 blue:0.3 alpha:1] imageName:nil backgroundImageName:nil target:self selector:@selector(cancelAction)];
    cancelBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [self addSubview:cancelBtn];
    
    UILabel *label2 = [FactoryUI createLabelWithFrame:CGRectMake(15, 35, 100, 20) text:@"Miscellaneous" textColor:[UIColor blackColor] font:[UIFont systemFontOfSize:13]];
    [self addSubview:label2];
    
    
    _creditCardTF= [[UITextField alloc] initWithFrame:CGRectMake(15, 65, SCREEN_W - 35, 30)];
    _creditCardTF.placeholder = @"Card Number";
    _creditCardTF.keyboardType = UIKeyboardTypeNumberPad;
    _creditCardTF.layer.borderWidth = 1;
    _creditCardTF.layer.borderColor = [UIColor colorWithHexString:@"#DDDDDD"].CGColor;
    _creditCardTF.borderStyle = UITextBorderStyleRoundedRect;
    _creditCardTF.delegate = self;
    [self addSubview:_creditCardTF];
    
    UIImageView *imageView = [FactoryUI createImageViewWithFrame:CGRectMake(SCREEN_W - 70, 65, 40, 30) imageName:@""];
    [self addSubview:imageView];
    
    UILabel *label3 = [FactoryUI createLabelWithFrame:CGRectMake(15, 95, 100, 30) text:@"Security Code" textColor:[UIColor blackColor] font:[UIFont systemFontOfSize:13]];
    [self addSubview:label3];
    
    UILabel *label4 = [FactoryUI createLabelWithFrame:CGRectMake(15, 115, SCREEN_W, 60) text:@"The 3 or 4 digit security code on the front or back of your credit card" textColor:[UIColor lightGrayColor] font:[UIFont systemFontOfSize:12]];
    [self addSubview:label4];
    
    _codeTF = [[UITextField alloc] initWithFrame:CGRectMake(200, 105, SCREEN_W - 220, 30)];
    _codeTF.placeholder = @"CVV";
    _codeTF.delegate = self;
    _codeTF.layer.borderWidth = 1;
    _codeTF.keyboardType = UIKeyboardTypeNumberPad;
    _codeTF.layer.borderColor = [UIColor colorWithHexString:@"#DDDDDD"].CGColor;
    _codeTF.borderStyle = UITextBorderStyleRoundedRect;
    [self addSubview:_codeTF];
    
    UILabel *label5 = [FactoryUI createLabelWithFrame:CGRectMake(15, 165, 100, 30) text:@"Expiry date" textColor:[UIColor blackColor] font:[UIFont systemFontOfSize:13]];
    [self addSubview:label5];
    
    _dateTF = [[UITextField alloc] initWithFrame:CGRectMake(200, 165, SCREEN_W - 220, 30)];
    _dateTF.placeholder = @"MM";
    _dateTF.delegate = self;
    _dateTF.keyboardType = UIKeyboardTypeNumberPad;
    _dateTF.layer.borderWidth = 1;
    _dateTF.layer.borderColor = [UIColor colorWithHexString:@"#DDDDDD"].CGColor;
    _dateTF.borderStyle = UITextBorderStyleRoundedRect;
    _dateTF.allowsEditingTextAttributes = NO;
    UIImageView *downView = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_W-220-30, 0, 30, 30)];
    downView.image = [UIImage imageNamed:@"下拉"];
    downView.contentMode = UIViewContentModeCenter;
    [_dateTF addSubview:downView];
    [self addSubview:_dateTF];
    UIButton *button1 = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W-220, 30)];
    button1.backgroundColor = [UIColor clearColor];
    [_dateTF addSubview:button1];
    [button1 addTarget:self action:@selector(chooseYearAction) forControlEvents:UIControlEventTouchUpInside];
    
    _dateTF2 = [[UITextField alloc] initWithFrame:CGRectMake(200, 205, SCREEN_W - 220, 30)];
    _dateTF2.placeholder = @"YYYY";
    _dateTF2.delegate = self;
    _dateTF2.keyboardType = UIKeyboardTypeNumberPad;
    _dateTF2.layer.borderWidth = 1;
    _dateTF2.layer.borderColor = [UIColor colorWithHexString:@"#DDDDDD"].CGColor;
    _dateTF2.borderStyle = UITextBorderStyleRoundedRect;
    _dateTF2.allowsEditingTextAttributes = NO;
    UIImageView *downView2 = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_W-220-30, 0, 30, 30)];
    downView2.image = [UIImage imageNamed:@"下拉"];
    downView2.contentMode = UIViewContentModeCenter;
    [_dateTF2 addSubview:downView2];
    UIButton *button2 = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W-220, 30)];
    button2.backgroundColor = [UIColor clearColor];
    [_dateTF2 addSubview:button2];
    [self addSubview:_dateTF2];
    [button2 addTarget:self action:@selector(chooseMonthAction) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *label6 = [FactoryUI createLabelWithFrame:CGRectMake(15, 245, 150, 30) text:@"Billing Zip/Postal Code" textColor:[UIColor blackColor] font:[UIFont systemFontOfSize:13]];
    label6.numberOfLines = 0;
    [self addSubview:label6];
    UILabel *label7 = [FactoryUI createLabelWithFrame:CGRectMake(15, 275, SCREEN_W, 40) text:@"The zip postal code from the address registered for this credit card" textColor:[UIColor lightGrayColor] font:[UIFont systemFontOfSize:12]];
    label7.numberOfLines = 0;
    [self addSubview:label7];
    
    _postalCodeTF = [[UITextField alloc] initWithFrame:CGRectMake(200, 245, SCREEN_W -220, 30)];
    _postalCodeTF.placeholder = @"Zip/Postal Code";
    _postalCodeTF.delegate = self;
    _postalCodeTF.layer.borderWidth = 1;
    _postalCodeTF.layer.borderColor = [UIColor colorWithHexString:@"#DDDDDD"].CGColor;
    _postalCodeTF.keyboardType = UIKeyboardTypeNumberPad;
    _postalCodeTF.borderStyle = UITextBorderStyleRoundedRect;
    [self addSubview:_postalCodeTF];
    
    //UIButton *saveBtn = [FactoryUI createButtonWithFrame:CGRectMake(15, 335, SCREEN_W - 30, 40) title:@"Save payment Info" titleColor:[UIColor whiteColor] imageName:nil backgroundImageName:nil target:self selector:@selector(Savepayment)];
    UIView *gray = [[UIView alloc] initWithFrame:CGRectMake(0, 315, SCREEN_W, 42.5)];
    gray.backgroundColor = COLOR_FA;
    [self addSubview:gray];
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(15.5, 24, SCREEN_W-31, 0.5)];
    line.backgroundColor = COLOR_9;
    [gray addSubview:line];
    UILabel *method = [[UILabel alloc] initWithFrame:CGRectMake((SCREEN_W-150)/2, 15, 150, 17.5)];
    method.backgroundColor = COLOR_FA;
    method.text = @"The other method";
    method.textColor = COLOR_9;
    method.font = FONT_15;
    method.textAlignment = 1;
    
    UIButton *saveBtn = [FactoryUI createButtonWithFrame:CGRectMake(15, SCREEN_H-49, SCREEN_W - 30, 49) title:@"Save payment Info" titleColor:[UIColor whiteColor] imageName:nil backgroundImageName:nil target:self selector:@selector(Savepayment)];
    saveBtn.backgroundColor = [UIColor colorWithHexString:@"#de4536"];
    //saveBtn.layer.cornerRadius = 4;
    [self addSubview:saveBtn];
    
    UIImageView *imageView1 = [FactoryUI createImageViewWithFrame:CGRectMake(15, 405, 30, 30) imageName:@"锁"];
    imageView1.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:imageView1];
    
    UILabel *label8 = [FactoryUI createLabelWithFrame:CGRectMake(55, 395, 100, 30) text:@"Secure Payment" textColor:[UIColor lightGrayColor] font:[UIFont boldSystemFontOfSize:12]];
    [self addSubview:label8];
    
    UILabel *label9 = [FactoryUI createLabelWithFrame:CGRectMake(55, 415, SCREEN_W, 30) text:@"Trusted by over 100 milllion shoppers in 50 countries" textColor:[UIColor lightGrayColor] font:[UIFont systemFontOfSize:12]];
    label9.numberOfLines = 1;
    [self addSubview:label9];
}

-(void)setModel:(PayModel *)model{
    _model = model;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if (textField == _dateTF||textField == _dateTF2 ) {
        return NO;
    }
    return YES;
}

// 点击上传(从购物车页面获取到是不是填写过信用卡信息)
- (void)Savepayment{
    id card = [[NSUserDefaults standardUserDefaults]objectForKey:UD_CARD];
    if (_creditCardTF.text.length!=0&&_codeTF.text.length!=0&&_dateTF.text.length!=0&&_dateTF2.text.length!=0&&_postalCodeTF.text.length!=0) {
        if (card != nil) {
            [self editData];
        }else{
            [self UploadData];
        }
    }else{
        [MBManager showBriefMessage:@"Please complete all the information" InView:self];
    }
}

#pragma mark - 编辑信用卡
-(void)editData{
    NSString *time = [self getCurrentTimestamp];
    NSArray *arr = @[@"appKey",@"apiKey",@"timestamp",@"token",@"email",@"equipment_id",@"card_number",@"card_month",@"card_year",@"card_cvv",@"zip_code"];
    NSDictionary *dic = @{@"email" : CWEMAIL,
                          @"appKey" : APPKEY,
                          @"apiKey" : APIKEY,
                          @"equipment_id" : MYDEVICEID,
                          @"timestamp" : time,
                          @"token" : CWTOKEN,
                          @"card_number" : _creditCardTF.text,
                          @"card_month" : _dateTF.text,
                          @"card_year" :_dateTF2.text,
                          @"card_cvv": _codeTF.text,
                          @"zip_code":_postalCodeTF.text,
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
         [MBManager showBriefMessage:@"success" InView:self.superview];
         [UIView animateWithDuration:0.35 animations:^{
             self.frame = CGRectMake(0, SCREEN_H, SCREEN_W, SCREEN_H);
         }];
         [self endEditing:YES];
         ShopViewController *vc = (ShopViewController *)[self LJContentController];
         [vc LoadData];
     } failure:^(NSURLSessionDataTask *task, NSError *error)
     {
         NSLog(@"%@",error);
     }];
}

#pragma mark - 获取信用卡信息
-(void)getData {
    [PHPNetwork PHPNetworkWithParam:nil andUrl:GETCREDITCART_URL andSignature:YES andLogin:YES finish:^(NSURLSessionDataTask *task, id responseObject) {
        NSDictionary *dic = [responseObject valueForKey:@"data"];
        _creditCardTF.text = [dic valueForKey:@"card_number"];
        _codeTF.text = [dic valueForKey:@"card_cvv"];
        _dateTF.text = [dic valueForKey:@"card_month"];
        _dateTF2.text = [dic valueForKey:@"card_year"];
        _postalCodeTF.text = [dic valueForKey:@"zip_code"];
    } err:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}

#pragma mark - 添加信用卡
-(void)UploadData{
    NSString *time = [self getCurrentTimestamp];
    NSArray *arr = @[@"appKey",@"apiKey",@"timestamp",@"token",@"email",@"equipment_id",@"card_number",@"card_month",@"card_year",@"card_cvv",@"zip_code"];
    NSDictionary *dic = @{@"email" : CWEMAIL,
                          @"appKey" : APPKEY,
                          @"apiKey" : APIKEY,
                          @"equipment_id" : MYDEVICEID,
                          @"timestamp" : time,
                          @"token" : CWTOKEN,
                          @"card_number" : _creditCardTF.text,
                          @"card_month" : _dateTF.text,
                          @"card_year" :_dateTF2.text,
                          @"card_cvv": _codeTF.text,
                          @"zip_code":_postalCodeTF.text,
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
         //设置成功(提示)
         [MBManager showBriefMessage:@"success" InView:self.superview];
         [self cancelAction];
        ShopViewController *vc = (ShopViewController *)[self LJContentController];
        [vc LoadData];
    } failure:^(NSURLSessionDataTask *task, NSError *error)
    {
         LJLog(@"%@",error);
    }];
}

- (void)cancelAction
{
    [UIView animateWithDuration:0.35 animations:^{
        self.frame = CGRectMake(0, SCREEN_H, SCREEN_W, SCREEN_H);
    }];
    [self endEditing:YES];
}

-(BOOL) textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self endEditing:YES];
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    NSCharacterSet *cs;
    if(textField ==_dateTF)
    {
        cs = [[NSCharacterSet characterSetWithCharactersInString:NUMBERS] invertedSet];
        NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
        BOOL basicTest = [string isEqualToString:filtered];
        if(!basicTest)
        {
            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                            message:@"请输入00/00"
                                                           delegate:nil
                                                  cancelButtonTitle:@"确定"
                                                  otherButtonTitles:nil];
            [alert show];
            return NO;
        }
        
    }
    return YES;
}

- (void)chooseYearAction {
    NSDate *date =[NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    
    [formatter setDateFormat:@"yyyy"];
    NSInteger currentYear=[[formatter stringFromDate:date] integerValue];
    [formatter setDateFormat:@"MM"];
    NSInteger currentMonth=[[formatter stringFromDate:date] integerValue];
    NSMutableArray *arr = [NSMutableArray array];
    if (currentYear == [_dateTF.text integerValue]) {
        for (NSInteger i = currentMonth; i < 13; i++) {
            [arr addObject:[NSString stringWithFormat:@"%ld", i]];
        }
    }else{
        arr = [@[@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"11",@"12"] mutableCopy];
    }
    NSArray *array = [arr copy];
    ZHPickView *pickView = [[ZHPickView alloc] init];
    [pickView setDataViewWithItem:array title:@"Month"];
    [pickView showPickView:[self LJContentController]];
    pickView.block = ^(NSString *month){
        _dateTF.text = month;
    };
    [self endEditing:YES];
}

- (void)chooseMonthAction {
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
    [pickView showPickView:[self LJContentController]];
    pickView.block = ^(NSString *year){
        NSRange range = NSMakeRange(2, 2);
        NSString *str = [year substringWithRange:range];
        _dateTF2.text = str;
    };
    [self endEditing:YES];
}

@end
