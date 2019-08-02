//
//  OrdersTableViewController.m
//  Fresh-Chef-Analytics
//
//  Created by jpearl on 7/28/19.
//  Copyright © 2019 julia@ipearl.net. All rights reserved.
//

#import "OrdersViewController.h"
#import "OpenOrder.h"
#import "OrderViewCell.h"
#import "FunFormViewController.h"
#import "ComfortableFormViewController.h"
#import "ElegantFormViewController.h"
#import "Helpful_funs.h"
#import "OrderManager.h"
#import "MenuManager.h"
#import "AppDelegate.h"
#import "SVProgressHUD/SVProgressHUD.h"
#import "EditOrderViewController.h"



@interface OrdersViewController () <OrderViewCellDelegate, UITableViewDelegate, UITableViewDataSource> {
//    NSMutableArray *_objects;
//    //    NSLog(@"In the delegate, Clicked button one for %@", itemText);
//    NSString *customerNumber;
//    NSArray<OpenOrder *>*openOrders;
//    Waiter *waiter;
//    NSMutableArray <Dish *>*dishArray;
}
@property (strong, nonatomic) IBOutlet UITableView *openOrdersTable;
@property (strong, nonatomic) NSMutableDictionary<NSString *, NSArray<OpenOrder *>*>* totalOpenTables;
@property (strong, nonatomic) NSArray<NSString *>* keys;
@property (strong, nonatomic) NSMutableArray<Dish *>* dishesArray;
@property (strong, nonatomic) NSMutableDictionary<NSString *, Waiter *>*tableWaiterDictionary;
@property (assign, nonatomic) NSNumber *index;
//@property (strong, nonatomic) NSMutableArray *objects;
@property (strong, nonatomic) IBOutlet UIImageView *image;
@property (strong, nonatomic) IBOutlet UINavigationBar *navBar;
@end

@implementation OrdersViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.openOrdersTable.dataSource = self;
    self.openOrdersTable.delegate = self;
    self.tableWaiterDictionary = [[NSMutableDictionary alloc] init];
    self.dishesArray = [[NSMutableArray alloc] init];
    NSString *category = [PFUser currentUser][@"theme"];
    NSString *category_waiter = [NSString stringWithFormat:@"%@_waiter", category];
     [self.image setImage:[UIImage imageNamed:category_waiter]];
     self.navBar.shadowImage = [UIImage imageNamed:category];
    [self fetchOpenOrders:^(NSError * _Nullable error) {
        if (!error){
            self.openOrdersTable.delegate = self;
            self.openOrdersTable.dataSource = self;
        }
        else {
            NSLog(@"%@", error.localizedDescription);
        }
    }];

}
- (IBAction)refreshOrders:(UIBarButtonItem *)sender {
    [SVProgressHUD show];
    [self fetchOpenOrders:^(NSError * _Nullable error) {
        if (error){
            NSLog(@"%@", error.localizedDescription);
        }
        else {
            [self.openOrdersTable reloadData];
            [SVProgressHUD dismiss];
        }
    }];
    
}



#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.keys.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    OrderViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
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

    cell.waiter = self.tableWaiterDictionary[cell.tableNumber.text];
    cell.waiterName.text = cell.waiter.name;
    cell.customerNumber.text = [NSString stringWithFormat:@"%@", orderInCell[0].customerNum];


    
    return cell;
}






- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

//- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
//    if (editingStyle == UITableViewCellEditingStyleDelete) {
//        NSLog(@"Cell recursive description:\n\n%@\n\n", [[self.openOrdersTable cellForRowAtIndexPath:indexPath] performSelector:@selector(recursiveDescription)]);
//        [_objects removeObjectAtIndex:indexPath.row];
//        [self.openOrdersTable deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
//    } else {
//        NSLog(@"Unhandled editing style! %d", editingStyle);
//    }
//}
#pragma mark - SwipeableCellDelegate
- (void)editForIndex:(NSNumber *)index {
    self.index = index;
    [self performSegueWithIdentifier:@"Edit" sender:self];
    NSLog(@"yo");
}
//- (void)editForItemText:(NSArray <OpenOrder *>*)openOrders withCustomerNumber:(NSString*)number withWaiter:(Waiter *)waiter withDishArray:(NSMutableArray <Dish *>*)dishArray {
//    FunFormViewController
////    NSLog(@"In the delegate, Clicked button one for %@", itemText);
////    @property (strong, nonatomic) NSString *customerNumber;
////    @property (strong, nonatomic) NSArray<OpenOrder *>*openOrders;
////    @property (strong, nonatomic) Waiter *waiter;
////    @property (strong, nonatomic) NSMutableArray <Dish *>*dishArray;
//}

