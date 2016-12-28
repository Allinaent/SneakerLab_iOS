//
//  MenuController.m
//  caowei
//
//  Created by Jason cao on 16/8/30.
//  Copyright © 2016年 Jason cao. All rights reserved.
//

#import "MenuController.h"
#import "AppDelegate.h"
#import "NotificationsController.h"
#import "ShoppingCartController.h"
#import "OrderHistoryController.h"
#import "OrderHistoryViewController.h"
#import "CurrencyController.h"
#import "ContactUsController.h"
#import "languageController.h"
#import "CustomSupportController.h"
#import "AboutUsController.h"
#import "ReturnPolicyController.h"
#import "CollectionController.h"
#import "RegisterController.h"
#import "LoginoutViewController.h"
#import "CollectController.h"
#import "ShopViewController.h"
#import "OrderViewController.h"
#import "SignInController.h"
#import "GSignInViewController.h"
#import "RootViewController.h"
#import <UIButton+WebCache.h>
#import "GShippingCartViewController.h"
#import "GPlaceOrderViewController.h"
#import <WZLBadgeImport.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <FBSDKCoreKit/FBSDKApplicationDelegate.h>

@interface MenuController ()<UITableViewDataSource , UITableViewDelegate>
{
    NSMutableArray * _dataArray;
    UISearchController * _searchController;
    UITableView *_tableView;
    UILabel *_label;
}
@property (nonatomic, strong) FBSDKProfilePictureView *faceimageview;
@end

@implementation MenuController

- (void)viewDidLoad {
    [super viewDidLoad];
    _tableView.backgroundColor = [UIColor colorWithHexString:@"#32303D"];
}

#pragma mark ----自定义searchbar
- (void)createSearchBar{
    _searchController.searchBar.placeholder = [NSString stringWithCString:"搜索" encoding:NSUTF8StringEncoding];
    //设置searchBar的背景色
    UIImage * searchBarBg1 = [self GetImageWithColor:[UIColor blackColor] andHeight:40];
    [_searchController.searchBar setBackgroundImage:searchBarBg1];
    [_searchController.searchBar setBackgroundColor:[UIColor clearColor]];
    //设置输入框的背景色
    UIImage * searchBarBg2 = [self GetImageWithColor:[UIColor colorWithWhite:0.400 alpha:1.000] andHeight:40];
    [_searchController.searchBar setSearchFieldBackgroundImage:searchBarBg2 forState:UIControlStateNormal];
    //设置字体颜色/大小，和圆角边框
    UITextField *searchField = [_searchController.searchBar valueForKey:@"_searchField"];
    searchField.textColor = [UIColor grayColor];
    [searchField setValue:[UIColor grayColor] forKeyPath:@"_placeholderLabel.textColor"];
    searchField.font = [UIFont systemFontOfSize:17];
    searchField.layer.cornerRadius = _searchController.searchBar.frame.size.height/2;
    searchField.layer.masksToBounds = YES;
    [_searchController.searchBar setContentMode:UIViewContentModeLeft];
    _tableView.tableHeaderView = _searchController.searchBar;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}
//生成图片
- (UIImage*) GetImageWithColor:(UIColor*)color andHeight:(CGFloat)height
{
    CGRect r= CGRectMake(0.0f, 0.0f, 1.0f, height);
    UIGraphicsBeginImageContext(r.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, r);
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}

#pragma mark -------UItableView协议
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    NSDictionary *dic = _dataArray[indexPath.row];
    cell.textLabel.text = dic[@"title"];
    cell.textLabel.font = [UIFont systemFontOfSize:13];
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.imageView.image = [UIImage imageNamed:dic[@"imageName"]];
    if(indexPath.row == 2) {
        cell.imageView.tag = 300;
    }
    cell.backgroundColor = [UIColor colorWithHexString:@"#32303d"];
    tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
    cell.selectedBackgroundView.backgroundColor = [UIColor colorWithWhite:0.298 alpha:1.000];
