//
//  WaitDetailsViewController.m
//  Fresh-Chef-Analytics
//
//  Created by jpearl on 7/16/19.
//  Copyright © 2019 julia@ipearl.net. All rights reserved.
//

#import "WaitDetailsViewController.h"
#import "WaiterManager.h"

@interface WaitDetailsViewController ()

@end

@implementation WaitDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.waiterName.text = self.waiter.name;
    self.waiterTime.text = [[NSString stringWithFormat:@"%@", self.waiter.yearsWorked] stringByAppendingString:@" years"];
    self.waiterRating.text = [[NSString stringWithFormat:@"%@", [[WaiterManager shared] averageRating:self.waiter]] stringByAppendingString:@" stars"];
    self.waiterTabletops.text  = [[NSString stringWithFormat:@"%@", self.waiter.tableTops] stringByAppendingString:@" tables"];
    self.waiterNumCustomers.text = [[NSString stringWithFormat:@"%@", self.waiter.numOfCustomers] stringByAppendingString:@" customers served"];
    self.waiterTips.text = [[NSString stringWithFormat:@"%@", self.waiter.tipsMade] stringByAppendingString:@" tips made"];
    if(self.waiter.image!=nil){
        [self.waiter.image getDataInBackgroundWithBlock:^(NSData *imageData, NSError *error) {
            if(!error){
                self.waiterProfileImage.image = [UIImage imageWithData:imageData];
            } else {
                NSLog(@"Error setting waiter image with error: %@", error.localizedDescription);
            }
        }];
    } else {
        self.waiterProfileImage.image = nil;
    }
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
