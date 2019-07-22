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
#import "WaiterViewController.h"
#import "Dish.h"
#import "WaitTableViewCell.h"
#import "order.h"
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


@interface WaiterViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UITableView *menuItems;
@property (strong, nonatomic) NSArray <Dish *>*dishes;
@property (strong, nonatomic) NSArray <Waiter *>*waiters;
@property (strong, nonatomic) NSArray <Dish *>*filteredDishes;
@property (strong, nonatomic) NSMutableArray <order *>*customerOrder;
@property (nonatomic, strong) UIRefreshControl *refreshControl;
@property (weak, nonatomic) IBOutlet UITextField *customerNumber;

@property (strong, nonatomic) Waiter* waiter;


@end

@implementation WaiterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.menuItems.delegate = self;
    self.menuItems.dataSource = self;
    [self runWaiterQuery];
    self.waiterTable.delegate = self;
    self.waiterTable.dataSource = self;
    self.searchBar.delegate = self;
    self.customerOrder = [[NSMutableArray alloc] init];
    [self runDishQuery];
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(runDishQuery) forControlEvents:UIControlEventValueChanged];
    [self.menuItems insertSubview:refreshControl atIndex:0];
    self.menuItems.rowHeight = UITableViewAutomaticDimension;
    // construct query
   
    
    
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([tableView.restorationIdentifier isEqualToString:@"menu"]){
        return self.filteredDishes.count;
    }
    else {
        return self.waiters.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([tableView.restorationIdentifier isEqualToString:@"menu"]){
        WaitTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: @"Orders"];
        Dish *dish = self.filteredDishes[indexPath.row];
        cell.dish = dish;
        cell.name.text = dish.name;
        cell.type.text = dish.type;
        cell.stepper.dish = dish;
        cell.stepper.value = [self searchForAmount:self.customerOrder withDish:dish];
        cell.dishDescription.text = dish.dishDescription;
        PFFileObject *dishImageFile = (PFFileObject *)dish.image;
        [dishImageFile getDataInBackgroundWithBlock:^(NSData *imageData, NSError *error) {
            if(!error){
                cell.image.image = [UIImage imageWithData:imageData];
            }
        }];
        cell.amount.text = [NSString stringWithFormat:@"%.0f", cell.stepper.value];
        return cell;
    }
    else {
        static NSString *simpleTableIdentifier = @"SimpleTableItem";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: simpleTableIdentifier];
        if (cell == nil){
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
        }
        cell.textLabel.text = self.waiters[indexPath.row].name;
        cell.backgroundColor =  [[Helpful_funs shared] colorFromHexString:@"#ADD8E6"];
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


- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    if (searchText.length != 0) {
        NSPredicate *predicate = [NSPredicate predicateWithBlock:^BOOL(NSDictionary *evaluatedObject, NSDictionary *bindings) {
            return [evaluatedObject[@"name"] containsString:searchText];
        }];
        self.filteredDishes = [self.dishes filteredArrayUsingPredicate:predicate];
    }
    else {
        self.filteredDishes = self.dishes;
    }
    [self.menuItems reloadData];
}

- (IBAction)onSubmit:(id)sender{
    if (self.customerOrder.count != 0){
        NSLog(@"SUBMIT");
        NSLog(@"%.f", self.customerOrder.count);
        for (order *order in self.customerOrder)
        {
            NSLog(@"%@", order.dish.name);
            NSLog(@"%.f", order.amount);
        }
        NSString *category = [PFUser currentUser][@"theme"];
        
        [self performSegueWithIdentifier:category sender:self];
    }
}

- (IBAction)didTapLogout:(id)sender {
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    LoginViewController *loginViewController = [storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
    appDelegate.window.rootViewController = loginViewController;
    [PFUser logOutInBackgroundWithBlock:^(NSError * _Nullable error) {
        // PFUser.current() will now be nil
    }];
}


- (IBAction)stepperChange:(specialStepper *)sender {
    double orderAmount = [self searchForAmount:self.customerOrder withDish:sender.dish];
    order *newOrder = [order makeOrderItem:sender.dish withAmount:sender.value];
    if (orderAmount == 0.0){
        [self.customerOrder addObject:newOrder];
    } else {
        for (int i = 0; i < self.customerOrder.count; i++){
            if ([self.customerOrder[i].dish.name isEqualToString:sender.dish.name]){
                self.customerOrder[i] = newOrder;
                break;
            }
        }
    }
}





-(double )searchForAmount:(NSArray<order *> *)orderList withDish:(Dish *)dish{
    for (order *item in orderList){
        if ([item.dish.name isEqualToString:dish.name]){
            return item.amount;
        }
    }
    return 0;
}




- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
     NSString *category = [PFUser currentUser][@"theme"];

    
    if ([category isEqualToString:@"Fun"]){
        FunFormViewController *funVC = [segue destinationViewController];
        funVC.customerOrder = self.customerOrder;
        funVC.customerOrder[0].waiter = self.waiter;
        funVC.customerNumber = self.customerNumber.text;
    }
    if ([category isEqualToString:@"Comfortable"]){
        ComfortableFormViewController *comfVC = [segue destinationViewController];
        comfVC.customerOrder = self.customerOrder;
        comfVC.customerOrder[0].waiter = self.waiter;
        comfVC.customerNumber = self.customerNumber.text;
    }
    if ([category isEqualToString:@"Elegant"]){
        ElegantFormViewController *elegantVC = [segue destinationViewController];
        elegantVC.customerOrder = self.customerOrder;
        elegantVC.customerOrder[0].waiter = self.waiter;
        elegantVC.customerNumber = self.customerNumber.text;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    if (!([tableView.restorationIdentifier isEqualToString:@"menu"])){
        UITableViewCell *cell = [self.waiterTable cellForRowAtIndexPath:indexPath];
        [self.button setTitle:cell.textLabel.text forState:UIControlStateNormal];
        self.waiter = self.waiters[indexPath.row];
        self.waiterTable.hidden = YES;
    }
}
- (IBAction)selectedWaiter:(UIButton *)sender {
    self.waiterTable.hidden = !(self.waiterTable.hidden);
}




@end
