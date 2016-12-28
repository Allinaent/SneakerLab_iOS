//
//  ProductDetailViewController.m
//  SneakerLab
//
//  Created by 郭隆基 on 16/11/11.
//  Copyright © 2016年 Jason cao. All rights reserved.
//

#define dragStrength 65.0 //拖拽强度
#define contenSize (SCREEN_H-50)  //第二个scrollView的contentSize大小
#import "ProductDetailViewController.h"
#import "BuyBotomView.h"
#import "LoadMoreView.h"
#import "SecondPageTopBar.h"
#import <SDCycleScrollView.h>
#import "MyStarView.h"
#import "GTMNSString+HTML.h"
#import "ChoseView.h"
#import "ShopViewController.h"
#import "RatingController.h"
#import "ShoppingInfoController.h"
#import "SignInController.h"

@interface ProductDetailViewController ()<UIScrollViewDelegate,BotomViewDelegate,SecondPageTopBarDelegate,SDCycleScrollViewDelegate,UIWebViewDelegate,TypeSeleteDelegete>
{
    ChoseView *choseView;
    NSArray *sizearr;//型号数组
    NSArray *colorarr;//分类数组
    NSDictionary *stockarr;//商品库存量
    NSString *_product_option_id;//尺寸
    NSString *_product_option_value_id;
    NSString *_product_option_id2;//颜色（没有设计只能简单实现）
    NSString *_product_option_value_id2;
    NSString *_size;
}
@property(nonatomic,strong)NSMutableArray *sizeMutableArray;
@property(nonatomic,strong)NSMutableArray *colorMutableArray;

@property(nonatomic,strong)UIScrollView *mainScrollView;
@property(nonatomic,strong)UIScrollView *secScrollView;
@property(nonatomic,strong)SecondPageTopBar *topBar;
@property(nonatomic,strong)BuyBotomView *botomView;
@property(nonatomic,strong)UIView *NavBarView;
@property(nonatomic,strong)SDCycleScrollView * banerView;
@property(nonatomic,strong)UILabel * secPageHeaderLabel;
@property(nonatomic,strong)UIButton * backToTopBtn;

@property(nonatomic,strong)UILabel * banerIndictor;
@property(nonatomic,strong)UIView *infoView;
@property(nonatomic,strong)UIWebView *describeView;
@property(nonatomic,strong)UIButton *viewall1;
@property(nonatomic,strong)UIButton *viewall2;
/**
 商品属性
 */
@property(nonatomic,strong)NSString *price;
@property(nonatomic,strong)NSString *oriPrice;
@property(nonatomic,strong)NSString *productName;
@property(nonatomic,strong)NSString *sale;
@property(nonatomic,strong)NSString *bought;
@property(nonatomic,assign)CGFloat star;
@property(nonatomic,assign)NSInteger ratingNum;
@property(nonatomic,strong)NSString *htmlcontent;
@property(nonatomic,assign)NSInteger quantity;
@property(nonatomic,assign)NSInteger save;
@property(nonatomic,strong)NSDictionary *shipping_info;

@end

@implementation ProductDetailViewController
{
    int banerCurImg;
    NSArray * imagesUrlArr;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden=NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    self.botomView.botomViewDelegate = self;
    [self newDetailRequestAndHandleDatas];
    self.botomView.productID = self.productID;
    
}

- (void)newDetailRequestAndHandleDatas {
    NSDictionary *dic = @{@"product_id":self.productID};
    [PHPNetwork PHPNetworkWithParam:dic andUrl:PRODUCTDETAIL_URL andSignature:YES andLogin:NO finish:^(NSURLSessionDataTask *task, id responseObject) {
        NSDictionary *dataDic = [responseObject objectForKey:@"data"];
        NSArray *array = [dataDic objectForKey:@"images"];
        NSMutableArray *arr = [NSMutableArray array];
        for (NSString *str in array) {
            [arr addObject:[NSString phpStr:str]];
        }
        imagesUrlArr = [arr copy];
        banerCurImg = 1;
        self.banerView.currentPageDotColor = COLOR_8;
        self.banerView.pageDotColor = COLOR_D8;
        
        self.oriPrice = [dataDic valueForKey:@"original_price"];
        self.price = [dataDic valueForKey:@"special_price"];
        self.productName = [dataDic valueForKey:@"name"];
        self.sale = [dataDic valueForKey:@"discount"];
        self.bought = [dataDic valueForKey:@"sales_volume"];
        self.star = [[dataDic valueForKey:@"rating"] floatValue];
        self.ratingNum = [[dataDic valueForKey:@"reviews"] integerValue];
        self.htmlcontent = [dataDic valueForKey:@"description"];
        self.quantity = [[dataDic valueForKey:@"quantity"] integerValue];
        self.save = [[dataDic valueForKey:@"collections"] integerValue];
        self.shipping_info = [dataDic valueForKey:@"shipping_info"];
        NSArray *options = dataDic[@"options"];
        NSMutableArray *arrsize = [NSMutableArray array];
        NSMutableArray *arrcolor = [NSMutableArray array];
        for (NSDictionary *dict in options) {
            _product_option_id = dict[@"product_option_id"];
            NSString *attr = dict[@"name"];
            NSArray *productOptionValueArray = dict[@"product_option_value"];
            //获取属性数组内容
            for (NSDictionary *productOptionValueDict in productOptionValueArray) {
                //放入对应的数组中
                if ([attr isEqualToString:@"size"]) {
                    [self.sizeMutableArray addObject:productOptionValueDict];
                    [arrsize addObject:[productOptionValueDict valueForKey:@"name"]];
                }
                if ([attr isEqualToString:@"color"]) {
                    [self.colorMutableArray addObject:productOptionValueDict];
                    [arrcolor addObject:[productOptionValueDict valueForKey:@"name"]];
                }
                
            }
        }
        sizearr = [NSArray arrayWithArray:arrsize];
        colorarr = [NSArray arrayWithArray:arrcolor];
        [self setFirstPageView];
        [self addNavBarView];
        [self addBotomView];
        [self initChoseView];
        [self secScrollView];
        [self.view bringSubviewToFront:_botomView];
        [self describeView];
    } err:^(NSURLSessionDataTask *task, NSError *error) {
        LJLog(@"!!!%@", error);
    }];
}


