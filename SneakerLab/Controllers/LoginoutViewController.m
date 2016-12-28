//
//  LoginoutViewController.m
//  SneakerLab
//
//  Created by edz on 2016/10/19.
//  Copyright © 2016年 Jason cao. All rights reserved.
//

#import "LoginoutViewController.h"
#import "LoginController.h"
#import "AppDelegate.h"
#import "MenuController.h"
#import "RootViewController.h"
#import "SignInController.h"
@interface LoginoutViewController ()

@end

@implementation LoginoutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor clearColor];
    [self  logoutAction];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)logoutAction
{
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
             NSLog(@"%@",responseObject);
             NSLog(@"%@",@"退出成功");
             [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"CWToken"];
             [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"CWEmail"];
             [[NSUserDefaults standardUserDefaults] setObject:@NO forKey:@"signInSuccessful"];
             [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"firstname"];
             [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"customer_id"];
             [[NSUserDefaults standardUserDefaults] removeObjectForKey:UD_CARD];
             [[NSUserDefaults standardUserDefaults] removeObjectForKey:UD_SHIPADDRESS];
             [[NSUserDefaults standardUserDefaults] removeObjectForKey:UD_HEADURL];
             [[NSUserDefaults standardUserDefaults] removeObjectForKey:UD_PHONE];
             [[NSUserDefaults standardUserDefaults] removeObjectForKey:UD_SEX];
             [[NSUserDefaults standardUserDefaults] removeObjectForKey:UD_AGE];
             [[NSUserDefaults standardUserDefaults] removeObjectForKey:UD_EMAIL];
             [[NSUserDefaults standardUserDefaults] removeObjectForKey:UD_PAY];
             AppDelegate *tempAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
             MenuController *leftVC = [[MenuController alloc] init];
             RootViewController * rootVC = [[RootViewController alloc] init];
             tempAppDelegate.mainNavigationController = [[UINavigationController alloc] initWithRootViewController:rootVC];
             tempAppDelegate.LeftSlideVC = [[LeftSlideViewController alloc] initWithLeftView:leftVC andMainView:tempAppDelegate.mainNavigationController];
             tempAppDelegate.window.rootViewController = tempAppDelegate.LeftSlideVC;
             self.navigationController.navigationBarHidden = NO;
             //退出登录以后
             RootViewController *menu = [[RootViewController alloc]init];
             [self.navigationController pushViewController:menu animated:YES];
             
             // SignInController *vc = [[SignInController alloc] init];
             // [self.navigationController pushViewController:vc animated:YES];
         } failure:^(NSURLSessionDataTask *task, NSError *error)
         {
             NSLog(@"%@",error);
         }];
        
    }else{//游客模式
        // UIAlertView *alterView=[[UIAlertView alloc]initWithTitle:@"提示" message:@"这个App接口不能用" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        // [alterView show];
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Warning: no access to the API interface!"
                                                                       message:nil
                                                                preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* action = [UIAlertAction actionWithTitle:@"OK"
                                                         style:UIAlertActionStyleDefault
                                                       handler:nil];
        [alert addAction:action];
        [self presentViewController:alert animated:YES completion:nil];
    }    
}



@end
