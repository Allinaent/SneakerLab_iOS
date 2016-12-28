//
//  DetailController.m
//  caowei
//
//  Created by Jason cao on 16/9/5.
//  Copyright © 2016年 Jason cao. All rights reserved.
//

#import "DetailController.h"
#import "AppDelegate.h"
#import "SGTopTitleView.h"
#import "OverViewController.h"
#import "DescriptionController.h"
#import "RatedController.h"
#import "RatingController.h"
#import "ShoppingInfoController.h"
#import "ChoseView.h"
#import "RegisterController.h"
#import "DetailModel.h"
#import "PrductModel_OPTiON.h"
#import "ShopViewController.h"
#import "GTMNSString+HTML.h"

#pragma mark - 商品的详情
@interface DetailController ()<UIScrollViewDelegate , SGTopTitleViewDelegate ,UITextFieldDelegate,TypeSeleteDelegete>
{
    ChoseView *choseView;
    CGPoint center;
    NSArray *sizearr;//型号数组
    NSArray *colorarr;//分类数组
    NSDictionary *stockarr;//商品库存量
    NSString *_goodsStock;
    NSString *_price;
    NSString *_oldprice;
    NSString *_product_option_id;
    NSString *_product_option_value_id;
    NSString *_size;
    NSString *_littleStr;//小图片
}
@property (nonatomic , strong) SGTopTitleView *scrollerViewtop;
@property (nonatomic , strong) UIScrollView *scollerViewButtom;
@property (nonatomic , copy) NSArray *titleArray;
@property (nonatomic , strong) NSMutableArray *tatalSource;
@property (nonatomic , strong) NSMutableArray *images1;
@end

@implementation DetailController

- (NSMutableArray *)images1 {
    if (!_images1) {
        _images1 = [NSMutableArray array];
    }
    return _images1;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"DETAIL";
   
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"搜索"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]style:UIBarButtonItemStylePlain target:self action:@selector(searchAction)];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self refreshUI];
    [self createScrollerView];
    [self setupChildViewController];
    
    // sizearr = [[NSArray alloc] initWithObjects:@"S",@"M",@"L",nil];
    // colorarr = [[NSArray alloc] initWithObjects:@"蓝色",@"红色",@"湖蓝色",@"咖啡色",nil];
    NSString *str = [[NSBundle mainBundle] pathForResource: @"stock" ofType:@"plist"];
    stockarr = [[NSDictionary alloc] initWithContentsOfURL:[NSURL fileURLWithPath:str]];
    _tatalSource = [[NSMutableArray alloc]init];
    
   
}

#pragma mark ----刷新UI