- (void)completeForIndex:(NSNumber *)index {
  
    self.index = index;
    NSString *category = [PFUser currentUser][@"theme"];
    [self performSegueWithIdentifier:category sender:self];
    
}



/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

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
                    if (error){
                        NSLog(@"Waiter query: %@", error.localizedDescription);
                        completion(error);
                    }
                    if (waiters.count > 0 && waiters[0]){
                        
//                        [waiters[0] fetchIfNeeded];
                        [self.tableWaiterDictionary setObject:waiters[0] forKey:key];
                        doneWithArray = doneWithArray + 1;
                        NSLog(@"DONE monitor: %d", doneWithArray);
                        NSLog(@"keys count %d", self.keys.count);
                        if (doneWithArray >= self.keys.count){
                            [self.openOrdersTable reloadData];
                            NSLog(@"check 1");
                            completion(nil);
                        }
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

-(NSMutableArray<NSString *>*)fillCellArrays:(NSArray<OpenOrder *>*)openOrders {
    NSArray<Dish*>*dishArray = [[NSArray alloc] init];
    NSMutableArray<NSString*>*array = [[NSMutableArray alloc] init];
    NSString *dishesString = @"";
    NSString *amountsString = @"";
    dishArray = [[MenuManager shared] dishes];
    NSLog(@"%@", dishArray);
    for (int i = 0; i < openOrders.count; i++){
        for (int j = 0; j < dishArray.count; j++)
        {
            NSLog(@"%@", openOrders[i]);
            NSLog(@"%@", ((Dish*)openOrders[i].dish).objectId);
            if ([((Dish *)dishArray[j]).objectId isEqualToString:((Dish*)openOrders[i].dish).objectId]){
                dishesString = [NSString stringWithFormat:@"%@\n%@", dishesString, ((Dish *)dishArray[j]).name];
                amountsString = [NSString stringWithFormat:@"%@\n%@", amountsString, [openOrders[i].amount stringValue]];
                [self.dishesArray addObject:dishArray[j]];
            }
        }
    }
    [array addObject:dishesString];
    [array addObject:amountsString];
    
    return array;
}



- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSLog(@"%@", sender);
    NSLog(@"%@", segue.identifier);
   
//         NSString *category = [PFUser currentUser][@"theme"];
//
    if ([segue.identifier isEqualToString:@"Fun"]){
        FunFormViewController *funVC = [segue destinationViewController];
        funVC.waiter = self.tableWaiterDictionary[self.keys[[self.index integerValue]]];
        funVC.openOrders =  self.totalOpenTables[self.keys[[self.index integerValue]]];;
        funVC.customerNumber =  [self.totalOpenTables[self.keys[[self.index integerValue]]][0].customerNum stringValue];
        funVC.dishesArray = self.dishesArray;
        
     }
     if ([segue.identifier isEqualToString:@"Comfortable"]){
         ComfortableFormViewController *comfVC = [segue destinationViewController];
         comfVC.waiter = self.tableWaiterDictionary[self.keys[[self.index integerValue]]];
         comfVC.openOrders =  self.totalOpenTables[self.keys[[self.index integerValue]]];
         comfVC.customerNumber =  [self.totalOpenTables[self.keys[[self.index integerValue]]][0].customerNum stringValue];
         comfVC.dishesArray = self.dishesArray;
     }
     if ([segue.identifier isEqualToString:@"Elegant"]){
         ElegantFormViewController *elegantVC = [segue destinationViewController];
         elegantVC.waiter = self.tableWaiterDictionary[self.keys[[self.index integerValue]]];
         elegantVC.openOrders =  self.totalOpenTables[self.keys[[self.index integerValue]]];;
         elegantVC.customerNumber =  [self.totalOpenTables[self.keys[[self.index integerValue]]][0].customerNum stringValue];
         elegantVC.dishesArray = self.dishesArray;
     
     }
    if ([segue.identifier isEqualToString:@"Edit"]){
        EditOrderViewController *editVC = [segue destinationViewController];
        editVC.waiter = self.tableWaiterDictionary[self.keys[[self.index integerValue]]];
        editVC.openOrders =  self.totalOpenTables[self.keys[[self.index integerValue]]];
        editVC.index = self.index;
        editVC.editableOpenOrders = [editVC.openOrders mutableCopy];

        //editVC.dishesArray = self.dishesArray;
        
    }
    

}
//- (IBAction)newOrderAction:(UIBarButtonItem *)sender {
//    [self dismissViewControllerAnimated:YES completion:^{
//        //Stuff after dismissing
//    }];
//     //[self.navigationController popViewControllerAnimated:YES];
////    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
////    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
////    UINavigationController *navigationController = [storyboard instantiateViewControllerWithIdentifier:@"waiterView"];
////    appDelegate.window.rootViewController = navigationController;
//}


@end
