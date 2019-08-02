//
//  EditMenuViewController.m
//  Fresh-Chef-Analytics
//
//  Created by jpearl on 7/16/19.
//  Copyright © 2019 julia@ipearl.net. All rights reserved.
//

#import "EditMenuViewController.h"

@interface EditMenuViewController ()


@end

@implementation EditMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    [self updateLocalFromData];

    // Do any additional setup after loading the view.
}

- (void)editMenuCell:(EditMenuCell *)editMenuCell didTap:(Dish *)dish
{
    [[MenuManager shared] removeDishFromTable:dish withCompletion:^(NSMutableDictionary * _Nonnull categoriesOfDishes, NSError * _Nonnull error) {
        if (error==nil)
        {
            NSLog(@"Step 5");

            NSLog(@"Updating ui");
            self.categoriesOfDishes = categoriesOfDishes;
            self.categories = [self.categoriesOfDishes allKeys];
            
            //[self updateLocalFromData];
            [self.tableView reloadData];
        }
        else
        {
            NSLog(@"%@", error.localizedDescription);
        }
    }];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = indexPath.section;
    EditMenuCell *cell = [tableView dequeueReusableCellWithIdentifier:@"EditMenuCell" forIndexPath:indexPath];
    cell.delegate = self;
    Dish *dish = self.categoriesOfDishes[self.categories[section]][indexPath.row];
    cell.dish = dish;
    cell.dishName.text = dish.name;
    cell.dishType.text = dish.type;
    // set image if the dish has one
    if(dish.image!=nil){
        [dish.image getDataInBackgroundWithBlock:^(NSData *imageData, NSError *error) {
            if(!error){
                cell.dishView.image = [UIImage imageWithData:imageData];
            } else {
                NSLog(@"Error setting cell dish image with error: %@", error.localizedDescription);
            }
        }];
    } else {
        cell.dishView.image = [UIImage imageNamed:@"image_placeholder"];
    }
    cell.dishPrice.text = [NSString stringWithFormat:@"%@", dish.price];
    cell.dishRating.text = [NSString stringWithFormat:@"%@", [[MenuManager shared] averageRating:dish]];
    cell.dishFrequency.text = [NSString stringWithFormat:@"%@", dish.orderFrequency];
    cell.dishDescription.text = dish.dishDescription;
    return cell;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.categoriesOfDishes.count;
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return self.categories[section];
}
- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSLog(@"%lu", (unsigned long)[self.categoriesOfDishes[self.categories[section]] count]);
    return [self.categoriesOfDishes[self.categories[section]] count];
}
- (void) updateLocalFromData
{
    self.categoriesOfDishes = [[MenuManager shared] categoriesOfDishes];
    self.categories = [self.categoriesOfDishes allKeys];
}
// Table View Protocol Methods

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
