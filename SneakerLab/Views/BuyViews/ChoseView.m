
//
//  ChoseView.m
//  caowei
//
//  Created by Jason cao on 2016/9/18.
//  Copyright © 2016年 Jason cao. All rights reserved.
//

#import "ChoseView.h"
#import "ShopViewController.h"
#import "SignInController.h"
#import "UIView+Extension.h"
#import "GProductDetailViewController.h"
#import <WZLBadge/WZLBadgeImport.h>
#pragma mark -- 添加购物车的页面
@implementation ChoseView
@synthesize alphaiView,whiteView,img,lb_detail,lb_price,lb_stock,mainscrollview,sizeView,colorView,countView,bt_sure,bt_cancle,lb_line;
-(instancetype)initWithFrame:(CGRect)frame
{
   self = [super initWithFrame:frame];
    if (self) {
        [self CreatUI];
    }
    return self;
}

-(void)CreatUI{
    self.backgroundColor = [UIColor clearColor];
    //半透明视图
    alphaiView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    alphaiView.backgroundColor = [UIColor blackColor];
    alphaiView.alpha = 0.5;
    [self addSubview:alphaiView];
    //装载商品信息的视图
    whiteView = [[UIView alloc] init];
    [self addSubview:whiteView];
    [whiteView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.top.equalTo(self.mas_top).with.offset(SCREEN_W*2/3);
        make.bottom.equalTo(self);
    }];
    whiteView.backgroundColor = [UIColor whiteColor];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap)];
    [whiteView addGestureRecognizer:tap];
    
    // 商品图片
    img = [[UIImageView alloc] initWithFrame:CGRectMake(10, -20, 100, 100)];
    
    img.backgroundColor = [UIColor yellowColor];
    img.layer.cornerRadius = 4;
    img.layer.borderColor = [UIColor whiteColor].CGColor;
    img.layer.borderWidth = 5;
    [img.layer setMasksToBounds:YES];
    [whiteView addSubview:img];
    
    bt_cancle= [UIButton buttonWithType:UIButtonTypeCustom];
    [whiteView addSubview:bt_cancle];
    [bt_cancle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(whiteView.mas_right).with.offset(0);
        make.top.equalTo(whiteView.mas_top).with.offset(10);
        make.size.mas_equalTo(CGSizeMake(55, 30));
    }];
    [bt_cancle setImage:[UIImage imageNamed:@"close2"] forState:UIControlStateNormal];
    bt_cancle.contentMode = UIViewContentModeCenter;
    //商品价格
    lb_price = [[UILabel alloc] init];
    [whiteView addSubview:lb_price];
    [lb_price mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(img.mas_right).with.offset(20);
        make.top.equalTo(whiteView.mas_top).with.offset(10);
        make.height.mas_equalTo(20);
    }];
    lb_price.textColor = [UIColor redColor];
    lb_price.font = [UIFont systemFontOfSize:14];
    
    //商品库存
    lb_stock = [[UILabel alloc] init];
    [whiteView addSubview:lb_stock];
    [lb_stock mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(img.mas_right).with.offset(20);
        make.top.equalTo(lb_price.mas_bottom).with.offset(10);
        make.height.mas_equalTo(20);
    }];
    
    lb_stock.textColor = [UIColor blackColor];
    lb_stock.font = [UIFont systemFontOfSize:14];
    
    //用户所选择商品的尺码和颜色
    lb_detail = [[UILabel alloc] init];
    [whiteView addSubview:lb_detail];
    [lb_detail mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(img.mas_right).with.offset(20);
        make.top.equalTo(lb_stock.mas_bottom).with.offset(5);
        make.height.mas_equalTo(20);
    }];
    lb_detail.numberOfLines = 2;
    lb_detail.textColor = [UIColor blackColor];
    lb_detail.font = [UIFont systemFontOfSize:14];
    
    //分界线
    lb_line = [[UIView alloc] init];
    [whiteView addSubview:lb_line];
    [lb_line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.top.equalTo(img.mas_bottom).with.offset(20);
        make.size.mas_equalTo(CGSizeMake(SCREEN_W, 0.5));
    }];
    lb_line.backgroundColor = [UIColor lightGrayColor];
    
    //购买按钮
    self.button = [[UIButton alloc] init];
    [_button setTitle:@"Buy now" forState:UIControlStateNormal];
    [_button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _button.backgroundColor = [UIColor colorWithHexString:@"#de4536"];
    _button.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:15];
    [self setNeedsLayout];
    [self layoutIfNeeded];
    [whiteView addSubview:_button];
    _button.frame = CGRectMake(0, self.whiteView.frame.size.height-49, SCREEN_W, 49);
    
    [UIView showViewFrames:_button];
    _button.zhw_ignoreEvent = NO;
    _button.zhw_acceptEventInterval = 3.0;
    [_button addTarget:self action:@selector(beforeBuy) forControlEvents:UIControlEventTouchUpInside];//防抖动处理要升级
    //有的商品尺码和颜色分类特别多 所以用UIScrollView 分类过多显示不全的时候可滑动查看
    mainscrollview = [[UIScrollView alloc] init];
    [whiteView addSubview:mainscrollview];
    [mainscrollview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.top.equalTo(lb_line.mas_bottom);
        make.right.mas_equalTo(SCREEN_W);
        make.bottom.equalTo(_button.mas_top);
    }];
    mainscrollview.showsHorizontalScrollIndicator = NO;
    mainscrollview.showsVerticalScrollIndicator = NO;
    //购买数量的视图
    countView = [[BuyCountView alloc] initWithFrame:CGRectMake(0, _button.frame.origin.y-50-10, SCREEN_W, 50)];
    [mainscrollview addSubview:countView];
    
    [countView.bt_add addTarget:self action:@selector(add) forControlEvents:UIControlEventTouchUpInside];
    countView.tf_count.delegate = self;
    [countView.bt_reduce addTarget:self action:@selector(reduce) forControlEvents:UIControlEventTouchUpInside];
    [self setNeedsLayout];
    [self layoutIfNeeded];
    [self bringSubviewToFront:_button];
}

