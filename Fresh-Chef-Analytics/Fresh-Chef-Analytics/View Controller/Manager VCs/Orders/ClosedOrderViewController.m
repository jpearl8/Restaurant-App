//
//  ClosedOrderViewController.m
//  Fresh-Chef-Analytics
//
//  Created by jpearl on 8/5/19.
//  Copyright © 2019 julia@ipearl.net. All rights reserved.
//
#import "OrderViewCell.h"
#import "Helpful_funs.h"
#import "OrderManager.h"
#import "MenuManager.h"
#import "WaiterManager.h"
#import "ClosedOrderViewController.h"
#import "SVProgressHUD/SVProgressHUD.h"

@interface ClosedOrderViewController () <UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) IBOutlet UITableView *closedOrderTable;
@property (strong, nonatomic) NSArray<ClosedOrder *>* totalClosedTables;
@property (strong, nonatomic) NSMutableDictionary<NSString *, Waiter *>*tableWaiterDictionary;
@property (assign, nonatomic) NSNumber *index;

@end

@implementation ClosedOrderViewController{
    NSIndexPath *selectedIndexPath;
    int regularHeight;
    int expandedHeight;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableWaiterDictionary = [[NSMutableDictionary alloc] init];
    [self fetchClosedOrders:^(NSError * _Nullable error) {
        if (!error){
            self.closedOrderTable.dataSource = self;
            self.closedOrderTable.delegate = self;
        }
        else {
            NSLog(@"%@", error.localizedDescription);
        }
    }];
    regularHeight = 150;
    expandedHeight = 300;
    
}
    // Do any additional setup after loading the view.

- (IBAction)refreshOrders:(UIBarButtonItem *)sender {
    [SVProgressHUD show];
    [self fetchClosedOrders:^(NSError * _Nullable error) {
        if (error){
            NSLog(@"%@", error.localizedDescription);
        }
        else {
            [self.closedOrderTable reloadData];
            [SVProgressHUD dismiss];
        }
    }];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.totalClosedTables.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    OrderViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Order" forIndexPath:indexPath];
    ClosedOrder *closedOrder = (ClosedOrder*)(self.totalClosedTables[indexPath.row]);
    cell.tableNumber.text = [NSString stringWithFormat:@"%@", closedOrder.table];
    cell.index = [NSNumber numberWithInteger:indexPath.row];
    NSMutableArray *items = [[NSMutableArray alloc] init];
    items = [self fillCellArrays:closedOrder];
    cell.delegate = self;
    cell.dishes.text = items[0];
    cell.amounts.text = items[1];
    //cell.openOrders = [NSArray arrayWithArray:orderInCell];
    cell.indexPath = indexPath;
    cell.waiter = self.tableWaiterDictionary[cell.tableNumber.text];
    if ([cell.waiter isEqual:[NSNull null]]){
        cell.waiterName.text = @"No longer an employee";
    } else {
        cell.waiterName.text = cell.waiter.name;
    }
    cell.customerNumber.text = [NSString stringWithFormat:@"%@", closedOrder.numCustomers];
    
    
    
    return cell;
}

-(NSMutableArray<NSString *>*)fillCellArrays:(ClosedOrder *)closedOrder {
    NSMutableArray<NSString*>*array = [[NSMutableArray alloc] init];
    NSString *dishesString = @"";
    NSString *amountsString = @"";
    if (closedOrder.dishes.count == closedOrder.amounts.count){
        for (int i = 0; i < closedOrder.dishes.count; i++){
            dishesString = [NSString stringWithFormat:@"%@\n%@", dishesString, closedOrder.dishes[i]];
            amountsString = [NSString stringWithFormat:@"%@\n%@", amountsString, closedOrder.amounts[i]];
        }
        [array addObject:dishesString];
        [array addObject:amountsString];
        
        return array;
    }
    return nil;
}


-(void) fetchClosedOrders:(void (^)(NSError * _Nullable error)) completion{
    [[OrderManager shared] fetchClosedOrderItems:[PFUser currentUser] withCompletion:^(NSArray * _Nonnull closedOrders, NSError * _Nonnull error) {
        if (closedOrders){
            self.totalClosedTables = [[OrderManager shared] closedOrders];
            __block int doneWithArray = 0;
            for (int i = 0; i < closedOrders.count; i++){
                Waiter *waiter = (Waiter*)closedOrders[i][@"waiter"];
                Waiter *fullWaiter = [[WaiterManager shared]findWaiterwithRoster:waiter.objectId];
                if (fullWaiter){
                    [self.tableWaiterDictionary setObject:fullWaiter forKey:[NSString stringWithFormat:@"%@", closedOrders[i][@"table"]]];
                    doneWithArray = doneWithArray + 1;
                } else {
                    [self.tableWaiterDictionary setObject:[NSNull null] forKey:[NSString stringWithFormat:@"%@", closedOrders[i][@"table"]]];
                    doneWithArray = doneWithArray + 1;
                }
            }
                
            if (doneWithArray >= self.totalClosedTables.count){
                [self.closedOrderTable reloadData];
                completion(nil);
                NSLog(@"check 2");
            }
        
        } else {
            NSLog(@"Open order query: %@", error.localizedDescription);
            completion(error);
        }
    }];
}

-(void)orderForIndex:(NSIndexPath *)indexPath{
    OrderViewCell *cell = [self.closedOrderTable cellForRowAtIndexPath:indexPath];
    selectedIndexPath = indexPath;
    if(cell.isExpanded){
        cell.isExpanded = NO;
        [cell.ordersButton setImage:[UIImage imageNamed:@"order_select"] forState:UIControlStateNormal];
    } else {
        cell.isExpanded = YES;
        [cell.ordersButton setImage:[UIImage imageNamed:@"order_selected"] forState:UIControlStateNormal];
    }
    
    //update cell to reflect new state
    [self.closedOrderTable beginUpdates];
    [self.closedOrderTable endUpdates];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    OrderViewCell *cell = [self.closedOrderTable cellForRowAtIndexPath:indexPath];
    if(cell.isExpanded){
        return expandedHeight;
    } else {
        return regularHeight;
    }
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
