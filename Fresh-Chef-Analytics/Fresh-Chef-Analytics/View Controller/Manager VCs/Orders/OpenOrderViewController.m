//
//  OpenOrderViewController.m
//  Fresh-Chef-Analytics
//
//  Created by jpearl on 8/2/19.
//  Copyright © 2019 julia@ipearl.net. All rights reserved.
//

#import "OpenOrderViewController.h"
#import "OrderViewCell.h"
#import "SVProgressHUD/SVProgressHUD.h"
#import "Helpful_funs.h"
#import "OrderManager.h"
#import "MenuManager.h"
#import "WaiterManager.h"
#import "UIRefs.h"

@interface OpenOrderViewController () <UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) IBOutlet UITableView *openOrdersTable;
@property (strong, nonatomic) NSMutableDictionary<NSString *, NSArray<OpenOrder *>*>* totalOpenTables;
@property (strong, nonatomic) NSArray<NSString *>* keys;
@property (strong, nonatomic) NSMutableArray<Dish *>* dishesArray;
@property (strong, nonatomic) NSMutableDictionary<NSString *, Waiter *>*tableWaiterDictionary;
@property (assign, nonatomic) NSNumber *index;
@property (strong, nonatomic) IBOutlet UIView *noOrders;


@end

@implementation OpenOrderViewController{
    NSIndexPath *selectedIndexPath;
    int regularHeight;
    int expandedHeight;
}
//OrderCellDelegate, bar button image for refresh
- (void)viewDidLoad {
    [super viewDidLoad];
    //self.openOrdersTable.dataSource = self;
    //self.openOrdersTable.delegate = self;
    self.tableWaiterDictionary = [[NSMutableDictionary alloc] init];
    self.dishesArray = [[NSMutableArray alloc] init];
    [self fetchOpenOrders:^(NSError * _Nullable error) {
        if (!error){
            self.openOrdersTable.delegate = self;
            self.openOrdersTable.dataSource = self;
            [self noOrdersCheck];
        }
        else {
            NSLog(@"%@", error.localizedDescription);
        }
    }];
    regularHeight = 92;
    expandedHeight = 263;
    
}
    // Do any additional setup after loading the view.
- (IBAction)refreshOrders:(UIBarButtonItem *)sender {
    [SVProgressHUD show];
    [self fetchOpenOrders:^(NSError * _Nullable error) {
        if (error){
            NSLog(@"%@", error.localizedDescription);
        }
        else {
            [self.openOrdersTable reloadData];
            [self noOrdersCheck];
            [SVProgressHUD dismiss];
        }
    }];
    
}

