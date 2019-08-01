//
//  CustomPopUpViewController.h
//  Fresh-Chef-Analytics
//
//  Created by selinons on 8/1/19.
//  Copyright © 2019 julia@ipearl.net. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Dish.h"
#import "MenuManager.h"

NS_ASSUME_NONNULL_BEGIN

@interface CustomPopUpViewController : UIViewController <UINavigationControllerDelegate, UIImagePickerControllerDelegate>
@property (weak, nonatomic) IBOutlet UITextField *typeField;
@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (weak, nonatomic) IBOutlet UITextField *priceField;
@property (weak, nonatomic) IBOutlet UITextView *descriptionView;
@property (weak, nonatomic) IBOutlet UIButton *addButton;
@property (weak, nonatomic) IBOutlet UIImageView *dishView;
@property (weak, nonatomic) IBOutlet UIView *customPopUp;

@end

NS_ASSUME_NONNULL_END
