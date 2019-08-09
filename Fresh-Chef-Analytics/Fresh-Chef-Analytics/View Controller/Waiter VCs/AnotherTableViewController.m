//
//  AnotherTableViewController.m
//  Fresh-Chef-Analytics
//
//  Created by jpearl on 7/16/19.
//  Copyright © 2019 julia@ipearl.net. All rights reserved.
//

#import "AnotherTableViewController.h"
#import "Helpful_funs.h"
#import "UIRefs.h"
#import "AppDelegate.h"

@interface AnotherTableViewController ()
@property (strong, nonatomic) IBOutlet UIImageView *background;

@end

@implementation AnotherTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[UIRefs shared] setImage:self.background isCustomerForm:NO];

    // Do any additional setup after loading the view.
}
- (IBAction)didClick:(id)sender {
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UINavigationController *navigationController = [storyboard instantiateViewControllerWithIdentifier:@"waiterFlow"];
    appDelegate.window.rootViewController = navigationController;
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
