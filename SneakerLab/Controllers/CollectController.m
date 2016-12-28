//
//  CollectController.m
//  SneakerLab
//
//  Created by edz on 2016/10/21.
//  Copyright © 2016年 Jason cao. All rights reserved.
//

#import "CollectController.h"
#import "CollectCell.h"
#import "SignInController.h"
#import "ProductDetailViewController.h"
#import "ProductModel.h"
#import "GProductDetailViewController.h"

@interface CollectController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
{

    NSMutableArray *_dataSource;
    NSString *_productID;
    NSIndexPath *_path;


}
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UILabel *label;
@end

@implementation CollectController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"Collection";
    self.automaticallyAdjustsScrollViewInsets = NO;
    SET_NAV_MIDDLE
    self.view.backgroundColor = [UIColor whiteColor];
    _label = [FactoryUI createLabelWithFrame:CGRectMake(20, 10, SCREEN_W-40, 20) text:@"items" textColor:[UIColor blackColor] font:[UIFont systemFontOfSize:17]];
    _label.textAlignment = 1;
    [self.view addSubview:_label];
    [self createCollection];

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self refreshUI];
}

#pragma mark ---判断显示有无收藏的视图
- (void)showView
{
    if (_dataSource.count == 0)
    {
        UIImageView *image = [FactoryUI createImageViewWithFrame:CGRectMake(self.view.center.x - 40, self.view.center.y - 40, 80, 80) imageName:@" 收藏－kong"];
        UILabel *label = [FactoryUI createLabelWithFrame:CGRectMake(20, self.view.center.y + 40, SCREEN_W-40, 20) text:@"Collection still empty" textColor:[UIColor blackColor] font:[UIFont fontWithName:@"HelveticaNeue" size:15]];
        label.textAlignment = 1;
        label.textColor = COLOR_9;
        [self.view addSubview:image];
        [self.view addSubview:label];
    }
}


-(void)createCollection{
    UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    self.view.backgroundColor = [UIColor colorWithHexString:@"#FAFAFA"];
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 40, SCREEN_W - 5, SCREEN_H- 104) collectionViewLayout:layout];
    _collectionView.backgroundColor = [UIColor whiteColor];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    //注册cell
    [_collectionView registerClass:[CollectCell class] forCellWithReuseIdentifier:@"cell"];
    _collectionView.backgroundColor = [UIColor colorWithHexString:@"#FAFAFA"];
    [self.view addSubview:_collectionView];

}
#pragma mark ----collection协议
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _dataSource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CollectCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    if (_dataSource)
    {
        CollectModel * model = _dataSource[indexPath.row];
        [cell refreshUI:model];
    }
   return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake((SCREEN_W -20) / 2, (SCREEN_W -20) / 2 + 85);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(2.5, 2.5, 2.5, 2.5);
}
- (void)refreshUI
{
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"signInSuccessful"] boolValue] == YES)
    {
        NSString *time = [self getCurrentTimestamp];
        NSArray *arr = @[@"appKey",@"apiKey",@"timestamp",@"email",@"equipment_id",@"token"];
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
        [[CWAPIClient sharedClient] POSTRequest:COllECTION_URL parameters:parameters progress:nil success:^(NSURLSessionDataTask *task, id responseObject)
         {
             [self.dataSource removeAllObjects];
             NSArray *dataArr = responseObject[@"data"];
             for (NSDictionary *dic in dataArr)
             {
                CollectModel  *model = [[CollectModel alloc] init];
                 [model setValuesForKeysWithDictionary:dic];
                 [self.dataSource addObject:model];
             }
             if (self.dataSource.count == 0) {
                 [self showView];
             }
             [_collectionView reloadData];
         } failure:^(NSURLSessionDataTask *task, NSError *error)
         {
             NSLog(@"%@",error);
         }];}
    else
    {
       SignInController  *logVC = [[SignInController alloc] init];
        [self.navigationController pushViewController:logVC animated:NO];
    }
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
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    //ProductDetailViewController *detailVC = [[ProductDetailViewController alloc] init];
    GProductDetailViewController *detailVC = [[GProductDetailViewController alloc] init];
    ProductModel *model = _dataSource[indexPath.row];
    detailVC.productID = model.product_id;
    [self.navigationController pushViewController:detailVC animated:YES];
}

@end
