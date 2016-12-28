//
//  AddressInfoView.m
//  caowei
//
//  Created by Jason cao on 2016/9/14.
//  Copyright © 2016年 Jason cao. All rights reserved.
//

#import "AddressInfoView.h"
#import "OrderConfirmController.h"
#import "MyPickView.h"
@implementation AddressInfoView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        [self careteUI];
    }
    return self;
}

-(void)setAptTF:(UITextField *)aptTF {
    _aptTF = aptTF;
}

-(void)setCityTF:(UITextField *)cityTF {
    _cityTF = cityTF;
}

-(void)setCodeTF:(UITextField *)codeTF {
    _codeTF = codeTF;
}

-(void)setNameTF:(UITextField *)nameTF {
    _nameTF = nameTF;
}

-(void)setPhoneTF:(UITextField *)phoneTF {
    _phoneTF = phoneTF;
}

-(void)setStateTF:(UITextField *)stateTF {
    _stateTF = stateTF;
}

- (void)careteUI
{
    self.backgroundColor = [UIColor whiteColor];
    UILabel *label1 = [FactoryUI createLabelWithFrame:CGRectMake(15, 10, 60, 16.5) text:@"Bill To:" textColor:[UIColor blackColor] font:[UIFont systemFontOfSize:14]];
    [self addSubview:label1];
    
    UIButton *cancelBtn = [FactoryUI createButtonWithFrame:CGRectMake(SCREEN_W - 55, 15, 40, 20) title:@"cancel" titleColor:[UIColor colorWithRed:0.3 green:0.3 blue:0.3 alpha:1] imageName:nil backgroundImageName:nil target:self selector:@selector(cancelAction)];
    cancelBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [self addSubview:cancelBtn];

    UILabel *label2 = [FactoryUI createLabelWithFrame:CGRectMake(15, 36.5, 200, 14) text:@"*Indicates a field is required" textColor:[UIColor blackColor] font:[UIFont systemFontOfSize:12]];
    [self addSubview:label2];
    NSString * fullname = [[NSUserDefaults standardUserDefaults]objectForKey:@"fullname"];
    _nameTF= [[UITextField alloc] initWithFrame:CGRectMake(15, 55, SCREEN_W - 30, 32)];
    _nameTF.placeholder = @"  Name*";
    _nameTF.delegate = self;
    _nameTF.text = fullname;
    _nameTF.layer.borderColor = [UIColor colorWithHexString:@"#dddddd"].CGColor;
    _nameTF.layer.borderWidth = 0.5;
    [self addSubview:_nameTF];
    /*
     view1.nameTF.text = address[@"fullname"];
     view1.addressTF.text = address[@"address_1"];
     view1.aptTF.text = address[@"suite"];
     view1.countryTF.text = address[@"country_id"];
     view1.cityTF.text = address[@"city"];
     view1.codeTF.text = address[@"postcode"];
     view1.phoneTF.text = address[@"phone"];
     */
    NSString * address_1 = [[NSUserDefaults standardUserDefaults]objectForKey:@"address_1"];
    _addressTF = [[UITextField alloc] initWithFrame:CGRectMake(15, 97, SCREEN_W - 30, 32)];
    _addressTF.placeholder = @"  Street Address*";
    _addressTF.delegate = self;
    _addressTF.text = address_1;
    _addressTF.layer.borderColor = [UIColor colorWithHexString:@"#dddddd"].CGColor;
    _addressTF.layer.borderWidth = 0.5;
    [self addSubview:_addressTF];
    NSString * suite = [[NSUserDefaults standardUserDefaults]objectForKey:@"suite"];
    _aptTF = [[UITextField alloc] initWithFrame:CGRectMake(15, 150, SCREEN_W - 30, 32)];
    _aptTF.placeholder = @"  Apt/Suite/Unit(Optional)";
    _aptTF.delegate = self;
    _aptTF.text = suite;
    _aptTF.layer.borderColor = [UIColor colorWithHexString:@"#dddddd"].CGColor;
    _aptTF.layer.borderWidth = 0.5;
    [self addSubview:_aptTF];
    _countryTF = [[UITextField alloc] initWithFrame:CGRectMake(15, 192, 150, 32)];
    _countryTF.placeholder = @"  Country*";
    _countryTF.delegate = self;
    _countryTF.layer.borderColor = [UIColor colorWithHexString:@"#dddddd"].CGColor;
    _countryTF.layer.borderWidth = 0.5;
    [_countryTF addTarget:self action:@selector(chooseCountry:) forControlEvents:UIControlEventTouchDown];
    [self addSubview:_countryTF];
    
    UIImageView *image = [FactoryUI createImageViewWithFrame:CGRectMake(145, 200, 14, 14) imageName:@"下拉"];
    [self addSubview:image];
    _stateTF = [[UITextField alloc] initWithFrame:CGRectMake(170, 192, SCREEN_W - 185, 32)];
    _stateTF.placeholder = @"  State(Optional)";
    _stateTF.delegate = self;
    _stateTF.layer.borderColor = [UIColor colorWithHexString:@"#dddddd"].CGColor;
    _stateTF.layer.borderWidth = 0.5;
    [_stateTF addTarget:self action:@selector(chooseState) forControlEvents:UIControlEventTouchDown];
    [self addSubview:_stateTF];
    NSString * city = [[NSUserDefaults standardUserDefaults]objectForKey:@"city"];

    _cityTF = [[UITextField alloc] initWithFrame:CGRectMake(15, 234, SCREEN_W - 30, 32)];
    _cityTF.placeholder = @"  City*";
    _cityTF.delegate = self;
    _cityTF.text = city;
    _cityTF.layer.borderColor = [UIColor colorWithHexString:@"#dddddd"].CGColor;
    _cityTF.layer.borderWidth = 0.5;
    [self addSubview:_cityTF];
    NSString * postcode = [[NSUserDefaults standardUserDefaults]objectForKey:@"postcode"];
    

    _codeTF = [[UITextField alloc] initWithFrame:CGRectMake(15, 276, 150, 32)];
    _codeTF.placeholder = @"  Zip/Postal Code*";
    _codeTF.layer.borderColor = [UIColor colorWithHexString:@"#dddddd"].CGColor;
    _codeTF.text = postcode;
    _codeTF.layer.borderWidth = 0.5;
    _codeTF.delegate = self;
    [self addSubview:_codeTF];
     NSString * phone = [[NSUserDefaults standardUserDefaults]objectForKey:@"phone"];
    _phoneTF = [[UITextField alloc] initWithFrame:CGRectMake(170, 276, SCREEN_W - 185, 32)];
    _phoneTF.placeholder = @"  Phone Number*";
    _phoneTF.delegate = self;
    _phoneTF.text = phone;
    _phoneTF.layer.borderColor = [UIColor colorWithHexString:@"#dddddd"].CGColor;
    _phoneTF.layer.borderWidth = 0.5;
    
    [self addSubview:_phoneTF];
    
    UIButton *placeOrderBtn = [FactoryUI createButtonWithFrame:CGRectMake(17, 348, SCREEN_W - 34, 40) title:@"Place Order" titleColor:[UIColor whiteColor] imageName:nil backgroundImageName:nil target:self selector:@selector(placeOrder)];
    placeOrderBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    placeOrderBtn.backgroundColor = [UIColor colorWithHexString:@"#de4536"];
    [self addSubview:placeOrderBtn];
}

