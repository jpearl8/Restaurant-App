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
@property (strong, nonatomic) NSArray *categories;
@property (weak, nonatomic) IBOutlet UISegmentedControl *sortByControl;
@property (strong, nonatomic) NSMutableDictionary *orderedDishesDict;

@end

@implementation MenuListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.sortByArray = @[@"Frequency", @"Rating", @"Price"];
    self.menuList.dataSource = self;
    self.menuList.delegate = self;
    self.dishes = [[MenuManager shared] dishes];
    self.orderedDishesDict = [[MenuManager shared] categoriesOfDishes];
    self.categories = [self.orderedDishesDict allKeys];
//    self.orderedDishesDict = [[NSMutableDictionary alloc] initWithDictionary:self.categoriesOfDishes];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger section = indexPath.section;
    MenuListTableViewCell *cell = [self.menuList dequeueReusableCellWithIdentifier: @"Dish"];
    Dish *dish = self.orderedDishesDict[self.categories[section]][indexPath.row];
    //check which sort button is clicked

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
    return self.orderedDishesDict.count;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return self.categories[section];
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.orderedDishesDict[self.categories[section]] count];
}
- (IBAction)onEditSortBy:(id)sender {
    //refresh table view
    NSInteger selectedIndex = self.sortByControl.selectedSegmentIndex;
    if(selectedIndex == 0){
        self.orderedDishesDict = [[MenuManager shared] dishesByFreq];
    } else if (selectedIndex == 1) {
        self.orderedDishesDict = [[MenuManager shared] dishesByRating];
    } else if (selectedIndex == 2) {
        self.orderedDishesDict = [[MenuManager shared] dishesByPrice];
    } else {
        NSLog(@"No button selected??");
    }
    [self.menuList reloadData];
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
