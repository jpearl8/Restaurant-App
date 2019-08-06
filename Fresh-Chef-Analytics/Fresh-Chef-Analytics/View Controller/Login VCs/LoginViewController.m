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
@interface LoginViewController ()

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)loginUser {
    NSString *username = self.usernameField.text;
    NSString *password = self.passwordField.text;
      
    [PFUser logInWithUsernameInBackground:username password:password block:^(PFUser * user, NSError *  error) {
        if (error != nil) {
            NSLog(@"User log in failed: %@", error.localizedDescription);
        } else {
            NSLog(@"User logged in successfully");
            // display view controller that needs to shown after successful login
            user[@"types"] = [[NSArray alloc] init];
            [[MenuManager shared] fetchMenuItems:user withCompletion:^(NSMutableDictionary * _Nonnull categoriesOfDishes, NSError * _Nullable error) {
                if (!error)
                {
//                    [[OrderManager shared] fetchClosedOrderItems:user withCompletion:^(NSArray * _Nonnull closedOrders, NSError * _Nonnull error) {
//                        if (!error)
//                        {
//                            NSLog(@"fetched restaurant's closed orders");
//                        }
//                    }];
                    [[MenuManager shared] setOrderedDicts];
                    [[MenuManager shared] setTop3Bottom3Dict];
                    NSLog(@"fetched restaurant's menu");
                }
            }];
            [[WaiterManager shared] fetchWaiters:user withCompletion:^(NSError * _Nullable error) {
                if(!error)
                {
                    [[WaiterManager shared] setOrderedWaiterArrays];
                    NSLog(@"fetched restaurant's waiters");
                }
            }];
//            [[OrderManager shared] fetchOpenOrderItems:user withCompletion:^(NSArray * _Nonnull openOrders, NSError * _Nonnull error) {
//                if (!error)
//                {
//                    NSLog(@"fetched restaurant's open orders");
//                }
//            }];
            /* ********** Moved fetchClosedOrderItems to inside fetchMenu completion
                            block because getDish method for calculating profit needs dishes
             ***************/ // Switched back because wasn't working still
            
            
            [[OrderManager shared] fetchClosedOrderItems:user withCompletion:^(NSArray * _Nonnull closedOrders, NSError * _Nonnull error) {
                if (!error)
                {
                    NSLog(@"fetched restaurant's closed orders");
                }
            }];
            // Testing to make sure dishes can be created //
            //
//                [Dish postNewDish:@"testing" withType:@"american" withDescription:@"This is a test not a dish." withPrice:@(0) withCompletion:^(BOOL success, NSError *error)
//                 {
//                     if (success) {
//                         NSLog(@"Object saved");
//
//                     }
//                     else {
//                         NSLog(@"Error: %@", error.description);
//                     }
//                 }];
//
//            // Testing to make sure waiter can be created //
//                [Waiter addNewWaiter:@"john" withYears:@(3) withCompletion:^(BOOL succeeded, NSError * _Nullable error) {
//                    if (succeeded) {
//                        NSLog(@"Waiter saved");
//
//                    }
//                    else {
//                        NSLog(@"Error: %@", error.description);
//                    }
//                }];


            [self performSegueWithIdentifier:@"loginSegue" sender:nil];
        }
    }];
}

- (IBAction)didTapLogin:(id)sender {
    [self loginUser];
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