#pragma mark - 修改提交
- (void)placeOrder
{
    NSString *address = [[NSUserDefaults standardUserDefaults] objectForKey:@"address"];
    if (address) {
        [self editData];
    }else{
        [self UploadData];
    }
}

- (void)checkOut
{
    NSString *time = [self getCurrentTimestamp];
    NSArray *arr = @[@"appKey",@"apiKey",@"timestamp",@"equipment_id",@"email",@"address_id",@"card_number",@"card_month",@"card_year",@"card_cvv",@"token"];
    NSDictionary *dic = @{@"appKey" : APPKEY,
                          @"apiKey" : APIKEY,
                          @"equipment_id" : MYDEVICEID,
                          @"timestamp" : time,
                          @"email" : CWEMAIL,
                          @"token" : CWTOKEN,
                          @"address_id" : _addressID,
                          @"card_number" : @"4514617622367813",
                          @"card_month" : @"09",
                          @"card_year" : @"2020",
                          @"card_cvv" : @"144"
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
    
    [[CWAPIClient sharedClient] POSTRequest:CHECKOUT_URL parameters:parameters progress:nil success:^(NSURLSessionDataTask *task, id responseObject)
     {
         NSLog(@"%@",responseObject);
     } failure:^(NSURLSessionDataTask *task, NSError *error)
     {
         NSLog(@"%@",error);
     }];
}

- (void)UploadData
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
         NSLog(@"%@",responseObject);
     } failure:^(NSURLSessionDataTask *task, NSError *error)
     {
         NSLog(@"%@",error);
     }];
}

