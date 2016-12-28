//
//  RootViewController.m
//  caowei
//
//  Created by Jason cao on 16/8/30.
//  Copyright © 2016年 Jason cao. All rights reserved.
//

#import "RootViewController.h"
#import "AppDelegate.h"
#import "SGTopTitleView.h"
#import "OneVC.h"
#import "ShoppingCartView.h"
#import "SignInController.h"
#import "ChoseView.h"
#import "SearchController.h"
#import "OrderConfirmController.h"
@interface RootViewController ()<UIScrollViewDelegate , SGTopTitleViewDelegate>
{
    NSMutableArray *_titleArray;
    NSMutableArray *_categoryIDArray;
}
@property (nonatomic , strong) SGTopTitleView *scrollerViewtop;
@property (nonatomic , strong) UIScrollView *scrollerViewButtom;
@property (nonatomic , copy) NSMutableArray *titleArray;
@property (nonatomic , copy) NSMutableArray *categoryIDArray;

@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
#if PREDUPLICATE==0
    self.title = @"FOUNDED SOLE";
#elif PREDUPLICATE==1
    self.title = @"IVANKA JINGLE";
#elif PREDUPLICATE==5
    self.title = @"SNEAKER CRUNCH";
#elif PREDUPLICATE==6
    self.title = @"STYL";
#endif
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"列表"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]style:UIBarButtonItemStylePlain target:self action:@selector(openOrCloseLeftList)];
    //UIBarButtonItem *searchItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"搜索"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]style:UIBarButtonItemStylePlain target:self action:@selector(searchItemClicked:)];
    //UIBarButtonItem * filterItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"筛选"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]style:UIBarButtonItemStylePlain target:self action:@selector(filterItemClicked:)];
    
    //self.navigationItem.rightBarButtonItems = @[searchItem,filterItem];
    [self loadData];
}
#pragma mark -------添加子控制器
// 添加所有子控制器
- (void)setupChildViewController
{
    for (int i = 1; i < _titleArray.count; i++)
    {
        OneVC *vc = [[OneVC alloc] init];
        [self addChildViewController:vc];
    }
}

// 显示控制器的view
- (void)showVc:(NSInteger)index {
    
    CGFloat offsetX = index * self.view.frame.size.width;
    OneVC *vc = self.childViewControllers[index];
    [vc refreshUI:self.categoryIDArray[index]];
    
    // 判断控制器的view有没有加载过,如果已经加载过,就不需要加载
    if (vc.isViewLoaded) return;
    
    [self.scrollerViewButtom addSubview:vc.view];
    vc.view.frame = CGRectMake(offsetX, 0, self.view.frame.size.width, self.view.frame.size.height);
}
//增加一个搜索的功能
#pragma mark------item点击事件
- (void)searchItemClicked:(UIBarButtonItem *)item
{
//    SearchController *signVC = [[SearchController alloc] init];
//    [self.navigationController pushViewController:signVC animated:YES];
}
//增加一个筛选功能
- (void)filterItemClicked:(UIBarButtonItem *)item
{
//    OrderConfirmController *vc = [[OrderConfirmController alloc] init];
//    [self.navigationController pushViewController:vc animated:YES];
}


