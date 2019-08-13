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
#import "UIRefs.h"
@interface EditOrderViewController () <UITableViewDelegate, UITableViewDataSource, AddOrdersDelegate>

@property (strong, nonatomic) IBOutlet UIButton *waiterSelected;
@property (strong, nonatomic) IBOutlet UITableView *waiterTable;
- (IBAction)selectedWaiter:(UIButton *)sender;

@property (strong, nonatomic) IBOutlet UITextField *tableNumber;
@property (strong, nonatomic) IBOutlet UITextField *customerNumber;

@property (strong, nonatomic) IBOutlet UITableView *ordersTable;
@property (strong, nonatomic) IBOutlet UIImageView *backgroundIm;

@property (strong, nonatomic) NSMutableArray <NSString*>*dishNames;

@property (strong, nonatomic) NSArray <Waiter *>*waiters;

@property (assign, nonatomic) BOOL editChange;

- (IBAction)hitSave:(UIBarButtonItem *)sender;
- (IBAction)hitCancel:(UIBarButtonItem *)sender;
- (IBAction)hitDelete:(UIButton *)sender;
- (IBAction)customerNumEdited:(UITextField *)sender;

- (IBAction)tableEdited:(UITextField *)sender;
@end

@implementation EditOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[UIRefs shared] setImage:self.backgroundIm isCustomerForm:NO];
    self.dishNames = [[NSMutableArray alloc] init];
    [self fillCellArrays:self.editableOpenOrders];
    self.editChange = NO;
    if (self.openOrders.count > 0){
        self.tableNumber.text = [NSString stringWithFormat:@"%@", self.openOrders[0][@"table"]];
        self.customerNumber.text = [NSString stringWithFormat:@"%@", self.openOrders[0][@"customerNum"]];
        [self.waiterSelected setTitle:self.waiter.name forState:UIControlStateNormal];
    }
    self.waiterTable.hidden = YES;
    [self runWaiterQuery];
    self.waiterTable.delegate = self;
    self.waiterTable.dataSource = self;
    self.ordersTable.delegate = self;
    self.ordersTable.dataSource = self;
    self.waiterSelected.layer.borderWidth = .5f;
    self.waiterSelected.layer.borderColor = [[UIRefs shared] colorFromHexString:@"#2c91fd"].CGColor;

    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([tableView.restorationIdentifier isEqualToString:@"Orders"]){
        return self.editableOpenOrders.count;
    } else {
        return self.waiters.count;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([tableView.restorationIdentifier isEqualToString:@"Orders"]){
        EditOrderViewCell *cell = [tableView dequeueReusableCellWithIdentifier: @"EditOrder"];
        cell.dishName.text = self.dishNames[indexPath.row];
        cell.delegate = self;
        //cell.amount.placeholder =
     //  [NSString stringWithFormat:@"%@", self.editableOpenOrders[indexPath.row][@"amount"]]];
        cell.amount.text = [NSString stringWithFormat:@"%@", self.editableOpenOrders[indexPath.row][@"amount"]];
     //   cell.amount.attributedPlaceholder = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@", self.editableOpenOrders[indexPath.row][@"amount"]] attributes:@{NSForegroundColorAttributeName: [UIColor blackColor]}];
       // cell.amount.attributedPlaceholder color [NSForegroundColorAttributeName: yellowColor])
        cell.amount.layer.borderWidth = .5f;
        cell.amount.layer.borderColor = [[UIRefs shared] colorFromHexString:[UIRefs shared].purpleAccent].CGColor;
        cell.index = (int)indexPath.row;
        return cell;
    } else {
        static NSString *simpleTableIdentifier = @"SimpleTableItem";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: simpleTableIdentifier];
        if (cell == nil){
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
        }
        cell.textLabel.text = self.waiters[indexPath.row].name;
        return cell;
    }
}


-(void)runWaiterQuery{
    NSArray <Waiter *>*waiters = [[WaiterManager shared] roster];;
    if (waiters.count != 0) {
        self.waiters = waiters;
        [self.waiterTable reloadData];
    }
}

- (IBAction)onTap:(id)sender {
    [self.view endEditing:(YES)];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    if (!([tableView.restorationIdentifier isEqualToString:@"menu"])){
        UITableViewCell *cell = [self.waiterTable cellForRowAtIndexPath:indexPath];
        [self.waiterSelected setTitle:cell.textLabel.text forState:UIControlStateNormal];
        self.waiter = self.waiters[indexPath.row];
        self.waiterTable.hidden = YES;
    }
}

