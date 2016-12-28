//
//  SettingsViewController.m
//  SneakerLab
//
//  Created by 郭隆基 on 2016/11/26.
//  Copyright © 2016年 Jason cao. All rights reserved.
//

#import "SettingsViewController.h"
#import "SetPersonInfoViewController.h"
#import "AppDelegate.h"
#import "RootViewController.h"
#import "MenuController.h"
#import "CurrencyController.h"
#import "languageController.h"
#import "ReturnPolicyController.h"

@interface SettingsViewController ()

@end

@implementation SettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Settings";
    SET_NAV_MIDDLE
    self.view.backgroundColor = COLOR_FA;
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 20, SCREEN_W, 179)];
    view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:view];
    
    UIView *line1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, 1)];
    [view addSubview:line1];
    line1.backgroundColor = COLOR_D;
    UIView *view1 = [self viewWithImageString:@"货币兑换" title:@"Currency"];
    view1.frame = CGRectMake(0, 1, SCREEN_W, 43.5);
    [view addSubview:view1];
    UIButton *button1 = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, 43.5)];
    [view1 addSubview:button1];
    [button1 addTarget:self action:@selector(button1Action) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIView *line2 = [[UIView alloc] initWithFrame:CGRectMake(17.5, 44.5, SCREEN_W, 1)];
    [view addSubview:line2];
    line2.backgroundColor = COLOR_D;
    
    
    UIView *view2 = [self viewWithImageString:@"语言1" title:@"Language"];
    view2.frame = CGRectMake(0, 45.5, SCREEN_W, 43.5);
    [view addSubview:view2];
    UIButton *button2 = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, 43.5)];
    [view2 addSubview:button2];
    [button2 addTarget:self action:@selector(button2Action) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *line3 = [[UIView alloc] initWithFrame:CGRectMake(17.5, 89, SCREEN_W, 1)];
    [view addSubview:line3];
    line3.backgroundColor = COLOR_D;
    
    UIView *view3 = [self viewWithImageString:@"条款1" title:@"Return Policy"];
    view3.frame = CGRectMake(0, 90, SCREEN_W, 43.5);
    [view addSubview:view3];
    UIButton *button3 = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, 43.5)];
    [view3 addSubview:button3];
    [button3 addTarget:self action:@selector(button3Action) forControlEvents:UIControlEventTouchUpInside];
    UIView *line4 = [[UIView alloc] initWithFrame:CGRectMake(17.5, 133.5, SCREEN_W, 1)];
    [view addSubview:line4];
    line4.backgroundColor = COLOR_D;
    
    UIView *view4 = [self viewWithImageString:@"change password" title:@"Change Password"];
    view4.frame = CGRectMake(0, 134.5, SCREEN_W, 43.5);
    [view addSubview:view4];
    UIButton *button4 = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, 43.5)];
    [view4 addSubview:button4];
    [button4 addTarget:self action:@selector(button4Action) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *line5 = [[UIView alloc] initWithFrame:CGRectMake(0, 178, SCREEN_W, 1)];
    [view addSubview:line5];
    line5.backgroundColor = COLOR_D;
    
    UIView *li1 = [[UIView alloc] initWithFrame:CGRectMake(0, 209, SCREEN_W, 1)];
    li1.backgroundColor = COLOR_D;
    [self.view addSubview:li1];
    UIButton *logout = [[UIButton alloc] initWithFrame:CGRectMake(0, 210, SCREEN_W, 43.5)];
    [self.view addSubview:logout];
    [logout setTitle:@"logout" forState:UIControlStateNormal];
    logout.titleLabel.font = FONT_13;
    [logout setTitleColor:COLOR_9 forState:UIControlStateNormal];
    logout.backgroundColor = [UIColor whiteColor];
    [logout addTarget:self action:@selector(logoutAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:logout];
    
    UIView *li2 = [[UIView alloc] initWithFrame:CGRectMake(0, 253.5, SCREEN_W, 1)];
    li2.backgroundColor = COLOR_D;
    [self.view addSubview:li2];
    
}

- (void)logoutAction {
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"signInSuccessful"] boolValue] == YES)
    {//用户已登录
        NSString *time = [self getCurrentTimestamp];
        NSArray *arr = @[@"appKey",@"apiKey",@"timestamp",@"email",@"equipment_id",@"token"];
        NSDictionary *dic = @{@"email" : CWEMAIL,
                              @"appKey" : APPKEY,
                              @"apiKey" : APIKEY,
                              @"equipment_id" : MYDEVICEID,
                              @"timestamp" : time,
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
        
        [[CWAPIClient sharedClient] POSTRequest:LOGOUT_URL parameters:parameters progress:nil success:^(NSURLSessionDataTask *task, id responseObject)
         {
             AppDelegate *tempAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
             [tempAppDelegate.LeftSlideVC closeLeftView];
             [MBManager showBriefAlert:@"Logout success"];
             NSLog(@"%@",responseObject);
             NSLog(@"%@",@"退出成功");
             [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"CWToken"];
             [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"CWEmail"];
             [[NSUserDefaults standardUserDefaults] setObject:@NO forKey:@"signInSuccessful"];
             //bug修改，2016-11-03 13:57:18，郭隆基
             [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"firstname"];
             [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"lastname"];
             [[NSUserDefaults standardUserDefaults] removeObjectForKey:UD_CARD];
             [[NSUserDefaults standardUserDefaults] removeObjectForKey:UD_SHIPADDRESS];
             [[NSUserDefaults standardUserDefaults] removeObjectForKey:UD_HEADURL];
             [[NSUserDefaults standardUserDefaults] removeObjectForKey:UD_PHONE];
             [[NSUserDefaults standardUserDefaults] removeObjectForKey:UD_SEX];
             [[NSUserDefaults standardUserDefaults] removeObjectForKey:UD_AGE];
             [[NSUserDefaults standardUserDefaults] removeObjectForKey:UD_EMAIL];
             [[NSUserDefaults standardUserDefaults] removeObjectForKey:UD_PAY];
             MenuController *leftVC = [[MenuController alloc] init];
             RootViewController *rootVC = [[RootViewController alloc] init];
             tempAppDelegate.mainNavigationController = [[UINavigationController alloc] initWithRootViewController:rootVC];
             tempAppDelegate.LeftSlideVC = [[LeftSlideViewController alloc] initWithLeftView:leftVC andMainView:tempAppDelegate.mainNavigationController];
             tempAppDelegate.window.rootViewController = tempAppDelegate.LeftSlideVC;
             self.navigationController.navigationBarHidden = NO;
             //退出登录以后
             RootViewController *menu = [[RootViewController alloc]init];
             [self.navigationController pushViewController:menu animated:YES];
             
         } failure:^(NSURLSessionDataTask *task, NSError *error)
         {
             NSLog(@"%@",error);
         }];
        
    }
}

