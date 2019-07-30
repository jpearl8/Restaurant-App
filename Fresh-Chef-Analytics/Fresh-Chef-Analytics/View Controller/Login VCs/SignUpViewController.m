//
//  SignUpViewController.m
//  Fresh-Chef-Analytics
//
//  Created by rgallardo on 7/16/19.
//  Copyright © 2019 julia@ipearl.net. All rights reserved.
//

#import "SignUpViewController.h"
#import "Parse/Parse.h"
#import "AppDelegate.h"
#import "MenuManager.h"

@interface SignUpViewController ()

@end

@implementation SignUpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
}

- (void)registerUser {
    // initialize a user object
    PFUser *newUser = [PFUser user];
    // set user properties
    newUser.username = self.usernameField.text;
    newUser.password = self.passwordField.text;
    newUser[@"email"] = self.emailField.text;
    newUser[@"managerPassword"] = self.managerPasswordField.text;
    // if all fields are filled, call sign up function on the object
    if(![newUser.username  isEqual: @""] && ![newUser.password  isEqual: @""] && ![newUser[@"email"]  isEqual: @""] && ![newUser[@"managerPassword"]  isEqual: @""]) {
        [newUser signUpInBackgroundWithBlock:^(BOOL succeeded, NSError * error) {
            if (error != nil) {
                NSLog(@"Error: %@", error.localizedDescription);
            } else {
                
                NSLog(@"User registered successfully");
                AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
                UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                UINavigationController *navigationController = [storyboard instantiateViewControllerWithIdentifier:@"mainTabs"];
                appDelegate.window.rootViewController = navigationController;
            }
        }];
    } else {
        // alert user that they need to fill out all fields
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Incomplete Fields"
                                                                       message:@"Please fill out every field to sign up"
                                                                preferredStyle:(UIAlertControllerStyleAlert)];
        
        // create an OK action
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK"
                                                           style:UIAlertActionStyleDefault
                                                         handler:^(UIAlertAction * _Nonnull action) {
                                                             // handle response here.
                                                         }];
        // add the OK action to the alert controller
        [alert addAction:okAction];
        [self presentViewController:alert animated:YES completion:^{
            // optional code for what happens after the alert controller has finished presenting
        }];
    }
}

- (IBAction)didTapSignUp:(id)sender {
    [self registerUser];
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