-(UIScrollView*)mainScrollView{
    if (_mainScrollView == nil){
        _mainScrollView = [[UIScrollView alloc] init];
        _mainScrollView.delegate = self;
        _mainScrollView.frame = CGRectMake(0.0, 0.0, SCREEN_W, SCREEN_H-BottomH);
        _mainScrollView.pagingEnabled = NO;
        _mainScrollView.showsVerticalScrollIndicator = NO;
        _mainScrollView.tag =100;
        _mainScrollView.scrollEnabled = YES;
        _mainScrollView.bounces = YES;
        [self.view addSubview:_mainScrollView];
    }
    return _mainScrollView;
}
-(UIScrollView*)secScrollView{
    if (_secScrollView==nil) {
        _secScrollView=[[UIScrollView alloc]init];
        _secScrollView.backgroundColor = [UIColor whiteColor];
        _secScrollView.frame=CGRectMake(0, CGRectGetMaxY(self.mainScrollView.frame)+30, SCREEN_W, SCREEN_H-NaviBarH-BottomH-TopTabBarH);
        _secScrollView.delegate=self;
        _secScrollView.pagingEnabled=NO;
        _secScrollView.showsVerticalScrollIndicator=NO;
        _secScrollView.tag=200;
        self.secScrollView.contentSize=CGSizeMake(0, contenSize);
        [self.view addSubview:_secScrollView];
    }
    return _secScrollView;
}

