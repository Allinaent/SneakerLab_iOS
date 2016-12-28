//
//  OverViewController.m
//  caowei
//
//  Created by Jason cao on 16/9/5.
//  Copyright © 2016年 Jason cao. All rights reserved.
//

#import "OverViewController.h"
#import "OverviewModel.h"
#import "OverviewCell.h"
@interface OverViewController ()<UITableViewDelegate, UITableViewDataSource>
{
    UITableView *_tableView;
    NSMutableArray *_dataSource;
    NSInteger _reviewCount;
}

@end

@implementation OverViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, SCREEN_H - 118) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _footer = [[FooterView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, 180)];
    _tableView.tableFooterView = _footer;
    [self getLikeBtnState];
}

#pragma mark -----TableView协议
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _reviewCount;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    OverviewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"overviewCell"];
    if (!cell)
    {
        cell = [[OverviewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"overviewCell"];
    }
    if (_dataSource)
    {
        OverviewModel *model = _dataSource[indexPath.row];
        [cell refreshUI:model];
    }
    return cell;
}

- (void)getLikeBtnState
{//登录状态是判断，游客模式直接没有收藏
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"signInSuccessful"] boolValue] == NO) {
        _header.likeBtnState = NO;
    }
    else
    {
        NSDictionary *dic = @{@"email" : CWEMAIL,
                              @"token" : CWTOKEN
                              };
        [PHPNetwork PHPNetworkWithParam:dic  andUrl:COllECTION_URL andSignature:YES andLogin:YES finish:^(NSURLSessionDataTask *task, id responseObject) {
            
        } err:^(NSURLSessionDataTask *task, NSError *error) {
            NSLog(@"!!!");
        }];
    }
}

- (void)refreshUI:(NSString *)productID
{
    NSString *time = [self getCurrentTimestamp];
    NSArray *arr = @[@"appKey",@"apiKey",@"timestamp",@"product_id",@"equipment_id"];
    NSDictionary *dic = @{@"product_id" : productID,
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
    
    [[CWAPIClient sharedClient] POSTRequest:PRODUCTDETAIL_URL parameters:parameters progress:nil success:^(NSURLSessionDataTask *task, id responseObject)
     {
         NSDictionary *dic = responseObject[@"data"];
         NSArray *imgs = dic[@"images"];
         NSMutableArray *arr = [NSMutableArray array];
         for (NSString *imgStr in imgs) {
             [arr addObject:(NSString *)
              CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)imgStr.gtm_stringByUnescapingFromHTML, (CFStringRef)@"!$&'()*+,-./:;=?@_~%#[]", NULL, kCFStringEncodingUTF8))];
         }
         _header = [[HeaderView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, SCREEN_W + 155) withArr:arr];
         _header.nameLabel.text = dic[@"name"];
         _header.productID = productID;
         NSNumber *star = dic[@"rating"];//分级
         NSNumber *reviewsNumber = dic[@"reviews"];
         _reviewCount = reviewsNumber.integerValue;
         
         _header.reviewedLabel.text = [NSString stringWithFormat:@"  (%d)", reviewsNumber.intValue];
         [_header.starView withStar:[star intValue] :80 :14];
         _tableView.tableHeaderView = _header;
         [self.view addSubview:_tableView];
     } failure:^(NSURLSessionDataTask *task, NSError *error)
     {
         NSLog(@"%@",error);
     }];
}

- (void)refreshCellUI:(NSString *)productID
{
    NSString *time = [self getCurrentTimestamp];
    NSArray *arr = @[@"appKey",@"apiKey",@"timestamp",@"product_id",@"equipment_id",@"page",@"limit"];
    NSDictionary *dic = @{@"product_id" : productID,
                          @"appKey" : APPKEY,
                          @"apiKey" : APIKEY,
                          @"equipment_id" : MYDEVICEID,
                          @"timestamp" : time,
                          @"page" : @"1",
                          @"limit" : @"5"
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
    
    [[CWAPIClient sharedClient] POSTRequest:RATING_URL parameters:parameters progress:nil success:^(NSURLSessionDataTask *task, id responseObject)
     {
         NSArray *dataArr = responseObject[@"data"];
         for (NSDictionary *dic in dataArr)
         {
             OverviewModel *model = [[OverviewModel alloc] init];
             [model setValuesForKeysWithDictionary:dic];
             [self.dataSource addObject:model];
         }
         [_tableView reloadData];
     } failure:^(NSURLSessionDataTask *task, NSError *error)
     {
         NSLog(@"%@",error);
     }];
}

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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
