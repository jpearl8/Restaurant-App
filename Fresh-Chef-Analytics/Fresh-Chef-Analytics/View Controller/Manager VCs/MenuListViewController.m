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
@property (strong, nonatomic) NSArray *dishes;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UISegmentedControl *sortByControl;
@property (strong, nonatomic) NSMutableDictionary *orderedDishesDict;
@property (strong, nonatomic) NSMutableDictionary *filteredCategoriesOfDishes;
@property (strong, nonatomic) NSArray *categories;
@property (assign, nonatomic) NSInteger selectedIndex;
@end

@implementation MenuListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.menuList.dataSource = self;
    self.menuList.delegate = self;
    self.searchBar.delegate = self;
    self.dishes = [[MenuManager shared] dishes];
    //setting dictionary elements
    self.categories = [[[MenuManager shared] categoriesOfDishes] allKeys];
    self.orderedDishesDict = [[NSMutableDictionary alloc] initWithDictionary:[[MenuManager shared] categoriesOfDishes]];
    self.filteredCategoriesOfDishes = [NSMutableDictionary alloc];
    self.filteredCategoriesOfDishes = [self.filteredCategoriesOfDishes initWithDictionary:self.orderedDishesDict];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger section = indexPath.section;
    MenuListTableViewCell *cell = [self.menuList dequeueReusableCellWithIdentifier: @"Dish"];
    Dish *dish = self.filteredCategoriesOfDishes[self.categories[section]][indexPath.row];
    cell.dish = dish;
    cell.name.text = dish.name;
//    cell.rating.text = [dish.rating stringValue];
    cell.rating.text = [[NSString stringWithFormat:@"%@", dish.rating] stringByAppendingString:@"/10"];
//    cell.orderFrequency.text = [dish.orderFrequency stringValue];
    cell.orderFrequency.text = [[dish.orderFrequency stringValue] stringByAppendingString:@" sold"];
    cell.price.text = [@"$" stringByAppendingString: [dish.price stringValue]];
    cell.descriptionLabel.text = dish.dishDescription;
    cell.selectedIndex = self.selectedIndex;
    cell.ratingCategory = dish.ratingCategory;
    cell.freqCategory = dish.freqCategory;
    cell.profitCategory = dish.profitCategory;
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
    return self.filteredCategoriesOfDishes.count;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return self.categories[section];
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.filteredCategoriesOfDishes[self.categories[section]] count];
}

- (IBAction)onEditSortBy:(id)sender {
    //refresh table view
    //check which sort button is clicked
    self.selectedIndex = self.sortByControl.selectedSegmentIndex;
    if(self.selectedIndex == 0){
        self.orderedDishesDict = [[MenuManager shared] dishesByFreq];
    } else if (self.selectedIndex == 1) {
        self.orderedDishesDict = [[MenuManager shared] dishesByRating];
    } else if (self.selectedIndex == 2) {
        self.orderedDishesDict = [[MenuManager shared] dishesByPrice];
    } else {
        NSLog(@"no buttons pressed");
    }
    self.filteredCategoriesOfDishes = [NSMutableDictionary dictionaryWithDictionary:self.orderedDishesDict];
    [self.menuList reloadData];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    if (searchText.length != 0) {
        NSPredicate *predicate = [NSPredicate predicateWithBlock:^BOOL(NSDictionary *evaluatedObject, NSDictionary *bindings) {
            return [[evaluatedObject[@"name"] lowercaseString] containsString:[searchText lowercaseString]];
        }];
        for (NSString *category in self.categories)
        {
            NSArray *filteredCategory = [[NSArray alloc] initWithArray:self.orderedDishesDict[category]];
            filteredCategory = [filteredCategory filteredArrayUsingPredicate:predicate];
            [self.filteredCategoriesOfDishes setValue:filteredCategory forKey:category];
        }
        [self.menuList reloadData];

    }
    else {
        self.filteredCategoriesOfDishes = [NSMutableDictionary dictionaryWithDictionary:self.orderedDishesDict];
        [self.menuList reloadData];

    }
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
