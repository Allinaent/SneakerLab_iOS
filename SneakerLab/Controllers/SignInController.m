//
//  SignInController.m
//  caowei
//
//  Created by Jason cao on 2016/9/12.
//  Copyright © 2016年 Jason cao. All rights reserved.
//

#import "SignInController.h"
#import "RootViewController.h"
#import "AppDelegate.h"
#import "MenuController.h"
#import "SetPersonInfoViewController.h"
#import <Firebase.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <FBSDKCoreKit/FBSDKApplicationDelegate.h>

@interface SignInController ()<UITextFieldDelegate,FBSDKLoginButtonDelegate>
{
    UITextField *_emailText;
    UITextField *_passwordText;
}
@end

@implementation SignInController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"Login";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"返回"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]style:UIBarButtonItemStylePlain target:self action:@selector(backAction)];
    self.view.backgroundColor = [UIColor whiteColor];
    
    UILabel *label = [FactoryUI createLabelWithFrame:CGRectMake(20, 10, SCREEN_W - 40, 20) text:@"Let's log you in" textColor:[UIColor colorWithHexString:@"#999999"] font:[UIFont systemFontOfSize:14]];
    label.textAlignment = 1;
    [self.view addSubview:label];
    
    _emailText = [[UITextField alloc] initWithFrame:CGRectMake(10, 45, SCREEN_W - 20, 30)];
    _emailText.placeholder = @"  Email";
    _emailText.autocapitalizationType = UITextAutocapitalizationTypeNone;
    _emailText.font = [UIFont systemFontOfSize:12];
    _emailText.layer.borderColor = [UIColor colorWithHexString:@"#E5E5E5"].CGColor;
    _emailText.layer.borderWidth = 0.5;
    _emailText.delegate = self;
    [self.view addSubview:_emailText];
    
    _passwordText = [[UITextField alloc] initWithFrame:CGRectMake(10, 85, SCREEN_W - 20, 30)];
    _passwordText.placeholder = @"  Password";
    _passwordText.font = [UIFont systemFontOfSize:12];
    _passwordText.secureTextEntry = YES;
    _passwordText.delegate = self;
    _passwordText.layer.borderColor = [UIColor colorWithHexString:@"#E5E5E5"].CGColor;
    _passwordText.layer.borderWidth = 0.5;
    [self.view addSubview:_passwordText];
    
    UIButton *signnBtn = [FactoryUI createButtonWithFrame:CGRectMake(10, 131.5, SCREEN_W - 20, 40) title:@"Login" titleColor:[UIColor whiteColor] imageName:nil backgroundImageName:nil target:self selector:@selector(signInAction)];
    signnBtn.backgroundColor = [UIColor colorWithHexString:@"#DE4536"];
    signnBtn.layer.cornerRadius = 3;
    [self.view addSubview:signnBtn];
    
    UIButton *forgetPasswdBtn = [FactoryUI createButtonWithFrame:CGRectMake(self.view.center.x - 100, 187.5, 200, 16) title:@"Forget Password" titleColor:[UIColor colorWithHexString:@"#666666"] imageName:nil backgroundImageName:nil target:self selector:@selector(forgetPasswordAction)];
    forgetPasswdBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [self.view addSubview:forgetPasswdBtn];
    
    //UIButton *facebookBtn = [FactoryUI createButtonWithFrame:CGRectMake(10, 216.5, SCREEN_W - 20, 40) title:@"Sign In with Facebook" titleColor: [UIColor colorWithHexString:@"#666666"]imageName:nil backgroundImageName:nil target:self selector:@selector(facebookAction)];
    FBSDKLoginButton *facebookBtn = [[FBSDKLoginButton alloc] init];
    facebookBtn.delegate = self;
    facebookBtn.hidden = YES;
    facebookBtn.frame = CGRectMake(10, 216.5, SCREEN_W - 20, 40);
    facebookBtn.readPermissions = @[@"public_profile", @"email", @"user_friends", @"pages_messaging_phone_number",];
    facebookBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    facebookBtn.backgroundColor = [UIColor colorWithHexString:@"#E7E7E7"];
    [self.view addSubview:facebookBtn];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(_updateContent:)
                                                 name:FBSDKProfileDidChangeNotification
                                               object:nil];
}