-(UILabel*)secPageHeaderLabel{
    if (_secPageHeaderLabel==nil) {
        _secPageHeaderLabel=[[UILabel alloc]init];
        _secPageHeaderLabel.frame=CGRectMake(0, 28, SCREEN_W, 21);
        _secPageHeaderLabel.textColor=[UIColor blackColor];
        _secPageHeaderLabel.font=[UIFont systemFontOfSize:12];
        _secPageHeaderLabel.alpha=0;
        _secPageHeaderLabel.textAlignment=NSTextAlignmentCenter;
    }
    return _secPageHeaderLabel;
}
-(UIButton*)backToTopBtn{
    if (_backToTopBtn==nil) {
        _backToTopBtn=[[UIButton alloc]initWithFrame:CGRectMake(SCREEN_W-15-40, SCREEN_H-BottomH-20-40, 40, 40)];
        [_backToTopBtn setImage:[UIImage imageNamed:@"srp_scroll_2_top_btn@2x"] forState:UIControlStateNormal];
        [_backToTopBtn addTarget:self action:@selector(backToTopView) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backToTopBtn;
}
-(void)setFirstPageView{
    self.mainScrollView.contentSize=CGSizeMake(0, contenSize);
    // banner图
    self.banerView=[SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, SCREEN_W, SCREEN_W) delegate:self placeholderImage:loadFailImg];
    self.banerView.imageURLStringsGroup=imagesUrlArr;
    self.banerView.currentPageDotColor = COLOR_8;
    self.banerView.pageDotColor = COLOR_D8;
    self.banerView.tag=66;
    self.banerView.autoScroll=NO;
    self.banerView.delegate=self;
    [self.mainScrollView addSubview:self.banerView];
    // banner图的指示标签
    if (imagesUrlArr.count>1) {
        _banerIndictor=[[UILabel alloc]initWithFrame:CGRectMake(SCREEN_W-40, SCREEN_W-40, 30, 30)];
        _banerIndictor.layer.cornerRadius=15;
        _banerIndictor.clipsToBounds=YES;
        _banerIndictor.backgroundColor=[UIColor grayColor];
        _banerIndictor.font=[UIFont systemFontOfSize:12];
        _banerIndictor.textColor=[UIColor whiteColor];
        _banerIndictor.text=[NSString stringWithFormat:@"%d/%lu",banerCurImg,(unsigned long)imagesUrlArr.count];
        _banerIndictor.textAlignment=NSTextAlignmentCenter;
        [self.mainScrollView addSubview:_banerIndictor];
    }
    // masonry与scrollview混合使用必须极度注意
    UILabel *name = [[UILabel alloc] init];
    [self.mainScrollView addSubview:name];
    [name mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_banerView).with.offset(20);
        make.right.equalTo(_banerView).with.offset(-20);
        make.top.equalTo(_banerView.bottom).offset(1);
        make.height.equalTo(30);
    }];
    name.font = [UIFont fontWithName:@"HelveticaNeue" size:16];
    name.textColor = COLOR_3;
    name.text = _productName;
    UILabel *priceLB = [[UILabel alloc] init];
    [self.mainScrollView addSubview:priceLB];
    [priceLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(name.mas_bottom).with.offset(12);
        make.left.equalTo(name);
        make.height.mas_equalTo(20);
    }];
    
    priceLB.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:17];
    priceLB.textColor = [UIColor colorWithHexString:@"#DE4536"];
    
    priceLB.text = [NSString stringWithFormat:@"$%@", self.price];
    
    UILabel *oriPrice = [[UILabel alloc] init];
    [self.mainScrollView addSubview:oriPrice];
    [oriPrice mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(priceLB.mas_right).with.offset(8);
        make.centerY.equalTo(priceLB.mas_centerY);
        make.height.mas_equalTo(20);
    }];
    
    NSAttributedString *attrStr =
    [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"$%@",self.oriPrice]
                                    attributes:
     @{NSFontAttributeName:[UIFont fontWithName:@"HelveticaNeue" size:12],
       NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#999999"],
       NSStrikethroughStyleAttributeName:@(NSUnderlineStyleSingle|NSUnderlinePatternSolid),
       NSStrikethroughColorAttributeName:[UIColor colorWithHexString:@"#999999"]}];
    oriPrice.attributedText = attrStr;
    
    UIView *sale = [[UIView alloc] init];
    [self.mainScrollView addSubview:sale];
    [sale mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(oriPrice.mas_right).with.offset(7.5);
        make.centerY.equalTo(oriPrice.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(41, 18));
    }];
    sale.layer.borderWidth = 0.5;
    sale.layer.borderColor = COLOR_D.CGColor;
    sale.backgroundColor = [UIColor colorWithHexString:@"#FAFAFA"];
    UILabel *saleLB = [[UILabel alloc] init];
    [sale addSubview:saleLB];
    [saleLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(sale.center);
    }];
    saleLB.text = [NSString stringWithFormat:@"-%@", self.sale];
    saleLB.font = [UIFont fontWithName:@"HelveticaNeue" size:12];
    saleLB.textColor = [UIColor colorWithHexString:@"#FFA057"];
    
    UILabel *bought = [[UILabel alloc] init];
    [self.mainScrollView addSubview:bought];
    [bought mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(name);
        make.centerY.equalTo(saleLB.mas_centerY);
        make.height.equalTo(name);
    }];
    bought.textColor = COLOR_9;
    bought.textAlignment = NSTextAlignmentRight;
    bought.font = [UIFont fontWithName:@"HelveticaNeue" size:12];
    bought.text = [NSString stringWithFormat:@"%@ bought", self.bought];
    
    UIView *line1 = [[UIView alloc] init];
    [self.mainScrollView addSubview:line1];
    [line1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(name);
        make.right.equalTo(name).with.offset(20);
        make.height.equalTo(0.5);
        make.top.equalTo(priceLB.bottom).with.offset(11);
    }];
    line1.backgroundColor = COLOR_D;
    
    UILabel *promotion = [[UILabel alloc] init];
    [self.mainScrollView addSubview:promotion];
    [promotion makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(name);
        make.height.equalTo(16.5);
        make.top.equalTo(line1).with.offset(8.5);
    }];
    promotion.text = @"Price-off promotions";
    promotion.font = [UIFont fontWithName:@"HelveticaNeue" size:14];
    promotion.textColor = COLOR_9;
    
    UIView *pink = [[UIView alloc] init];
    [self.mainScrollView addSubview:pink];
    [pink makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(name);
        make.size.equalTo(CGSizeMake(54.5, 17));
        make.centerY.equalTo(promotion.centerY);
    }];
    pink.backgroundColor = [UIColor colorWithHexString:@"#FF897D"];
    UILabel *pinkLB = [[UILabel alloc] init];
    [pink addSubview:pinkLB];
    [pinkLB makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(pink);
        make.size.equalTo(pink);
    }];
    pinkLB.textAlignment = 1;
    pinkLB.textColor = [UIColor whiteColor];
    pinkLB.font = [UIFont fontWithName:@"HelveticaNeue" size:11];
    pinkLB.text = @"short run";
    
    UIView *section1 = [[UIView alloc] init];
    [self.mainScrollView addSubview:section1];
    [section1 makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.banerView);
        make.top.equalTo(promotion.bottom).with.offset(9);
        make.height.equalTo(10);
    }];
    section1.backgroundColor = [UIColor colorWithHexString:@"#FAFAFA"];
    
    UILabel *rating = [[UILabel alloc] init];
    [self.mainScrollView addSubview:rating];
    [rating makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(name);
        make.top.equalTo(section1.bottom).with.offset(16);
        make.size.equalTo(CGSizeMake(47.5, 16.5));
    }];
    rating.textColor = COLOR_3;
    rating.font = [UIFont fontWithName:@"HelveticaNeue" size:14];
    rating.text = @"Ratings";
    
    MyStarView *starView = [[MyStarView alloc] init];
    [self.mainScrollView addSubview:starView];
    [starView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(rating.right).with.offset(18.5);
        make.centerY.equalTo(rating);
        make.size.equalTo(CGSizeMake(87.5, 12));
    }];
    [starView withStar:self.star :87.5 :12];
    UILabel *ratingnum = [[UILabel alloc] init];
    [self.mainScrollView addSubview:ratingnum];
    [ratingnum makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(starView);
        make.left.equalTo(starView.right).with.offset(7.5);
        make.size.equalTo(CGSizeMake(31, 16.5));
    }];
    ratingnum.text = [NSString stringWithFormat:@"(%ld)", (long)self.ratingNum];
    ratingnum.font = [UIFont fontWithName:@"HelveticaNeue" size:14];
    ratingnum.textColor = COLOR_9;
    
    UIImageView *rightArray1 = [[UIImageView alloc] init];
    [self.mainScrollView addSubview:rightArray1];
    [rightArray1 makeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(CGSizeMake(6.5, 11.5));
        make.right.equalTo(name);
        make.centerY.equalTo(rating);
    }];
    rightArray1.contentMode = UIViewContentModeCenter;
    rightArray1.image = [UIImage imageNamed:@"向右箭头"];
    
    _viewall1 = [[UIButton alloc] init];
    [self.mainScrollView addSubview:_viewall1];
    [_viewall1 makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(rightArray1.left).offset(-11.5);
        make.centerY.equalTo(rightArray1);
        make.size.equalTo(CGSizeMake(37.5, 13));
    }];
    [_viewall1 setTitle:@"View all" forState:UIControlStateNormal];
    _viewall1.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:11];
    [_viewall1 setTitleColor:COLOR_9 forState:UIControlStateNormal];
    [_viewall1 addTarget:self action:@selector(viewall1Action) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *line2 = [[UIView alloc] init];
    [self.mainScrollView addSubview:line2];
    [line2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(name);
        make.right.equalTo(name).with.offset(20);
        make.height.equalTo(0.5);
        make.top.equalTo(ratingnum.bottom).with.offset(15.5);
    }];
    line2.backgroundColor = COLOR_D;
    
    UILabel *shipping = [[UILabel alloc] init];
    [self.mainScrollView addSubview:shipping];
    [shipping makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(name);
        make.top.equalTo(line2.bottom).with.offset(15);
        make.size.equalTo(CGSizeMake(82.5, 16.5));
    }];
    shipping.textColor = COLOR_3;
    shipping.font = [UIFont fontWithName:@"HelveticaNeue" size:14];
    shipping.text = @"Shipping info";
    
    
    UIImageView *rightArray2 = [[UIImageView alloc] init];
    [self.mainScrollView addSubview:rightArray2];
    [rightArray2 makeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(CGSizeMake(6.5, 11.5));
        make.right.equalTo(name);
        make.centerY.equalTo(shipping);
    }];
    rightArray2.contentMode = UIViewContentModeCenter;
    rightArray2.image = [UIImage imageNamed:@"向右箭头"];
    
    _viewall2 = [[UIButton alloc] init];
    [self.mainScrollView addSubview:_viewall2];
    [_viewall2 makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(rightArray2.left).offset(-11.5);
        make.centerY.equalTo(rightArray2);
        make.size.equalTo(CGSizeMake(37.5, 13));
    }];
    [_viewall2 setTitle:@"View all" forState:UIControlStateNormal];
    _viewall2.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:11];
    [_viewall2 setTitleColor:COLOR_9 forState:UIControlStateNormal];
    [_viewall2 addTarget:self action:@selector(viewall2Action) forControlEvents:UIControlEventTouchUpInside];
    [self.mainScrollView setNeedsLayout];
    [self.mainScrollView layoutIfNeeded];
    
    //加载更多
    UIView * loadMoreView=[LoadMoreView view];
    [self.mainScrollView addSubview:loadMoreView];
    [loadMoreView makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(_banerView);
        make.top.equalTo(_viewall2.bottom).with.offset(17.5).priorityHigh();
        make.bottom.equalTo(60);
        make.bottom.greaterThanOrEqualTo(SCREEN_H-50).priorityLow();
    }];
    [self.mainScrollView setNeedsLayout];
    [self.mainScrollView layoutIfNeeded];
    self.mainScrollView.contentSize = CGSizeMake(SCREEN_W, loadMoreView.frame.origin.y+loadMoreView.frame.size.height+64);
}

