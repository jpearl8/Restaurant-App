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
    
    [self updateLocalFromData];

    // Do any additional setup after loading the view.
}
- (IBAction)saveItem:(id)sender {
    Dish * newDish = [Dish postNewDish:self.nameField.text withType:self.typeField.text withDescription:self.descriptionView.text withPrice:[NSNumber numberWithFloat:[self.priceField.text floatValue]] withImage:self.dishView.image withCompletion:^(BOOL succeeded, NSError * _Nullable error) {
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

- (IBAction)didTapDishImage:(id)sender {
    NSLog(@"tapped camera image");
    UIImagePickerController *imagePickerVC = [UIImagePickerController new];
    imagePickerVC.delegate = self;
    imagePickerVC.allowsEditing = YES;
    // if camera is available, use it, else, use camera roll
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        imagePickerVC.sourceType = UIImagePickerControllerSourceTypeCamera;
    }
    else {
        NSLog(@"Camera 🚫 available so we will use photo library instead");
        imagePickerVC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    [self presentViewController:imagePickerVC animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    // Get the image captured by the UIImagePickerController
    UIImage *editedImage = info[UIImagePickerControllerEditedImage];
    self.dishView.image = editedImage;
    // Dismiss UIImagePickerController to go back to original view controller
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void) didAddItem: (Dish *) dish
{
    NSArray *dishesOfType;
    [[MenuManager shared] addDishToDict:dish toArray:dishesOfType];
    self.categories = [self.categories arrayByAddingObject:dish.type];
    [self.tableView reloadData];
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
        cell.dishView.image = nil;
    }
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