-(void)fillCellArrays:(NSMutableArray<OpenOrder *>*)ordersArray {
    NSArray<Dish*>*dishArray = [[NSArray alloc] init];
    dishArray = [[MenuManager shared] dishes];
    for (int i = 0; i < ordersArray.count; i++){
        for (int j = 0; j < dishArray.count; j++)
        {
            if ([((Dish *)dishArray[j]).objectId isEqualToString:((Dish*)ordersArray[i].dish).objectId]){
                [self.dishNames addObject:((Dish *)dishArray[j]).name];
            }
        }
    }
}




- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"toAdd"]){
        if (self.editChange){
            for (int i = 0; i < self.editableOpenOrders.count; i++){
                NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
                f.numberStyle = NSNumberFormatterDecimalStyle;
                
                self.editableOpenOrders[i][@"waiter"] = self.waiter;
                self.editableOpenOrders[i][@"table"] = [f numberFromString:self.tableNumber.text];
                self.editableOpenOrders[i][@"customerNum"] = [f numberFromString:self.customerNumber.text];
            }
        }
        AddItemViewController *addVC = [segue destinationViewController];
        addVC.delegate = self;
        addVC.index = self.index;
    }
}

-(Waiter *)getWaiter{
    return self.waiter;
}
-(NSNumber *)getTable{
    if (self.openOrders.count > 0){
         return self.openOrders[0][@"table"];
    }
    return [NSNumber numberWithInt:-1];
}
-(NSNumber *)getCustomerNum{
    if (self.openOrders.count > 0){
        return self.openOrders[0][@"customerNum"];
    }
    return [NSNumber numberWithInt:-1];
}
-(NSMutableArray <OpenOrder *>*)getEditableOpenOrders{
    return self.editableOpenOrders;
}
-(NSArray <OpenOrder *>*)getOldOpenOrders{
    return self.openOrders;
}


- (IBAction)hitSave:(UIBarButtonItem *)sender {
    if (self.editChange){
        for (int i = 0; i < self.editableOpenOrders.count; i++){
            NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
            f.numberStyle = NSNumberFormatterDecimalStyle;
            
            self.editableOpenOrders[i][@"waiter"] = self.waiter;
            self.editableOpenOrders[i][@"table"] = [f numberFromString:self.tableNumber.text];
            self.editableOpenOrders[i][@"customerNum"] = [f numberFromString:self.customerNumber.text];
        }
    }
    [[OrderManager shared] changeOpenOrders:self.openOrders withEditedArray:self.editableOpenOrders withCompletion:^(NSError * _Nonnull error) {
        if (!error){
            [self.vcDelegate callSuperRefresh];
            [self dismissViewControllerAnimated:YES completion:^{
            }];
            //[self dismissModalViewControllerAnimated:YES];
        } else {
            NSLog(@"%@", error.localizedDescription);
        }
    }];
}

- (IBAction)hitCancel:(UIBarButtonItem *)sender {
    [self.vcDelegate callSuperRefresh];
    [self dismissViewControllerAnimated:YES completion:^{

    }];
    //[self dismissModalViewControllerAnimated:YES];
}

- (IBAction)hitDelete:(UIButton *)sender {
    [[OrderManager shared] changeOpenOrders:self.openOrders withEditedArray:NULL withCompletion:^(NSError * _Nonnull error) {
        if (!error){
            [self.vcDelegate callSuperRefresh];
            [self dismissViewControllerAnimated:YES completion:^{

            }];
        } else {
            NSLog(@"%@", error.localizedDescription);
        }
    }];
}
-(void)callEditRefresh:(NSMutableArray <OpenOrder *>*)changedOpenOrders{
    //[self.editableOpenOrders removeAllObjects];
    self.editableOpenOrders = changedOpenOrders;
    [self viewDidLoad];
    [self.ordersTable reloadData];
}
- (IBAction)customerNumEdited:(UITextField *)sender {
    self.editChange = YES;
}

- (IBAction)tableEdited:(UITextField *)sender {
    self.editChange = YES;
}

-(void)changeAmount:(NSNumber *)amount atIndex:(int)index{
    self.editableOpenOrders[index][@"amount"] = amount;
    
}
- (IBAction)selectedWaiter:(UIButton *)sender {
    self.editChange = YES;
    self.waiterTable.hidden = !(self.waiterTable.hidden);
}



- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

-(void)deleteRowAtIndex:(int)index{
    [self.editableOpenOrders removeObjectAtIndex:index];
    [self.dishNames removeObjectAtIndex:index];
    [self.ordersTable reloadData];
}

@end