#pragma mark - facebookBtn delegate
- (void)loginButtonDidLogOut:(FBSDKLoginButton *)loginButton {
    
}

- (void)loginButton:(FBSDKLoginButton *)loginButton didCompleteWithResult:(FBSDKLoginManagerLoginResult *)result error:(NSError *)error {
    /*
    FBSDKProfilePictureView *imageview = [[FBSDKProfilePictureView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    imageview.profileID = @"me";
    [FBSDKProfile currentProfile];
    [self.view addSubview:imageview];
     */
}

- (void)_updateContent:(NSNotification *)notification {
    AppDelegate *tempAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    RootViewController * rootVC = [[RootViewController alloc] init];
    MenuController *leftVC = [[MenuController alloc] init];
    tempAppDelegate.mainNavigationController = [[UINavigationController alloc] initWithRootViewController:rootVC];
    tempAppDelegate.LeftSlideVC = [[LeftSlideViewController alloc] initWithLeftView:leftVC andMainView:tempAppDelegate.mainNavigationController];
    tempAppDelegate.window.rootViewController = tempAppDelegate.LeftSlideVC;
    [[NSUserDefaults standardUserDefaults] setObject:@YES forKey:@"signInSuccessful"];
    //[[NSUserDefaults standardUserDefaults] setBool:YES forKey:UD_FACEBOOK];
    FBSDKProfile *profile = [notification.userInfo valueForKey:@"FBSDKProfileNew"];
    NSURL *headUrl = [profile imageURLForPictureMode:FBSDKProfilePictureModeSquare size:CGSizeMake(200, 200)];
    NSString *headStr = headUrl.absoluteString;
    NSString *accesstoken = [FBSDKAccessToken currentAccessToken].tokenString;
    //NSString *facebookId = profile.userID;
    NSString *email = @"";
    NSString *phone = @"";
    NSString *firstname;
    NSString *middlename;
    NSString *lastname;
    if (profile.firstName!=nil) {
        firstname = profile.firstName;
    }else{
        firstname = @"";
    }
    if (profile.middleName!=nil) {
        middlename = profile.middleName;
    }else{
        middlename = @"";
    }
    if (profile.lastName!=nil) {
        lastname = profile.lastName;
    }else{
        lastname = @"";
    }
    
    //测试用例
    NSString *time = [self getCurrentTimestamp];
    NSArray *arr = @[@"appKey",@"apiKey",@"timestamp",@"equipment_id",@"email",@"phone",@"firstname",@"middlename",@"lastname",@"avatarimage",@"token"];
    NSDictionary *dic = @{@"appKey" : APPKEY,
                          @"apiKey" : APIKEY,
                          @"equipment_id" : MYDEVICEID,
                          @"timestamp" : time,
                          @"email" : email,
                          @"phone" : phone,
                          @"firstname" : firstname,
                          @"middlename" : middlename,
                          @"lastname" : lastname,
                          @"avatarimage" : headStr,
                          @"token" : accesstoken
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
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/json",@"text/html",@"application/json",@"text/plain",nil];
    [manager POST:FACEBOOK_URL parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        DebugLog(@"%@", dic);
        NSString *str = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        DebugLog(@"%@", str);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
    ///
}

- (void)backAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)signInAction
{
    if (_passwordText.text.length<6) {
        [MBManager showBriefAlert:@"Password length should be greater than 6"];
        return;
    }
    [self loadData];
    
}

- (void)forgetPasswordAction
{
    SetPersonInfoViewController *vc = [[SetPersonInfoViewController alloc] init];
    vc.headline = @"Change Password";
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)facebookAction
{
    
}

- (void)loadData
{
    NSString *time = [self getCurrentTimestamp];
    NSArray *arr = @[@"appKey",@"apiKey",@"timestamp",@"password",@"email",@"equipment_id"];
    NSDictionary *dic = @{@"email" : _emailText.text,
                          @"password" : _passwordText.text,
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
        LJLog(@"%@",responseObject);
        NSString *loginInfo = responseObject[@"message"];
        if ([loginInfo isEqualToString:@"Login successful."])
        {
            if ([self.fromController isEqualToString:@"productDetail"]) {
                NSArray *controllers = self.navigationController.viewControllers;
                NSDictionary *dic = responseObject[@"data"];
                [[NSUserDefaults standardUserDefaults] setObject:dic[@"token"] forKey:@"CWToken"];
                NSDictionary *dic1 = dic[@"user_info"];
                [[NSUserDefaults standardUserDefaults] setObject:dic1[@"email"] forKey:@"CWEmail"];
                [[NSUserDefaults standardUserDefaults] setObject:@YES forKey:@"signInSuccessful"];
                [[NSUserDefaults standardUserDefaults] setObject:dic1[@"firstname"] forKey:@"firstname"];
                [[NSUserDefaults standardUserDefaults] setObject:dic1[@"lastname"] forKey:@"lastname"];
                [[NSUserDefaults standardUserDefaults] setObject:dic1[@"customer_id"] forKey:@"customer_id"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                [[NSNotificationCenter defaultCenter]postNotificationName:kFIRInstanceIDTokenRefreshNotification object:self userInfo:nil];
                //根据索引号直接pop到指定视图
                [self.navigationController popToViewController:[controllers objectAtIndex:1] animated:YES];
           }else{
                NSDictionary *dic = responseObject[@"data"];
                [[NSUserDefaults standardUserDefaults] setObject:dic[@"token"] forKey:@"CWToken"];
                NSDictionary *dic1 = dic[@"user_info"];
                [[NSUserDefaults standardUserDefaults] setObject:dic1[@"email"] forKey:@"CWEmail"];
                AppDelegate *tempAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
                [[NSUserDefaults standardUserDefaults] setObject:@YES forKey:@"signInSuccessful"];
                [[NSUserDefaults standardUserDefaults]synchronize];
                MenuController *leftVC = [[MenuController alloc] init];
                leftVC.userName = dic1[@"firstname"];
                [[NSUserDefaults standardUserDefaults] setObject:dic1[@"firstname"] forKey:@"firstname"];
                [[NSUserDefaults standardUserDefaults] setObject:dic1[@"lastname"] forKey:@"lastname"];
                [[NSUserDefaults standardUserDefaults] setObject:dic1[@"customer_id"] forKey:@"customer_id"];
                [[NSUserDefaults standardUserDefaults]synchronize];
                [[NSNotificationCenter defaultCenter]postNotificationName:kFIRInstanceIDTokenRefreshNotification object:self userInfo:nil];
                RootViewController * rootVC = [[RootViewController alloc] init];
                tempAppDelegate.mainNavigationController = [[UINavigationController alloc] initWithRootViewController:rootVC];
                tempAppDelegate.LeftSlideVC = [[LeftSlideViewController alloc] initWithLeftView:leftVC andMainView:tempAppDelegate.mainNavigationController];
                tempAppDelegate.window.rootViewController = tempAppDelegate.LeftSlideVC;
                [[NSUserDefaults standardUserDefaults] setObject:@YES forKey:@"signInSuccessful"];
            }
            //这里是登录成功
            //在这里向服务器发送firebase token，注册也是需要的
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
             UIAlertAction* action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
             [alert addAction:action];
             [self presentViewController:alert animated:YES completion:nil];
         }
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
    [self.view endEditing:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

@end
