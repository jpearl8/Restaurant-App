//
//  ReceiptViewController.m
//  Fresh-Chef-Analytics
//
//  Created by jpearl on 7/16/19.
//  Copyright © 2019 julia@ipearl.net. All rights reserved.
//

#import "ReceiptViewController.h"
#import "ReceiptTableViewCell.h"
#import "Parse/Parse.h"

@interface ReceiptViewController () <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *receiptTable;
@property (weak, nonatomic) IBOutlet UILabel *totalPrice;
@property (assign, nonatomic) float priceTracker;
@property (weak, nonatomic) IBOutlet UITextField *tip;
@property (weak, nonatomic) IBOutlet UILabel *finalPrice;
@property (weak, nonatomic) IBOutlet UILabel *date;
@property (weak, nonatomic) IBOutlet UILabel *restaurantAddress;
@property (weak, nonatomic) IBOutlet UILabel *restaurantName;


@end

@implementation ReceiptViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.receiptTable.dataSource = self;
    self.receiptTable.delegate = self;
    PFUser *currentUser = [PFUser currentUser];
    self.restaurantName.text = currentUser.username;
    self.restaurantAddress.text = currentUser[@"address"];
    self.date.text = self.openOrder.waiter[@"updatedAt"];
    
    //NSString *test = @"XuLMO3Jh3r";
    // Do any additional setup after loading the view.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.openOrder.amounts.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ReceiptTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: @"receiptCell"];
    Dish *dish = self.openOrder.dishes[indexPath.row];
    NSNumber *amount = self.openOrder.amounts[indexPath.row];
    order *order = self.customerOrder[indexPath.row];
    cell.order = order;
    cell.dishName.text = dish.name;
    cell.dishAmount.text = [NSString stringWithFormat:@"%.0@", amount];
    cell.calculatedPrice.text = [NSString stringWithFormat:@"%.2f", ([dish.price floatValue] * [amount floatValue])];
    self.priceTracker += [cell.calculatedPrice.text floatValue];
    self.totalPrice.text = [NSString stringWithFormat:@"%.2f", self.priceTracker];
    return cell;
}
- (IBAction)editingChange:(id)sender {
    self.finalPrice.text = [NSString stringWithFormat:@"%.2f", ([self.tip.text floatValue] + self.priceTracker)];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (IBAction)didSubmit:(id)sender {
    float pastTotalTips = [self.openOrder.waiter.tipsMade floatValue];
    self.openOrder.waiter.tipsMade = [NSNumber numberWithFloat: ([self.tip.text floatValue] + pastTotalTips)];
    [ClosedOrder postOldOrderWithOpenOrder:self.openOrder withCompletion:^(BOOL succeeded, NSError * _Nullable error) {
        if (!error){
            NSLog(@"posted closed order");
        }}];
    [self performSegueWithIdentifier:@"toThankYou" sender:self];

}

@end
