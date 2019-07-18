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

@interface WaiterViewController () <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UITableView *menuItems;
@property (strong, nonatomic) NSArray <Dish *>*dishes;
@property (strong, nonatomic) NSArray <Dish *>*filteredDishes;
@property (strong, nonatomic) NSMutableArray <order *>*customerOrder;
@property (nonatomic, strong) UIRefreshControl *refreshControl;
@property (weak, nonatomic) IBOutlet UITextField *waiterName;
@property (weak, nonatomic) IBOutlet UILabel *customerNumber;


@end

@implementation WaiterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.menuItems.delegate = self;
    self.menuItems.dataSource = self;
    self.searchBar.delegate = self;
    self.customerOrder = [[NSMutableArray alloc] init];;
    // Do any additional setup after loading the view.
    
    [self runDishQuery];
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(runDishQuery) forControlEvents:UIControlEventValueChanged];
    [self.menuItems insertSubview:refreshControl atIndex:0];
    self.menuItems.rowHeight = UITableViewAutomaticDimension;
    // construct query
   
    
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.filteredDishes.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
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


-(void)runDishQuery{
    PFQuery *dishQuery = [Dish query];
    [dishQuery includeKey:@"restaurantID"];
    // id test = [PFUser currentUser].objectId;
    NSString *test = @"XuLMO3Jh3r";
    [dishQuery whereKey:@"restaurantID" containsString:test];
    // fetch data asynchronously
    [dishQuery findObjectsInBackgroundWithBlock:^(NSArray<Dish *> * _Nullable dishes, NSError * _Nullable error) {
        if (error){
            NSLog(@"%@", error);
        }
        if (dishes.count != 0) {
            // do something with the data fetched
            self.dishes = dishes;
            self.filteredDishes = dishes;
            [self.menuItems reloadData];
            [self.refreshControl endRefreshing];
        }
        else {
            [self.refreshControl endRefreshing];
        }
    }];
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
    NSLog(@"SUBMIT");
    NSLog(@"%.f", self.customerOrder.count);
    for (order *order in self.customerOrder)
    {
       // UILabel *labelF = [cell name];
        NSLog(@"%@", order.dish.name);
        NSLog(@"%.f", order.amount);
    }
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
    // id test = [PFUser currentUser].theme;
    NSString *category = @"Fun";
    if ([category isEqualToString:@"Fun"]){
        FunFormViewController *funVC = [segue destinationViewController];
        funVC.customerOrder = self.customerOrder;
        funVC.waiterName = self.waiterName.text;
        funVC.customerNumber = self.customerNumber.text;
    }
    if ([category isEqualToString:@"Comfortable"]){
        ComfortableFormViewController *comfVC = [segue destinationViewController];
        comfVC.customerOrder = self.customerOrder;
        comfVC.waiterName = self.waiterName.text;
        comfVC.customerNumber = self.customerNumber.text;
    }
    if ([category isEqualToString:@"Elegant"]){
        ElegantFormViewController *elegantVC = [segue destinationViewController];
        elegantVC.customerOrder = self.customerOrder;
        elegantVC.waiterName = self.waiterName.text;
        elegantVC.customerNumber = self.customerNumber.text;
    }
}


@end
