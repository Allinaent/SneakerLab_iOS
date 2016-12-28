//
//  UserInfo.h
//  SneakerLab
//
//  Created by 郭隆基 on 2016/11/29.
//  Copyright © 2016年 Jason cao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserInfo : NSObject
@property (nonatomic, strong) NSString *firstname;
@property (nonatomic, strong) NSString *lastname;
@property (nonatomic, strong) NSString *phone;
@property (nonatomic, strong) NSString *sex;
@property (nonatomic, strong) NSString *age;
@property (nonatomic, strong) NSString *email;
@property (nonatomic, strong) NSString *avatar;
+ (instancetype)sharedUserInfo;
@end