#pragma mark - 跳转方法
//rating
-(void)viewall1Action {
    RatingController *vc = [[RatingController alloc] init];
    vc.productID = self.productID;
    vc.ratingNum = self.ratingNum;
    vc.productImage = imagesUrlArr.firstObject;
    vc.productName = _productName;
    vc.bought = self.bought;
    vc.save = self.save;
    vc.star = self.star;
    [self.navigationController pushViewController:vc animated:YES];
}

//shipping info
-(void)viewall2Action {
    ShoppingInfoController *vc = [[ShoppingInfoController alloc] init];
    vc.shipping_info = self.shipping_info;
    [self.navigationController pushViewController:vc animated:YES];
}


-(void)setSecondPageView{
    /*
    UILabel * lab=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, SCREEN_W, 21)];
    lab.backgroundColor=[UIColor lightGrayColor];
    lab.text=@"我在第二屏的顶头位置";
    lab.textAlignment=NSTextAlignmentCenter;
    [self.secScrollView addSubview:lab];
     */
}

/**
 添加导航栏背后的View
 */
-(void)addNavBarView{
    UIView* view = [[UIView alloc] init];
    self.NavBarView = view;
    view.frame = CGRectMake(0, 0, SCREEN_W, NaviBarH);
    view.backgroundColor = [UIColor colorWithHexString:@"#32303D"];
    [self.view addSubview:view];
    
    UIView * lineView=[[UIView alloc]initWithFrame:CGRectMake(0, NaviBarH-0.5, SCREEN_W, 0.5)];
    lineView.backgroundColor=[UIColor clearColor];
    [self.NavBarView addSubview:lineView];
    
    UIButton * backBtn=[[UIButton alloc]initWithFrame:CGRectMake(10, 32, 25, 25)];
    [backBtn setImage:[UIImage imageNamed:@"返回"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(navBarBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    backBtn.layer.cornerRadius=25/2;
    //backBtn.backgroundColor=[UIColor lightGrayColor];
    [self.NavBarView addSubview:backBtn];
    backBtn.tag=1;
    UILabel *title = [[UILabel alloc] init];
    [view addSubview:title];
    [title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(view);
        make.centerY.equalTo(backBtn);
        make.size.equalTo(CGSizeMake(56, 20));
    }];
    title.text = @"Detail";
    title.textColor = [UIColor whiteColor];
    title.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:17];
}

/**
 *  添加底部的购买 加入购物车 收藏等模块
 */
-(void)addBotomView{
    _botomView=[BuyBotomView botomViewWithFrame:CGRectMake(0, SCREEN_H-BottomH, SCREEN_W, BottomH) withDelegate:self withPrice:self.price withProductID:self.productID];
    [self.view addSubview:_botomView];
    _botomView.backgroundColor = [UIColor whiteColor];
    [self.view bringSubviewToFront:_botomView];
}

/**
 *  第二屏顶部的三个模块
 *  @return 懒加载
 */
-(SecondPageTopBar*)topBar{
    if (_topBar==nil) {
        _topBar=[[SecondPageTopBar alloc]initWithArray:@[@"图文详情",@"包装参数",@"商品评价"]];
        _topBar.frame=CGRectMake(0, NaviBarH, SCREEN_W, TopTabBarH);
        _topBar.delegate=self;
        [self.view addSubview:_topBar];
    }
    return _topBar;
}

/**
 第二屏的简单实现
 */
-(UIWebView *)describeView{
    if (_describeView==nil) {
        _describeView = [[UIWebView alloc] initWithFrame: CGRectMake(0, 50, self.view.frame.size.width, 0)];
        _describeView.delegate = self;
        _describeView.scrollView.bounces = NO;
        _describeView.scrollView.showsHorizontalScrollIndicator = NO;
        _describeView.scrollView.scrollEnabled = NO;
        [_describeView sizeToFit];
        
        //设置内容，这里包装一层div，用来获取内容实际高度（像素），htmlcontent是html格式的字符串
        NSString *htmlcontentstring = [NSString stringWithFormat:@"<head><style>img{max-width:%fpx !important;}</style></head><div id=\"webview_content_wrapper\">%@</div>", (SCREEN_W-20),self.htmlcontent.gtm_stringByUnescapingFromHTML];
        [_describeView loadHTMLString:htmlcontentstring baseURL:nil];
        [_secScrollView addSubview:_describeView];
    }
    return _describeView;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    //获取页面高度（像素）
    NSString * clientheight_str = [webView stringByEvaluatingJavaScriptFromString: @"document.body.offsetHeight"];
    float clientheight = [clientheight_str floatValue];
    //设置到WebView上
    webView.frame = CGRectMake(0, 0, self.view.frame.size.width, clientheight);
    //获取WebView最佳尺寸（点）
    CGSize frame = [webView sizeThatFits:webView.frame.size];
    //获取内容实际高度（像素）
    NSString * height_str= [webView stringByEvaluatingJavaScriptFromString: @"document.getElementById('webview_content_wrapper').offsetHeight + parseInt(window.getComputedStyle(document.getElementsByTagName('body')[0]).getPropertyValue('margin-top'))  + parseInt(window.getComputedStyle(document.getElementsByTagName('body')[0]).getPropertyValue('margin-bottom'))"];
    float height = [height_str floatValue];
    //内容实际高度（像素）* 点和像素的比
    height = height * frame.height / clientheight;
    //再次设置WebView高度（点）
    webView.frame = CGRectMake(0, 0, self.view.frame.size.width, height);
    //避免WebView最下方出现黑线
    webView.backgroundColor = [UIColor clearColor];
    webView.opaque = NO;
    
    //添加底部的view
    UIView *view = [[UIView alloc] init];
    [_secScrollView addSubview:view];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(webView);
        make.height.equalTo(128.5);
        make.top.equalTo(webView.bottom);
    }];
    view.backgroundColor = [UIColor whiteColor];
    UIView *section = [[UIView alloc] init];
    [view addSubview:section];
    [section mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(view);
        make.height.equalTo(9.5);
    }];
    section.backgroundColor = [UIColor colorWithHexString:@"#FAFAFA"];
    UIView *line1 = [[UIView alloc] init];
    [view addSubview:line1];
    [line1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(20);
        make.width.equalTo((SCREEN_W-116)/2-20-11.5);
        make.height.equalTo(0.5);
        make.top.equalTo(section.bottom).with.offset(18);
    }];
    line1.backgroundColor = COLOR_9;
    UILabel *service = [[UILabel alloc] init];
    [view addSubview:service];
    [service mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(view);
        make.size.equalTo(CGSizeMake(116, 16.5));
        make.top.equalTo(section.bottom).with.offset(9);
    }];
    service.text = @"Service Guarantee";
    service.textColor = COLOR_9;
    service.font = [UIFont fontWithName:@"HelveticaNeue" size:14];
    UIView *line2 = [[UIView alloc] init];
    [view addSubview:line2];
    [line2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(-20);
        make.width.equalTo((SCREEN_W-116)/2-20-11.5);
        make.height.equalTo(0.5);
        make.top.equalTo(section.bottom).with.offset(18);
    }];
    line2.backgroundColor = COLOR_9;
    
    UIImageView *image1 = [[UIImageView alloc] init];
    [view addSubview:image1];
    [image1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo((SCREEN_W-41*3)/4);
        make.size.equalTo(CGSizeMake(41, 41));
        make.top.equalTo(line1.bottom).with.offset(25.5);
    }];
    image1.image = [UIImage imageNamed:@"secure"];
    
    UIImageView *image2 = [[UIImageView alloc] init];
    [view addSubview:image2];
    [image2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(view);
        make.size.equalTo(CGSizeMake(41, 41));
        make.top.equalTo(line1.bottom).with.offset(25.5);
    }];
    image2.image = [UIImage imageNamed:@"quality"];
    
    UIImageView *image3 = [[UIImageView alloc] init];
    [view addSubview:image3];
    [image3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(-(SCREEN_W-41*3)/4);
        make.size.equalTo(CGSizeMake(41, 41));
        make.top.equalTo(line1.bottom).with.offset(25.5);
    }];
    image3.image = [UIImage imageNamed:@"fast"];
    
    UILabel *lab1 = [[UILabel alloc] init];
    [view addSubview:lab1];
    [lab1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(image1);
        make.size.equalTo(CGSizeMake(50, 14));
        make.top.equalTo(image1.bottom).with.offset(5);
    }];
    lab1.text = @"Secure";
    lab1.textColor = COLOR_6;
    lab1.font = [UIFont fontWithName:@"HelveticaNeue" size:12];
    lab1.textAlignment = 1;
    UILabel *lab2 = [[UILabel alloc] init];
    [view addSubview:lab2];
    [lab2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(image2);
        make.size.equalTo(CGSizeMake(50, 14));
        make.top.equalTo(image1.bottom).with.offset(5);
    }];
    lab2.text = @"Quality";
    lab2.textColor = COLOR_6;
    lab2.font = [UIFont fontWithName:@"HelveticaNeue" size:12];
    lab2.textAlignment = 1;
    UILabel *lab3 = [[UILabel alloc] init];
    [view addSubview:lab3];
    [lab3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(image3);
        make.size.equalTo(CGSizeMake(50, 14));
        make.top.equalTo(image1.bottom).with.offset(5);
    }];
    lab3.text = @"Fast";
    lab3.textColor = COLOR_6;
    lab3.font = [UIFont fontWithName:@"HelveticaNeue" size:12];
    lab3.textAlignment = 1;
    
    height=MAX(height+128.5, SCREEN_H);
    _secScrollView.contentSize = CGSizeMake(SCREEN_W, height);
    [self.view bringSubviewToFront:_backToTopBtn];
    _backToTopBtn.hidden = NO;
}

