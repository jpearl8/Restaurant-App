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
#import "UIRefs.h"

@interface ManagerLoginViewController ()
@property (strong, nonatomic) IBOutlet UIButton *otherLogin;
@property (weak, nonatomic) IBOutlet UITextField *managerPasswordField;
@property (strong, nonatomic) IBOutlet UIView *passwordView;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *allButtons;
- (IBAction)didTapFullLogin:(id)sender;
@property (strong, nonatomic) IBOutlet UITextField *managerPass;
@property (strong, nonatomic) IBOutlet UIButton *loginButton;
@end

@implementation ManagerLoginViewController
-(void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    [self.otherLogin setFrame:CGRectMake(104.5, 260, 205, 39)];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.otherLogin setFrame:CGRectMake(104.5, 260, 205, 39)];
    self.passwordView.hidden = YES;
    
    for (UIButton *aButton in self.allButtons){
        aButton.layer.borderWidth = .5f;
        aButton.layer.borderColor = [[UIRefs shared] colorFromHexString:[UIRefs shared].purpleAccent].CGColor;
    }

    // Do any additional setup after loading the view.
}
- (IBAction)didTapLoginAsManager:(id)sender {
    self.managerPass.layer.borderWidth = .5f;
    self.managerPass.layer.borderColor = [[UIRefs shared] colorFromHexString:[UIRefs shared].blueHighlight].CGColor;
    self.loginButton.layer.borderWidth = .5f;
    self.loginButton.layer.borderColor = [[UIRefs shared] colorFromHexString:[UIRefs shared].blueHighlight].CGColor;
    self.passwordView.layer.borderWidth = .5f;
    self.passwordView.layer.borderColor = [[UIRefs shared] colorFromHexString:[UIRefs shared].purpleAccent].CGColor;
    [UIView animateWithDuration:.5 animations:^{
        if (self.passwordView.hidden){
            [sender setFrame:CGRectMake(62, 260, 290, 39)];
        } else {
            
            [sender setFrame:CGRectMake(104.5, 260, 205, 39)];
        }
        
        self.passwordView.hidden = !(self.passwordView.hidden);
    }];
    
 
    
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
    [self.passwordView endEditing:YES]; //dismiss keyboard
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)didTapFullLogin:(id)sender {
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
@end