#pragma mark ------抽屉
- (void)openOrCloseLeftList
{
    AppDelegate *tempAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    if (tempAppDelegate.LeftSlideVC.closed)
    {
        [tempAppDelegate.LeftSlideVC openLeftView];
        [tempAppDelegate.LeftSlideVC.leftVC viewWillAppear:YES];
    }
    else
    {
        [tempAppDelegate.LeftSlideVC closeLeftView];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    AppDelegate *tempAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [tempAppDelegate.LeftSlideVC setPanEnabled:NO];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    AppDelegate *tempAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [tempAppDelegate.LeftSlideVC setPanEnabled:YES];
}

#pragma mark -------scrollerView
- (void)createScrollerView
{
    self.scrollerViewtop = [SGTopTitleView topTitleViewWithFrame:CGRectMake(0, 0, SCREEN_W, 36)];
    
    //设置代理
    _scrollerViewtop.scrollTitleArr = [NSArray arrayWithArray:_titleArray];
    _scrollerViewtop.delegate_SG = self;
    self.scrollerViewtop.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
    [self.view addSubview:self.scrollerViewtop];
    
    // 创建底部scrollerView
    self.scrollerViewButtom = [[UIScrollView alloc] initWithFrame:CGRectMake(5, -64, SCREEN_W, SCREEN_H)];
    self.scrollerViewButtom.delegate = self;
    self.scrollerViewButtom.pagingEnabled = YES;
    self.scrollerViewButtom.bounces = NO;
    self.scrollerViewButtom.showsHorizontalScrollIndicator = NO;
    self.scrollerViewButtom.showsVerticalScrollIndicator = NO;
    self.scrollerViewButtom.contentSize = CGSizeMake(_titleArray.count * SCREEN_W, 0);
    OneVC *one = [[OneVC alloc] init];
    if (self.categoryIDArray!=nil&&self.categoryIDArray.count>0) {
        [one refreshUI:self.categoryIDArray[0]];
    }
    [self.scrollerViewButtom addSubview:one.view];
    [self addChildViewController:one];
    [self.view addSubview:self.scrollerViewButtom];
    
    [self.view insertSubview:self.scrollerViewButtom belowSubview:self.scrollerViewtop];
}

#pragma mark - - - SGTopScrollMenu代理方法
- (void)SGTopTitleView:(SGTopTitleView *)topTitleView didSelectTitleAtIndex:(NSInteger)index {
    
    // 1 计算滚动的位置
    CGFloat offsetX = index * self.view.frame.size.width;
    self.scrollerViewButtom.contentOffset = CGPointMake(offsetX, 0);
    
    // 2.给对应位置添加对应子控制器
    [self showVc:index];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    // 计算滚动到哪一页
    NSInteger index = scrollView.contentOffset.x / scrollView.frame.size.width;
    
    // 1.添加子控制器view
    [self showVc:index];
    
    // 2.把对应的标题选中
    UILabel *selLabel = self.scrollerViewtop.allTitleLabel[index];

    [self.scrollerViewtop scrollTitleLabelSelecteded:selLabel];
    
    // 3.让选中的标题居中
    [self.scrollerViewtop scrollTitleLabelSelectededCenter:selLabel];
}


// 请求数据
- (void)loadData
{
    NSString *time = [self getCurrentTimestamp];
    NSArray *arr = @[@"appKey",@"apiKey",@"timestamp",@"limit",@"page",@"parent_id",@"equipment_id"];
    NSDictionary *dic = @{@"page" : @"1",
                          @"limit" : @"10",
                          @"parent_id" : @"0",
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
    
    [[CWAPIClient sharedClient] POSTRequest:CATEGORY_URL parameters:parameters progress:nil success:^(NSURLSessionDataTask *task, id responseObject)
     {
         NSMutableArray *arr = responseObject[@"data"];
         for (NSDictionary *dic in arr)
         {
             NSString *str = dic[@"name"];
             NSString *str1 = dic[@"category_id"];
             [self.titleArray addObject:str];
             [self.categoryIDArray addObject:str1];
         }
         [self createScrollerView];
         [self setupChildViewController];
     } failure:^(NSURLSessionDataTask *task, NSError *error)
     {
         NSLog(@"%@",error);
     }];
}

#pragma mark ---- 懒加载
- (NSMutableArray *)titleArray
{
    if (_titleArray == nil)
    {
        _titleArray = [[NSMutableArray alloc] init];
    }
    return _titleArray;
}

- (NSMutableArray *)categoryIDArray
{
    if (_categoryIDArray == nil)
    {
        _categoryIDArray = [[NSMutableArray alloc] init];
    }
    return _categoryIDArray;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

@end
