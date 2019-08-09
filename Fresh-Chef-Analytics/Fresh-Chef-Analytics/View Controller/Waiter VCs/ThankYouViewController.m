//
//  ThankYouViewController.m
//  Fresh-Chef-Analytics
//
//  Created by jpearl on 7/16/19.
//  Copyright © 2019 julia@ipearl.net. All rights reserved.
//

#import "ThankYouViewController.h"
#import "Parse/Parse.h"
#import "Helpful_funs.h"
#import "UIRefs.h"

@interface ThankYouViewController ()
@property (weak, nonatomic) IBOutlet UILabel *restaurantName;
@property (strong, nonatomic) IBOutlet UIImageView *backgroundIm;
@property (strong, nonatomic) IBOutlet UIButton *button;
@property (strong, nonatomic) IBOutlet UILabel *label;

@end

@implementation ThankYouViewController

- (void)viewDidLoad {
    PFUser *currentUser = [PFUser currentUser];
    self.restaurantName.text = currentUser.username;
    [[UIRefs shared] setImage:self.backgroundIm isCustomerForm:YES];
    self.button.layer.borderWidth = .5f;
    self.button.layer.borderColor = [UIColor blackColor].CGColor;
    NSString *category = [PFUser currentUser][@"theme"];
    if ([category isEqualToString:@"Comfortable"]){
        self.restaurantName.textColor = [UIColor whiteColor];
        self.label.textColor = [UIColor whiteColor];
        
    }
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
