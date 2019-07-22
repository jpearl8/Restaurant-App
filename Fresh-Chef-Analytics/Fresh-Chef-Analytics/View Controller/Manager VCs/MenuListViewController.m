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
@property (strong, nonatomic) NSMutableDictionary *categoriesOfDishes;
@property (strong, nonatomic) NSMutableDictionary *filteredCategoriesOfDishes;
@property (strong, nonatomic) NSMutableDictionary *shownCategoriesOfDishes;
@property (strong, nonatomic) NSArray *categories;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;

@end

@implementation MenuListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.menuList.dataSource = self;
    self.menuList.delegate = self;
    self.searchBar.delegate = self;
    self.dishes = [[MenuManager shared] dishes];
    self.categoriesOfDishes = [NSMutableDictionary alloc];
    self.categoriesOfDishes = [self.categoriesOfDishes initWithDictionary:[[MenuManager shared] categoriesOfDishes]];
    self.categories = [self.categoriesOfDishes allKeys];
    self.filteredCategoriesOfDishes = [NSMutableDictionary alloc];
    self.filteredCategoriesOfDishes = [self.filteredCategoriesOfDishes initWithDictionary:self.categoriesOfDishes];
    self.shownCategoriesOfDishes = [NSMutableDictionary alloc];
    self.shownCategoriesOfDishes = [self.shownCategoriesOfDishes initWithDictionary:self.categoriesOfDishes];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger section = indexPath.section;
    MenuListTableViewCell *cell = [self.menuList dequeueReusableCellWithIdentifier: @"Dish"];
    Dish *dish = self.shownCategoriesOfDishes[self.categories[section]][indexPath.row];
    cell.name.text = dish.name;
    cell.rating.text = [dish.rating stringValue];
    cell.orderFrequency.text = [dish.orderFrequency stringValue];
    cell.type.text = dish.type;
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
    return self.shownCategoriesOfDishes.count;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return self.categories[section];
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //NSLog(@"%lu", (unsigned long)[self.filteredCategoriesOfDishes[self.categories[section]] count]);
    return [self.shownCategoriesOfDishes[self.categories[section]] count];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    if (searchText.length != 0) {
        NSPredicate *predicate = [NSPredicate predicateWithBlock:^BOOL(NSDictionary *evaluatedObject, NSDictionary *bindings) {
            return [[evaluatedObject[@"name"] lowercaseString] containsString:[searchText lowercaseString]];
        }];
        for (NSString *category in self.categories)
        {
            NSArray *filteredCategory = [[NSArray alloc] init];
            filteredCategory = [NSArray arrayWithArray:self.categoriesOfDishes[category]];
            filteredCategory = [filteredCategory filteredArrayUsingPredicate:predicate];
            [self.filteredCategoriesOfDishes setValue:filteredCategory forKey:category];
            self.shownCategoriesOfDishes = self.filteredCategoriesOfDishes;
        }
        [self.menuList reloadData];

    }
    else {
        self.shownCategoriesOfDishes = self.categoriesOfDishes;
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