//    if (indexPath.row == (_dataArray.count-1)&&[[[NSUserDefaults standardUserDefaults] valueForKey:@"signInSuccessful"] boolValue] == NO) {
//        cell.textLabel.textColor = [UIColor grayColor];
//    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 140;
}

#pragma mark -- 头视图
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W*0.7, 140)];
    header.backgroundColor = [UIColor colorWithHexString:@"#32303d"];
    //UIImageView  *imageview1 = [FactoryUI createImageViewWithFrame:CGRectMake(0, 0, SCREEN_W*0.7, 140) imageName:@"背景图"];
    UIImageView *imageview1 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W*0.7, 140)];
    imageview1.image = headBackImg;
    imageview1.contentMode = UIViewContentModeScaleAspectFill;
    imageview1.bounds = CGRectMake(0, 0, SCREEN_W*0.7, 140);
    imageview1.layer.masksToBounds = YES;
    imageview1.backgroundColor = [UIColor colorWithHexString:@"#32303D"];
    UIView *view1 = [[UIView alloc]init];
    view1.backgroundColor = [UIColor colorWithHexString:@"#32303D"];
    view1.frame = imageview1.bounds;
    view1.alpha = 0.57;
    UIButton *imageBtn = [FactoryUI createButtonWithFrame:CGRectMake(10, 40, 80, 80) title:nil titleColor:nil imageName:nil backgroundImageName:@"头像－抽屉" target:self selector:nil];
    [imageBtn setBackgroundImage:headImg forState:UIControlStateNormal];
    imageBtn.layer.cornerRadius = imageBtn.frame.size.height/2;
    imageBtn.layer.masksToBounds = YES;
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:UD_FACEBOOK]==YES) {
        self.faceimageview = [[FBSDKProfilePictureView alloc] initWithFrame:imageBtn.bounds];
        _faceimageview.profileID = @"me";
        [FBSDKProfile currentProfile];
    }
    
    UIButton *cover = [[UIButton alloc] initWithFrame:header.bounds];
    cover.backgroundColor = [UIColor clearColor];
    [cover addTarget:self action:@selector(myself) forControlEvents:UIControlEventTouchUpInside];
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"signInSuccessful"] boolValue] == YES) {//登录成功
        NSString *firstname = [[NSUserDefaults standardUserDefaults]objectForKey:@"firstname"];
        NSString *lastname = [[NSUserDefaults standardUserDefaults]objectForKey:@"lastname"];
        if (firstname) {
            _userName = [NSString stringWithFormat:@"%@ %@", firstname, lastname];
        }
        _label = [[UILabel alloc] init];
        _label.frame = CGRectMake(100, 60, SCREEN_W*0.7-110, 40);
        _label.textColor = [UIColor whiteColor];
        _label.text = _userName;
        _label.adjustsFontSizeToFitWidth = YES;
        
        [PHPNetwork PHPNetworkWithParam:nil andUrl:PERSONINFO_URL andSignature:YES andLogin:YES finish:^(NSURLSessionDataTask *task, id responseObject) {
            
            if ([[responseObject valueForKey:@"status_code"] integerValue] == 0) {
                NSDictionary *data = [responseObject valueForKey:@"data"];
                for (NSString *key in data.allKeys) {
                    if ([key isEqualToString:@"avatar"]) {
                        NSString *imageUrl = [data valueForKey:@"avatar"];
                        [imageBtn sd_setBackgroundImageWithURL:[NSURL URLWithString:imageUrl] forState:UIControlStateNormal placeholderImage:headImg];
                    }else{
                        
                    }
                }
            }
            
        } err:^(NSURLSessionDataTask *task, NSError *error) {
            [MBManager showBriefAlert:@"Error"];
        }];
        
    }else{//游客登录
        _label = [[UILabel alloc] init];
        _label.frame = CGRectMake(100, 60, SCREEN_W*0.7-110, 40);
        _label.textColor = [UIColor whiteColor];
        _label.text = @"Login";
        _label.adjustsFontSizeToFitWidth = YES;
    }
    [header addSubview:imageview1];
    [header addSubview:view1];
    [header addSubview:_label];
    [header addSubview:imageBtn];
    [header addSubview:cover];
    [header bringSubviewToFront:cover];
    return header;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0;
}

