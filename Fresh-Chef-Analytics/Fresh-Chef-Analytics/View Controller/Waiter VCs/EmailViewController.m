//
//  EmailViewController.m
//  Fresh-Chef-Analytics
//
//  Created by jpearl on 8/6/19.
//  Copyright © 2019 julia@ipearl.net. All rights reserved.
//
#import "UIRefs.h"
#import "CustomerTrack.h"
#import "Parse/Parse.h"
#import "EmailViewController.h"
#import "WaiterViewController.h"

@interface EmailViewController ()
@property (strong, nonatomic) IBOutlet UIImageView *backgroundIm;
@property (strong, nonatomic) IBOutlet UILabel *restaurantName;
@property (strong, nonatomic) IBOutlet UITextField *emailText;
- (IBAction)barButtonAction:(UIBarButtonItem *)sender;
@property (assign, nonatomic) NSNumber *level;
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *allLabels;

@end

@implementation EmailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    PFUser *currentUser = [PFUser currentUser];
    NSString *category = [PFUser currentUser][@"theme"];
    self.restaurantName.text =  currentUser.username;
    self.emailText.text = self.email;
    [[UIRefs shared] setImage:self.backgroundIm isCustomerForm:YES];
    if ([category isEqualToString:@"Comfortable"]){
        for (UILabel *aLabel in self.allLabels){
            aLabel.textColor = [UIColor whiteColor];
        }
    }
    // Do any additional setup after loading the view.
}






- (IBAction)barButtonAction:(UIBarButtonItem *)sender {
    if ([sender.title isEqualToString:@"Save"]){
        [[CustomerTrack shared] changeCustomer:self.emailText.text withCompletion:^(int level, NSError * _Nullable error) {
            if (!error){
                self.level = [NSNumber numberWithInteger:level];
                [self.customerLevelDelegate changeLevel:self.level withEmail:self.emailText.text];
                [self dismissModalViewControllerAnimated:YES];
            } else {
                NSLog(@"%@", error.localizedDescription);
            }
        }];
    } else {
       // [self.navigationController popViewControllerAnimated:YES];
       [self dismissModalViewControllerAnimated:YES];
    }
}
- (IBAction)onTap:(id)sender {
    [self.view endEditing:(YES)];
}



 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
     WaiterViewController *waitVC = [segue destinationViewController];
     waitVC.customerLevelNumber = self.level;
     waitVC.customerEmail = self.emailText.text;
     NSString *content = @"☆";
     UIColor *starColor;
     [waitVC.customerLevel setTitle:content forState:UIControlStateNormal];
     [waitVC.customerLevel setTitleColor:starColor forState:UIControlStateNormal];
 }

@end
