//
//  WaiterViewController.m
//  
//
//  Created by jpearl on 7/16/19.
//


/* TODO:
get dish items from restaurant table
hookup search bar
pass final array on submit button of data table
 */

#import "YelpAPIManager.h"
#import "WaiterViewController.h"
#import "OrdersViewController.h"

#import "Dish.h"
#import "WaitTableViewCell.h"
#import "Parse/Parse.h"
#import "FunFormViewController.h"
#import "ElegantFormViewController.h"
#import "ComfortableFormViewController.h"
#import "MenuManager.h"
#import "Helpful_funs.h"
#import "Waiter.h"
#import "AppDelegate.h"
#import "LoginViewController.h"
#import "WaiterManager.h"
#import "OpenOrder.h"
#import "OrderManager.h"
#import "EmailViewController.h"
#import "UIRefs.h"


@interface WaiterViewController () <UITableViewDelegate, UITableViewDataSource, StepperCell, CustomerLevelDelegate>

@property (strong, nonatomic) IBOutlet UIView *contentView;

@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UITableView *menuItems;
@property (strong, nonatomic) NSArray <Dish *>*dishes;
@property (strong, nonatomic) NSArray <Waiter *>*waiters;
@property (strong, nonatomic) NSArray <Dish *>*filteredDishes;
@property (nonatomic, strong) UIRefreshControl *refreshControl;
@property (weak, nonatomic) IBOutlet UITextField *customerNumber;
@property (weak, nonatomic) IBOutlet UITextField *tableNumber;
@property (strong, nonatomic) NSMutableArray <Dish *>*orderedDishes;
@property (strong, nonatomic) NSMutableArray <NSNumber *>*amounts;
@property (strong, nonatomic) Waiter *selectedWaiter;
- (IBAction)cancelAction:(UIBarButtonItem *)sender;
@property (strong, nonatomic) IBOutlet UIButton *submitButton;




@property (strong, nonatomic) IBOutlet UIImageView *backgroundImage;







@property (strong, nonatomic) NSMutableDictionary *orderedDishesDict;
@property (strong, nonatomic) NSMutableDictionary *filteredCategoriesOfDishes;
@property (strong, nonatomic) NSArray *categories;
@property (assign, nonatomic) NSInteger selectedIndex;




@end

@implementation WaiterViewController


- (void)viewDidLoad {

    [super viewDidLoad];
    self.navigationItem.hidesBackButton = true;
    self.submitButton.layer.cornerRadius = 10;
    self.customerLevelNumber = [NSNumber numberWithInteger:-1];
    self.customerNumber.text = @"";
    self.tableNumber.text = @"";
    NSString *content = @"☆";
    UIColor *starColor;
    
    if ([self.customerLevelNumber isEqual:[NSNumber numberWithInteger:-1]]){
        starColor = [[UIRefs shared] colorFromHexString:([UIRefs shared].blueHighlight)];
    } else {
        content = @"★";
        if ([self.customerLevelNumber isEqual:[NSNumber numberWithInt:1]]){
            starColor = [[UIRefs shared] colorFromHexString:([UIRefs shared].bronze)];
        } else if ([self.customerLevelNumber isEqual:[NSNumber numberWithInt:2]]){
            starColor = [[UIRefs shared] colorFromHexString:([UIRefs shared].silver)];
        } else {
            starColor = [[UIRefs shared] colorFromHexString:([UIRefs shared].gold)];
        }
    }
    [self.customerLevel setTitle:content forState:UIControlStateNormal];
    [self.customerLevel setTitleColor:starColor forState:UIControlStateNormal];
    self.customerLevel.layer.borderWidth = .5f;
    self.customerLevel.layer.borderColor = [[UIRefs shared] colorFromHexString:@"#2c91fd"].CGColor;
    self.button.layer.borderWidth = 1.f;
    self.button.layer.borderColor = [[UIRefs shared] colorFromHexString:@"#2c91fd"].CGColor;
    self.tableNumber.layer.borderWidth = .5f;
    self.tableNumber.layer.borderColor = [[UIRefs shared] colorFromHexString:@"#2c91fd"].CGColor;
    self.customerNumber.layer.borderWidth = .5f;
    self.customerNumber.layer.borderColor = [[UIRefs shared] colorFromHexString:@"#2c91fd"].CGColor;
    self.contentView.layer.borderWidth = .5f;
    self.contentView.layer.borderColor = [[UIRefs shared] colorFromHexString:[UIRefs shared].purpleAccent].CGColor;
    [[UIRefs shared] setImage:self.backgroundImage isCustomerForm:NO] ;
    self.waiterTable.hidden = YES;
    self.menuItems.delegate = self;
    self.menuItems.dataSource = self;
    [self runWaiterQuery];
    self.waiterTable.delegate = self;
    self.waiterTable.dataSource = self;
    self.searchBar.delegate = self;
    self.orderedDishes = [[NSMutableArray alloc] init];
    self.amounts = [[NSMutableArray alloc] init];
    [self runDishQuery];
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(runDishQuery) forControlEvents:UIControlEventValueChanged];
    [self.menuItems insertSubview:refreshControl atIndex:0];
    self.menuItems.rowHeight = UITableViewAutomaticDimension;
    
    self.selectedIndex = 0;
    self.categories = [[[MenuManager shared] categoriesOfDishes] allKeys];
    self.orderedDishesDict = [[NSMutableDictionary alloc] initWithDictionary:[[MenuManager shared] dishesByAlphabet]];
    self.filteredCategoriesOfDishes = [NSMutableDictionary alloc];
    self.filteredCategoriesOfDishes = [self.filteredCategoriesOfDishes initWithDictionary:self.orderedDishesDict];
}

