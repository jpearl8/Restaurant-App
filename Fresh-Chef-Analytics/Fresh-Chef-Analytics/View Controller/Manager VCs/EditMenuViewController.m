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
@end

@implementation EditMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.dishes = [[MenuManager shared] dishes];
    // Do any additional setup after loading the view.
}
- (IBAction)saveItem:(id)sender {
    [Dish postNewDish:self.nameField.text withType:self.typeField.text withDescription:self.descriptionView.text withPrice:[NSNumber numberWithFloat:[self.priceField.text floatValue]] withCompletion:^(BOOL succeeded, NSError * _Nullable error) {
        if (succeeded)
        {
            PFUser *restaurant = [PFUser currentUser];
            [[MenuManager shared] fetchMenuItems:restaurant];
            self.dishes = [[MenuManager shared] dishes];

            [self.tableView reloadData];
            // Here we should add the table view reload so new value pops up
            NSLog(@"yay");
        }
        else{
            NSLog(@"%@", error.localizedDescription);
        }
    }];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    EditMenuCell *cell = [tableView dequeueReusableCellWithIdentifier:@"EditMenuCell" forIndexPath:indexPath];
    Dish *dish = self.dishes[indexPath.row];
    cell.dishName.text = dish.name;
    cell.dishType.text = dish.type;
    cell.dishPrice.text = [NSString stringWithFormat:@"%@", dish.price];
    cell.dishRating.text = [NSString stringWithFormat:@"%@", dish.rating];
    cell.dishFrequency.text = [NSString stringWithFormat:@"%@", dish.orderFrequency];
    cell.dishDescription.text = dish.dishDescription;
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dishes.count;
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
