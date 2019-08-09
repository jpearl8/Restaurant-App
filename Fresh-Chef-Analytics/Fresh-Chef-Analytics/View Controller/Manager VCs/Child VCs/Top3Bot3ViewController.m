//
//  Top3Bot3ViewController.m
//  Fresh-Chef-Analytics
//
//  Created by selinons on 7/22/19.
//  Copyright © 2019 julia@ipearl.net. All rights reserved.
//

#import "Top3Bot3ViewController.h"
#import "Top3Bottom3TableViewCell.h"
#import "MenuManager.h"
#import "MKDropdownMenu.h"
#import "UIRefs.h"

@interface Top3Bot3ViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableDictionary *top3Bottom3Freq;
@property (strong, nonatomic) NSMutableDictionary *top3Bottom3Rating;
@property (strong, nonatomic) NSMutableDictionary *top3Bottom3Selected;
@property (strong, nonatomic) NSArray *categories;
@property (weak, nonatomic) IBOutlet UISegmentedControl *rankByControl;


@end

@implementation Top3Bot3ViewController {
    NSIndexPath *selectedIndexPath;
    int regularHeight;
    int expandedHeight;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.rankByControl.tintColor = [[UIRefs shared] colorFromHexString:[UIRefs shared].purpleAccent];
    [[UISegmentedControl appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]} forState:UIControlStateSelected];
    self.top3Bottom3Freq = [[MenuManager shared] top3Bottom3Freq];
    self.top3Bottom3Rating = [[MenuManager shared] top3Bottom3Rating];
    self.top3Bottom3Selected = [[NSMutableDictionary alloc] initWithDictionary: self.top3Bottom3Freq];
    self.categories = [self.top3Bottom3Selected allKeys];
    regularHeight = (self.view.frame.size.height - self.rankByControl.frame.size.height - 40)/6;
    expandedHeight = 300;
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    NSInteger section = indexPath.section;
    Top3Bottom3TableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier: @"T3B3Dish"];
    Dish *dish = self.top3Bottom3Selected[self.categories[section]][indexPath.row];
//    cell.selectedIndex = self.selectedIndex; //for toggling between frequency and rating
    cell.dish = dish;
    cell.name.text = dish.name;
    cell.rating.text = [NSString stringWithFormat:@"%@", [[MenuManager shared] averageRating:dish]];
    cell.frequency.text = [[NSString stringWithFormat:@"%@", dish.orderFrequency] stringByAppendingString:@" orders"];
    cell.price.text = [@"Price: $"  stringByAppendingString:[NSString stringWithFormat:@"%.2f", [dish.price floatValue]]];

    cell.profit.text = [@"Profit: $" stringByAppendingString:[dish.profit stringValue]];
    cell.ratingCategory = [[MenuManager shared] getRankOfType:@"rating" ForDish:dish];
    cell.freqCategory = [[MenuManager shared] getRankOfType:@"freq" ForDish:dish];;
    cell.profitCategory = [[MenuManager shared] getRankOfType:@"profit" ForDish:dish];
    cell.suggestionsLabel.text = dish.suggestions;
    cell.selectedIndex = self.rankByControl.selectedSegmentIndex;
    if(dish.image != nil){
        PFFileObject *dishImageFile = (PFFileObject *)dish.image;
        [dishImageFile getDataInBackgroundWithBlock:^(NSData *imageData, NSError *error) {
            if(!error){
                cell.image.image = [UIImage imageWithData:imageData];
            }
        }];
    } else {
        cell.image.image = [UIImage imageNamed:@"image_placeholder"];
    }
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.top3Bottom3Selected.count;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return self.categories[section];
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.top3Bottom3Selected [self.categories[section]] count];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Top3Bottom3TableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    selectedIndexPath = indexPath;
    if(cell.isExpanded){
        cell.isExpanded = NO;
        [UIView animateWithDuration:0.4 animations:^{
            cell.arrow.transform = CGAffineTransformMakeRotation((0.0 * M_PI) / 180.0);
        }];
        cell.showMore.hidden = NO;
    } else {
        cell.isExpanded = YES;
        [UIView animateWithDuration:0.4 animations:^{

            cell.arrow.transform = CGAffineTransformMakeRotation((180.0 * M_PI) / 180.0);
        }];
        cell.showMore.hidden = YES;
    }
    
    //update cell to reflect new state
    [self.tableView beginUpdates];
    [self.tableView endUpdates];
    [self.tableView scrollToRowAtIndexPath:indexPath
                         atScrollPosition:UITableViewScrollPositionTop
                                 animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Top3Bottom3TableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    if([indexPath compare:selectedIndexPath] == NSOrderedSame){
        if(cell.isExpanded){
            return expandedHeight;
        } else {
            return (self.view.frame.size.height - self.rankByControl.frame.size.height - 85)/6;;
        }
    } else {
        cell.isExpanded = NO; //when another cell is clicked unexpand opened cell
        return (self.view.frame.size.height - self.rankByControl.frame.size.height - 85)/6;;
    }
}

- (IBAction)onEditRankBy:(id)sender {
    if(self.rankByControl.selectedSegmentIndex == 0){
        self.top3Bottom3Selected = self.top3Bottom3Freq;
    } else {
        self.top3Bottom3Selected = self.top3Bottom3Rating;
    }
    [self.tableView reloadData];
}

@end