-(void)setUserName:(NSString *)userName{

    _userName = userName;
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"signInSuccessful"]) {
        
        _label = [FactoryUI createLabelWithFrame:CGRectMake(120, 60, 80, 40) text:_userName textColor:[UIColor whiteColor] font:[UIFont systemFontOfSize:20]];
        [_label sizeToFit];
    }
}
#pragma mark ----TF协议
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    AppDelegate *tempAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NotificationsController *notifyVC = [[NotificationsController alloc] init];
    //ShoppingCartController *shopppingCartVC = [[ShoppingCartController alloc] init];//可能已经弃用，2016-11-03 15:18:07，郭隆基
    OrderHistoryViewController *orderVC = [[OrderHistoryViewController alloc] init];
    CurrencyController *currencyVC = [[CurrencyController alloc] init];
    ContactUsController *contactVC = [[ContactUsController alloc] init];
    languageController *languageVC = [[languageController alloc] init];
    AboutUsController *aboutUsVC = [[AboutUsController alloc] init];
    ReturnPolicyController *returnPolicyVC = [[ReturnPolicyController alloc] init];
    CollectController *collect = [[CollectController alloc]init];
    //ShopViewController *shopVC = [[ShopViewController alloc]init];
    SignInController *vc = [[SignInController alloc] init];
    bool flag = [[[NSUserDefaults standardUserDefaults] objectForKey:@"signInSuccessful"] boolValue];
    switch (indexPath.row) {
        case 0://Browse
            [tempAppDelegate.LeftSlideVC closeLeftView];//关闭左侧抽屉
            break;
        case 1://Notifications
            if (flag) {
                [tempAppDelegate.mainNavigationController pushViewController:notifyVC animated:YES];
            }
            else{
                [tempAppDelegate.mainNavigationController pushViewController:vc animated:YES];
            }
            [tempAppDelegate.LeftSlideVC closeLeftView];
            break;
        case 2://Shopping Cart
            if (flag) {
                //[tempAppDelegate.mainNavigationController pushViewController:shopVC animated:YES];
                GPlaceOrderViewController *gpvc = [[GPlaceOrderViewController alloc] init];
                gpvc.from = MENU;
                //测试
                //GSignInViewController *signvc = [[GSignInViewController alloc] init];
                GShippingCartViewController *shipvc = [[GShippingCartViewController alloc] init];
                [tempAppDelegate.mainNavigationController pushViewController:shipvc animated:YES];
            }
            else{
                [tempAppDelegate.mainNavigationController pushViewController:vc animated:YES];
            }
            [tempAppDelegate.LeftSlideVC closeLeftView];
            break;
        case 3://Order History
            if (flag) {
                [tempAppDelegate.mainNavigationController pushViewController:orderVC animated:YES];
            }
            else{
                [tempAppDelegate.mainNavigationController pushViewController:vc animated:YES];
            }
            [tempAppDelegate.LeftSlideVC closeLeftView];
            break;
        case 4://Currency
            //[tempAppDelegate.mainNavigationController pushViewController:currencyVC animated:YES];
            //改为contact us
            [tempAppDelegate.mainNavigationController pushViewController:contactVC animated:YES];
            [tempAppDelegate.LeftSlideVC closeLeftView];
            break;
        case 5://Contact US
            //改为customer support，因为用到了IM，所以先不做了
            //[tempAppDelegate.mainNavigationController pushViewController:contactVC animated:YES];
            //[tempAppDelegate.LeftSlideVC closeLeftView];
            //改为custom support
            [tempAppDelegate.mainNavigationController pushViewController:aboutUsVC animated:YES];
            [tempAppDelegate.LeftSlideVC closeLeftView];
            break;
        case 6://Custom Support
            //改为about us
            [tempAppDelegate.mainNavigationController pushViewController:returnPolicyVC animated:YES];
            [tempAppDelegate.LeftSlideVC closeLeftView];
            break;
        case 7://Language
            [tempAppDelegate.mainNavigationController pushViewController:languageVC animated:YES];
            [tempAppDelegate.LeftSlideVC closeLeftView];
            break;
        case 8://About Us
            [tempAppDelegate.mainNavigationController pushViewController:aboutUsVC animated:YES];
            [tempAppDelegate.LeftSlideVC closeLeftView];
            break;
        case 9://Return Policy
            [tempAppDelegate.mainNavigationController pushViewController:returnPolicyVC animated:YES];
            [tempAppDelegate.LeftSlideVC closeLeftView];
            break;
        case 10://Collect
            if (flag) {
                [tempAppDelegate.mainNavigationController pushViewController:collect animated:YES];
            }
            else{
                [tempAppDelegate.mainNavigationController pushViewController:vc animated:YES];
            }
            [tempAppDelegate.LeftSlideVC closeLeftView];
            break;

        case 11://Logout
            [self logoutAction];
            ;
            break;
        default:
            break;
    }
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
             [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"customer_id"];
             [[NSUserDefaults standardUserDefaults] removeObjectForKey:UD_CARD];
             [[NSUserDefaults standardUserDefaults] removeObjectForKey:UD_SHIPADDRESS];
             [[NSUserDefaults standardUserDefaults] removeObjectForKey:UD_HEADURL];
             [[NSUserDefaults standardUserDefaults] removeObjectForKey:UD_PHONE];
             [[NSUserDefaults standardUserDefaults] removeObjectForKey:UD_SEX];
             [[NSUserDefaults standardUserDefaults] removeObjectForKey:UD_AGE];
             [[NSUserDefaults standardUserDefaults] removeObjectForKey:UD_EMAIL];
             [[NSUserDefaults standardUserDefaults] removeObjectForKey:UD_PAY];
             MenuController *leftVC = [[MenuController alloc] init];
             RootViewController * rootVC = [[RootViewController alloc] init];
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
        
    }else{//游客模式
        /*
        SignInController *vc = [[SignInController alloc] init];
        AppDelegate *tempAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        [tempAppDelegate.mainNavigationController pushViewController:vc animated:YES];
         */
        /*
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Warning: no access to the API interface!"
                                                                       message:nil
                                                                preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* action = [UIAlertAction actionWithTitle:@"OK"
                                                         style:UIAlertActionStyleDefault
                                                       handler:nil];
        [alert addAction:action];
        [self presentViewController:alert animated:YES completion:nil];
         */
    }
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