- (void)beforeBuy {
    [[self class] cancelPreviousPerformRequestsWithTarget:self selector:@selector(buy) object:nil];
    [self performSelector:@selector(buy) withObject:nil afterDelay:0.5f];
}

-(void)add
{
    int count =[countView.tf_count.text intValue];
    if (count < self.stock) {
        countView.tf_count.text = [NSString stringWithFormat:@"%d",count+1];
    }else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Tip" message:@"Out of range" delegate:self cancelButtonTitle:@"Confirm" otherButtonTitles:nil];
        alert.tag = 100;
        [alert show];
    }
}

-(void)setImages1:(NSString *)images1{
    _images1 = images1;
    [img sd_setImageWithURL:[NSURL URLWithString:_images1]];
}


-(void)reduce
{
    int count =[countView.tf_count.text intValue];
    if (count > 1) {
        countView.tf_count.text = [NSString stringWithFormat:@"%d", count-1];
    }else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Tip" message:@"At least one" delegate:self cancelButtonTitle:@"Confirm" otherButtonTitles:nil];
        alert.tag = 100;
        [alert show];
    }
}

#pragma mark-tf
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    mainscrollview.contentOffset = CGPointMake(0, countView.frame.origin.y);
    return YES;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [countView.tf_count resignFirstResponder];
    mainscrollview.contentOffset = CGPointMake(0, 0);
    return YES;
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    int count =[countView.tf_count.text intValue];
    if (count > self.stock) {
       
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Tip" message:@"Out of range" delegate:self cancelButtonTitle:@"Confirm" otherButtonTitles:nil];
        alert.tag = 100;
        [alert show];
        countView.tf_count.text = [NSString stringWithFormat:@"%ld",(long)self.stock];
        [self tap];
    }
    else if (count < self.minimum){
        countView.tf_count.text = [NSString stringWithFormat:@"%ld", self.minimum];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Tip" message:[NSString stringWithFormat:@"At least %ld", self.minimum] delegate:self cancelButtonTitle:@"Confirm" otherButtonTitles:nil];
        alert.tag = 100;
        [alert show];
        [self tap];
    }
}

-(void)tap
{
    mainscrollview.contentOffset = CGPointMake(0, 0);
    [countView.tf_count resignFirstResponder];
}

