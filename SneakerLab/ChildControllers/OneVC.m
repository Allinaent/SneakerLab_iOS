//
//  OneVC.m
//  caowei
//
//  Created by Jason cao on 16/9/1.
//  Copyright © 2016年 Jason cao. All rights reserved.
//
#import "OneVC.h"
#import "RootViewController.h"
#import "AppDelegate.h"
#import "DetailController.h"
#import "ProductDetailViewController.h"
#import "ProductCell.h"
#import "ProductModel.h"
#import "ShoppingCartView.h"
#import "GProductDetailViewController.h"
@interface OneVC ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
{
    UICollectionView *_collectionView;
    NSMutableArray *_dataArr;
}
@end

@implementation OneVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 108, SCREEN_W - 5, SCREEN_H - 108) collectionViewLayout:layout];
    _collectionView.backgroundColor = [UIColor whiteColor];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    // 注册cell
    [_collectionView registerClass:[ProductCell class] forCellWithReuseIdentifier:@"cell"];
    
    [self.view addSubview:_collectionView];

}

#pragma mark -- collectionView协议 组数
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _dataArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    ProductCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    if (_dataArr)
    {
        ProductModel *model = _dataArr[indexPath.row];
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

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    ProductDetailViewController *detailVC = [[ProductDetailViewController alloc] init];
    ProductModel *model = _dataArr[indexPath.row];
    detailVC.productID = model.product_id;
    //[self.navigationController pushViewController:detailVC animated:YES];
    //测试
    GProductDetailViewController *vc = [[GProductDetailViewController alloc] init];
    vc.productID = model.product_id;
    [self.navigationController pushViewController:vc animated:YES];
    /*
    NewDetailViewController *detailVC = [[NewDetailViewController alloc] init];
    ProductModel *model = _dataArr[indexPath.row];
    detailVC.productID = model.product_id;
    [self.navigationController pushViewController:detailVC animated:YES];
     */
    /*
    DetailController *detailVC = [[DetailController alloc] init];
    ProductModel *model = _dataArr[indexPath.row];
    detailVC.productID = model.product_id;
    [self.navigationController pushViewController:detailVC animated:YES];
     */
    /*
    NewDetailViewController *detailVC = [UIViewController controllerWithStoryBoardName:@"ProductDetail" andIdentifier:@"newdetail_main"];
    ProductModel *model = _dataArr[indexPath.row];
    detailVC.productID = model.product_id;
    [self.navigationController pushViewController:detailVC animated:YES];
     */

}
#pragma mark- 分页
- (void)refreshUI:(NSString *)ID
{
    NSString *time = [self getCurrentTimestamp];
    NSArray *arr = @[@"appKey",@"apiKey",@"timestamp",@"limit",@"page",@"category_id",@"equipment_id",@"searchKey"];
    NSDictionary *dic = @{@"page" : @"1",
                          @"limit" : @"1000",
                          @"category_id" : ID,
                          @"appKey" : APPKEY,
                          @"apiKey" : APIKEY,
                          @"equipment_id" : MYDEVICEID,
                          @"timestamp" : time,
                          @"searchKey" :@""
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
    LJLog(@"%@", PRODUCT_URL);
    [[CWAPIClient sharedClient] POSTRequest:PRODUCT_URL parameters:parameters progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        LJLog(@"%@",responseObject);
        _dataArr = [NSMutableArray array];
        NSArray *dataArr = responseObject[@"data"];
        for (NSDictionary *dic in dataArr)
        {
            ProductModel *model = [[ProductModel alloc] init];
            [model setValuesForKeysWithDictionary:dic];
            [_dataArr addObject:model];
        }
        [_collectionView reloadData];
        }failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
