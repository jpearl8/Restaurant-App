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

@interface ProfileViewController : UIViewController <UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIPickerViewDataSource, UIPickerViewDelegate> {
//    UIPickerView *themePickerView;
}
@property (weak, nonatomic) IBOutlet UIImageView *restaurantProfileImage;
@property (weak, nonatomic) IBOutlet UILabel *restaurantNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *restaurantCategoryLabel;
@property (weak, nonatomic) IBOutlet UILabel *restaurantPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *restaurantEmailLabel;
@property (weak, nonatomic) IBOutlet UILabel *restaurantThemeLabel;

@property (weak, nonatomic) IBOutlet UITextField *restaurantNameField;
@property (weak, nonatomic) IBOutlet UITextField *restaurantCategoryField;
@property (weak, nonatomic) IBOutlet UITextField *restaurantPriceField;
@property (weak, nonatomic) IBOutlet UITextField *restaurantEmailField;
@property (weak, nonatomic) IBOutlet UILabel *tapToEditLabel;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *editButton;
@property (weak, nonatomic) IBOutlet UIButton *logoutButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *cancelButton;
@property (weak, nonatomic) PFUser *user;
@property (weak, nonatomic) IBOutlet UIButton *themeButton;
@property (weak, nonatomic) IBOutlet UIPickerView *themePickerView;

//@property (retain, nonatomic) IBOutlet UIPickerView *themePickerView;
@property (weak, nonatomic) IBOutlet UITextField *themeTextField;

@property (weak, nonatomic) IBOutlet UILabel *numCustomersServed;
@property (weak, nonatomic) IBOutlet UILabel *numTables;

@end

NS_ASSUME_NONNULL_END
