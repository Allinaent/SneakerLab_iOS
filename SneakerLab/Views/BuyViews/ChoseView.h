//
//  ChoseView.h
//  caowei
//
//  Created by Jason cao on 2016/9/18.
//  Copyright © 2016年 Jason cao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TypeView.h"
#import "BuyCountView.h"
@interface ChoseView : UIView<UITextFieldDelegate,UIAlertViewDelegate>
@property(nonatomic, retain)UIView *alphaiView;
@property(nonatomic, retain)UIView *whiteView;
@property(nonatomic, strong)NSString *imgStr;
@property(nonatomic, retain)UIImageView *img;

@property(nonatomic, retain)UILabel *lb_price;
@property(nonatomic, retain)UILabel *lb_stock;
@property(nonatomic, retain)UILabel *lb_detail;
@property(nonatomic, retain)UIView *lb_line;

@property(nonatomic, retain)UIScrollView *mainscrollview;

@property(nonatomic, retain)TypeView *sizeView;
@property(nonatomic, retain)TypeView *colorView;
@property(nonatomic, retain)BuyCountView *countView;

@property(nonatomic, retain)UIButton *bt_sure;
@property(nonatomic, retain)UIButton *bt_cancle;


@property(nonatomic, assign) NSInteger stock;
@property (nonatomic , copy) NSString *productID;
@property(nonatomic,copy)NSString *images1;
@property(nonatomic,strong)NSArray *arrayImage;
@property(nonatomic,copy)NSString *product_option_id;
//尺寸
@property(nonatomic,copy)NSString *product_option_value_id;
//颜色
@property(nonatomic,copy)NSString *product_option_value_id2;
@property(nonatomic,assign)NSInteger quantity;
//type,add,buy,决定是那个接口
@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) UIButton *button;
@property (nonatomic, assign) NSInteger minimum;
-(void)CreatUI;

@end