#pragma mark--UIScrollViewDelegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if(scrollView.tag == 100){
        if(scrollView.contentOffset.y<0){
            scrollView.contentOffset = CGPointMake(0, 0);//限制不能下拉
        }
        if(scrollView.contentOffset.y>=0){
            //上拖的时候改变导航栏背部的颜色
            CGFloat  fir_maxContentOffSet_Y=self.mainScrollView.contentSize.height-self.mainScrollView.frame.size.height;
            CGFloat  scal=(1-(scrollView.contentOffset.y)/fir_maxContentOffSet_Y);
            //NSLog(@"%f", scal);
            self.NavBarView.backgroundColor=[UIColor colorWithRed:50/255.0 green:48/255.0 blue:61/255.0 alpha:scal];
        }
    }
    if (scrollView.tag==200) {
        //在0-60之间 懒加载子控件，并且随拖动的幅度改变子控件的标题和alpha
        CGFloat  mininumContenOffSet_Y=0;
        CGFloat  maxContentOffSet_Y=-dragStrength;
        self.secPageHeaderLabel.alpha=scrollView.contentOffset.y/maxContentOffSet_Y;
        if (scrollView.contentOffset.y>maxContentOffSet_Y&&scrollView.contentOffset.y<mininumContenOffSet_Y) {
            self.secPageHeaderLabel.text=@"";
            [self.view addSubview:self.secPageHeaderLabel];
        }
        if(scrollView.contentOffset.y<maxContentOffSet_Y){
            self.secPageHeaderLabel.text=@"";
        }
    }
}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    if (scrollView.tag==100) {
        CGFloat mininumContentset_Y=self.mainScrollView.contentSize.height-SCREEN_H+BottomH +dragStrength;
        if(scrollView.contentOffset.y>mininumContentset_Y){
            //此时第一屏滑到底部 可调滑动手势强度
            [self setSecondPageView];
            //self.topBar.hidden=NO;
            [self.view bringSubviewToFront:self.botomView];
            self.backToTopBtn.hidden=NO;
            [self.view addSubview:self.backToTopBtn];
            //然后懒加载第二屏
            [UIView animateWithDuration:0.5 delay:0.0 options:UIViewAnimationOptionLayoutSubviews animations:^{
#pragma mark - 第二屏
                self.secScrollView.frame=CGRectMake(0, 20, SCREEN_W, SCREEN_H-BottomH-20);
                self.mainScrollView.frame=CGRectMake(0, NaviBarH-SCREEN_H-50, SCREEN_W, SCREEN_H-BottomH);
                [self describeView];
                [self.mainScrollView setNeedsLayout];
                [self.mainScrollView layoutIfNeeded];
                [self.secScrollView setNeedsLayout];
                [self.secScrollView layoutIfNeeded];
                
            } completion:^(BOOL finished) {
            }];
        }
    }
    if (scrollView.tag==200) {
        CGFloat  maxContentOffSet_Y=-dragStrength;
        if (scrollView.contentOffset.y<maxContentOffSet_Y) {
            
            self.backToTopBtn.hidden=YES;
            [self.view bringSubviewToFront:self.botomView];
            
            [UIView animateWithDuration:0.5 delay:0.0 options:UIViewAnimationOptionLayoutSubviews animations:^{
                self.secPageHeaderLabel.alpha=0;
                self.secScrollView.frame=CGRectMake(0, SCREEN_H, SCREEN_W, SCREEN_H-BottomH);
                self.mainScrollView.frame=CGRectMake(0, 0, SCREEN_W, SCREEN_H-BottomH);
                [self.mainScrollView setNeedsLayout];
                [self.mainScrollView layoutIfNeeded];
                [self.secScrollView setNeedsLayout];
                [self.secScrollView layoutIfNeeded];
                
            } completion:^(BOOL finished) {
                [_viewall1 addTarget:self action:@selector(viewall1Action) forControlEvents:UIControlEventTouchUpInside];
                [_viewall2 addTarget:self action:@selector(viewall2Action) forControlEvents:UIControlEventTouchUpInside];
            }];
        }
    }
}
#pragma mark---banner图的滚动回调
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didScrollToIndex:(NSInteger)index{
    self.banerIndictor.text=[NSString stringWithFormat:@"%ld/%lu",(index+1),(unsigned long)imagesUrlArr.count];
}
#pragma mark---底部按钮
-(void)clickedBotomViewBtnWithBtnTag:(NSInteger)btnTag{
    DebugLog(@"底部的第%ld个",(long)btnTag);
    if (btnTag==101) {
        //购买
        [self buyAction];
    }
}
#pragma mark---第二页顶部按钮
-(void)tabBar:(SecondPageTopBar *)tabBar didSelectIndex:(NSInteger)index;{
    DebugLog(@"顶部的第%ld个",(long)index);
}
#pragma mark---导航栏按钮的事件
-(void)navBarBtnAction:(UIButton*)sender{
    if (sender.tag==1) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}
