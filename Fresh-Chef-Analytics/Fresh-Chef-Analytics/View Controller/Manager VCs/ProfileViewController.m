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
#import "MenuManager.h"
#import "UIRefs.h"

@interface ProfileViewController ()

@property (nonatomic, assign) BOOL isEditable;
@property (nonatomic, assign) BOOL isThemePickerOpen;
@property (weak, nonatomic) NSString *categoryPlaceholder;
@property (weak, nonatomic) NSString *pricePlaceholder;
@property (weak, nonatomic) NSString *themePlaceholder;
@property (strong, nonatomic) NSArray *themesArr;
@property (strong, nonatomic) UIAlertController *alert;
@property (weak, nonatomic) IBOutlet UIImageView *backgroundPic1;
@property (weak, nonatomic) IBOutlet UIImageView *backgroundPic2;
@property (strong, nonatomic) UIButton *chooseLibrary;
@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //setup display
    self.chooseLibrary = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.chooseLibrary addTarget:self
               action:@selector(didTapLibrary:)
     forControlEvents:UIControlEventTouchUpInside];
    [self.chooseLibrary setTitle:@"Choose from Library" forState:UIControlStateNormal];
    self.chooseLibrary.frame = CGRectMake(300, 212, 100, 40.0);
    self.chooseLibrary.backgroundColor = [[UIRefs shared] colorFromHexString:[UIRefs shared].purpleAccent];
    [self.view addSubview:self.chooseLibrary];
    self.chooseLibrary.hidden = YES;
    [self.navigationItem setTitle:@"Profile"];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor blackColor],NSFontAttributeName:[UIFont systemFontOfSize:21 weight:UIFontWeightThin]}];
    self.restaurantProfileImage.layer.cornerRadius = 0.1 * self.restaurantProfileImage.frame.size.width;
    // Set class variables

    
    
    self.categoryPlaceholder = @"Set Restaurant Category";
    self.pricePlaceholder = @"Set Restaurant Price";
    self.themePlaceholder = @"Set Restaurant Theme";
    
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
    // setup picker for theme
//    self.themePickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 44, 0, 0)];
    self.themePickerView.delegate = self;
    self.themePickerView.dataSource = self;
    self.themePickerView.showsSelectionIndicator = YES;
    self.themesArr = @[@"Fun", @"Comfortable", @"Elegant"];
//    self.themePickerView set
//    self.themeTextField.inputView = self.themePickerView;
    self.themeTextField.hidden = YES;
    self.themeTextField.enabled = NO;
    // set price range from yelp
//    [[YelpAPIManager shared] userParameters];
    //alert view for picker
    self.alert = [UIAlertController alertControllerWithTitle:@"Set Theme" message:@"Choose a theme for your customer form" preferredStyle:(UIAlertControllerStyleActionSheet)];
//    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Done" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//        // handle response here.
//    }];
//    [self.alert addAction:okAction];
    int i = 0;
    for (NSString *theme in self.themesArr) {
        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:theme style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            // handle response here.
            [self didSelectRowInAlertController:i];
        }];
        [self.alert addAction:defaultAction];
        i++;
    }
    
