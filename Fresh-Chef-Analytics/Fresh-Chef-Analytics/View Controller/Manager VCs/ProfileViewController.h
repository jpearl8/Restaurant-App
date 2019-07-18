//
//  ProfileViewController.h
//  Fresh-Chef-Analytics
//
//  Created by jpearl on 7/16/19.
//  Copyright © 2019 julia@ipearl.net. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Parse/Parse.h"

NS_ASSUME_NONNULL_BEGIN

@interface ProfileViewController : UIViewController <UINavigationControllerDelegate, UIImagePickerControllerDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *restaurantProfileImage;
@property (weak, nonatomic) IBOutlet UILabel *restaurantNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *restaurantCategoryLabel;
@property (weak, nonatomic) IBOutlet UILabel *restaurantPriceLabel;

@property (weak, nonatomic) IBOutlet UITextField *restaurantNameField;
@property (weak, nonatomic) IBOutlet UITextField *restaurantCategoryField;
@property (weak, nonatomic) IBOutlet UITextField *restaurantPriceField;
@property (weak, nonatomic) IBOutlet UILabel *tapToEditLabel;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *editButton;
@property (weak, nonatomic) PFUser *user;

@end

NS_ASSUME_NONNULL_END