//货币
- (void)button1Action {
    CurrencyController *currencyVC = [[CurrencyController alloc] init];
    [self.navigationController pushViewController:currencyVC animated:YES];
}

- (void)button2Action {
    languageController *languageVC = [[languageController alloc] init];
    [self.navigationController pushViewController:languageVC animated:YES];
}

- (void)button3Action {
    ReturnPolicyController *returnPolicyVC = [[ReturnPolicyController alloc] init];
    [self.navigationController pushViewController:returnPolicyVC animated:YES];
}

- (void)button4Action {
    SetPersonInfoViewController *vc = [[SetPersonInfoViewController alloc] init];
    vc.headline = @"Change Password";
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

- (UIView *)viewWithImageString:(NSString *)image title:(NSString *)title {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, 43.5)];
    UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(21, 13, 18, 18)];
    [view addSubview:img];
    img.image = [UIImage imageNamed:image];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(47.5, 14, 150, 15.5)];
    label.textAlignment = 0;
    label.font = FONT_13;
    label.text = title;
    [view addSubview:label];
    UIImageView *right = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_W - 17-11.5, 16, 11.5, 11.5)];
    right.image = [UIImage imageNamed:@"setting-jinru"];
    [view addSubview:right];
    view.userInteractionEnabled = YES;
    return view;
}

@end
