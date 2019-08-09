//
//  ManagerLoginViewController.m
//  Fresh-Chef-Analytics
//
//  Created by rgallardo on 7/17/19.
//  Copyright © 2019 julia@ipearl.net. All rights reserved.
//

#import "ManagerLoginViewController.h"
#import "Parse/Parse.h"
#import "AppDelegate.h"
#import "LoginViewController.h"

@interface ManagerLoginViewController ()
@property (weak, nonatomic) IBOutlet UITextField *managerPasswordField;

@end

@implementation ManagerLoginViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
- (IBAction)didTapLoginAsManager:(id)sender {
    PFUser *currentUser = [PFUser currentUser];
    NSString *managerPassword = currentUser[@"managerPassword"];
    if([self.managerPasswordField.text isEqualToString: managerPassword]){
//        [self performSegueWithIdentifier:@"managerLoginSegue" sender:nil];
        AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        UINavigationController *navigationController = [storyboard instantiateViewControllerWithIdentifier:@"mainTabs"];
        appDelegate.window.rootViewController = navigationController;
    } else {
        NSLog(@"wrong password");
    }
}
- (IBAction)didTapContinueAsWaiter:(id)sender {
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UINavigationController *navigationController = [storyboard instantiateViewControllerWithIdentifier:@"waiterFlow"];
    appDelegate.window.rootViewController = navigationController;
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
- (IBAction)didTapBackground:(id)sender {
    [self.view endEditing:YES]; //dismiss keyboard
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