- (void)buy
{
    if ([countView.tf_count.text integerValue] < self.minimum) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Tip" message:[NSString stringWithFormat:@"At least %ld", self.minimum] delegate:self cancelButtonTitle:@"Confirm" otherButtonTitles:nil];
        alert.tag = 100;
        [alert show];
        return;
    }
    if ([self.type isEqualToString:@"buy"]) {
        if([[[NSUserDefaults standardUserDefaults] objectForKey:@"signInSuccessful"] boolValue] == YES){
            //buy now
            //跳转页面并传值
        }else{
            LoginController *vc = [[LoginController alloc] init];
            vc.fromController = @"productDetail";
            [self.NavViewController pushViewController:vc animated:YES];
        }
    }else if ([self.type isEqualToString:@"add"]) {
        if([[[NSUserDefaults standardUserDefaults] objectForKey:@"signInSuccessful"] boolValue] == YES){
            [self loadData];
        }else{
            LoginController *vc = [[LoginController alloc] init];
            vc.fromController = @"productDetail";
            [self.NavViewController pushViewController:vc animated:YES];
        }
    }
}

#pragma clang diagnostic ignored "-Wunused-variable"
#pragma mark - 妥协的艺术和坚持的艺术
// 加入到购物车(加入购物车的数量和颜色还没有统计)
- (void)loadData
{
#if PREDUPLICATE==0
    if (self.product_option_id!=nil) {
#endif
        NSString *time = [self getCurrentTimestamp];
#if PREDUPLICATE==0
        NSDictionary *arr1 = [NSDictionary dictionary];
        if (self.product_option_value_id2.length!=0) {
            if (self.product_option_value_id==nil||self.product_option_value_id2==nil) {
                [MBManager showBriefMessage:@"please choose size and color" InView:self];
                return;
            }
            arr1 = @{self.product_option_id:self.product_option_value_id,self.product_option_id:self.product_option_value_id2};
        }else{
            if (self.product_option_value_id==nil) {
                [MBManager showBriefMessage:@"please choose size" InView:self];
                return;
            }
            arr1 = @{self.product_option_id:self.product_option_value_id};
        }
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:arr1 options:NSJSONWritingPrettyPrinted error:nil];
        NSString *jsonStr = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
#elif PREDUPLICATE==1
        NSString *jsonStr = @"";
#elif PREDUPLICATE==2
        NSString *jsonStr = @"";
#elif PREDUPLICATE==3
        NSString *jsonStr = @"";
#elif PREDUPLICATE==4
        NSString *jsonStr = @"";
#elif PREDUPLICATE==5
        NSString *jsonStr = @"";
#elif PREDUPLICATE==6
        NSString *jsonStr = @"";
#elif PREDUPLICATE==7
        NSString *jsonStr = @"";
#endif
        NSArray *arr = @[@"appKey",@"apiKey",@"timestamp",@"option",@"quantity",@"product_id",@"equipment_id",@"recurring_id",@"token",@"email"];
        NSDictionary *dic = @{@"option" : jsonStr,
                              @"quantity" : [NSString stringWithFormat:@"%ld", [countView.tf_count.text integerValue]],
                              @"product_id" : self.productID,
                              @"recurring_id" : @"0",
                              @"appKey" : APPKEY,
                              @"apiKey" : APIKEY,
                              @"equipment_id" : MYDEVICEID,
                              @"timestamp" : time,
                              @"email" : CWEMAIL,
                              @"token" :CWTOKEN
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
        [[CWAPIClient sharedClient] POSTRequest:ADDSHOPPING_URL parameters:parameters progress:nil success:^(NSURLSessionDataTask *task, id responseObject)
         {
             NSLog(@"%@",responseObject);
             UINavigationController *nav = [self NavViewController];
             //ShopViewController *vc = [[ShopViewController alloc] init];
             //[nav pushViewController:vc animated:YES];
             //buy进行判断，是否填写过地址及银行卡信息
             [UIView animateWithDuration: 0.35 animations: ^{
                 self.frame =CGRectMake(0, (SCREEN_H-64), SCREEN_W, self.frame.size.height);
             } completion: nil];
             [MBManager showBriefAlert:@"success"];
             GProductDetailViewController *vc = (GProductDetailViewController *)[self LJContentController];
             vc.cartnum = vc.cartnum + 1;
             [vc.cart showBadgeWithStyle:WBadgeStyleNumber value:vc.cartnum animationType:WBadgeAnimTypeNone];
         } failure:^(NSURLSessionDataTask *task, NSError *error)
         {
             NSLog(@"%@",error);
         }];
#if PREDUPLICATE==0
    }
#endif
}

- (UINavigationController*)NavViewController {
    for (UIView* next = [self superview]; next; next = next.superview) {
        UIResponder* nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UINavigationController class]]) {
            return (UINavigationController*)nextResponder;
        }
    }
    return nil;
}

@end