- (IBAction)selectedWaiter:(UIButton *)sender {
    self.waiterTable.hidden = !(self.waiterTable.hidden);
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([tableView.restorationIdentifier isEqualToString:@"menu"]){
        return [self.filteredCategoriesOfDishes[self.categories[section]] count];
    }
    else {
        return self.waiters.count;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if ([tableView.restorationIdentifier isEqualToString:@"menu"]){
        return self.filteredCategoriesOfDishes.count;
    } else { return 1; }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if ([tableView.restorationIdentifier isEqualToString:@"menu"]){
        return self.categories[section];
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
{
    view.tintColor = [UIColor whiteColor];
    UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *)view;
    UIColor *purple = [[UIRefs shared] colorFromHexString:[UIRefs shared].purpleAccent];
    [header.textLabel setTextColor:purple];
     header.contentView.backgroundColor = [[UIRefs shared] colorFromHexString:@"#EFEFF4"];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([tableView.restorationIdentifier isEqualToString:@"menu"]){
        WaitTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: @"Orders"];
        Dish *dish = self.filteredCategoriesOfDishes[self.categories[indexPath.section]][indexPath.row];
        cell.dish = dish;
        cell.delegate = self;
        cell.name.text = dish.name;
        cell.type.text = dish.type;

        int index = [[Helpful_funs shared] findAmountIndexwithDishArray:self.orderedDishes withDish:dish];
        if (index == -1){
            cell.value = 0;
        } else {
            cell.value = [self.amounts[index] doubleValue];
        }
        cell.dishDescription.text = dish.dishDescription;
        NSString *category = [PFUser currentUser][@"theme"];
        if ([category isEqualToString:@"Comfortable"]){
            cell.type.textColor = [UIColor whiteColor];
        }
        PFFileObject *dishImageFile = (PFFileObject *)dish.image;
        [dishImageFile getDataInBackgroundWithBlock:^(NSData *imageData, NSError *error) {
            if(!error){
                cell.image.image = [UIImage imageWithData:imageData];
            }
        }];
        cell.amount.text = [NSString stringWithFormat:@"%.0f", cell.value];
        return cell;
    }
    else {
        static NSString *simpleTableIdentifier = @"SimpleTableItem";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: simpleTableIdentifier];
        if (cell == nil){
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
        }
        cell.textLabel.text = self.waiters[indexPath.row].name;
        cell.backgroundColor = [UIColor whiteColor];
        return cell;
    }
}



-(void)runDishQuery{
    NSArray <Dish *>*dishes = [[MenuManager shared] dishes];
    if (dishes.count != 0){
        self.dishes = dishes;
        self.filteredDishes = dishes;
        [self.menuItems reloadData];
        [self.refreshControl endRefreshing];
    }
    else {
        [self.refreshControl endRefreshing];
    }
}


-(void)runWaiterQuery{
    NSArray <Waiter *>*waiters = [[WaiterManager shared] roster];;
    if (waiters.count != 0) {
        self.waiters = waiters;
        [self.waiterTable reloadData];
    }
}


- (IBAction)onTap:(id)sender {
    [self.view endEditing:(YES)];
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
        [self.menuItems reloadData];
        
    }
    else {
        self.filteredCategoriesOfDishes = [NSMutableDictionary dictionaryWithDictionary:self.orderedDishesDict];
        [self.menuItems reloadData];
        
    }
}


