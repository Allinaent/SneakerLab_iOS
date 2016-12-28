//
//  RegisterController.m
//  caowei
//
//  Created by Jason cao on 2016/9/12.
//  Copyright © 2016年 Jason cao. All rights reserved.
//

#import "RegisterController.h"
#import "PersonlityController.h"
#import "CWAPIClient.h"
#import "NSString+NSString_MD5.h"
#import "UIViewController+UIViewController_TimesTamp.h"
#import "RootViewController.h"
#import "AppDelegate.h"
#import "MenuController.h"
#import <Firebase.h>
@interface RegisterController () <UITextFieldDelegate>
{
      UITextField *_emailText;
    UITextField *_passswordText;
    UITextField *_confirmPWText;
}
@end

@implementation RegisterController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"Create Account";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"返回"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]style:UIBarButtonItemStylePlain target:self action:@selector(backAction)];
    UILabel *label = [FactoryUI createLabelWithFrame:CGRectMake(0, 10, SCREEN_W, 20) text:@"Let's create your account" textColor:[UIColor colorWithRed:0.4 green:0.4 blue:0.4 alpha:1] font:[UIFont systemFontOfSize:16]];
    label.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:label];
    
    _firstName = [[UITextField alloc] initWithFrame:CGRectMake(10, 40, (SCREEN_W - 30 ) / 2, 30)];
    _firstName.placeholder = @"First Name";
    _firstName.font = [UIFont systemFontOfSize:14];
    _firstName.delegate = self;
    _firstName.borderStyle = UITextBorderStyleRoundedRect;
    [self.view addSubview:_firstName];
    
    _lastName = [[UITextField alloc] initWithFrame:CGRectMake((SCREEN_W - 30 ) / 2 + 20, 40, (SCREEN_W - 30 ) / 2, 30)];
    _lastName.font = [UIFont systemFontOfSize:14];
    _lastName.delegate = self;
    _lastName.borderStyle = UITextBorderStyleRoundedRect;
    _lastName.placeholder = @"Last Name";
    [self.view addSubview:_lastName];
    
    _emailText = [[UITextField alloc] initWithFrame:CGRectMake(10, 80, SCREEN_W - 20, 30)];
    _emailText.placeholder = @"Email";
    _emailText.font = [UIFont systemFontOfSize:14];
    _emailText.delegate = self;
    _emailText.borderStyle = UITextBorderStyleRoundedRect;
    [self.view addSubview:_emailText];
    
    _passswordText = [[UITextField alloc] initWithFrame:CGRectMake(10, 120, SCREEN_W - 20, 30)];
    _passswordText.placeholder = @"Password";
    _passswordText.font = [UIFont systemFontOfSize:14];
    _passswordText.delegate = self;
    _passswordText.secureTextEntry = YES;
    _passswordText.clearsOnBeginEditing = YES;
    _passswordText.borderStyle = UITextBorderStyleRoundedRect;
    [self.view addSubview:_passswordText];
    
    _confirmPWText = [[UITextField alloc] initWithFrame:CGRectMake(10, 160, SCREEN_W - 20, 30)];
    _confirmPWText.placeholder = @"Confirm Password";
    _confirmPWText.font = [UIFont systemFontOfSize:14];
    _confirmPWText.delegate = self;
    _confirmPWText.secureTextEntry = YES;
    _confirmPWText.clearsOnBeginEditing = YES;
    _confirmPWText.borderStyle = UITextBorderStyleRoundedRect;
    [self.view addSubview:_confirmPWText];
    
    UIButton *createBtn = [FactoryUI createButtonWithFrame:CGRectMake(10, 205, SCREEN_W - 20, 40) title:@"Create Account" titleColor:[UIColor whiteColor] imageName:nil backgroundImageName:nil target:self selector:@selector(createAction)];
    createBtn.layer.cornerRadius = 3;
    createBtn.backgroundColor = [UIColor colorWithRed:0.85 green:0.29 blue:0.24 alpha:1];
    [self.view addSubview:createBtn];
    
    UILabel *label1 = [FactoryUI createLabelWithFrame:CGRectMake(self.view.center.x, 265, 20, 15) text:@"OR" textColor:[UIColor colorWithRed:0.4 green:0.4 blue:0.4 alpha:1] font:[UIFont systemFontOfSize:12]];
    label1.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:label1];
    
    UIButton *facebookBtn = [FactoryUI createButtonWithFrame:CGRectMake(10, 300, SCREEN_W - 20, 40) title:@"Join with Facebook" titleColor:[UIColor colorWithRed:0.4 green:0.4 blue:0.4 alpha:1] imageName:nil backgroundImageName:nil target:self selector:@selector(facebookSignIn)];
    facebookBtn.backgroundColor = [UIColor lightGrayColor];
    facebookBtn.layer.cornerRadius = 3;
    [self.view addSubview:facebookBtn];
    
}

