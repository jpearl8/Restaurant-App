//
//  ProfileViewController.m
//  Fresh-Chef-Analytics
//
//  Created by jpearl on 7/16/19.
//  Copyright © 2019 julia@ipearl.net. All rights reserved.
//

#import "ProfileViewController.h"
#import "AppDelegate.h"
#import "LoginViewController.h"
#import "YelpAPIManager.h"

@interface ProfileViewController ()

@property (nonatomic, assign) BOOL isEditable;
@property (weak, nonatomic) NSString *categoryPlaceholder;
@property (weak, nonatomic) NSString *pricePlaceholder;

@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //setup display
    [self.navigationItem setTitle:@"Profile"];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor blackColor],NSFontAttributeName:[UIFont systemFontOfSize:21 weight:UIFontWeightThin]}];
    self.restaurantProfileImage.layer.cornerRadius = 0.1 * self.restaurantProfileImage.frame.size.width;
    // Set class variables

    
    
    self.categoryPlaceholder = @"Set Restaurant Category";
    self.pricePlaceholder = @"Set Restaurant Price";
    
    // Set restaurant name, category and price labels
    self.user = [PFUser currentUser];
    self.isEditable = NO; // the profile is not editable initially
    self.restaurantNameLabel.text = self.user[@"username"];
    [self setProfileLabels];
    // show label and hide text field initially
    [self showLabels:YES];
    if(self.user[@"image"] != nil){
        [self setProfilePicture];
    }
}

- (IBAction)didTapLogout:(id)sender {
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    LoginViewController *loginViewController = [storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
    appDelegate.window.rootViewController = loginViewController;
    [PFUser logOutInBackgroundWithBlock:^(NSError * _Nullable error) {
        // PFUser.current() will now be nil
    }];
}

- (IBAction)didTapEdit:(id)sender {
    /*
     if button says edit then the profile will become editable and
     if button says 'save' then the profile will save edits
     */
    if(self.isEditable == NO){
        self.isEditable = YES;
        //change edit label to 'save' and logout button to 'cancel'
        self.editButton.title = @"Save";
        // show text fields and cancel and hide labels
        [self showLabels:NO];
        //set text fields if their labels have been set
        self.restaurantNameField.text = self.restaurantNameLabel.text; // restaurant name will already be set
        self.restaurantEmailField.text = self.restaurantEmailLabel.text; // email will already be set
        // if user has a category then set field text to category
        if(![self.restaurantCategoryLabel.text isEqualToString: self.categoryPlaceholder]){
            self.restaurantCategoryField.text = self.restaurantCategoryLabel.text;
        }
        // if user has a price then set field text to price
        if(![self.restaurantPriceLabel.text isEqualToString: self.pricePlaceholder]){
            self.restaurantPriceField.text = self.restaurantPriceLabel.text;
        }
    } else {
        //User pressed 'save' button
        self.isEditable = NO;
        self.editButton.title = @"Edit";
        // Hide text fields, show labels, and save values
        [self showLabels:YES];
        //save values to PFUser
        self.user[@"username"] = self.restaurantNameField.text;
        self.user[@"category"] = self.restaurantCategoryField.text;
        self.user[@"email"] = self.restaurantEmailField.text;
        self.user[@"image"] = [self getPFFileFromImage:self.restaurantProfileImage.image];
//        self.user[@"price"] = self.restaurantPriceField;
        [self.user saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
            if(succeeded){
                NSLog(@"successfully saved updates");
                [self setProfileLabels];
            } else {
                NSLog(@"Error saving updates: %@", error.localizedDescription);
            }
        }];
    }
}