-(void)noOrdersCheck {
    if (self.keys.count == 0){
        self.openOrdersTable.hidden = YES;
        self.noOrders.hidden = NO;
        self.noOrders.layer.cornerRadius = 5;
        //self.noOrders.frame.size.width/2;
        self.noOrders.layer.borderWidth = .5f;
        self.noOrders.layer.borderColor = [[UIRefs shared] colorFromHexString:[UIRefs shared].purpleAccent].CGColor;
    } else {
        self.openOrdersTable.hidden = NO;
        self.noOrders.hidden = YES;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.keys.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    OrderViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Order" forIndexPath:indexPath];
    cell.tableNumber.text = self.keys[indexPath.row];
    cell.index = [NSNumber numberWithInteger:indexPath.row];
    NSString *tableString = [NSString stringWithFormat:@"%@", cell.tableNumber.text];
    NSArray <OpenOrder *>* orderInCell = [[NSArray alloc] init];
    orderInCell = [NSArray arrayWithArray:self.totalOpenTables[tableString]];
    NSMutableArray *items = [[NSMutableArray alloc] init];
    items = [self fillCellArrays:orderInCell];
    cell.delegate = self;
    cell.dishes.text = items[0];
    cell.amounts.text = items[1];
    cell.openOrders = [[NSArray alloc] init];
    cell.openOrders = [NSArray arrayWithArray:orderInCell];
    cell.indexPath = indexPath;
    cell.waiter = self.tableWaiterDictionary[cell.tableNumber.text];
    cell.waiterName.text = cell.waiter.name;
    cell.customerNumber.text = [NSString stringWithFormat:@"%@", orderInCell[0].customerNum];
    NSString *content = @"☆";
    UIColor *starColor;
    if (orderInCell.count > 0){
        if (!(orderInCell[0].customerLevel) || [orderInCell[0].customerLevel isEqual:[NSNumber numberWithInteger:-1]]){
            starColor = [[UIRefs shared] colorFromHexString:([UIRefs shared].blueHighlight)];
        } else {
            content = @"★";
            if ([orderInCell[0].customerLevel isEqual:[NSNumber numberWithInt:0]]){
                starColor = [[UIRefs shared] colorFromHexString:([UIRefs shared].blueHighlight)];
            } else if ([orderInCell[0].customerLevel isEqual:[NSNumber numberWithInt:1]]){
                starColor = [[UIRefs shared] colorFromHexString:([UIRefs shared].bronze)];
            } else if ([orderInCell[0].customerLevel isEqual:[NSNumber numberWithInt:2]]){
                starColor = [[UIRefs shared] colorFromHexString:([UIRefs shared].silver)];
            } else {
                starColor = [[UIRefs shared] colorFromHexString:([UIRefs shared].gold)];
            }
        }
        [cell.customerLevel setTitle:content forState:UIControlStateNormal];
        [cell.customerLevel setTitleColor:starColor forState:UIControlStateNormal];
    }
    
    return cell;
}


-(NSMutableArray<NSString *>*)fillCellArrays:(NSArray<OpenOrder *>*)openOrders {
    NSArray<Dish*>*dishArray = [[NSArray alloc] init];
    NSMutableArray<NSString*>*array = [[NSMutableArray alloc] init];
    NSString *dishesString = @"";
    NSString *amountsString = @"";
    dishArray = [[MenuManager shared] dishes];
    for (int i = 0; i < openOrders.count; i++){
        for (int j = 0; j < dishArray.count; j++)
        {
            if ([((Dish *)dishArray[j]).objectId isEqualToString:((Dish*)openOrders[i].dish).objectId]){
                if (i == 0 || i == (openOrders.count)){
                    dishesString = [NSString stringWithFormat:@"%@%@", dishesString, ((Dish *)dishArray[j]).name];
                    amountsString = [NSString stringWithFormat:@"%@%@", amountsString, [openOrders[i].amount stringValue]];
                } else {
                    dishesString = [NSString stringWithFormat:@"%@\n%@", dishesString, ((Dish *)dishArray[j]).name];
                    amountsString = [NSString stringWithFormat:@"%@\n%@", amountsString, [openOrders[i].amount stringValue]];
                }
                [self.dishesArray addObject:dishArray[j]];
            }
        }
    }
    [array addObject:dishesString];
    [array addObject:amountsString];
    
    return array;
}

-(void) fetchOpenOrders:(void (^)(NSError * _Nullable error)) completion{
    [[OrderManager shared] fetchOpenOrderItems:[PFUser currentUser] withCompletion:^(NSArray * _Nonnull openOrders, NSError * _Nonnull error) {
        if (openOrders){
            self.totalOpenTables = [[OrderManager shared] openOrdersByTable];
            self.keys = [self.totalOpenTables allKeys];
            __block int doneWithArray = 0;
            for (NSString *key in self.keys){
                Waiter *waiter = (Waiter*)((OpenOrder *)self.totalOpenTables[key][0]).waiter;
                Waiter *fullWaiter = [[WaiterManager shared]findWaiterwithRoster:waiter.objectId];
                if (fullWaiter){
                    [self.tableWaiterDictionary setObject:fullWaiter forKey:key];
                    doneWithArray = doneWithArray + 1;
                }
                else {
                    [[WaiterManager shared]findWaiter:waiter.objectId withCompletion:^(NSArray * _Nonnull waiters, NSError * _Nullable error) {
                        if (error){
                            NSLog(@"Waiter query: %@", error.localizedDescription);
                            completion(error);
                        }
                        if (waiters.count > 0 && waiters[0]){
                            
                            //                        [waiters[0] fetchIfNeeded];
                            [self.tableWaiterDictionary setObject:waiters[0] forKey:key];
                            doneWithArray = doneWithArray + 1;
                            if (doneWithArray >= self.keys.count){
                                [self.openOrdersTable reloadData];
                                completion(nil);
                            }
                        }
                        
                    }];
                }
            }
            if (doneWithArray >= self.keys.count){
                [self.openOrdersTable reloadData];
                completion(nil);
            }
            
        } else {
            NSLog(@"Open order query: %@", error.localizedDescription);
            completion(error);
        }
    }];
    
    
    
}

-(void)orderForIndex:(NSIndexPath *)indexPath{
    OrderViewCell *cell = [self.openOrdersTable cellForRowAtIndexPath:indexPath];
    selectedIndexPath = indexPath;
    if(cell.isExpanded){
        cell.isExpanded = NO;
        [cell.flipButton setImage:[UIImage imageNamed:@"arrow_grey"] forState:UIControlStateNormal];
    } else {
        cell.isExpanded = YES;
        [cell.flipButton setImage:[UIImage imageNamed:@"arrow_down"] forState:UIControlStateNormal];
    }
    
    //update cell to reflect new state
    [self.openOrdersTable beginUpdates];
    [self.openOrdersTable endUpdates];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    OrderViewCell *cell = [self.openOrdersTable cellForRowAtIndexPath:indexPath];
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
