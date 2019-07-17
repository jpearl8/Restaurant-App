//
//  ProfileViewController.m
//  Fresh-Chef-Analytics
//
//  Created by jpearl on 7/16/19.
//  Copyright © 2019 julia@ipearl.net. All rights reserved.
//

#import "ProfileViewController.h"
#import "Parse/Parse.h"

@interface ProfileViewController ()

@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Set restaurant name, category and price labels
    PFUser *currentUser = [PFUser currentUser];
    self.restaurantNameLabel.text = currentUser[@"username"];
    NSString *category = currentUser[@"category"];
    
    if(category != nil){ self.restaurantCategoryLabel.text = currentUser[@"category"];
    } else {
        self.restaurantCategoryLabel.text = @"Set Restaurant Category";
    }
    NSString *price = currentUser[@"priceRange"];
    if (price != nil) {
        self.restaurantPriceLabel.text = price;
    } else {
        self.restaurantPriceLabel.text = @"Set Restaurant Price Range";
    }
}

- (IBAction)didTapEditMenu:(id)sender {
//    [self performSegueWithIdentifier:@"editMenuSegue" sender:nil];
}

- (IBAction)didTapEditWaiterStaff:(id)sender {
//    [self performSegueWithIdentifier:@"editWaiterStaffSegue" sender:nil];
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
