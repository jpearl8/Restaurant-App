//
//  MenuListViewController.m
//  Fresh-Chef-Analytics
//
//  Created by jpearl on 7/16/19.
//  Copyright © 2019 julia@ipearl.net. All rights reserved.
//

#import "MenuListViewController.h"
#import "MenuListTableViewCell.h"
#import "Parse/Parse.h"
#import "DishDetailsViewController.h"
#import "MenuManager.h"

@interface MenuListViewController () 
@property (weak, nonatomic) IBOutlet UITableView *menuList;
@property (nonatomic, strong) UIRefreshControl *refreshControl;
@property (strong, nonatomic) NSArray<Dish *> *dishes;
@property (strong, nonatomic) NSMutableDictionary *categoriesOfDishes;
@property (strong, nonatomic) NSArray *categories;
@property (weak, nonatomic) IBOutlet UISegmentedControl *sortByControl;
//@property (strong, nonatomic) NSArray *sortByArray;

@end

@implementation MenuListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.sortByArray = @[@"Frequency", @"Rating", @"Price"];
    self.menuList.dataSource = self;
    self.menuList.delegate = self;
    self.dishes = [[MenuManager shared] dishes];
    self.categoriesOfDishes = [[MenuManager shared] categoriesOfDishes];
    self.categories = [self.categoriesOfDishes allKeys];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger section = indexPath.section;
    MenuListTableViewCell *cell = [self.menuList dequeueReusableCellWithIdentifier: @"Dish"];
    //check which sort button is clicked
//    if(self.sortByControl){
    Dish *dish = self.categoriesOfDishes[self.categories[section]][indexPath.row];
//    } else if (self.sortByControl)
    cell.name.text = dish.name;
    cell.rating.text = [dish.rating stringValue];
    cell.orderFrequency.text = [dish.orderFrequency stringValue];
    cell.price.text = [dish.price stringValue];
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
    return self.categoriesOfDishes.count;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return self.categories[section];
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSLog(@"%lu", (unsigned long)[self.categoriesOfDishes[self.categories[section]] count]);
    return [self.categoriesOfDishes[self.categories[section]] count];
}
- (IBAction)onEditSortBy:(id)sender {
//    NSString *sortBy = self.sortByArray[self.sortByControl.selectedSegmentIndex];
//
//
//
//
//
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([sender isKindOfClass:MenuListTableViewCell.class]){
        MenuListTableViewCell *tappedCell = sender;
        NSIndexPath *indexPath = [self.menuList indexPathForCell:tappedCell];
        if (indexPath.row >= 0){
            Dish *dish = self.dishes[indexPath.row];
            DishDetailsViewController *dishDetailsVC = [segue destinationViewController];
            dishDetailsVC.dish = dish;
        }
    }
}


@end
