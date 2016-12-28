//
//  FactoryUI.h
//  LoveLife
//
//  Created by 杨阳 on 16/4/25.
//  Copyright © 2016年 yangyang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface FactoryUI : NSObject

//利用工厂模式，将基本控件用静态方法创建，似的能够更方便的修改类似的属性
//UIView
+(UIView *)createViewWithFrame:(CGRect)frame;
//UILabel
+(UILabel *)createLabelWithFrame:(CGRect)frame text:(NSString *)text textColor:(UIColor *)textColor font:(UIFont *)font;
//UIButton
+(UIButton *)createButtonWithFrame:(CGRect)frame title:(NSString *)title titleColor:(UIColor *)titleColor imageName:(NSString *)imageName backgroundImageName:(NSString *)backgroundImageName target:(id)target selector:(SEL)selector;
//UIImageView
+(UIImageView *)createImageViewWithFrame:(CGRect)frame imageName:(NSString *)imageName;
//UITextField
+(UITextField *)createTextFieldWithFrame:(CGRect)frame text:(NSString *)text placeHolder:(NSString *)placeHolder;

@end