#pragma mark ----statusBar

//设置状态栏颜色
- (void)setStatusBarBackgroundColor:(UIColor *)color {
    
    UIView *statusBar = [[[UIApplication sharedApplication] valueForKey:@"statusBarWindow"] valueForKey:@"statusBar"];
    if ([statusBar respondsToSelector:@selector(setBackgroundColor:)]) {
        statusBar.backgroundColor = color;
    }
}

#pragma mark --- 游客登录，用户进入个人收藏
- (void)myself
{
    AppDelegate *tempAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"signInSuccessful"] boolValue] == YES) {
        CollectionController *VC = [[CollectionController alloc] init];
        [tempAppDelegate.mainNavigationController pushViewController:VC animated:YES];
    }
    else{
        //SignInController *vc = [[SignInController alloc] init];
        LoginController *vc = [[LoginController alloc] init];
        [tempAppDelegate.mainNavigationController pushViewController:vc animated:YES];
    }
    [tempAppDelegate.LeftSlideVC closeLeftView];
}

//- (void)viewDidAppear:(BOOL)animated {
//    [super viewDidAppear:animated];
//#pragma mark - 刷新小红点
//    [PHPNetwork PHPNetworkWithParam:nil andUrl:SHOPPINGCART_URL andSignature:YES andLogin:YES finish:^(NSURLSessionDataTask *task, id responseObject) {
//        NSDictionary *all = [responseObject valueForKey:@"data"];
//        NSArray *carts = [all valueForKey:@"cart"];
//        //NSArray *cartbacks = [all valueForKey:@"cartback"];
//        [[_tableView viewWithTag:300] showBadgeWithStyle:WBadgeStyleNumber value:carts.count animationType:WBadgeAnimTypeNone];
//    } err:^(NSURLSessionDataTask *task, NSError *error) {
//        
//    }];
//}