- (IBAction)didTapLogout:(id)sender {
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    LoginViewController *loginViewController = [storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
    appDelegate.window.rootViewController = loginViewController;
    [PFUser logOutInBackgroundWithBlock:^(NSError * _Nullable error) {

    }];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    if (!([tableView.restorationIdentifier isEqualToString:@"menu"])){
        UITableViewCell *cell = [self.waiterTable cellForRowAtIndexPath:indexPath];
        [self.button setTitle:cell.textLabel.text forState:UIControlStateNormal];
        self.selectedWaiter = self.waiters[indexPath.row];
        self.waiterTable.hidden = YES;
    }
}



-(void)stepperIncrement:(double)amount withDish:(Dish*)dish{
    int index = [[Helpful_funs shared] findAmountIndexwithDishArray:self.orderedDishes withDish:dish];
    if (index == -1){
        [self.orderedDishes addObject:dish];
        [self.amounts addObject:[NSNumber numberWithInt:1]];
    } else {
        self.amounts[index] = [NSNumber numberWithDouble:amount];
    };
}

-(void)changeLevel:(NSNumber *)newLevel withEmail:(nonnull NSString *)email{
    self.customerLevelNumber = newLevel;
    self.customerEmail = email;
    NSString *content = @"★";;
    UIColor *starColor;
     if (!(newLevel) || [newLevel isEqual:[NSNumber numberWithInteger:0]]){
         starColor = [[UIRefs shared] colorFromHexString:([UIRefs shared].blueHighlight)];
     } else {
         if ([newLevel isEqual:[NSNumber numberWithInt:1]]){
             starColor = [[UIRefs shared] colorFromHexString:([UIRefs shared].bronze)];
         } else if ([newLevel isEqual:[NSNumber numberWithInt:2]]){
             starColor = [[UIRefs shared] colorFromHexString:([UIRefs shared].silver)];
         } else {
             starColor = [[UIRefs shared] colorFromHexString:([UIRefs shared].gold)];
         }
     }
    [self.customerLevel setTitle:content forState:UIControlStateNormal];
    [self.customerLevel setTitleColor:starColor forState:UIControlStateNormal];
    
}
- (IBAction)onSubmit:(id)sender{
    NSMutableArray<OpenOrder *>*openOrdersArray = [[NSMutableArray alloc] init];
    if (self.amounts.count == 0 || [[Helpful_funs shared]arrayOfZeros:self.amounts] || self.selectedWaiter == nil || [self.tableNumber.text isEqualToString:@""] || [self.customerNumber.text isEqualToString:@""]){
        NSString *missing;
        if (self.amounts.count == 0 || [[Helpful_funs shared]arrayOfZeros:self.amounts]){
            missing = @"There are no dishes in this order";
        } else if (self.selectedWaiter == nil) {
            missing = @"Please select a waiter";
        } else if ([self.tableNumber.text isEqualToString:@""]){
            missing = @"Please record the table number";
        } else {
            missing = @"Please record the number of customers";
        }
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Missing Order Information" message:missing preferredStyle:(UIAlertControllerStyleAlert)];

        UIAlertAction *tryAgain = [UIAlertAction actionWithTitle:@"OK"
                                                           style:UIAlertActionStyleDefault
                                                         handler:^(UIAlertAction * _Nonnull action) {
    
                                                            
                                                         }];
        [alert addAction:tryAgain];
        [self presentViewController:alert animated:YES completion:^{

    

        }];
    }

    else {
        for (int i = 0; i < self.amounts.count; i++){
            if (self.amounts[i] != [NSNumber numberWithInt:0]){
                OpenOrder *openOrderNew = [OpenOrder new];
                openOrderNew.dish = self.orderedDishes[i];
                openOrderNew.amount = self.amounts[i];
                openOrderNew.waiter = self.selectedWaiter;
                openOrderNew.restaurant = [PFUser currentUser];
                openOrderNew.customerEmail = self.customerEmail;
                NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
                formatter.numberStyle = NSNumberFormatterDecimalStyle;
                openOrderNew.table = [formatter numberFromString:self.tableNumber.text];
                openOrderNew.restaurantId = [PFUser currentUser].objectId;
                openOrderNew.customerNum = [formatter numberFromString:self.customerNumber.text];
                openOrderNew.customerLevel = self.customerLevelNumber;
                [openOrdersArray addObject:openOrderNew];
            }
        }
        [[OrderManager shared] postAllOpenOrders:openOrdersArray withCompletion:^(NSError * _Nonnull error) {
            if (!error){
                [self.vcDelegate callSuperRefresh];
                [self dismissViewControllerAnimated:YES completion:^{
                }];
            } else{
                NSLog(@"%@", error.localizedDescription);
            }
        }];
    }
}
- (IBAction)barButtonSubmit:(UIBarButtonItem *)sender {
    [self onSubmit:self.submitButton];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    EmailViewController *emailVC = [segue destinationViewController];
    emailVC.customerLevelDelegate = self;
    emailVC.email = self.customerEmail;
    
    
}



- (IBAction)cancelAction:(UIBarButtonItem *)sender {
    [self dismissViewControllerAnimated:YES completion:^{
    }];
}


@end
