//
//  AnotherTableViewController.m
//  Fresh-Chef-Analytics
//
//  Created by jpearl on 7/16/19.
//  Copyright © 2019 julia@ipearl.net. All rights reserved.
//

#import "AnotherTableViewController.h"
#import "Helpful_funs.h"
@interface AnotherTableViewController ()
@property (strong, nonatomic) IBOutlet UIImageView *background;

@end

@implementation AnotherTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[Helpful_funs shared] setImages:self.background top:[NSNull null] waiterView:YES];
    // Do any additional setup after loading the view.
}
- (IBAction)didClick:(id)sender {
    [self performSegueWithIdentifier:@"toBeginning" sender:self];
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