#pragma mark---滚动到顶部
-(void)backToTopView{
    self.backToTopBtn.hidden=YES;
    
    [UIView animateWithDuration:0.5 delay:0.0 options:UIViewAnimationOptionLayoutSubviews animations:^{
        //self.topBar.frame=CGRectMake(0, SCREEN_H, SCREEN_W, TopTabBarH);
        self.secScrollView.frame=CGRectMake(0, SCREEN_H+TopTabBarH, SCREEN_W, SCREEN_H-NaviBarH-BottomH-TopTabBarH);
        self.mainScrollView.contentOffset=CGPointMake(0, 0);
        self.mainScrollView.frame=CGRectMake(0, 0, SCREEN_W, SCREEN_H-BottomH);
        self.secPageHeaderLabel.alpha=0;
    } completion:^(BOOL finished) {
        //self.topBar.hidden=YES;
    }];
}

#pragma mark---Buy页面
/**
 *  初始化弹出视图
 */
-(void)initChoseView
{
    //选择尺码颜色的视图
    choseView = [[ChoseView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height/2, self.view.frame.size.width, self.view.frame.size.height)];

    choseView.productID = self.productID;
    choseView.arrayImage = imagesUrlArr;
    choseView.product_option_id = self.product_option_id;
    choseView.images1 = imagesUrlArr.firstObject;
    
    //存货量
    choseView.stock = self.quantity;
    //颜色
    if (self.colorMutableArray.count==0) {
        choseView.colorView.frame = CGRectZero;
    }
    else{
        choseView.colorView = [[TypeView alloc] initWithFrame:CGRectMake(0, 0, choseView.frame.size.width, 50) andDatasource:colorarr :@"Color"];
        choseView.colorView.delegate = self;
        choseView.colorView.frame = CGRectMake(0, 0, choseView.frame.size.width, choseView.colorView.height);
    }
    [choseView.mainscrollview addSubview:choseView.colorView];
    
    //尺码
    if (self.sizeMutableArray.count==0) {
        choseView.sizeView.frame = CGRectZero;
    }
    else{
        choseView.sizeView = [[TypeView alloc] initWithFrame:CGRectMake(0, choseView.colorView.frame.size.height, choseView.frame.size.width, 50) andDatasource:sizearr :@"Size"];
        choseView.sizeView.delegate = self;
        [choseView.mainscrollview addSubview:choseView.sizeView];
        choseView.sizeView.frame = CGRectMake(0, choseView.colorView.frame.size.height, choseView.frame.size.width, choseView.sizeView.height);
    }
    
    //购买数量
    choseView.countView.frame = CGRectMake(0, choseView.sizeView.frame.size.height+choseView.sizeView.frame.origin.y, choseView.frame.size.width, 50);
    choseView.mainscrollview.contentSize = CGSizeMake(self.view.frame.size.width, choseView.countView.frame.size.height+choseView.countView.frame.origin.y);
    choseView.lb_price.text = [NSString stringWithFormat:@"$%@",_price];
    //存货量
    choseView.lb_stock.text = [NSString stringWithFormat:@"Inventory:%ld",(long)self.quantity];
    choseView.lb_detail.text = @"Please choose color and size";
    [choseView.bt_cancle addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    
    //点击黑色透明视图choseView会消失
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)];
    [choseView.alphaiView addGestureRecognizer:tap];
    //点击图片放大图片
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showBigImage:)];
    choseView.img.userInteractionEnabled = YES;
    [choseView.img addGestureRecognizer:tap1];
}

