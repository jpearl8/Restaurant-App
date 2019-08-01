//
//  EditOrderViewController.m
//  Fresh-Chef-Analytics
//
//  Created by rgallardo on 7/24/19.
//  Copyright © 2019 julia@ipearl.net. All rights reserved.
//

#import "EditOrderViewController.h"
#import "EditOrderViewCell.h"
#import "WaitTableViewCell.h"
#import "Helpful_funs.h"
#import "MenuManager.h"
#import "OrderManager.h"
#import "WaiterManager.h"
#import "AddItemViewController.h"

@interface EditOrderViewController () <UITableViewDelegate, UITableViewDataSource, AddOrdersDelegate>

@property (strong, nonatomic) IBOutlet UIButton *waiterSelected;
@property (strong, nonatomic) IBOutlet UITableView *waiterTable;
- (IBAction)selectedWaiter:(UIButton *)sender;

@property (strong, nonatomic) IBOutlet UITextField *tableNumber;
@property (strong, nonatomic) IBOutlet UITextField *customerNumber;

@property (strong, nonatomic) IBOutlet UITableView *ordersTable;
- (IBAction)addNewItem:(UIButton *)sender;

@property (strong, nonatomic) NSMutableArray <NSString*>*dishNames;

@property (strong, nonatomic) NSArray <Waiter *>*waiters;

- (IBAction)hitSave:(UIBarButtonItem *)sender;
- (IBAction)hitCancel:(UIBarButtonItem *)sender;
- (IBAction)hitDelete:(UIButton *)sender;

@end

@implementation EditOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dishNames = [[NSMutableArray alloc] init];
    [self fillCellArrays:self.openOrders];
    if (self.openOrders.count > 0){
        self.tableNumber.text = [NSString stringWithFormat:@"%@", self.openOrders[0][@"table"]];
        self.customerNumber.text = [NSString stringWithFormat:@"%@", self.openOrders[0][@"customerNum"]];
        [self.waiterSelected setTitle:self.waiter.name forState:UIControlStateNormal];
    }
    self.waiterTable.hidden = YES;
    ;
    [self runWaiterQuery];
    self.waiterTable.delegate = self;
    self.waiterTable.dataSource = self;
    self.ordersTable.delegate = self;
    self.ordersTable.dataSource = self;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([tableView.restorationIdentifier isEqualToString:@"Orders"]){
        return self.openOrders.count;
    } else {
        return self.waiters.count;
    }
}




- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([tableView.restorationIdentifier isEqualToString:@"Orders"]){
        EditOrderViewCell *cell = [tableView dequeueReusableCellWithIdentifier: @"EditOrder"];
        cell.dishName.text = self.dishNames[indexPath.row];
        cell.delegate = self;
        cell.amount.text = [NSString stringWithFormat:@"%@", self.openOrders[indexPath.row][@"amount"]];
        cell.index = (int)indexPath.row;
        return cell;
    } else {
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

//-(void)runDishQuery{
//    NSArray <Dish *>*dishes = [[MenuManager shared] dishes];
//    if (dishes.count != 0){
//        self.allDishes = dishes;
//        self.filteredDishes = dishes;
//        [self.ordersTableView reloadData];
//        [self.refreshControl endRefreshing];
//    }
//    else {
//        [self.refreshControl endRefreshing];
//    }
//}


-(void)runWaiterQuery{
    NSArray <Waiter *>*waiters = [[WaiterManager shared] roster];;
    if (waiters.count != 0) {
        self.waiters = waiters;
        [self.waiterTable reloadData];
    }
}
//- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
//    if (searchText.length != 0) {
//        NSPredicate *predicate = [NSPredicate predicateWithBlock:^BOOL(NSDictionary *evaluatedObject, NSDictionary *bindings) {
//            return [evaluatedObject[@"name"] containsString:searchText];
//        }];
//        self.filteredDishes = [self.allDishes filteredArrayUsingPredicate:predicate];
//    }
//    else {
//        self.filteredDishes = self.allDishes;
//    }
//    [self.ordersTableView reloadData];
//}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    if (!([tableView.restorationIdentifier isEqualToString:@"menu"])){
        UITableViewCell *cell = [self.waiterTable cellForRowAtIndexPath:indexPath];
        [self.waiterSelected setTitle:cell.textLabel.text forState:UIControlStateNormal];
        self.waiter = self.waiters[indexPath.row];
        self.waiterTable.hidden = YES;
    }
}

-(void)fillCellArrays:(NSArray<OpenOrder *>*)openOrders {
    NSArray<Dish*>*dishArray = [[NSArray alloc] init];
    dishArray = [[MenuManager shared] dishes];
    NSLog(@"%@", dishArray);
    for (int i = 0; i < openOrders.count; i++){
        for (int j = 0; j < dishArray.count; j++)
        {
            NSLog(@"%@", openOrders[i]);
            NSLog(@"%@", ((Dish*)openOrders[i].dish).objectId);
            if ([((Dish *)dishArray[j]).objectId isEqualToString:((Dish*)openOrders[i].dish).objectId]){
                [self.dishNames addObject:((Dish *)dishArray[j]).name];
            }
        }
    }
}




- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    AddItemViewController *addVC = [segue destinationViewController];
    addVC.delegate = self;
    addVC.delegate.waiter = self.waiter;
    if (self.openOrders.count > 0){
        addVC.delegate.table = self.openOrders[0][@"table"];
        addVC.delegate.customerNum = self.openOrders[0][@"customerNum"];
    }
}


//- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
//    <#code#>
//}
//
//- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    <#code#>
//}

-(void)addOpenOrders:(NSMutableArray<OpenOrder *> *)additionalOrders{
    NSMutableArray *openOrdersMutable = [self.openOrders mutableCopy];
    [openOrdersMutable addObjectsFromArray: additionalOrders];
    self.openOrders = [openOrdersMutable copy];
}

- (IBAction)hitSave:(UIBarButtonItem *)sender {
}

- (IBAction)hitCancel:(UIBarButtonItem *)sender {
}

- (IBAction)hitDelete:(UIButton *)sender {
}
- (IBAction)selectedWaiter:(UIButton *)sender {
    self.waiterTable.hidden = !(self.waiterTable.hidden);
}

- (IBAction)addNewItem:(UIButton *)sender {
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
-(void)deleteRowAtIndex:(int)index{
    NSMutableArray *openOrdersCopy = [self.openOrders mutableCopy];
    [openOrdersCopy removeObjectAtIndex:index];
    [self.dishNames removeObjectAtIndex:index];
    self.openOrders = [openOrdersCopy copy];
    
   // [self.ordersTable removeObjectAtIndex:index];
    [self.ordersTable reloadData]; // tell table to refresh now
}
@end
