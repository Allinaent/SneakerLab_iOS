//
//  TypeView.h
//  caowei
//
//  Created by Jason cao on 2016/9/18.
//  Copyright © 2016年 Jason cao. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol TypeSeleteDelegete <NSObject>

-(void)btnindex:(int) tag;

@end
@interface TypeView : UIView
@property(nonatomic)float height;
@property(nonatomic)int seletIndex;
@property (nonatomic,retain) id<TypeSeleteDelegete> delegate;

-(instancetype)initWithFrame:(CGRect)frame andDatasource:(NSArray *)arr :(NSString *)typename;
@end