- (void)setProfileLabels {
    self.restaurantNameLabel.text = self.user[@"username"];
    NSString *category = self.user[@"category"];
    NSString *price = self.user[@"price"];
    NSString *email = self.user[@"email"];
    if(category != nil && ![category isEqualToString: @""]){
        self.restaurantCategoryLabel.text = category;
    } else {
        self.restaurantCategoryLabel.text = self.categoryPlaceholder;
        self.restaurantCategoryField.placeholder = self.categoryPlaceholder;
    }
    if (price != nil && ![price isEqualToString:@""]) {
        self.restaurantPriceLabel.text = price;
    } else {
        self.restaurantPriceLabel.text = self.pricePlaceholder;
        self.restaurantPriceField.placeholder = self.pricePlaceholder;
    }
    if(email != nil && ![email isEqualToString:@""]){
        self.restaurantEmailLabel.text = email;
    } else {
        self.restaurantEmailLabel.text = @"Set Restaurant Email";
        self.restaurantEmailField.placeholder = @"Set Restaurant Email";
    }
}

- (IBAction)didTapCancel:(id)sender {
    [self showLabels:YES];
    [self setProfilePicture];
    self.isEditable = NO;
    self.editButton.title = @"Edit";
}

-(void) showLabels: (BOOL)trueFalse {
    // if trueFalse is YES then show labels and hide fields
    // if trueFalse is NO then do the reverse
    //name
    self.restaurantNameLabel.hidden = !trueFalse;
    self.restaurantNameField.enabled = !trueFalse;
    self.restaurantNameField.hidden = trueFalse;
    //category
    self.restaurantCategoryLabel.hidden = !trueFalse;
    self.restaurantCategoryField.enabled = !trueFalse;
    self.restaurantCategoryField.hidden = trueFalse;
    //price
    self.restaurantPriceLabel.hidden = !trueFalse;
    self.restaurantPriceField.enabled = !trueFalse;
    self.restaurantPriceField.hidden = trueFalse;
    //email
    self.restaurantEmailLabel.hidden = !trueFalse;
    self.restaurantEmailField.enabled = !trueFalse;
    self.restaurantEmailField.hidden = trueFalse;
    
    self.tapToEditLabel.hidden = trueFalse;
    self.cancelButton.enabled = !trueFalse;
    if(trueFalse == YES){
        self.cancelButton.tintColor = UIColor.clearColor;
    } else {
        self.cancelButton.tintColor = self.view.tintColor;
    }
    
}

- (IBAction)didTapBackground:(id)sender {
    //dismiss keyboard
    [self.view endEditing:YES];
}

- (IBAction)didTapProfilePic:(id)sender {
    if(self.isEditable == YES){
        NSLog(@"tapped camera image");
        UIImagePickerController *imagePickerVC = [UIImagePickerController new];
        imagePickerVC.delegate = self;
        imagePickerVC.allowsEditing = YES;
        // if camera is available, use it, else, use camera roll
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            imagePickerVC.sourceType = UIImagePickerControllerSourceTypeCamera;
        }
        else {
            NSLog(@"Camera 🚫 available so we will use photo library instead");
            imagePickerVC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        }
        [self presentViewController:imagePickerVC animated:YES completion:nil];
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    
    // Get the image captured by the UIImagePickerController
    UIImage *editedImage = info[UIImagePickerControllerEditedImage];
    // Resize image to avoid memory issues in Parse
    //----------- Necessary???????????-----------------
    
    
//    UIImage *resizedImage = [self resizeImage:editedImage withSize:CGSizeMake(400, 400)];
    self.restaurantProfileImage.image = editedImage;
    // Dismiss UIImagePickerController to go back to original view controller
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (PFFileObject *)getPFFileFromImage: (UIImage * _Nullable)image {
    // check if image is not nil
    if (!image) {
        return nil;
    }
    NSData *imageData = UIImagePNGRepresentation(image);
    // get image data and check if that is not nil
    if (!imageData) {
        return nil;
    }
    return [PFFileObject fileObjectWithName:@"image.png" data:imageData];
}

- (void)setProfilePicture {
    PFFileObject *userImageFile = self.user[@"image"];
    [userImageFile getDataInBackgroundWithBlock:^(NSData *imageData, NSError *error) {
        if(!error){
            self.restaurantProfileImage.image = [UIImage imageWithData:imageData];
        }
    }];

//    self.restaurantProfileImage.image = self.user[@"image"];
//    [self.restaurantProfileImage loadInBackground];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
