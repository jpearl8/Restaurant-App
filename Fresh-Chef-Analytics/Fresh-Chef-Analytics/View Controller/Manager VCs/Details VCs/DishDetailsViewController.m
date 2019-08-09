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
#import "UIRefs.h"
@interface DishDetailsViewController ()
@property (weak, nonatomic) IBOutlet UILabel *dishName;
@property (weak, nonatomic) IBOutlet UIImageView *dishPic;
@property (weak, nonatomic) IBOutlet UILabel *dishDescription;
@property (weak, nonatomic) IBOutlet UILabel *dishRating;
@property (weak, nonatomic) IBOutlet UILabel *dishPrice;
@property (weak, nonatomic) IBOutlet UIView *ratingView;
@property (weak, nonatomic) IBOutlet UILabel *dishFrequency;
@property (weak, nonatomic) IBOutlet UILabel *dishProfit;

@property (weak, nonatomic) IBOutlet UITableView *dishCommentsTable;
@property (weak, nonatomic) NSString *ratingCategory;
@property (weak, nonatomic) NSString *freqCategory;
@property (weak, nonatomic) NSString *profitCategory;
@property (weak, nonatomic) IBOutlet UIImageView *ratingImage;
@property (strong, nonatomic) NSArray *ratingImages;
@end

@implementation DishDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.ratingImages = @[@"happy.png", @"meh.png", @"sad.png"];
    NSString *greenGood = [[UIRefs shared] green];
    NSString *redBad = [[UIRefs shared] red];
    self.dishCommentsTable.delegate = self;
    self.dishCommentsTable.dataSource = self;
    self.ratingView.layer.shadowRadius  = 1.5f;
    self.ratingView.layer.shadowColor   = [UIColor colorWithRed:176.f/255.f green:199.f/255.f blue:226.f/255.f alpha:1.f].CGColor;
    self.ratingView.layer.shadowOffset  = CGSizeMake(0.0f, 0.0f);
    self.ratingView.layer.shadowOpacity = 0.9f;
    self.ratingView.layer.masksToBounds = NO;
    
    UIEdgeInsets shadowInsets     = UIEdgeInsetsMake(0, 0, -1.5f, 0);
    UIBezierPath *shadowPath      = [UIBezierPath bezierPathWithRect:UIEdgeInsetsInsetRect(self.ratingView.bounds, shadowInsets)];
    self.ratingView.layer.shadowPath    = shadowPath.CGPath;
    self.ratingCategory = [[MenuManager shared] getRankOfType:@"rating" ForDish:self.dish];
    //    cell.freqCategory = dish.freqCategory;
    self.freqCategory = [[MenuManager shared] getRankOfType:@"freq" ForDish:self.dish];;
    //    cell.profitCategory = dish.profitCategory;
    self.profitCategory = [[MenuManager shared] getRankOfType:@"profit" ForDish:self.dish];
    if ([self.ratingCategory isEqualToString: @"high"]) {
        self.ratingView.backgroundColor = [[UIRefs shared] colorFromHexString:greenGood];
        self.ratingImage.image = [UIImage imageNamed:self.ratingImages[0]];
    } else if ([self.ratingCategory isEqualToString: @"medium"]) {
        self.ratingView.backgroundColor = [UIColor grayColor];
        self.ratingImage.image = [UIImage imageNamed:self.ratingImages[1]];

    } else {
        self.ratingView.backgroundColor = [[UIRefs shared] colorFromHexString:redBad];
        self.ratingImage.image = [UIImage imageNamed:self.ratingImages[2]];

    }
    if ([self.freqCategory isEqualToString: @"high"]) {
        [self.dishFrequency setTextColor:[[UIRefs shared] colorFromHexString:greenGood]];
    } else if ([self.freqCategory isEqualToString: @"medium"]) {
        [self.dishFrequency setTextColor:UIColor.grayColor];
    } else {
        [self.dishFrequency setTextColor:[[UIRefs shared] colorFromHexString:redBad]];
    }
    if ([self.profitCategory isEqualToString: @"high"]) {
        [self.dishProfit setTextColor:[[UIRefs shared] colorFromHexString:greenGood]];
    } else if ([self.profitCategory isEqualToString: @"medium"]) {
        [self.dishProfit setTextColor:UIColor.grayColor];
    } else {
        [self.dishProfit setTextColor:[[UIRefs shared] colorFromHexString:redBad]];
    }
    self.dishName.text = self.dish.name;
    self.dishDescription.text = self.dish.dishDescription;
    self.dishFrequency.text = [NSString stringWithFormat:@"%@", self.dish.orderFrequency];
    self.dishRating.text = [NSString stringWithFormat:@"%@",[[MenuManager shared] averageRating:self.dish]];
    self.dishPrice.text = [@"$" stringByAppendingString: [NSString stringWithFormat:@"%.2f", [self.dish.price floatValue]]];
    self.dishProfit.text = [@"$" stringByAppendingString:[NSString stringWithFormat:@"%.2f", ([self.dish.price floatValue] * [self.dish.orderFrequency floatValue])]];
    PFFileObject *dishImageFile = (PFFileObject *)self.dish.image;
    [dishImageFile getDataInBackgroundWithBlock:^(NSData *imageData, NSError *error) {
        if(!error){
            self.dishPic.image = [UIImage imageWithData:imageData];
        }
    }];
}
- (IBAction)dismiss:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
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
    backgroundView.backgroundColor = [[UIRefs shared] colorFromHexString:@"#fbfaf1"];
    [cell addSubview:backgroundView];
    [cell sendSubviewToBack:backgroundView];
    cell.textLabel.text = [[[NSString stringWithFormat:@"%ld", (indexPath.row+1)] stringByAppendingString:@". "] stringByAppendingString:self.dish.comments[indexPath.row]];
    
    [cell.textLabel setFont:[UIFont systemFontOfSize:15 weight:UIFontWeightThin]];
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
