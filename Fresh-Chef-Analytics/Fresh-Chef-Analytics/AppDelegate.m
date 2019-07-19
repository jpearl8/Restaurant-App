//
//  AppDelegate.m
//  Fresh-Chef-Analytics
//
//  Created by jpearl on 7/16/19.
//  Copyright © 2019 julia@ipearl.net. All rights reserved.
//

#import "AppDelegate.h"
#import "Parse/Parse.h"
#import "Dish.h"
#import "Waiter.h"
#import "MenuManager.h"
#import "WaiterManager.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(  NSDictionary *)launchOptions {
    
    ParseClientConfiguration *config = [ParseClientConfiguration   configurationWithBlock:^(id<ParseMutableClientConfiguration> configuration) {
        
        configuration.applicationId = @"freshChef";
        configuration.server = @"http://fresh-chef-analytics.herokuapp.com/parse";
    }];
    
    [Parse initializeWithConfiguration:config];
    // Code for persisting user across sessions
    if (PFUser.currentUser) {
    
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        [[MenuManager shared] fetchMenuItems:PFUser.currentUser withCompletion:^(NSMutableDictionary * _Nonnull categoriesOfDishes, NSError * _Nullable error) {
            if (error!=nil)
            {
                NSLog(@"fetched restaurant's data");
            }
        }];        [[WaiterManager shared] fetchWaiters:PFUser.currentUser];
        self.window.rootViewController = [storyboard instantiateViewControllerWithIdentifier:@"ManagerPasswordVCNavigationController"];
    }
    
    // Testing to make sure dishes can be created //
//
//    [Dish postNewDish:@"testing" withType:@"american" withDescription:@"This is a test not a dish." withPrice:@(0) withCompletion:^(BOOL success, NSError *error)
//     {
//         if (success) {
//             NSLog(@"Object saved");
//
//         }
//         else {
//             NSLog(@"Error: %@", error.description);
//         }
//     }];
    
    // Testing to make sure waiter can be created //
//    [Waiter addNewWaiter:@"john" withYears:@(3) withCompletion:^(BOOL succeeded, NSError * _Nullable error) {
//        if (succeeded) {
//            NSLog(@"Waiter saved");
//
//        }
//        else {
//            NSLog(@"Error: %@", error.description);
//        }
//    }];
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