- (void)refreshUI
{
    [_images1 removeAllObjects];
    NSString *time = [self getCurrentTimestamp];
    NSArray *arr = @[@"appKey",@"apiKey",@"timestamp",@"product_id",@"equipment_id"];
    NSDictionary *dic = @{@"product_id" : self.productID,
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
         NSLog(@"PRODUCTDETAIL_URL response = %@",responseObject);
         
         NSDictionary *dic = responseObject[@"data"];
         NSArray *imgs = dic[@"images"];
         NSString *imgStr = imgs.firstObject;
         NSString *encodeStr = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)imgStr.gtm_stringByUnescapingFromHTML, (CFStringRef)@"!$&'()*+,-./:;=?@_~%#[]", NULL, kCFStringEncodingUTF8));
         
         
         NSMutableArray *sizeMutableArray = [[NSMutableArray alloc] init];
         NSMutableArray *colorMutableArray = [[NSMutableArray alloc] init];
         NSArray *options = dic[@"options"];
         for (NSDictionary *dict in options) {
             if ([[dict valueForKey:@"name"] isEqualToString:@"size"]) {
                 
                 NSArray * productOptionValueArray = dict[@"product_option_value"];
                 _product_option_id = dict[@"product_option_id"];
                 
                 NSLog(@"product_option_value = %@", productOptionValueArray);
                 
                 for (NSDictionary *productOptionValueDict in productOptionValueArray) {
                     _product_option_value_id = productOptionValueDict[@"product_option_value_id"];
                     if ([productOptionValueDict objectForKey:@"name"] != nil) {
                         [sizeMutableArray addObject:[productOptionValueDict objectForKey:@"name"]];
                     }
                 }
             }
             if ([[dict valueForKey:@"name"] isEqualToString:@"color"]) {
                 
                 NSArray * productOptionValueArray = dict[@"product_option_value"];
                 _product_option_id = dict[@"product_option_id"];
                 
                 NSLog(@"product_option_value = %@", productOptionValueArray);
                 
                 for (NSDictionary *productOptionValueDict in productOptionValueArray) {
                     _product_option_value_id = productOptionValueDict[@"product_option_value_id"];
                     if ([productOptionValueDict objectForKey:@"name"] != nil) {
                         [colorMutableArray addObject:[productOptionValueDict objectForKey:@"name"]];
                     }
                 }
             }
         }
         
         sizearr = [[NSArray alloc] initWithArray:sizeMutableArray];
         colorarr = [[NSArray alloc] initWithArray:colorMutableArray];
         _price = dic[@"special_price"];
         _oldprice = dic[@"original_price"];
         _littleStr = encodeStr;
         _goodsStock = dic[@"quantity"];
         [self initChoseView];
         //此处是下面的两个按钮
         [self createBuyViewWithPrice:_price :_oldprice];
         
     } failure:^(NSURLSessionDataTask *task, NSError *error)
     {
         NSLog(@"%@",error);
     }];
}

- (void)createBuyViewWithPrice:(NSString *)price :(NSString *)oldprice
{
    UIView *buyView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_H - 118, SCREEN_W, 54)];
    buyView.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
    buyView.layer.borderColor = [UIColor colorWithHexString:@"#DDDDDD"].CGColor;
    buyView.layer.borderWidth = 0.5;
    
    UILabel *priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 15, 100, 20)];
    priceLabel.backgroundColor = [UIColor clearColor];
    priceLabel.textAlignment = NSTextAlignmentCenter;
    priceLabel.font = [UIFont systemFontOfSize:17];
    priceLabel.text = [NSString stringWithFormat:@"$%@",price];
    priceLabel.textColor = [UIColor colorWithHexString:@"#DE4536"];
    
    UILabel *oldPriceLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, 20, 60, 15)];
    oldPriceLabel.backgroundColor = [UIColor clearColor];
    oldPriceLabel.textAlignment = NSTextAlignmentCenter;
    NSAttributedString *attrStr =
    [[NSAttributedString alloc]initWithString:[NSString stringWithFormat:@"$%@",oldprice]
                                  attributes:
  @{NSFontAttributeName:[UIFont systemFontOfSize:12],
    NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#999999"],
    NSStrikethroughStyleAttributeName:@(NSUnderlineStyleSingle|NSUnderlinePatternSolid),
    NSStrikethroughColorAttributeName:[UIColor colorWithHexString:@"#999999"]}];
    oldPriceLabel.attributedText = attrStr;
    
    UIButton *buyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    buyBtn.frame = CGRectMake(SCREEN_W * 0.56, 0, SCREEN_W * 0.44, 54);
    buyBtn.backgroundColor = [UIColor colorWithHexString:@"#de4536"];
    [buyBtn setTitle:@"Buy" forState:UIControlStateNormal];
    buyBtn.titleLabel.font = [UIFont boldSystemFontOfSize:15];
    [buyBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [buyBtn addTarget:self action:@selector(buyAction) forControlEvents:UIControlEventTouchUpInside];
    
    [buyView addSubview:buyBtn];
    [buyView addSubview:oldPriceLabel];
    [buyView addSubview:priceLabel];
    [self.view addSubview:buyView];
}

