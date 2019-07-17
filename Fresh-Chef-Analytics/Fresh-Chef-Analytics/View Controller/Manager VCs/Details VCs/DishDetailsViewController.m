//
//  DishDetailsViewController.m
//  Fresh-Chef-Analytics
//
//  Created by jpearl on 7/16/19.
//  Copyright © 2019 julia@ipearl.net. All rights reserved.
//

#import "DishDetailsViewController.h"

@interface DishDetailsViewController ()
@property (weak, nonatomic) IBOutlet UILabel *dishName;
@property (weak, nonatomic) IBOutlet UIImageView *dishPic;
@property (weak, nonatomic) IBOutlet UILabel *dishDescription;
@property (weak, nonatomic) IBOutlet UILabel *dishRating;
@property (weak, nonatomic) IBOutlet UILabel *dishPrice;
@property (weak, nonatomic) IBOutlet UITableView *dishCommentsTable;

@end

@implementation DishDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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