/**
 *  此处嵌入浏览图片代码
 */
-(void)showBigImage:(UITapGestureRecognizer *)tap
{
    NSLog(@"放大图片");
}

/**
 *  点击半透明部分或者取消按钮，弹出视图消失
 */
-(void)dismiss
{
    //center.y = center.y+self.view.frame.size.height;
    [UIView animateWithDuration: 0.35 animations: ^{
        choseView.frame =CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, self.view.frame.size.height);
    } completion: nil];
    
}

#pragma mark - typeDelegate（这里是选择尺寸和颜色的点击方法）
-(void)btnindex:(int)tag
{
    //通过seletIndex是否>=0来判断尺码和颜色是否被选择，－1则是未选择状态
    if (choseView.colorView.frame.size.height!=0) {
        if (choseView.sizeView.seletIndex >-1&&choseView.colorView.seletIndex >-1) {
            //尺码和颜色都选择的时候
            NSString *size =[sizearr objectAtIndex:choseView.sizeView.seletIndex];
            NSString *color =[colorarr objectAtIndex:choseView.colorView.seletIndex];
            choseView.lb_stock.text = [NSString stringWithFormat:@"Stock %@ ",[[stockarr objectForKey: size] objectForKey:color]];
            choseView.lb_detail.text = [NSString stringWithFormat:@"Chosn \"%@\" \"%@\"",size,color];
            choseView.stock =[[[stockarr objectForKey: size] objectForKey:color] intValue];
            
            [self reloadTypeBtn:[stockarr objectForKey:color] :sizearr :choseView.sizeView :choseView.bt_sure];
            
            choseView.bt_sure.enabled = YES;
            choseView.bt_sure.backgroundColor = [UIColor colorWithHexString:@"#de4536"];
            for (NSDictionary *dic in self.sizeMutableArray) {
                if ([[dic valueForKey:@"name"] isEqualToString:size]) {
                    choseView.product_option_value_id = [dic valueForKey:@"product_option_value_id"];
                }
            }
            for (NSDictionary *dic in self.colorMutableArray) {
                if ([[dic valueForKey:@"name"] isEqualToString:color]) {
                    choseView.product_option_value_id2 = [dic valueForKey:@"product_option_value_id"];
                }
            }
        }
        else{
            NSLog(@"Please choose color and size");
        }
    }
    else{
        if (choseView.sizeView.seletIndex >-1) {
            // 只选了尺码
            _size =[sizearr objectAtIndex:choseView.sizeView.seletIndex];
            // 根据所选尺码 取出该尺码对应所有颜色的库存字典
            [self resumeBtn:sizearr :choseView.sizeView];
            choseView.lb_detail.text = [NSString stringWithFormat:@"Chosn \"%@\"", _size];
            choseView.stock = 10;//先固定
            choseView.bt_sure.enabled = NO;
            choseView.bt_sure.backgroundColor = [UIColor redColor];
            for (NSDictionary *dic in self.sizeMutableArray) {
                if ([[dic valueForKey:@"name"] isEqualToString:_size]) {
                    choseView.product_option_value_id = [dic valueForKey:@"product_option_value_id"];
                }
            }
        }
        else{
            NSLog(@"Please choose size");
        }
    }
    
}

