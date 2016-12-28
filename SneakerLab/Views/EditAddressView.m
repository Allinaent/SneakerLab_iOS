//
//  EditAddressView.m
//  SneakerLab
//
//  Created by Jason cao on 2016/10/10.
//  Copyright © 2016年 Jason cao. All rights reserved.
//

#import "EditAddressView.h"
#import "MyPickView.h"
#import "ShopViewController.h"
@implementation EditAddressView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        [self careteUI];
    }
    return self;
}


- (void)careteUI
{
    self.backgroundColor = [UIColor whiteColor];
    
    UILabel *label1 = [FactoryUI createLabelWithFrame:CGRectMake(15, 15, 60, 20) text:@"Ship to:" textColor:[UIColor blackColor] font:[UIFont boldSystemFontOfSize:13]];
    [self addSubview:label1];
    
    UIButton *cancelBtn = [FactoryUI createButtonWithFrame:CGRectMake(SCREEN_W - 55, 15, 40, 20) title:@"cancel" titleColor:[UIColor colorWithRed:0.3 green:0.3 blue:0.3 alpha:1] imageName:nil backgroundImageName:nil target:self selector:@selector(cancelAction)];
    cancelBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [self addSubview:cancelBtn];
    
    UILabel *label2 = [FactoryUI createLabelWithFrame:CGRectMake(15, 40, 200, 20) text:@"*Indicates a field is required" textColor:[UIColor blackColor] font:[UIFont systemFontOfSize:12]];
    [self addSubview:label2];
    
    _nameTF = [[UITextField alloc] initWithFrame:CGRectMake(15, 70, SCREEN_W - 30, 30)];
    _nameTF.placeholder = @"Bay";
    _nameTF.delegate = self;
    _nameTF.borderStyle = UITextBorderStyleRoundedRect;
    [self addSubview:_nameTF];
    
    _addressTF = [[UITextField alloc] initWithFrame:CGRectMake(15, 110, SCREEN_W - 30, 30)];
    _addressTF.placeholder = @"Street Address*";
    _addressTF.delegate = self;
    _addressTF.borderStyle = UITextBorderStyleRoundedRect;
    [self addSubview:_addressTF];
    
    
    _aptTF = [[UITextField alloc] initWithFrame:CGRectMake(15, 150, SCREEN_W - 30, 30)];
    _aptTF.placeholder = @"Apt/Suite/Unit(Optional)";
    _aptTF.delegate = self;
    _aptTF.borderStyle = UITextBorderStyleRoundedRect;
    [self addSubview:_aptTF];
    
    _countryTF = [[UIButton alloc] initWithFrame:CGRectMake(15, 190, 150, 30)];
    _countryTF.zhw_ignoreEvent = NO;
    _countryTF.zhw_acceptEventInterval = 3;
    _countryTF.backgroundColor = [UIColor lightGrayColor];
    [_countryTF setTitle:@"Country*" forState:UIControlStateNormal];
    [_countryTF addTarget:self action:@selector(chooseCountry) forControlEvents:UIControlEventTouchDown];
    [self addSubview:_countryTF];
    
    _stateTF = [[UIButton alloc] initWithFrame:CGRectMake(170, 190, SCREEN_W - 185, 30)];
    _stateTF.zhw_ignoreEvent = NO;
    _stateTF.zhw_acceptEventInterval = 3;
    [_stateTF setTitle:@"State(Optional)" forState:UIControlStateNormal];
    _stateTF.backgroundColor = [UIColor lightGrayColor];

    [_stateTF addTarget:self action:@selector(chooseState) forControlEvents:UIControlEventTouchDown];
    [self addSubview:_stateTF];
    
    _cityTF = [[UITextField alloc] initWithFrame:CGRectMake(15, 230, SCREEN_W - 30, 30)];
    _cityTF.placeholder = @"City*";
    _cityTF.delegate = self;
    _cityTF.borderStyle = UITextBorderStyleRoundedRect;
    [self addSubview:_cityTF];
    
    _codeTF = [[UITextField alloc] initWithFrame:CGRectMake(15, 270, 150, 30)];
    _codeTF.placeholder = @"Zip/Postal Code*";
    _codeTF.keyboardType = UIKeyboardTypeNumberPad;
    _codeTF.borderStyle = UITextBorderStyleRoundedRect;
    _codeTF.delegate = self;
    [self addSubview:_codeTF];
    
    _phoneTF = [[UITextField alloc] initWithFrame:CGRectMake(170, 270, SCREEN_W - 185, 30)];
    _phoneTF.placeholder = @"Phone Number*";
    _phoneTF.delegate = self;
    _phoneTF.borderStyle = UITextBorderStyleRoundedRect;
    [self addSubview:_phoneTF];
    
    UIButton *placeOrderBtn = [FactoryUI createButtonWithFrame:CGRectMake(15, 340, SCREEN_W - 30, 40) title:@"Save shipping  Info" titleColor:[UIColor whiteColor] imageName:nil backgroundImageName:nil target:self selector:@selector(placeOrder)];
    placeOrderBtn.backgroundColor = [UIColor colorWithHexString:@"#de4536"];
    [self addSubview:placeOrderBtn];
}