#pragma mark --按钮点击
- (void)createAction
{
    if (_confirmPWText.text.length<6) {
        [MBManager showBriefAlert:@"Password length should be greater than 6"];
        return;
    }
    if ((_firstName.text.length && _lastName.text.length && _emailText.text.length && _passswordText.text.length && _confirmPWText.text.length) != 0)
    {
        if ([self isValidateEmail:_emailText.text] == YES)
        {
            if ([_passswordText.text isEqualToString:_confirmPWText.text])
            {
                NSString *time = [self getCurrentTimestamp];
                NSArray *arr = @[@"appKey",@"apiKey",@"timestamp",@"firstname",@"lastname",@"email",@"password",@"equipment_id"];
                NSDictionary *dic = @{@"firstname" : _firstName.text,
                                      @"lastname" : _lastName.text,
                                      @"email" : _emailText.text,
                                      @"password" : _passswordText.text,
                                      @"appKey" : APPKEY,
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
                [MBManager showLoading];
//                [[CWAPIClient sharedClient] POSTRequest:REGISTER_URL parameters:parameters progress:nil success:^(NSURLSessionDataTask *task, id responseObject)
//                 {
//                     [MBManager hideAlert];
//                     NSLog(@"%@",responseObject);
//                     NSLog(@"success的页面");
//                     [self signIn];
//                 } failure:^(NSURLSessionDataTask *task, NSError *error)
//                 {
//                     [MBManager hideAlert];
//                     NSLog(@"%@",error);
//                 }];
                
                AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
                manager.requestSerializer = [AFHTTPRequestSerializer serializer];
                manager.responseSerializer = [AFHTTPResponseSerializer serializer];
                manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/json",@"text/html",@"application/json",@"text/plain",nil];
                [manager POST:REGISTER_URL parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
                    
                } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                    [MBManager hideAlert];
                    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
                    DebugLog(@"%@", dic);
                    NSString *str = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
                    DebugLog(@"%@", str);
                    [self signIn];
                } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                    [MBManager hideAlert];
                }];
            }
            else
            {
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"The two input passwords are different"
                                                                               message:nil
                                                                        preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction* action = [UIAlertAction actionWithTitle:@"OK"
                                                                 style:UIAlertActionStyleDefault
                                                               handler:nil];
                [alert addAction:action];
                [self presentViewController:alert animated:YES completion:nil];
            }
        }
        else
        {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"It is not an availability email"
                                                                           message:nil
                                                                    preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction* action = [UIAlertAction actionWithTitle:@"OK"
                                                             style:UIAlertActionStyleDefault
                                                           handler:nil];
            [alert addAction:action];
            [self presentViewController:alert animated:YES completion:nil];
        }
    }
    else
    {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"All infomation must not be null"
                                                                       message:nil
                                                                preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* action = [UIAlertAction actionWithTitle:@"OK"
                                                         style:UIAlertActionStyleDefault
                                                       handler:nil];
        [alert addAction:action];
        [self presentViewController:alert animated:YES completion:nil];
    }
    
}
-(void)goToPersonlityPage{
    PersonlityController *personVC = [[PersonlityController alloc] init];
    [self.navigationController pushViewController:personVC animated:YES];
}