//恢复按钮的原始状态
-(void)resumeBtn:(NSArray *)arr :(TypeView *)view
{
    for (int i = 0; i< arr.count; i++) {
        UIButton *btn =(UIButton *) [view viewWithTag:100+i];
        btn.enabled = YES;
        btn.selected = NO;
        [btn setBackgroundColor:[UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1]];
        [btn setTitleColor:[UIColor blackColor] forState:0];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        if (view.seletIndex == i) {
            btn.selected = YES;
            [btn setBackgroundColor:[UIColor colorWithHexString:@"#de4536"]];
        }
    }
}

//根据所选的尺码或者颜色对应库存量 确定哪些按钮不可选
-(void)reloadTypeBtn:(NSDictionary *)dic :(NSArray *)arr :(TypeView *)view :(UIButton *)btnSure
{
    for (int i = 0; i<arr.count; i++)
    {
        int count = [[dic objectForKey:[arr objectAtIndex:i]] intValue];
        UIButton *btn =(UIButton *)[view viewWithTag:100+i];
        btn.selected = NO;
        [btn setBackgroundColor:[UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1]];
        //库存为零 不可点击
        if (count == 0)
        {
            btn.enabled = NO;
            [btn setTitleColor:[UIColor colorWithHexString:@"#de4536"] forState:0];
        }
        else
        {
            btn.enabled = YES;
            [btn setTitleColor:[UIColor colorWithHexString:@"#de4536"] forState:0];
        }
        //根据seletIndex 确定用户当前点了那个按钮
        if (view.seletIndex == i)
        {
            btn.selected = YES;
            [btn setBackgroundColor:[UIColor redColor]];
        }
    }
    
}

- (void)buyAction
{
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"signInSuccessful"]boolValue] == YES)
    {
        [UIView animateWithDuration: 0.35 animations: ^{
            [self.view addSubview:choseView];
            choseView.center = self.view.center;
            choseView.frame =CGRectMake(0, 0, SCREEN_W, SCREEN_H);
        } completion: nil];
    }
    else
    {
        [UIView animateWithDuration: 0.35 animations: ^{
            [self.view addSubview:choseView];
            choseView.center = self.view.center;
            choseView.frame =CGRectMake(0, 0, SCREEN_W, SCREEN_H);
        } completion: nil];
    }
}

- (NSMutableArray *)sizeMutableArray {
    if (!_sizeMutableArray) {
        _sizeMutableArray = [NSMutableArray array];
    }
    return _sizeMutableArray;
}

- (NSMutableArray *)colorMutableArray {
    if (!_colorMutableArray) {
        _colorMutableArray = [NSMutableArray array];
    }
    return _colorMutableArray;
}

@end
