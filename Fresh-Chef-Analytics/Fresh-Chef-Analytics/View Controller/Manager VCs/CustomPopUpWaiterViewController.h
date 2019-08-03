//
//  CustomPopUpWaiterViewController.h
//  Fresh-Chef-Analytics
//
//  Created by selinons on 8/1/19.
//  Copyright © 2019 julia@ipearl.net. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WaiterManager.h"

NS_ASSUME_NONNULL_BEGIN

@interface CustomPopUpWaiterViewController : UIViewController <UINavigationControllerDelegate, UIImagePickerControllerDelegate>
@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (weak, nonatomic) IBOutlet UIImageView *profileImage;
@property (weak, nonatomic) IBOutlet UITextField *yearsField;
@property (weak, nonatomic) IBOutlet UIButton *addButton;
@end

NS_ASSUME_NONNULL_END
