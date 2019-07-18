//
//  EditMenuViewController.m
//  Fresh-Chef-Analytics
//
//  Created by jpearl on 7/16/19.
//  Copyright © 2019 julia@ipearl.net. All rights reserved.
//

#import "EditMenuViewController.h"
#import "Dish.h"
#import "MenuManager.h"
#import "EditMenuCell.h"

@interface EditMenuViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *dishes;
@property (strong, nonatomic) NSMutableDictionary *categoriesOfDishes;
@property (strong, nonatomic) NSArray *categories;
@end

@implementation EditMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.dishes = [[MenuManager shared] dishes];
    self.categoriesOfDishes = [[MenuManager shared] categoriesOfDishes];
    self.categories = [self.categoriesOfDishes allKeys];

    // Do any additional setup after loading the view.
}
- (IBAction)saveItem:(id)sender {
    Dish * newDish = [Dish postNewDish:self.nameField.text withType:self.typeField.text withDescription:self.descriptionView.text withPrice:[NSNumber numberWithFloat:[self.priceField.text floatValue]] withCompletion:^(BOOL succeeded, NSError * _Nullable error) {
        if (succeeded)
        {
            // Here we should add the table view reload so new value pops up
            NSLog(@"yay");
        }
        else{
            NSLog(@"%@", error.localizedDescription);
        }
    }];
    [self didAddItem:newDish];

}
- (void) didAddItem: (Dish *) dish
{
    NSArray *newMenu = [self.dishes arrayByAddingObject:dish];
    self.dishes = newMenu;
    [self.tableView reloadData];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = indexPath.section;
    EditMenuCell *cell = [tableView dequeueReusableCellWithIdentifier:@"EditMenuCell" forIndexPath:indexPath];
    Dish *dish = self.categoriesOfDishes[ self.categories[section]][indexPath.row];
    cell.dishName.text = dish.name;
    cell.dishType.text = dish.type;
    cell.dishPrice.text = [NSString stringWithFormat:@"%@", dish.price];
    cell.dishRating.text = [NSString stringWithFormat:@"%@", dish.rating];
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
