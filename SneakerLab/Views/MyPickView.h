//
//  MypickView.h
//  caowei
//
//  Created by Jason cao on 16/9/5.
//  Copyright © 2016年 Jason cao. All rights reserved.
//

#import <UIKit/UIKit.h>
@class zySheetPickerView;
//回调  pickerView 回传类本身 用来做调用 销毁动作
//     choiceString  回传选择器 选择的单个条目字符串
typedef void(^zySheetPickerViewBlock)(zySheetPickerView *pickerView,NSString *choiceString);
@interface zySheetPickerView : UIView
@property (nonatomic,copy)zySheetPickerViewBlock callBack;

@property (nonatomic, strong) UIColor *textColor;
@property (nonatomic, strong) UIFont *textFont;


//------单条选择器
+(instancetype)ZYSheetStringPickerWithTitle:(NSArray *)title andHeadTitle:(NSString *)headTitle Andcall:(zySheetPickerViewBlock)callBack;
//显示
-(void)show;
//销毁类
-(void)dismissPicker;

@end

//@class MyPickView;
////回调  pickerView 回传类本身 用来做调用 销毁动作
////     choiceString  回传选择器 选择的单个条目字符串
//typedef void(^MyPickViewBlock)(MyPickView *pickerView,NSString *choiceString);
//@interface MyPickView : UIView
//@property (nonatomic,copy)MyPickViewBlock callBack;
//
//@property (nonatomic, strong) UIColor *textColor;
//@property (nonatomic, strong) UIFont *textFont;
//
//
////------单条选择器
//+(instancetype)MyPickerWithTitle:(NSArray *)title andHeadTitle:(NSString *)headTitle Andcall:(MyPickViewBlock)callBack;
////显示
//-(void)show;
////销毁类
//-(void)dismissPicker;
//
//
//@end