//    [self.alert.view addSubview:self.themePickerView];
//    // add the OK action to the alert controller
//    [self.alert addAction:okAction];
    // set pics
    [self setBackgroundPics];
}
- (IBAction)didTapLibrary:(id)sender
{
    UIImagePickerController *imagePickerVC = [UIImagePickerController new];
    imagePickerVC.delegate = self;
    imagePickerVC.allowsEditing = YES;
    imagePickerVC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:imagePickerVC animated:YES completion:nil];
    
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
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        self.chooseLibrary.hidden = NO;
    }
    else
    {
        self.chooseLibrary.hidden = YES;
    }
    if(self.isEditable == NO){
        self.isEditable = YES;
        //change edit label to 'save' and logout button to 'cancel'
        self.editButton.title = @"Save";
        // show text fields and cancel and hide labels
        [self showLabels:NO];
        //set text fields if their labels have been set
        self.restaurantNameField.text = self.restaurantNameLabel.text; // restaurant name will already be set
        self.restaurantEmailField.text = self.restaurantEmailLabel.text; // email will already be set
        self.themeButton.titleLabel.text = self.restaurantThemeLabel.text;
        // if user has a category then set field text to category
        if(![self.restaurantCategoryLabel.text isEqualToString: self.categoryPlaceholder]){
            self.restaurantCategoryField.text = self.restaurantCategoryLabel.text;
        }
        // if user has a price then set field text to price
        if(![self.restaurantPriceLabel.text isEqualToString: self.pricePlaceholder]){
            self.restaurantPriceField.text = self.restaurantPriceLabel.text;
        }
        if(![self.restaurantThemeLabel.text isEqualToString:self.themePlaceholder]) {
            self.themeButton.titleLabel.text = self.restaurantThemeLabel.text;
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
        self.user[@"theme"] = self.restaurantThemeLabel.text;
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
    NSString *theme = self.user[@"theme"];
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
    if (email != nil && ![email isEqualToString:@""]){
        self.restaurantEmailLabel.text = email;
    } else {
        self.restaurantEmailLabel.text = @"No email registered";
        self.restaurantEmailField.placeholder = @"Set Restaurant Email";
    }
    if (theme != nil && ![theme isEqualToString:@""]) {
        self.restaurantThemeLabel.text = theme;
    } else {
        self.restaurantThemeLabel.text = @"No Theme Chosen";
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
    //theme
    self.restaurantThemeLabel.hidden = !trueFalse;
    self.themeButton.enabled = !trueFalse;
    self.themeButton.hidden = trueFalse;
    
    
    self.tapToEditLabel.hidden = trueFalse;
    self.cancelButton.enabled = !trueFalse;
    if(trueFalse == YES){
        self.cancelButton.tintColor = UIColor.clearColor;
        self.themePickerView.hidden = YES;
        self.themePickerView.userInteractionEnabled = NO;
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
        else
        {
            NSLog(@"Camera 🚫 available so we will use photo library instead");
            imagePickerVC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        }
        [self presentViewController:imagePickerVC animated:YES completion:nil];

        
        
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    // Get the image captured by the UIImagePickerController
    UIImage *editedImage = info[UIImagePickerControllerEditedImage];
    self.restaurantProfileImage.image = editedImage;
    // Dismiss UIImagePickerController to go back to original view controller
    [picker dismissViewControllerAnimated:YES completion:nil];
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
}

- (IBAction)didTapEditTheme:(id)sender {
   
    if (self.isThemePickerOpen == YES) {
//        self.themePickerView.hidden = YES;
//        self.themePickerView.userInteractionEnabled = NO;
//        self.isThemePickerOpen = NO;
        
        [self presentViewController:self.alert animated:YES completion:^{
            // optional code for what happens after the alert controller has finished presenting
            
        }];
    } else {
//        self.themePickerView.hidden = NO;
//        self.themePickerView.userInteractionEnabled = YES;
//        [self.alert.view addSubview:self.themePickerView];
//        self.isThemePickerOpen = YES;
        [self presentViewController:self.alert animated:YES completion:^{}];
        
    }
    
}

- (void)displayThemePicker
{
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (NSInteger)numberOfComponentsInPickerView:(nonnull UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(nonnull UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return [self.themesArr count];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (component == 0) {
        return self.themesArr[row];
    } else {
        NSLog(@"There should only be one component in picker view");
        return nil;
    }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    // set button text to picker
    self.themeButton.titleLabel.text = self.themesArr[row];
    self.restaurantThemeLabel.text = self.themeButton.titleLabel.text;
    self.themePickerView.hidden = YES;
    self.themePickerView.userInteractionEnabled = NO;
    self.isThemePickerOpen = NO;
}

- (void)setBackgroundPics
{
    NSArray *dishes = [[MenuManager shared] dishes];
    __block BOOL isFirstPicSet = NO;
    __block BOOL isSecondPicSet = NO;
    NSData *placeholderPic = UIImagePNGRepresentation([UIImage imageNamed:@"image_placeholder"]);
    for (Dish *dish in dishes) {
//        UIImage *dishImage = dish.image;
        if (isFirstPicSet && isSecondPicSet) {
            break;
        } else if (dish.image != nil) {
            PFFileObject *dishImageFile = (PFFileObject *)dish.image;
            [dishImageFile getDataInBackgroundWithBlock:^(NSData *imageData, NSError *error) {
                if(!error){
                    //check if image is placeholder
//                    NSData *imageData = imageData; //UIImagePNGRepresentation()
                    if (![placeholderPic isEqual:imageData]) {
                
                        if (!isFirstPicSet) {
                            self.backgroundPic1.image = [UIImage imageWithData:imageData];
                            isFirstPicSet = YES;
                        } else if (!isSecondPicSet) {
                            self.backgroundPic2.image = [UIImage imageWithData:imageData];
                            isSecondPicSet = YES;
                        } else {
                            //both set so will break
                        }
                    }
                }
            }];
        }
    }
}

- (void)didSelectRowInAlertController:(NSInteger)row
{
    // set button text to picker
    NSString *themeLabelPlaceholder = self.themesArr[row];
    self.themeButton.titleLabel.text = themeLabelPlaceholder;
    self.restaurantThemeLabel.text = themeLabelPlaceholder;
    
}
@end
