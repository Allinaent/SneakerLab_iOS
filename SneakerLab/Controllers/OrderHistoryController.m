//
//  OrderHistoryController.m
//  caowei
//
//  Created by Jason cao on 16/9/2.
//  Copyright © 2016年 Jason cao. All rights reserved.
//

#import "OrderHistoryController.h"
#import "OrderHistoryCell.h"
#import "SignInController.h"
#pragma mark - 分类的列表
@interface OrderHistoryController ()<UITableViewDelegate ,UITableViewDataSource>
{
    UITableView *_tableView;
    NSMutableArray *_dataSource;
}
@end

@implementation OrderHistoryController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Order History";
    self.view.backgroundColor = [UIColor whiteColor];
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, SCREEN_H) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    [self refreshUI];
}

#pragma mark ---tableView协议
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    OrderHistoryCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell)
    {
        cell = [[OrderHistoryCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    return cell;
}

- (void)refreshUI
{
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"signInSuccessful"] boolValue] == YES)
    {
        NSString *time = [self getCurrentTimestamp];
        NSArray *arr = @[@"appKey",@"apiKey",@"timestamp",@"limit",@"page",@"equipment_id",@"email",@"token"];
        NSDictionary *dic = @{@"page" : @"1",
                              @"limit" : @"10",
                              @"appKey" : APPKEY,
                              @"apiKey" : APIKEY,
                              @"equipment_id" : MYDEVICEID,
                              @"timestamp" : time,
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
        [[CWAPIClient sharedClient] POSTRequest:DINGDANLIEBIAO_URL parameters:parameters progress:nil success:^(NSURLSessionDataTask *task, id responseObject)
         {
             NSLog(@"%@",responseObject);
             // boom
             //（支付，订单列表签名，评论bug，firebase bug，购物车bug）
             [self showView];
         } failure:^(NSURLSessionDataTask *task, NSError *error)
         {
             NSLog(@"%@",error);
             [self showView];
         }];
    }
    else
    {
        SignInController *logVC = [[SignInController alloc] init];
        [self.navigationController pushViewController:logVC animated:NO];
    }
}

#pragma mark ---判断显示有无收藏的视图
- (void)showView
{
    if (_dataSource.count == 0)
    {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, SCREEN_H-64)];
        view.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:view];
        UIImageView *image = [FactoryUI createImageViewWithFrame:CGRectMake(self.view.center.x - 40, self.view.center.y - 40, 80, 80) imageName:@" 收藏－kong"];
        UILabel *label = [FactoryUI createLabelWithFrame:CGRectMake(20, self.view.center.y + 40, SCREEN_W-40, 20) text:@"No order yet" textColor:[UIColor blackColor] font:[UIFont fontWithName:@"HelveticaNeue" size:15]];
        label.textAlignment = 1;
        label.textColor = COLOR_9;
        [self.view addSubview:image];
        [self.view addSubview:label];
    }
}


#pragma mark ----懒加载
- (NSMutableArray *)dataSource
{
    if (_dataSource == nil)
    {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