#pragma mark -------添加子控制器
- (void)setupChildViewController
{
    // DescriptionController
    DescriptionController *threeVC = [[DescriptionController alloc] init];
    threeVC.productID = self.productID;
    [self addChildViewController:threeVC];
    
    // RatingController
    RatingController *fourVC = [[RatingController alloc] init];
    fourVC.productID = self.productID;
    [self addChildViewController:fourVC];
    
    // ShoppingInfoController
    ShoppingInfoController *fiveVC = [[ShoppingInfoController alloc] init];
    [self addChildViewController:fiveVC];
    
}
// 显示控制器的view
- (void)showVc:(NSInteger)index {
    
    CGFloat offsetX = index * self.view.frame.size.width;
    
    UIViewController *vc = self.childViewControllers[index];
    
    // 判断控制器的view有没有加载过,如果已经加载过,就不需要加载
    if (vc.isViewLoaded) return;
    
    [self.scollerViewButtom addSubview:vc.view];
    vc.view.frame = CGRectMake(offsetX, 0, self.view.frame.size.width, self.view.frame.size.height);
}

#pragma mark------item点击事件
- (void)backAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)searchAction
{
    RegisterController *registerVC = [[RegisterController alloc] init];
    [self.navigationController pushViewController:registerVC animated:YES];
}

- (void)buyAction
{
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"signInSuccessful"])
    {
        [UIView animateWithDuration: 0.35 animations: ^{
            [self.view addSubview:choseView];
            choseView.center = self.view.center;
            choseView.frame =CGRectMake(0, 0, SCREEN_W, SCREEN_H);
        } completion: nil];
    }
    else
    {
        LoginController *vc = [[LoginController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
}
#pragma mark -------scrollerView
- (void)createScrollerView
{
    self.titleArray = @[@"OVERVIEW",@"DESCRIPTION",@"RATING",@"SHOPPINFO"];
    
    self.scrollerViewtop = [SGTopTitleView topTitleViewWithFrame:CGRectMake(0, 0, SCREEN_W, 36)];
    //设置代理
    _scrollerViewtop.scrollTitleArr = [NSArray arrayWithArray:_titleArray];
    _scrollerViewtop.delegate_SG = self;
    self.scrollerViewtop.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
    [self.view addSubview:self.scrollerViewtop];
    
    // 创建底部scrollerView
    self.scollerViewButtom = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, SCREEN_H)];
    self.scollerViewButtom.delegate = self;
    self.scollerViewButtom.pagingEnabled = YES;
    self.scollerViewButtom.bounces = NO;
    self.scollerViewButtom.showsHorizontalScrollIndicator = NO;
    self.scollerViewButtom.showsVerticalScrollIndicator = NO;
    self.scollerViewButtom.contentSize = CGSizeMake(_titleArray.count * SCREEN_W, 0);
    OverViewController *oneView = [[OverViewController alloc] init];
    if (!oneView.footer.footerBlock)
    {
        oneView.footer.footerBlock = ^{
            __weak typeof(self) weakSelf =  self;
            weakSelf.scollerViewButtom.contentOffset = CGPointMake(SCREEN_W, 0);
        };
    }
   
    [oneView refreshUI:self.productID];
    [oneView refreshCellUI:self.productID];
    [self.scollerViewButtom addSubview:oneView.view];
    [self addChildViewController:oneView];
    [self.view addSubview:self.scollerViewButtom];
    
    [self.view insertSubview:self.scollerViewButtom belowSubview:self.scrollerViewtop];
}