- (void)facebookSignIn
{
    
}

- (void)backAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(BOOL) textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

// 判断email格式
- (BOOL)isValidateEmail:(NSString *)email{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

- (void)signIn
{
    NSString *time = [self getCurrentTimestamp];
    NSArray *arr = @[@"appKey",@"apiKey",@"timestamp",@"password",@"email",@"equipment_id"];
    NSDictionary *dic = @{@"email" : _emailText.text,
                          @"password" : _passswordText.text,
                          @"appKey" : APPKEY,
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
    
    [[CWAPIClient sharedClient] POSTRequest:LOGIN_URL parameters:parameters progress:nil success:^(NSURLSessionDataTask *task, id responseObject)
     {
         NSLog(@"%@",responseObject);
         NSLog(@"%@",@"succer ");
         NSString *loginInfo = responseObject[@"message"];
         if ([loginInfo isEqualToString:@"Login successful."])
         {
             NSDictionary *dic = responseObject[@"data"];
             [[NSUserDefaults standardUserDefaults] setObject:dic[@"token"] forKey:@"CWToken"];
             NSDictionary *dic1 = dic[@"user_info"];
             [[NSUserDefaults standardUserDefaults] setObject:dic1[@"email"] forKey:@"CWEmail"];
             AppDelegate *tempAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
             [[NSUserDefaults standardUserDefaults] setObject:@YES forKey:@"signInSuccessful"];
             [[NSUserDefaults standardUserDefaults] setObject:dic1[@"customer_id"] forKey:@"customer_id"];
             [[NSUserDefaults standardUserDefaults] synchronize];
             [self goToPersonlityPage];
             MenuController *leftVC = [[MenuController alloc] init];
             [[NSUserDefaults standardUserDefaults] setObject:dic1[@"firstname"] forKey:@"firstname"];
             [[NSUserDefaults standardUserDefaults] setObject:dic1[@"lastname"] forKey:@"lastname"];
             [[NSUserDefaults standardUserDefaults] setObject:@YES forKey:@"signInSuccessful"];
             [[NSUserDefaults standardUserDefaults] setObject:dic1[@"customer_id"] forKey:@"customer_id"];
             [[NSUserDefaults standardUserDefaults] synchronize];
             [[NSNotificationCenter defaultCenter]postNotificationName:kFIRInstanceIDTokenRefreshNotification object:self userInfo:nil];
             RootViewController *rootVC = [[RootViewController alloc] init];
             tempAppDelegate.mainNavigationController = [[UINavigationController alloc] initWithRootViewController:rootVC];
             tempAppDelegate.LeftSlideVC = [[LeftSlideViewController alloc] initWithLeftView:leftVC andMainView:tempAppDelegate.mainNavigationController];
             tempAppDelegate.window.rootViewController = tempAppDelegate.LeftSlideVC;
             // 这里是登录成功
             // 在这里向服务器发送firebase token，注册也是需要的
             if ([[FIRInstanceID instanceID] token]!=nil) {
                 
                 NSDictionary *dict = @{@"token":[[FIRInstanceID instanceID] token],@"custom_id":[[NSUserDefaults standardUserDefaults] valueForKey:@"customer_id"]};
                 [PHPNetwork PHPNetworkWithParam:dict andUrl:UPLOADTOKEN_URL andSignature:YES andLogin:YES finish:^(NSURLSessionDataTask *task, id responseObject) {
                     
                 } err:^(NSURLSessionDataTask *task, NSError *error) {
                     
                 }];
             }
         }
         else
         {
             UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Login failed,please check your account information." message:nil preferredStyle:UIAlertControllerStyleAlert];
             UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
             [alert addAction:action];
             [self presentViewController:alert animated:YES completion:nil];
         }
     } failure:^(NSURLSessionDataTask *task, NSError *error)
     {
         NSLog(@"%@",error);
     }];
}

@end
