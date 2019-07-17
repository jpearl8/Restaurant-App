//
//  ManagerLoginViewController.m
//  Fresh-Chef-Analytics
//
//  Created by rgallardo on 7/17/19.
//  Copyright © 2019 julia@ipearl.net. All rights reserved.
//

#import "ManagerLoginViewController.h"
#import "Parse/Parse.h"

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
        [self performSegueWithIdentifier:@"managerLoginSegue" sender:nil];
    } else {
        NSLog(@"wrong password");
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