-(void)setModel:(AddressModel *)model{
    _model = model;
    _phoneTF.text = model.phone;
}

- (void)placeOrder
{
    id address = [[NSUserDefaults standardUserDefaults]objectForKey:UD_SHIPADDRESS];
    if (_nameTF.text.length!=0&&_addressTF.text.length!=0&&_cityTF.text.length!=0&&![_countryTF.titleLabel.text isEqualToString:@"Country*"]&&_codeTF.text.length!=0&&_phoneTF.text.length!=0) {
        if (address) {
            [self editData];
        }else{
            [self UploadData];
        }
    }else{
        [MBManager showBriefMessage:@"Please complete all the mandatory" InView:self];
    }
}

#pragma mark - 获取地址信息
- (void)getData {
    NSDictionary *dic = @{@"address_id":self.address_id};
    [PHPNetwork PHPNetworkWithParam:dic andUrl:GETADDRESS_URL andSignature:YES andLogin:YES finish:^(NSURLSessionDataTask *task, id responseObject) {
        NSDictionary *dic = [responseObject valueForKey:@"data"];
        _nameTF.text = [dic valueForKey:@"fullname"];
        _addressTF.text = [dic valueForKey:@"address_1"];
        _aptTF.text = [dic valueForKey:@"suite"];
        _cityTF.text = [dic valueForKey:@"city"];
        _codeTF.text = [dic valueForKey:@"postcode"];
        if ([dic valueForKey:@"country"]!=0) {
            [_countryTF setTitle:[dic valueForKey:@"country"] forState:UIControlStateNormal];
        }
        if ([dic valueForKey:@"zone"]!=0) {
            [_stateTF setTitle:[dic valueForKey:@"zone"] forState:UIControlStateNormal];
        }
        _address_id = [dic valueForKey:@"address_id"];
    } err:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}

#pragma mark - 添加地址信息
-(void)UploadData
{
    NSString *time = [self getCurrentTimestamp];
    NSArray *arr = @[@"appKey",@"apiKey",@"timestamp",@"equipment_id",@"fullname",@"phone",@"address",@"suite",@"city",@"postcode",@"country_id",@"zone_id",@"email",@"token"];
    NSDictionary *dic = @{@"appKey" : APPKEY,
                          @"apiKey" : APIKEY,
                          @"equipment_id" : MYDEVICEID,
                          @"timestamp" : time,
                          @"fullname" : _nameTF.text,
                          @"phone" : _phoneTF.text,
                          @"address" : _addressTF.text,
                          @"suite":_aptTF.text,
                          @"city" : _cityTF.text,
                          @"postcode" : _codeTF.text,
                          @"country_id" : _countryID,
                          @"zone_id" : _stateID,
                          @"email" : CWEMAIL,
                          @"token" : CWTOKEN
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
    [[CWAPIClient sharedClient] POSTRequest:ADDADDRESS_URL parameters:parameters progress:nil success:^(NSURLSessionDataTask *task, id responseObject)
     {
         [MBManager showBriefMessage:@"success" InView:self.superview];
         [self cancelAction];
     } failure:^(NSURLSessionDataTask *task, NSError *error)
     {
         LJLog(@"%@",error);
     }];
}

#pragma mark - 编辑地址信息
-(void)editData{
    NSString *time = [self getCurrentTimestamp];
    NSArray *arr = @[@"appKey",@"apiKey",@"timestamp",@"equipment_id",@"address_id",@"fullname",@"phone",@"address",@"suite",@"city",@"postcode",@"country_id",@"zone_id",@"email",@"token"];
    if (_cityTF.text.length==0) {
        _cityTF.text = @"";
    }
    if (_aptTF.text.length==0) {
        _aptTF.text = @"";
    }
    if (_stateID.length==0) {
        _stateID = @"";
    }
    NSDictionary *dic = @{@"appKey" : APPKEY,
                          @"apiKey" : APIKEY,
                          @"equipment_id" : MYDEVICEID,
                          @"timestamp" : time,
                          @"address_id":self.address_id,
                          @"fullname" : _nameTF.text,
                          @"phone" : _phoneTF.text,
                          @"address" : _addressTF.text,
                          @"suite":_aptTF.text,
                          @"city" : _cityTF.text,
                          @"postcode" : _codeTF.text,
                          @"country_id" : _countryID,
                          @"zone_id" : _stateID,
                          @"email" : CWEMAIL,
                          @"token" : CWTOKEN
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
    [[CWAPIClient sharedClient] POSTRequest:EDITADDRESS_URL parameters:parameters progress:nil success:^(NSURLSessionDataTask *task, id responseObject)
     {
         [MBManager showBriefMessage:@"success" InView:self.superview];
         [self cancelAction];
         
     } failure:^(NSURLSessionDataTask *task, NSError *error)
     {
         NSLog(@"%@",error);
     }];
}

- (void)cancelAction
{
    [UIView animateWithDuration:0.35 animations:^{
        self.frame = CGRectMake(0, SCREEN_H, SCREEN_W, SCREEN_H);
    }];
    ShopViewController *vc = (ShopViewController *)[self LJContentController];
    [vc LoadData];
}

- (UINavigationController*)NavViewController {
    for (UIView *next = [self superview]; next; next = next.superview) {
        UIResponder *nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UINavigationController class]]) {
            return (UINavigationController*)nextResponder;
        }
    }
    return nil;
}

