//
//  EmailViewController.m
//  Fresh-Chef-Analytics
//
//  Created by jpearl on 8/6/19.
//  Copyright © 2019 julia@ipearl.net. All rights reserved.
//
#import "UIRefs.h"
#import "CustomerTrack.h"
#import "Parse.h"
#import "EmailViewController.h"
#import "WaiterViewController.h"

@interface EmailViewController ()
@property (strong, nonatomic) IBOutlet UIImageView *backgroundIm;
@property (strong, nonatomic) IBOutlet UILabel *restaurantName;
@property (strong, nonatomic) IBOutlet UITextField *emailText;
- (IBAction)barButtonAction:(UIBarButtonItem *)sender;
@property (assign, nonatomic) NSNumber *level;


@end

@implementation EmailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    PFUser *currentUser = [PFUser currentUser];
    self.restaurantName.text =  currentUser.username;
    [[UIRefs shared] setImage:self.backgroundIm isCustomerForm:YES];
    // Do any additional setup after loading the view.
}






- (IBAction)barButtonAction:(UIBarButtonItem *)sender {
    if ([sender.title isEqualToString:@"Save"]){
        [[CustomerTrack shared] changeCustomer:self.emailText.text withCompletion:^(int level, NSError * _Nullable error) {
            if (!error){
                self.level = [NSNumber numberWithInteger:level];
                [self performSegueWithIdentifier:@"order" sender:self];
            } else {
                NSLog(@"%@", error.localizedDescription);
            }
        }];
    } else {
       // [self.navigationController popViewControllerAnimated:YES];
        [self performSegueWithIdentifier:@"order" sender:self];
    }
}


 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
     WaiterViewController *waitVC = [segue destinationViewController];
     waitVC.customerLevelNumber = self.level;
     waitVC.customerEmail = self.emailText.text;
     NSString *content = @"☆";
     UIColor *starColor;
//     if (!(self.level) || [self.level isEqual:[NSNumber numberWithInteger:0]]){
//         starColor = [[UIRefs shared] colorFromHexString:([UIRefs shared].blueHighlight)];
//     } else {
//         content = @"★";
//         if ([self.level isEqual:[NSNumber numberWithInt:1]]){
//             starColor = [[UIRefs shared] colorFromHexString:([UIRefs shared].bronze)];
//         } else if ([self.level isEqual:[NSNumber numberWithInt:2]]){
//             starColor = [[UIRefs shared] colorFromHexString:([UIRefs shared].silver)];
//         } else {
//             starColor = [[UIRefs shared] colorFromHexString:([UIRefs shared].gold)];
//         }
//     }
     [waitVC.customerLevel setTitle:content forState:UIControlStateNormal];
     [waitVC.customerLevel setTitleColor:starColor forState:UIControlStateNormal];
 }

@end