-(void)viewWillAppear:(BOOL)animated{
    [self setStatusBarBackgroundColor:[UIColor colorWithHexString:@"#32303d"]];
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"signInSuccessful"] boolValue] == YES)
    {
        //如果登录成功
        [self refreshUI];
#pragma mark - 刷新小红点
        [PHPNetwork PHPNetworkWithParam:nil andUrl:SHOPPINGCART_URL andSignature:YES andLogin:YES finish:^(NSURLSessionDataTask *task, id responseObject) {
            NSDictionary *all = [responseObject valueForKey:@"data"];
            NSArray *carts = [all valueForKey:@"cart"];
            NSArray *cartbacks = [all valueForKey:@"cartback"];
            [[_tableView viewWithTag:300] showBadgeWithStyle:WBadgeStyleNumber value:carts.count+cartbacks.count animationType:WBadgeAnimTypeNone];
        } err:^(NSURLSessionDataTask *task, NSError *error) {
            
        }];
    }
    else
    {
        [self reloadData];
    }
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, SCREEN_H) style:UITableViewStyleGrouped];
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = [UIColor colorWithHexString:@"#32303d"];
    _tableView.bounces = NO;
    [self.view addSubview:_tableView];
}
-(void)reloadData{

    self.view.frame = CGRectMake(0, 0, SCREEN_W, SCREEN_H);
    self.view.backgroundColor = [UIColor colorWithHexString:@"#32303d"];
    _dataArray =[@[@{@"title":@"Browse",@"imageName":@"首页"},
                   @{@"title":@"Notifications",@"imageName":@"通知2"},
                   @{@"title":@"Shopping Cart",@"imageName":@"购物车"},
                   @{@"title":@"Order History",@"imageName":@"历史订单"},
                   //@{@"title":@"Currency",@"imageName":@"货币"},
                   @{@"title":@"Contact Us",@"imageName":@"联系我们"},
                   //@{@"title":@"Custom Support",@"imageName":@"客户支持"},
                   //@{@"title":@"Language",@"imageName":@"语言"},
                   @{@"title":@"About Us",@"imageName":@"关于我们"}
                   //@{@"title":@"Return Policy",@"imageName":@"条款"},
                   //@{@"title":@"Collection",@"imageName":@"collect"},
                   //@{@"title":@"Logout",@"imageName":@"退出"}
                   
                   ] mutableCopy];
}

#pragma mark --- 登录成功刷新UI
- (void)refreshUI
{
    [self reloadData];
    NSString *time = [self getCurrentTimestamp];
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"signInSuccessful"] boolValue] == YES)
    {
        NSArray *arr = @[@"appKey",@"apiKey",@"timestamp",@"email",@"token",@"equipment_id"];
        NSDictionary *dic = @{@"email" : CWEMAIL,
                              @"token" : CWTOKEN,
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
        
        [[CWAPIClient sharedClient] POSTRequest:SHOPPINGCART_URL parameters:parameters progress:nil success:^(NSURLSessionDataTask *task, id responseObject)
         {
             NSDictionary *dic = responseObject[@"data"];
             NSArray *productsArr = dic[@"products"];
             if (productsArr.count > 0)
             {
                 
             }
         } failure:^(NSURLSessionDataTask *task, NSError *error)
         {
             NSLog(@"%@",error);
         }];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    UIView *view = [_tableView viewWithTag:300];
    [view clearBadge];
}

@end