- (void)chooseCountry
{
    for (UITextField * text in self.subviews) {
        [text resignFirstResponder];
    }
    [self loadCountry];
}

- (void)chooseState
{
    if (_countryID.length!=0) {
        for (UITextField * text in self.subviews) {
            [text resignFirstResponder];
        }
        [self loadState];
    }else{
        [MBManager showBriefMessage:@"Please choose the country first" InView:self];
    }
}

//做上传数据
- (void)commitAction
{
    NSString *time = [self getCurrentTimestamp];
    NSArray *arr = @[@"appKey",@"apiKey",@"timestamp",@"equipment_id",@"firstname",@"lastname",@"phone",@"address",@"city",@"postcode",@"country_id",@"zone_id",@"email",@"token"];
    NSDictionary *dic = @{@"appKey" : APPKEY,
                          @"apiKey" : APIKEY,
                          @"equipment_id" : MYDEVICEID,
                          @"timestamp" : time,
                          @"firstname" : _nameTF.text,
                          @"lastname" : _nameTF.text,
                          @"phone" : _phoneTF.text,
                          @"address" : _addressTF.text,
                          @"city" : _cityTF.text,
                          @"postcode" : _codeTF.text,
                          @"country_id" : _countryID,
                          @"zone_id" : _stateID,
                          @"email" : CWEMAIL,
                          @"token" : CWTOKEN
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
    [[CWAPIClient sharedClient] POSTRequest:ADDADDRESS_URL parameters:parameters progress:nil success:^(NSURLSessionDataTask *task, id responseObject)
     {
         
     } failure:^(NSURLSessionDataTask *task, NSError *error)
     {
         LJLog(@"%@",error);
     }];
}

- (void)loadCountry
{
    NSString *time = [self getCurrentTimestamp];
    NSArray *arr = @[@"appKey",@"apiKey",@"timestamp",@"equipment_id"];
    NSDictionary *dic = @{@"appKey" : APPKEY,
                          @"apiKey" : APIKEY,
                          @"equipment_id" : MYDEVICEID,
                          @"timestamp" : time
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
    
    [[CWAPIClient sharedClient] POSTRequest:COUNTRIES_URL parameters:parameters progress:nil success:^(NSURLSessionDataTask *task, id responseObject)
     {
         NSLog(@"%@",responseObject);
         NSMutableArray *countryArr = [NSMutableArray array];
         NSArray *arr = responseObject[@"data"];
         for (NSDictionary *dic in arr)
         {
             NSString *country = dic[@"name"];
             [countryArr addObject:country];
         }
         zySheetPickerView *pickerView = [zySheetPickerView ZYSheetStringPickerWithTitle:countryArr andHeadTitle:@"Choose Country" Andcall:^(zySheetPickerView *pickerView, NSString *choiceString) {
             [_countryTF setTitle:choiceString forState:UIControlStateNormal];
             for (NSInteger i = 0; i < arr.count; i++)
             {
                 if ([choiceString isEqualToString:arr[i][@"name"]])
                 {
                     _countryID = arr[i][@"country_id"];
                     break;
                 }
             }
             [pickerView dismissPicker];
         }];
         [pickerView show];
     } failure:^(NSURLSessionDataTask *task, NSError *error)
     {
         NSLog(@"%@",error);
     }];
}

- (void)loadState
{
    NSString *time = [self getCurrentTimestamp];
    NSArray *arr = @[@"appKey",@"apiKey",@"timestamp",@"equipment_id",@"country_id"];
    NSDictionary *dic = @{@"appKey" : APPKEY,
                          @"apiKey" : APIKEY,
                          @"equipment_id" : MYDEVICEID,
                          @"timestamp" : time,
                          @"country_id" : _countryID
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
    [[CWAPIClient sharedClient] POSTRequest:STATES_URL parameters:parameters progress:nil success:^(NSURLSessionDataTask *task, id responseObject)
     {
         NSLog(@"%@",responseObject);
         NSMutableArray *stateArr = [NSMutableArray array];
         NSArray *arr1 = responseObject[@"data"];
         for (NSDictionary *dic1 in arr1)
         {
             NSString *state1 = dic1[@"name"];
             [stateArr addObject: state1];
         }
         zySheetPickerView *pickView = [zySheetPickerView ZYSheetStringPickerWithTitle:stateArr andHeadTitle:@"Choose State" Andcall:^(zySheetPickerView *pickerView, NSString *choiceString) {
             [_stateTF setTitle:choiceString forState:UIControlStateNormal];
             for (NSInteger i = 0; i < arr1.count; i++)
             {
                 if ([choiceString isEqualToString:arr1[i][@"name"]])
                 {
                     _stateID = arr1[i][@"zone_id"];
                     break;
                 }
             }
             [pickerView  dismissPicker];
         }];
         [pickView  show];
     } failure:^(NSURLSessionDataTask *task, NSError *error)
     {
         NSLog(@"%@",error);
     }];
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


@end
