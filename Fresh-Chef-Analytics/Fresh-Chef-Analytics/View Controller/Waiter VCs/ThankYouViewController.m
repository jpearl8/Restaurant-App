//
//  ThankYouViewController.m
//  Fresh-Chef-Analytics
//
//  Created by jpearl on 7/16/19.
//  Copyright © 2019 julia@ipearl.net. All rights reserved.
//

#import "ThankYouViewController.h"
#import "Parse/Parse.h"

@interface ThankYouViewController ()
@property (weak, nonatomic) IBOutlet UILabel *restaurantName;

@end

@implementation ThankYouViewController

- (void)viewDidLoad {
    PFUser *currentUser = [PFUser currentUser];
    self.restaurantName.text = currentUser.username;
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
- (IBAction)didContinue:(id)sender {
    [self performSegueWithIdentifier:@"toNext" sender:self];
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