#pragma mark - - - SGTopScrollMenu代理方法
- (void)SGTopTitleView:(SGTopTitleView *)topTitleView didSelectTitleAtIndex:(NSInteger)index {
    
    // 1 计算滚动的位置
    CGFloat offsetX = index * self.view.frame.size.width;
    self.scollerViewButtom.contentOffset = CGPointMake(offsetX, 0);
    
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


#pragma mark---Buy页面
/**
 *  初始化弹出视图
 */


-(void)initChoseView
{
    choseView = [[ChoseView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height/2, self.view.frame.size.width, self.view.frame.size.height)];
    choseView.imgStr = _littleStr;
    [choseView CreatUI];
    //选择尺码颜色的视图
    choseView.productID = self.productID;
    choseView.arrayImage = _images1;
    choseView.product_option_id = self.product_option_id;
    choseView.product_option_value_id = self.product_option_value_id;
//#warning 颜色和尺码！！！
    //颜色
    if (colorarr.count!=0) {
        choseView.colorView = [[TypeView alloc] initWithFrame:CGRectMake(0, 0, choseView.frame.size.width, 10) andDatasource:colorarr :@"Color"];
        choseView.colorView.delegate = self;
        [choseView.mainscrollview addSubview:choseView.colorView];
    }
    if (sizearr.count!=0) {
        
        //尺码
        choseView.sizeView = [[TypeView alloc] initWithFrame:CGRectMake(0, choseView.colorView.frame.size.height, choseView.frame.size.width, 50) andDatasource:sizearr :@"Size"];
        choseView.sizeView.delegate = self;
        [choseView.mainscrollview addSubview:choseView.sizeView];
    }
    
    //购买数量
    //choseView.countView.frame = CGRectMake(0, choseView.sizeView.frame.size.height+choseView.sizeView.frame.origin.y, choseView.frame.size.width, 50);
    choseView.countView = [[BuyCountView alloc] init];
    [choseView.mainscrollview addSubview:choseView.countView];
    [choseView.countView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(choseView.mainscrollview.mas_left);
        make.top.equalTo(choseView.sizeView.mas_bottom).with.offset(5);
        make.right.equalTo(choseView.mainscrollview.mas_right);
        make.height.mas_equalTo(50);
    }];
    
    choseView.mainscrollview.contentSize = CGSizeMake(self.view.frame.size.width, choseView.countView.frame.size.height+choseView.countView.frame.origin.y);
    choseView.lb_price.text = [NSString stringWithFormat:@"$%@",_price];
//#warning 这里换为存储量
    choseView.lb_stock.text = [NSString stringWithFormat:@"Inventory:%@", _goodsStock];
    choseView.lb_detail.text = @"Please choose color and size";
    [choseView.bt_cancle addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    
    //点击黑色透明视图choseView会消失
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)];
    [choseView.alphaiView addGestureRecognizer:tap];
    //点击图片放大图片
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showBigImage:)];
    choseView.img.userInteractionEnabled = YES;
    [choseView.img addGestureRecognizer:tap1];
    [choseView.mainscrollview addSubview:choseView.countView];
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
//        bgview.transform = CGAffineTransformScale(CGAffineTransformIdentity,1.0,1.0);
//        bgview.center = self.view.center;
    } completion: nil];
    
}
#pragma mark-typedelegete
-(void)btnindex:(int)tag
{
    //通过seletIndex是否>=0来判断尺码和颜色是否被选择，－1则是未选择状态
    if (choseView.sizeView.seletIndex >=0&&choseView.colorView.seletIndex >=0) {
        //尺码和颜色都选择的时候
        NSString *size;
        if (sizearr.count!=0) {
            size = [sizearr objectAtIndex:choseView.sizeView.seletIndex];
        }
        NSString *color;
        if (colorarr.count!=0) {
            color = [colorarr objectAtIndex:choseView.colorView.seletIndex];
        }
        choseView.lb_stock.text = [NSString stringWithFormat:@"Stock %@ ",[[stockarr objectForKey: size] objectForKey:color]];
        choseView.lb_detail.text = [NSString stringWithFormat:@"Chosn \"%@\" \"%@\"",size,color];
        choseView.stock =[[[stockarr objectForKey: size] objectForKey:color] intValue];
        
        // [self reloadTypeBtn:[stockarr objectForKey:size] :colorarr :choseView.colorView :choseView.bt_sure];
        [self reloadTypeBtn:[stockarr objectForKey:color] :sizearr :choseView.sizeView :choseView.bt_sure];
        //        NSLog(@"%d",choseView.colorView.seletIndex);
        //  choseView.img.image = [UIImage imageNamed:[NSString stringWithFormat:@"%d.jpg",choseView.colorView.seletIndex+1]];
        
        choseView.bt_sure.enabled = YES;
        choseView.bt_sure.backgroundColor = [UIColor colorWithHexString:@"#de4536"];
    }else if (choseView.sizeView.seletIndex ==-1&&choseView.colorView.seletIndex == -1)
    {
        //尺码和颜色都没选的时候
        choseView.lb_price.text = [NSString stringWithFormat:@"$%@",_price];
        choseView.lb_stock.text = [NSString stringWithFormat:@"$%@",_oldprice];
        choseView.lb_detail.text = @"Please choose color and size";
        choseView.stock = 100000;
        //全部恢复可点击状态
        [self resumeBtn:colorarr :choseView.colorView];
        [self resumeBtn:sizearr :choseView.sizeView];
        choseView.bt_sure.enabled = NO;
    }
    else if (choseView.sizeView.seletIndex ==-1&&choseView.colorView.seletIndex >= 0)
    {
        //只选了颜色
        NSString *color =[colorarr objectAtIndex:choseView.colorView.seletIndex];
        //根据所选颜色 取出该颜色对应所有尺码的库存字典
        NSDictionary *dic = [stockarr objectForKey:color];
        [self reloadTypeBtn:dic :sizearr :choseView.sizeView :choseView.bt_sure];
        [self resumeBtn:colorarr :choseView.colorView];
        choseView.lb_stock.text =[NSString stringWithFormat:@"$%@",_oldprice];
        choseView.lb_detail.text = @"Please choose size";
        choseView.stock = 100000;
        choseView.img.image = [UIImage imageNamed:[NSString stringWithFormat:@"%d.jpg",choseView.colorView.seletIndex+1]];
        choseView.bt_sure.enabled = NO;
        choseView.bt_sure.backgroundColor = [UIColor redColor];
    }
    else if (choseView.sizeView.seletIndex >= 0&&choseView.colorView.seletIndex == -1)
    {
        //只选了尺码
#pragma mark -  选择尺码
        _size =[sizearr objectAtIndex:choseView.sizeView.seletIndex];
        //根据所选尺码 取出该尺码对应所有颜色的库存字典
        NSDictionary *dic = [stockarr objectForKey:_size];
        [self resumeBtn:sizearr :choseView.sizeView];
        choseView.lb_stock.text = _oldprice;
        choseView.lb_detail.text = @"Please choose color";
        choseView.stock = 100000;
        choseView.bt_sure.enabled = NO;
        choseView.bt_sure.backgroundColor = [UIColor redColor];
        for (int i = 0; i<colorarr.count; i++) {
            int count = [[dic objectForKey:[colorarr objectAtIndex:i]] intValue];
            //遍历颜色字典 库存为零则改尺码按钮不能点击
            if (count == 0) {
                UIButton *btn =(UIButton *) [choseView.colorView viewWithTag:100+i];
                btn.enabled = NO;
                btn.backgroundColor = [UIColor grayColor];
            }
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
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
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
            [btn setTitleColor:[UIColor redColor] forState:0];
           
        }
        else
        {
            btn.enabled = YES;
            [btn setTitleColor:[UIColor blackColor] forState:0];
        }
        //根据seletIndex 确定用户当前点了那个按钮
        if (view.seletIndex == i)
        {
            btn.selected = YES;
            [btn setBackgroundColor:[UIColor redColor]];
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
