//
//  GEditAddressViewController.m
//  SneakerLab
//
//  Created by 郭隆基 on 2016/12/8.
//  Copyright © 2016年 Jason cao. All rights reserved.
//

#import "GEditAddressViewController.h"
#import "MyPickView.h"
#import <ZYKeyboardUtil/ZYKeyboardUtil.h>
#import "GEditCardViewController.h"

@interface GEditAddressViewController ()
@property (nonatomic, strong) UITextField *name;
@property (nonatomic, strong) UITextField *address;
@property (nonatomic, strong) UITextField *apt;
@property (nonatomic, strong) UITextField *city;
@property (nonatomic, strong) UITextField *zip;
@property (nonatomic, strong) UITextField *phone;
@property (nonatomic, strong) UIButton *country;
@property (nonatomic, strong) UIButton *state;

@property (nonatomic, strong) NSString *countryID;
@property (nonatomic, strong) NSString *stateID;
@property (nonatomic, strong) ZYKeyboardUtil *keyboardUtil;
@end

@implementation GEditAddressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.keyboardUtil = [[ZYKeyboardUtil alloc] init];
    __weak UIViewController *weakSelf = self;
    [_keyboardUtil setAnimateWhenKeyboardAppearAutomaticAnimBlock:^(ZYKeyboardUtil *keyboardUtil) {
        [keyboardUtil adaptiveViewHandleWithController:weakSelf adaptiveView:weakSelf.view, nil];
    }];
    SET_NAV_MIDDLE
    if ([self.type isEqualToString:@"billing"]) {
        self.title = @"Edit Billing Address";
    }else{
        self.title = @"Edit Shipping Info";
    }
    self.view.backgroundColor = [UIColor whiteColor];
    UIView *head = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, 72.5)];
    head.backgroundColor = COLOR_FA;
    [self.view addSubview:head];
    
    UILabel *alert = [[UILabel alloc] initWithFrame:CGRectMake(31, 10.5, SCREEN_W-31*2, 52.5)];
    alert.text = @"Please input your address accurately and we will deliver your purchase quickly.The safety of your information is guaranteed.";
    alert.textColor = [UIColor colorWithHexString:@"#FF8922"];
    alert.numberOfLines = 3;
    alert.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
    [self.view addSubview:alert];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15.5, 87.5, 200, 14)];
    label.font = FONT_12;
    label.textColor = COLOR_3;
    label.textAlignment = 0;
    label.text = @"* Indicates a field is required";
    [self.view addSubview:label];
    
    UIButton *save = [[UIButton alloc] initWithFrame:CGRectMake(0, SCREEN_H-64-49, SCREEN_W, 49)];
    save.backgroundColor = COLOR_RED;
    [save setTitle:@"Save" forState:UIControlStateNormal];
    if (_next) {
        [save setTitle:@"Save the info and next" forState:UIControlStateNormal];
    }
    save.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:15];
    [save addTarget:self action:@selector(saveButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:save];
    _name = [[UITextField alloc] initWithFrame:CGRectMake(15, 122.5, SCREEN_W-30, 40)];
    _name.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 40)];
    _name.leftViewMode = UITextFieldViewModeAlways;
    _name.placeholder = @"Full name *";
    _name.font = FONT_14;
    _name.layer.borderWidth = 0.5;
    _name.layer.borderColor = [COLOR_D CGColor];
    [self.view addSubview:_name];
    
    _address = [[UITextField alloc] initWithFrame:CGRectMake(15, 172.5, SCREEN_W-30, 40)];
    _address.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 40)];
    _address.leftViewMode = UITextFieldViewModeAlways;
    _address.placeholder = @"Street Address *";
    _address.font = FONT_14;
    _address.layer.borderWidth = 0.5;
    _address.layer.borderColor = [COLOR_D CGColor];
    [self.view addSubview:_address];
    
    _apt = [[UITextField alloc] initWithFrame:CGRectMake(15, 222.5, SCREEN_W-30, 40)];
    _apt.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 40)];
    _apt.leftViewMode = UITextFieldViewModeAlways;
    _apt.placeholder = @"Apt/Suite/Unit(Optional)";
    _apt.font = FONT_14;
    _apt.layer.borderWidth = 0.5;
    _apt.layer.borderColor = [COLOR_D CGColor];
    [self.view addSubview:_apt];
    
    _country = [[UIButton alloc] initWithFrame:CGRectMake(15, 272.5, (SCREEN_W-30-5)/2, 40)];
    _country.zhw_ignoreEvent = NO;
    _country.zhw_acceptEventInterval = 3;
    _country.backgroundColor = [UIColor whiteColor];
    [_country setTitle:@"Country*" forState:UIControlStateNormal];
    [_country addTarget:self action:@selector(chooseCountry) forControlEvents:UIControlEventTouchDown];
    _country.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    _country.titleLabel.textAlignment = 0;
    [_country setTitleColor:COLOR_3 forState:UIControlStateNormal];
    _country.layer.borderWidth = 0.5;
    _country.layer.borderColor = [COLOR_D CGColor];
    _country.titleLabel.font = FONT_12;
    [self.view addSubview:_country];
    UIImageView *down1 = [[UIImageView alloc] initWithFrame:CGRectMake((SCREEN_W-30-5)/2-40, 0, 40, 40)];
    down1.image = [UIImage imageNamed:@"下拉"];
    down1.contentMode = UIViewContentModeCenter;
    [_country addSubview:down1];
    
    _state = [[UIButton alloc] initWithFrame:CGRectMake(15+(SCREEN_W-30-5)/2+5, 272.5, (SCREEN_W-30-5)/2, 40)];
    _state.zhw_ignoreEvent = NO;
    _state.zhw_acceptEventInterval = 3;
    [_state setTitle:@"State(Optional)" forState:UIControlStateNormal];
    _state.backgroundColor = [UIColor whiteColor];
    [_state setTitleColor:COLOR_3 forState:UIControlStateNormal];
    _state.titleLabel.font = FONT_12;
    _state.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    [_state addTarget:self action:@selector(chooseState) forControlEvents:UIControlEventTouchDown];
    _state.titleLabel.textAlignment = 0;
    _state.layer.borderWidth = 0.5;
    _state.layer.borderColor = [COLOR_D CGColor];
    [self.view addSubview:_state];
    UIImageView *down2 = [[UIImageView alloc] initWithFrame:CGRectMake((SCREEN_W-30-5)/2-40, 0, 40, 40)];
    down2.image = [UIImage imageNamed:@"下拉"];
    down2.contentMode = UIViewContentModeCenter;
    [_state addSubview:down2];
    
    
    _city = [[UITextField alloc] initWithFrame:CGRectMake(15, 322.5, SCREEN_W-30, 40)];
    _city.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 40)];
    _city.leftViewMode = UITextFieldViewModeAlways;
    _city.placeholder = @"city *";
    _city.font = FONT_14;
    _city.layer.borderWidth = 0.5;
    _city.layer.borderColor = [COLOR_D CGColor];
    [self.view addSubview:_city];
    
    _zip = [[UITextField alloc] initWithFrame:CGRectMake(15, 372, SCREEN_W-30, 40)];
    _zip.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 40)];
    _zip.leftViewMode = UITextFieldViewModeAlways;
    _zip.placeholder = @"Zip";
    _zip.font = FONT_14;
    _zip.layer.borderWidth = 0.5;
    _zip.layer.borderColor = [COLOR_D CGColor];
    [self.view addSubview:_zip];
    
    _phone = [[UITextField alloc] initWithFrame:CGRectMake(15, 422, SCREEN_W-30, 40)];
    _phone.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 40)];
    _phone.leftViewMode = UITextFieldViewModeAlways;
    _phone.placeholder = @"Phone *";
    _phone.font = FONT_14;
    _phone.layer.borderWidth = 0.5;
    _phone.layer.borderColor = [COLOR_D CGColor];
    [self.view addSubview:_phone];
    
    if (self.add==NO) {
        [self requestdatas];
    }
}

