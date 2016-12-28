//
//  WelcomeController.m
//  caowei
//
//  Created by Jason cao on 2016/9/20.
//  Copyright © 2016年 Jason cao. All rights reserved.
//

#import "WelcomeController.h"
#import "RatedCell.h"
#import "RootViewController.h"
#import "MenuController.h"
#import "AppDelegate.h"
@interface WelcomeController () <UICollectionViewDelegateFlowLayout,UICollectionViewDelegate, UICollectionViewDataSource>
{
    UICollectionView *_collectionView;
    NSMutableArray *_dataSource;
}
@end

@implementation WelcomeController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"Welcome";
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Skip" style:UIBarButtonItemStylePlain target:self action:@selector(skipAction)];
    self.navigationItem.hidesBackButton = YES;
    UILabel *label = [FactoryUI createLabelWithFrame:CGRectMake(self.view.center.x - 100, 15, 200, 30) text:@"What do you like to shop for?" textColor:[UIColor blackColor] font:[UIFont boldSystemFontOfSize:14]];
    [self.view addSubview:label];
    
    UILabel *label1 = [FactoryUI createLabelWithFrame:CGRectMake(self.view.center.x - 100, 55, 200, 30) text:@"Pick at least one category" textColor:[UIColor lightGrayColor] font:[UIFont systemFontOfSize:14]];
    [self.view addSubview:label1];
    UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 95, SCREEN_W, SCREEN_H - 200) collectionViewLayout:layout];
    _collectionView.backgroundColor = [UIColor whiteColor];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.allowsMultipleSelection = YES;
    
    UIButton *nextBtn = [FactoryUI createButtonWithFrame:CGRectMake(0, SCREEN_H - 40, SCREEN_W, 40) title:@"Next" titleColor:[UIColor whiteColor] imageName:nil backgroundImageName:nil target:self selector:@selector(nextAction)];
    nextBtn.backgroundColor = [UIColor colorWithHexString:@"#de4536"];
    nextBtn.layer.cornerRadius = 4;
    [self.view addSubview:nextBtn];
    // 注册cell
    [_collectionView registerClass:[RatedCell class] forCellWithReuseIdentifier:@"ratedCell"];
    [self.view addSubview:_collectionView];
}

#pragma mark -- collectionView协议 组数
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 4;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    RatedCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ratedCell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor blackColor];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake((SCREEN_W -20) / 2, (SCREEN_W -20) / 2);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(2.5, 2.5, 2.5, 2.5);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    RatedCell *cell = (RatedCell *)[collectionView cellForItemAtIndexPath:indexPath];
    cell.contentView.alpha = 0.3;
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    RatedCell *cell = (RatedCell *)[collectionView cellForItemAtIndexPath:indexPath];
    cell.contentView.alpha = 1;
}

- (void)skipAction
{
    
  /*  AppDelegate *tempAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    MenuController *leftVC = [[MenuController alloc] init];
    RootViewController * rootVC = [[RootViewController alloc] init];
    tempAppDelegate.mainNavigationController = [[UINavigationController alloc] initWithRootViewController:rootVC];
    tempAppDelegate.LeftSlideVC = [[LeftSlideViewController alloc] initWithLeftView:leftVC andMainView:tempAppDelegate.mainNavigationController];
    tempAppDelegate.window.rootViewController = tempAppDelegate.LeftSlideVC;
    self.navigationController.navigationBarHidden = NO;*/
        AppDelegate *tempAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];

      MenuController *leftVC = [[MenuController alloc] init];
     
      RootViewController *rootVC = [[RootViewController alloc] init];
     tempAppDelegate.mainNavigationController = [[UINavigationController alloc] initWithRootViewController:rootVC];
     tempAppDelegate.LeftSlideVC = [[LeftSlideViewController alloc] initWithLeftView:leftVC andMainView:tempAppDelegate.mainNavigationController];
     tempAppDelegate.window.rootViewController = tempAppDelegate.LeftSlideVC;
    self.navigationController.navigationBarHidden = NO;
    [self.navigationController pushViewController:rootVC animated:YES];
}

- (void)nextAction
{
    [self skipAction];
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