-(void)editData{
   NSString *time = [self getCurrentTimestamp];
   NSArray *arr = @[@"appKey",@"apiKey",@"timestamp",@"equipment_id",@"address_id",@"fullname",@"phone",@"address",@"suite",@"city",@"postcode",@"country_id",@"zone_id",@"email",@"token"];
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
    [[CWAPIClient sharedClient] POSTRequest:ADDADDRESS_URL parameters:parameters progress:nil success:^(NSURLSessionDataTask *task, id responseObject)
     {
         NSLog(@"%@",responseObject);
     } failure:^(NSURLSessionDataTask *task, NSError *error)
     {
         NSLog(@"%@",error);
     }];
}

- (void)cancelAction
{
    [self removeFromSuperview];
}

- (UINavigationController*)NavViewController {
    for (UIView* next = [self superview]; next; next = next.superview) {
        UIResponder* nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UINavigationController class]]) {
            return (UINavigationController*)nextResponder;
        }
    }
    return nil;
}

- (void)chooseCountry:(UIButton *)btn
{
    [_nameTF resignFirstResponder];
    [self loadCountry];
}

- (void)chooseState
{
    for (UITextField * text in self.subviews) {
        [text resignFirstResponder];
    }
    [self loadState];
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
         NSMutableArray *countryArr = [NSMutableArray array];
         _countryIdArr = [NSMutableArray array];
         NSArray *arr = responseObject[@"data"];
         for (NSDictionary *dic in arr)
         {
             NSString *country = dic[@"name"];
             [countryArr addObject:country];
         }
        zySheetPickerView *pickerView = [zySheetPickerView ZYSheetStringPickerWithTitle:countryArr andHeadTitle:@"Choose Country" Andcall:^(zySheetPickerView *pickerView, NSString *choiceString) {
            _countryTF.text = choiceString;
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
         NSMutableArray *stateArr = [NSMutableArray array];
         NSArray *arr = responseObject[@"data"];
         for (NSDictionary *dic in arr)
         {
             NSString *state = dic[@"name"];
             [stateArr addObject:state];
         }
         if (stateArr.count > 0)
         {
             zySheetPickerView *pickerView = [zySheetPickerView ZYSheetStringPickerWithTitle:stateArr andHeadTitle:@"Choose State" Andcall:^(zySheetPickerView *pickerView, NSString *choiceString) {
                 _stateTF.text = choiceString;
                 for (NSInteger i = 0; i < arr.count; i++)
                 {
                     if ([choiceString isEqualToString:arr[i][@"name"]])
                     {
                         _stateID = arr[i][@"zone_id"];
                         break;
                     }
                 }
                 [pickerView dismissPicker];
             }];
             [pickerView show];
         }
         else
         {
            
         }
     } failure:^(NSURLSessionDataTask *task, NSError *error)
     {
         NSLog(@"%@",error);
     }];
}

@end