- (void)saveButtonAction {
    if (_city.text.length==0) {
        _city.text = @"";
    }
    if (_apt.text.length==0) {
        _apt.text = @"";
    }
    if (_stateID.length==0) {
        _stateID = @"";
    }
    if (_name.text.length!=0&&_address.text.length!=0&&_city.text.length!=0&&![_country.titleLabel.text isEqualToString:@"Country*"]&&_zip.text.length!=0&&_phone.text.length!=0) {
        if (_add) {
            [self addAddress];
        }else{
            [self edit];
        }
    }else{
        [MBManager showBriefAlert:@"Please complete all the mandatory"];
    }
    
}

- (void)edit {
    NSString *type;
    if ([self.type isEqualToString:@"billing"]) {
        type = @"2";
    }else{
        type = @"1";
    }
    NSString *time = [self getCurrentTimestamp];
    NSArray *arr = @[@"appKey",@"apiKey",@"timestamp",@"equipment_id",@"fullname",@"phone",@"address",@"suite",@"city",@"postcode",@"country_id",@"zone_id",@"email",@"token",@"set_default",@"address_id"];
    NSDictionary *dic = @{@"appKey" : APPKEY,
                          @"apiKey" : APIKEY,
                          @"equipment_id" : MYDEVICEID,
                          @"timestamp" : time,
                          @"fullname" : _name.text,
                          @"phone" : _phone.text,
                          @"address" : _address.text,
                          @"suite":_apt.text,
                          @"city" : _city.text,
                          @"postcode" : _zip.text,
                          @"country_id" : _countryID,
                          @"zone_id" : _stateID,
                          @"set_default":@"1",
                          @"address_id":self.address_id,
                          @"type" : type,
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
         [self.navigationController popViewControllerAnimated:YES];
     } failure:^(NSURLSessionDataTask *task, NSError *error)
     {
         LJLog(@"%@",error);
     }];
}

