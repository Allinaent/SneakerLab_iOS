//
//  FactoryUI.m
//  LoveLife
//
//  Created by 杨阳 on 16/4/25.
//  Copyright © 2016年 yangyang. All rights reserved.
//

#import "FactoryUI.h"

@implementation FactoryUI

//UIView
+(UIView *)createViewWithFrame:(CGRect)frame
{
    UIView * view = [[UIView alloc]initWithFrame:frame];
    return view;
}
//UILabel
+(UILabel *)createLabelWithFrame:(CGRect)frame text:(NSString *)text textColor:(UIColor *)textColor font:(UIFont *)font
{
    UILabel * label = [[UILabel alloc]initWithFrame:frame];
    //文字
    label.text = text;
    
    //文字颜色
    label.textColor = textColor;
    //字体颜色
    label.font = font;
    //设置对齐方式
    label.textAlignment = NSTextAlignmentLeft;
    return label;
    
}
//UIButton
+(UIButton *)createButtonWithFrame:(CGRect)frame title:(NSString *)title titleColor:(UIColor *)titleColor imageName:(NSString *)imageName backgroundImageName:(NSString *)backgroundImageName target:(id)target selector:(SEL)selector
{
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = frame;
    //设置标题
    [button setTitle:title forState:UIControlStateNormal];
    //设置标题颜色
    [button setTitleColor:titleColor forState:UIControlStateNormal];
    //设置图片
    [button setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    //设置背景图片
    [button setBackgroundImage:[UIImage imageNamed:backgroundImageName] forState:UIControlStateNormal];
    
    //设置响应事件
    [button addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    return button;
}
//UIImageView
+(UIImageView *)createImageViewWithFrame:(CGRect)frame imageName:(NSString *)imageName
{
    UIImageView * imageView = [[UIImageView alloc]initWithFrame:frame];
    imageView.image = [UIImage imageNamed:imageName];
    return imageView;
}
//UITextField
+(UITextField *)createTextFieldWithFrame:(CGRect)frame text:(NSString *)text placeHolder:(NSString *)placeHolder
{
    UITextField * textField = [[UITextField alloc]initWithFrame:frame];
    textField.text = text;
    textField.placeholder = placeHolder;
    return textField;
}

@end
