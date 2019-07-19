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

@end

@implementation MenuListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.menuList.dataSource = self;
    self.menuList.delegate = self;
    self.dishes = [[MenuManager shared] dishes];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dishes.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MenuListTableViewCell *cell = [self.menuList dequeueReusableCellWithIdentifier: @"Dish"];
    Dish *dish =  self.dishes[indexPath.row];
    cell.name.text = dish.name;
    cell.rating.text = [dish.rating stringValue];
    cell.orderFrequency.text = [dish.orderFrequency stringValue];
    cell.type.text = dish.type;
    cell.price.text = [dish.price stringValue];
    PFFileObject *dishImageFile = (PFFileObject *)dish.image;
    [dishImageFile getDataInBackgroundWithBlock:^(NSData *imageData, NSError *error) {
        if(!error){
            cell.image.image = [UIImage imageWithData:imageData];
        }
    }];
    return cell;
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
