//
//  DishDetailsViewController.m
//  Fresh-Chef-Analytics
//
//  Created by jpearl on 7/16/19.
//  Copyright © 2019 julia@ipearl.net. All rights reserved.
//

#import "DishDetailsViewController.h"
#import "Parse/Parse.h"
#import "MenuManager.h"

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
    self.dishCommentsTable.delegate = self;
    self.dishCommentsTable.dataSource = self;
    self.dishName.text = self.dish.name;
    self.dishDescription.text = self.dish.dishDescription;
    
    self.dishRating.text = [[NSString stringWithFormat:@"%@",[[MenuManager shared] averageRating:self.dish]] stringByAppendingString:@"/10"];
    self.dishPrice.text = [@"$" stringByAppendingString: [self.dish.price stringValue]];
    PFFileObject *dishImageFile = (PFFileObject *)self.dish.image;
    [dishImageFile getDataInBackgroundWithBlock:^(NSData *imageData, NSError *error) {
        if(!error){
            self.dishPic.image = [UIImage imageWithData:imageData];
        }
    }];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dish.comments count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: @"SimpleTableView"];
    if (cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"SimpleTableView"];
    }
    UIView *backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 50)];
    backgroundView.backgroundColor = [UIColor colorWithRed:.94 green:.72 blue:.69 alpha:0.8];
    [cell addSubview:backgroundView];
    [cell sendSubviewToBack:backgroundView];
    cell.textLabel.text = self.dish.comments[indexPath.row];
    
    [cell.textLabel setFont:[UIFont systemFontOfSize:21 weight:UIFontWeightThin]];
    return cell;
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
