//
//  EditAddressView.h
//  SneakerLab
//
//  Created by Jason cao on 2016/10/10.
//  Copyright © 2016年 Jason cao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AddressModel.h"
@interface EditAddressView : UIView <UITextFieldDelegate>
{
    UITextField *_nameTF;
    UITextField *_addressTF;
    UITextField *_cityTF;
    UITextField *_codeTF;
    UITextField *_phoneTF;
    UIButton *_countryTF;
    UIButton *_stateTF;
    UITextField *_aptTF;
}
@property(nonatomic,strong)NSString *address_id;
@property(nonatomic,strong)AddressModel *model;
@property(nonatomic,strong)NSString *countryID;
@property(nonatomic,strong)NSString *stateID;
- (void)getData;

@end
