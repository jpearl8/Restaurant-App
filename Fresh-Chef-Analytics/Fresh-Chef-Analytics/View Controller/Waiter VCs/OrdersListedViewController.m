//
//  OrdersListedViewController.m
//  Fresh-Chef-Analytics
//
//  Created by rgallardo on 7/24/19.
//  Copyright © 2019 julia@ipearl.net. All rights reserved.
//

#import "OrdersListedViewController.h"
#import "WaitOrderTableViewCell.h"
#import "OpenOrder.h"
#import "FunFormViewController.h"
#import "ComfortableFormViewController.h"
#import "ElegantFormViewController.h"
#import "OpenOrderButton.h"
#import "OrderManager.h"

@interface OrdersListedViewController () <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *openOrdersTable;
@property (strong, nonatomic) NSMutableDictionary<NSString *, NSArray<OpenOrder *>*>* totalOpenTables;
@property (strong, nonatomic) NSMutableDictionary<NSString *, Waiter *>*tableWaiterDictionary;
@property (strong, nonatomic) NSArray<NSString *>* keys;
- (IBAction)completeOrder:(OpenOrderButton *)sender;
- (IBAction)editOrder:(OpenOrderButton *)sender;


@end

@implementation OrdersListedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableWaiterDictionary = [[NSMutableDictionary alloc] init];
    [self fetchOpenOrders:^(NSError * _Nullable error) {
        self.openOrdersTable.delegate = self;
        self.openOrdersTable.dataSource = self;
    }];
   
    
    

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.keys.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WaitOrderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: @"OpenOrders"];
    cell.tableNumber.text = self.keys[indexPath.row];
    NSArray <OpenOrder *>* openOrders = self.totalOpenTables[cell.tableNumber.text];
    cell.openOrders = openOrders;
    cell.waiter = self.tableWaiterDictionary[cell.tableNumber.text];
    cell.waiterName.text = cell.waiter.name;
    //cell.customerNumber.text = openOrders[0].customerNumber;

    
    return cell;
}
/*     NSArray *tableNumbers = [[[OrderManager shared] openOrdersByTable] allKeys];
 for (int i = 0; i < tableNumbers.count; i++){
 
 }
 
 
 
 /* for (NSArray table in openOrdersByTable)
 NSArray *tables = [openOrdersByTable allKeys];
 NSArray * <OpenOrders *> table_i = openOrdersByTable[tables[i]]; */
// Do any additional setup after loading the view.
//fill totalOpenTables

-(void) fetchOpenOrders:(void (^)(NSError * _Nullable error)) completion{
    [[OrderManager shared] fetchOpenOrderItems:[PFUser currentUser] withCompletion:^(NSArray * _Nonnull openOrders, NSError * _Nonnull error) {
        if (openOrders){
            self.totalOpenTables = [[OrderManager shared] openOrdersByTable];
            self.keys = [self.totalOpenTables allKeys];
            __block int doneWithArray = 0;
            for (NSString *key in self.keys){
                Waiter *waiter = (Waiter*)((OpenOrder *)self.totalOpenTables[key][0]).waiter;
                [[WaiterManager shared]findWaiter:waiter.objectId withCompletion:^(NSArray * _Nonnull waiters, NSError * _Nullable error) {
                    NSLog(@"Waiters array: %@", waiters);
                    if (waiters[0]){
                        [self.tableWaiterDictionary setObject:waiters[0] forKey:key];
                        doneWithArray = doneWithArray + 1;
                        if (doneWithArray >= self.keys.count){
                            [self.openOrdersTable reloadData];
                            NSLog(@"check 1");
                            completion(nil);
                        }
                    }
                    if (error){
                        NSLog(@"Waiter query: %@", error.localizedDescription);
                        completion(error);
                    }
                }];
            }
            if (doneWithArray >= self.keys.count){
                [self.openOrdersTable reloadData];
                completion(nil);
                NSLog(@"check 2");
            }
            
        } else {
            NSLog(@"Open order query: %@", error.localizedDescription);
            completion(error);
        }
    }];
    
    
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[NSString stringWithFormat:@"%@", ((OpenOrderButton *)sender).restorationIdentifier] isEqualToString:@"completeOrder"]){
        NSString *category = [PFUser currentUser][@"theme"];

        if ([category isEqualToString:@"Fun"]){
        FunFormViewController *funVC = [segue destinationViewController];

        funVC.openOrders = ((OpenOrderButton *)sender).openOrders;
        //funVC.customerNumber = ((OpenOrderButton *)sender).openOrders[0].customerNumber;
        }
        if ([category isEqualToString:@"Comfortable"]){
        ComfortableFormViewController *comfVC = [segue destinationViewController];
       //comfVC.customerOrder = self.customerOrder;
        comfVC.openOrders = ((OpenOrderButton *)sender).openOrders;
        //comfVC.customerNumber = self.customerNumber.text;
        }
        if ([category isEqualToString:@"Elegant"]){
        ElegantFormViewController *elegantVC = [segue destinationViewController];
        //elegantVC.customerOrder = self.customerOrder;
        elegantVC.openOrders = ((OpenOrderButton *)sender).openOrders;
       // elegantVC.customerNumber = self.customerNumber.text;
    }
    }
}



- (IBAction)editOrder:(OpenOrderButton *)sender {
}


- (IBAction)completeOrder:(OpenOrderButton *)sender {
    NSString *category = [PFUser currentUser][@"theme"];
    [self performSegueWithIdentifier:category sender:self];
}
@end
