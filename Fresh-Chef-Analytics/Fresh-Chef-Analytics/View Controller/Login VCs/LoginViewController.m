//
//  LoginViewController.m
//  Fresh-Chef-Analytics
//
//  Created by rgallardo on 7/16/19.
//  Copyright © 2019 julia@ipearl.net. All rights reserved.
//

#import "LoginViewController.h"
#import "Parse/Parse.h"
#import "Waiter.h"
#import "Dish.h"
#import "MenuManager.h"
#import "WaiterManager.h"
#import "OrderManager.h"
#import "Helpful_funs.h"
#import "UIRefs.h"
@interface LoginViewController ()
@property (strong, nonatomic) IBOutlet UIView *largerView;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *allButtons;
@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.largerView.layer.borderWidth = .5f;
    self.largerView.layer.borderColor = [[UIRefs shared] colorFromHexString:[UIRefs shared].purpleAccent].CGColor;
    for (UIButton *aButton in self.allButtons){
        aButton.layer.borderWidth = .5f;
        aButton.layer.borderColor = [[UIRefs shared] colorFromHexString:[UIRefs shared].purpleAccent].CGColor;
    }
    // Do any additional setup after loading the view.
}



- (IBAction)didTapLogin:(id)sender {
    NSString *username = self.usernameField.text;
    NSString *password = self.passwordField.text;
    [self.view endEditing:YES];
    [PFUser logInWithUsernameInBackground:username password:password block:^(PFUser * user, NSError *  error) {
        if (error != nil) {
            NSLog(@"User log in failed: %@", error.localizedDescription);
        } else {
            NSLog(@"User logged in successfully");
            // display view controller that needs to shown after successful login
            
            [self performSegueWithIdentifier:@"loginSegue" sender:nil];
        }
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
