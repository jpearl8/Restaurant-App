//
//  ElegantFormViewController.m
//  Fresh-Chef-Analytics
//
//  Created by jpearl on 7/16/19.
//  Copyright © 2019 julia@ipearl.net. All rights reserved.
//

#import "ElegantFormViewController.h"
#import "ReceiptViewController.h"
#import "ElegantTableViewCell.h"
#import "Helpful_funs.h"


@interface ElegantFormViewController () <UITableViewDelegate, UITableViewDataSource, UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UISlider *waiterRating;
@property (weak, nonatomic) IBOutlet UITableView *menuRatings;
@property (weak, nonatomic) IBOutlet UILabel *waiterNameLabel;
@property (weak, nonatomic) IBOutlet UITextView *waiterComments;
@property (weak, nonatomic) IBOutlet UILabel *charsRemaining;
@property (strong, nonatomic) NSMutableArray *customerRatings;
@property (strong, nonatomic) NSMutableArray *customerComments;
@property (weak, nonatomic) IBOutlet UIImageView *waiterPic;
@end

@implementation ElegantFormViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.menuRatings.delegate = self;
    self.menuRatings.dataSource = self;
    self.waiterNameLabel.text = self.openOrders[0].waiter.name;
    self.waiterComments.delegate = self;
    self.waiterComments.placeholder = @"Comments on your waiter";
    self.waiterComments.placeholderColor = [UIColor lightGrayColor];
    self.customerRatings = [[NSMutableArray alloc] init];
    self.customerComments = [[NSMutableArray alloc] init];
    // Do any additional setup after loading the view.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.openOrders.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ElegantTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: @"Elegant"];
    order *order = self.customerOrder[indexPath.row];
    Dish *dish = self.openOrders[indexPath.row].dish;
    NSNumber *amount = self.openOrders[indexPath.row].amount;
    cell.order = order;
    cell.dishName.text = dish.name;
    cell.dishType.text = dish.type;
    cell.dishDescription.text = dish.dishDescription;
    cell.index = (int)indexPath.row;
    cell.customerRatings = self.customerRatings;
    cell.customerComments = self.customerComments;
    cell.amount.text = [NSString stringWithFormat:@"%@", amount];
    PFFileObject *dishImageFile = (PFFileObject *)dish.image;
    cell.customerRating.value = 5;
    [dishImageFile getDataInBackgroundWithBlock:^(NSData *imageData, NSError *error) {
        if(!error){
            cell.image.image = [UIImage imageWithData:imageData];
        }
    }];
    cell.customerRating.value = [cell.customerRatings[indexPath.row] floatValue];
    return cell;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    int characterLimit = 140;
    NSString *newText = [self.waiterComments.text stringByReplacingCharactersInRange:range withString:text];
    self.charsRemaining.text = [NSString stringWithFormat: @"%d", (int)(characterLimit - newText.length)];
    return newText.length < characterLimit;
}


- (IBAction)changeWaiterReview:(UISlider *)sender {
    NSLog(@"%f", sender.value);
    self.customerOrder[0].waiterRating = sender.value;
}

- (IBAction)didSubmit:(UIButton *)sender {
    for (int i = 0; i < self.openOrders.count; i++){
        float totalRating = [((Dish *)self.openOrders[i].dish).rating floatValue];
        if (!totalRating){
            totalRating = 0;
        }
        ((Dish *)self.openOrders[i].dish).rating = [NSNumber numberWithFloat: (([self.customerRatings[i] floatValue] * [((NSNumber *)self.openOrders[i].amount) floatValue])  + totalRating)];
        if (!([self.customerComments[i] isEqualToString:@""])){
            ((Dish *)self.openOrders[i].dish).comments=[((Dish *)self.openOrders[i].dish).comments arrayByAddingObject:self.customerComments[i]];
        }
        float totalFrequency = [((Dish *)self.openOrders[i].dish).orderFrequency floatValue];
        ((Dish *)self.openOrders[i].dish).orderFrequency = [NSNumber numberWithFloat: ( [self.openOrders[i].amount floatValue] + totalFrequency)];
        [(Dish *)self.openOrders[i].dish saveInBackground];
    }
    float totalRating = [self.openOrders[0].waiter.rating floatValue];
    if (!totalRating){
        totalRating = 0;
    }
    self.openOrders[0].waiter.rating = [NSNumber numberWithFloat: (self.waiterRating.value  + totalRating)];
    
    if (!([self.waiterComments.text isEqualToString:@""])){
        self.openOrders[0].waiter.comments =[self.openOrders[0].waiter.comments arrayByAddingObject:self.waiterComments.text];
    }
    float numOfCustomers = [self.openOrders[0].waiter.numOfCustomers floatValue];
    self.openOrders[0].waiter.numOfCustomers = [NSNumber numberWithFloat: ([self.customerNumber floatValue] + numOfCustomers)];
    self.openOrders[0].waiter.tableTops = [NSNumber numberWithFloat: ([self.openOrders[0].waiter.tableTops floatValue] + 1)];
    [self.openOrders[0].waiter saveInBackground];
    
    [self performSegueWithIdentifier:@"toReceipt" sender:self];
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    ReceiptViewController *recVC = [segue destinationViewController];

    recVC.openOrders = self.openOrders;
    
}
@end
