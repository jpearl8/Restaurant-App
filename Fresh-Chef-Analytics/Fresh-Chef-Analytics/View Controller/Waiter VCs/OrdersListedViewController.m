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

@interface OrdersListedViewController () <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *openOrdersTable;
@property (strong, nonatomic) NSArray<NSArray<OpenOrder *>*>* totalOpenTables;
- (IBAction)completeOrder:(OpenOrderButton *)sender;
- (IBAction)editOrder:(OpenOrderButton *)sender;


@end

@implementation OrdersListedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.openOrdersTable.delegate = self;
    self.openOrdersTable.dataSource = self;
    // Do any additional setup after loading the view.
    //fill totalOpenTables
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.totalOpenTables.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WaitOrderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: @"OpenOrders"];
    NSArray <OpenOrder *>* openOrders = self.totalOpenTables[indexPath.row];
    cell.openOrders = openOrders;
    cell.tableNumber.text = [NSString stringWithFormat:@"%@", openOrders[0].table];
    //cell.customerNumber.text = openOrders[0].customerNumber;
    cell.waiterName.text = openOrders[0].waiter.name;
    return cell;
    
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