- (void)addAddress {
    NSString *type;
    if ([self.type isEqualToString:@"billing"]) {
        type = @"2";
    }else{
        type = @"1";
    }
    NSString *time = [self getCurrentTimestamp];
    NSArray *arr = @[@"appKey",@"apiKey",@"timestamp",@"equipment_id",@"fullname",@"phone",@"address",@"suite",@"city",@"postcode",@"country_id",@"zone_id",@"email",@"token",@"set_default"];
    NSDictionary *dic = @{@"appKey" : APPKEY,
                          @"apiKey" : APIKEY,
                          @"equipment_id" : MYDEVICEID,
                          @"timestamp" : time,
                          @"fullname" : _name.text,
                          @"phone" : _phone.text,
                          @"address" : _address.text,
                          @"suite":_apt.text,
                          @"city" : _city.text,
                          @"postcode" : _zip.text,
                          @"country_id" : _countryID,
                          @"zone_id" : _stateID,
                          @"set_default":@"1",
                          @"type" : type,
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
         NSString *message = [responseObject valueForKey:@"message"];
         LJLog(@"%@", message);
         if (_next) {
             GEditCardViewController *vc = [[GEditCardViewController alloc] init];
             vc.next = YES;
             vc.add = YES;
             [[NSUserDefaults standardUserDefaults] setBool:NO forKey:UD_PAY];
             [self.navigationController pushViewController:vc animated:YES];
         }else{
             [self.navigationController popViewControllerAnimated:YES];
         }
     } failure:^(NSURLSessionDataTask *task, NSError *error)
     {
         LJLog(@"%@",error);
     }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

- (void)chooseCountry
{
    for (UITextField * text in self.view.subviews) {
        [text resignFirstResponder];
    }
    [self loadCountry];
}

- (void)chooseState
{
    if (_countryID.length!=0) {
        for (UITextField * text in self.view.subviews) {
            [text resignFirstResponder];
        }
        [self loadState];
    }else{
        [MBManager showBriefAlert:@"Please choose the country first"];
    }
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
             [_country setTitle:choiceString forState:UIControlStateNormal];
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
             [_state setTitle:choiceString forState:UIControlStateNormal];
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

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

- (void)requestdatas {
    if (self.address_id.length==0) {
        return;
    }
    NSDictionary *dict = @{@"address_id":self.address_id};
    [PHPNetwork PHPNetworkWithParam:dict andUrl:ADDRESSSHOW_URL andSignature:YES andLogin:YES finish:^(NSURLSessionDataTask *task, id responseObject) {
        NSDictionary *dict = [responseObject valueForKey:@"data"];

        _name.text = [dict valueForKey:@"fullname"];
        _address.text = [dict valueForKey:@"address_1"];
        _apt.text = [dict valueForKey:@"suite"];
        _city.text = [dict valueForKey:@"city"];
        _zip.text = [dict valueForKey:@"postcode"];
        _phone.text = [dict valueForKey:@"phone"];
        [_country setTitle:[dict valueForKey:@"country"] forState:UIControlStateNormal];
        [_state setTitle:[dict valueForKey:@"zone"] forState:UIControlStateNormal];
        //后台bug，后台这个接口没有返回phone
    } err:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}

@end
