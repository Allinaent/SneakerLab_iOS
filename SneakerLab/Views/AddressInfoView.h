//
//  AddressInfoView.h
//  caowei
//
//  Created by Jason cao on 2016/9/14.
//  Copyright © 2016年 Jason cao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddressInfoView : UIView <UITextFieldDelegate>
{
//    UITextField *_nameTF;
//    UITextField *_addressTF;
//    UITextField *_cityTF;
//    UITextField *_codeTF;
//    UITextField *_phoneTF;
//    UITextField *_countryTF;
//    UITextField *_stateTF;
//    NSString *_countryID;
//    NSString *_stateID;
//    NSString *_addressID;
   NSMutableArray *_countryIdArr;
}
@property(nonatomic,copy)UITextField *nameTF;
@property(nonatomic,copy)UITextField *aptTF;
@property(nonatomic,copy)UITextField *addressTF;
@property(nonatomic,copy)UITextField *cityTF;
@property(nonatomic,copy)UITextField *codeTF;
@property(nonatomic,copy)UITextField *phoneTF;
@property(nonatomic,copy)UITextField *countryTF;
@property(nonatomic,copy)UITextField *stateTF;
@property(nonatomic,copy)UITextField *countryID;
@property(nonatomic,copy)UITextField *stateID;
@property(nonatomic,copy)UITextField *addressID;
//@property(nonatomic,copy)NSString *countryIdArr;
@property(nonatomic,copy)NSString *address_id;

- (void)UploadData;

@end
