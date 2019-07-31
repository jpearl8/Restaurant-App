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
#import "MenuManager.h"
#import "OrderManager.h"

@interface ReceiptViewController () <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *receiptTable;
@property (weak, nonatomic) IBOutlet UILabel *totalPrice;
@property (assign, nonatomic) float priceTracker;
@property (weak, nonatomic) IBOutlet UITextField *tip;
@property (weak, nonatomic) IBOutlet UILabel *finalPrice;
@property (weak, nonatomic) IBOutlet UILabel *date;
@property (weak, nonatomic) IBOutlet UILabel *restaurantAddress;
@property (weak, nonatomic) IBOutlet UILabel *restaurantName;
@property (strong, nonatomic) NSMutableArray<NSString *>* mutableDishes;
@property (strong, nonatomic) NSMutableArray* mutableAmounts;



@end

@implementation ReceiptViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.mutableAmounts = [[NSMutableArray alloc] init];
    self.mutableDishes = [[NSMutableArray alloc] init];
    self.receiptTable.dataSource = self;
    self.receiptTable.delegate = self;
    PFUser *currentUser = [PFUser currentUser];
    self.restaurantName.text = currentUser.username;
    self.restaurantAddress.text = currentUser[@"address"];
    self.date.text = self.waiter[@"updatedAt"];
    
    //NSString *test = @"XuLMO3Jh3r";
    // Do any additional setup after loading the view.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.openOrders.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ReceiptTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: @"receiptCell"];
    Dish *dish = self.dishesArray[indexPath.row];
    NSNumber *amount = self.openOrders[indexPath.row].amount;
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
    float pastTotalTips = [self.waiter.tipsMade floatValue];
    self.waiter.tipsMade = [NSNumber numberWithFloat: ([self.tip.text floatValue] + pastTotalTips)];
    [self fillCellArrays:self.openOrders];
    NSArray *dishNameStrings = [self.mutableDishes copy];
    NSArray *amounts = [self.mutableAmounts copy];
    [[OrderManager shared] closeOpenOrdersArray:self.openOrders withDishArray:dishNameStrings withAmounts:amounts withCompletion:^(NSError * _Nonnull error) {
        if (error){
            NSLog(@"%@", error.localizedDescription);
        }
        else {
            [self performSegueWithIdentifier:@"toThankYou" sender:self];
        }
            
    }];
    
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
                 [self.mutableDishes addObject:((Dish *)dishArray[j]).name];
                 [self.mutableAmounts addObject:openOrders[i].amount];
            }
        }
    }
}

@end
