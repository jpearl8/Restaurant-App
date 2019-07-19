//
//  FunFormViewController.m
//  Fresh-Chef-Analytics
//
//  Created by jpearl on 7/16/19.
//  Copyright © 2019 julia@ipearl.net. All rights reserved.
//

#import "FunFormViewController.h"
#import "ReceiptViewController.h"

@interface FunFormViewController () <UITableViewDelegate, UITableViewDataSource, UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *menuRatings;
@property (weak, nonatomic) IBOutlet UILabel *waiterNameLabel;
@property (weak, nonatomic) IBOutlet UITextView *waiterComments;
@property (weak, nonatomic) IBOutlet UILabel *charsRemaining;

@property (weak, nonatomic) IBOutlet UIImageView *waiterPic;

@end

@implementation FunFormViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.menuRatings.delegate = self;
    self.menuRatings.dataSource = self;
    self.waiterNameLabel.text = self.customerOrder[0].waiter.name;
    self.waiterComments.delegate = self;
    self.waiterComments.placeholder = @"Comments on your waiter";
    self.waiterComments.placeholderColor = [UIColor lightGrayColor];
    // Do any additional setup after loading the view.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.customerOrder.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FunTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: @"Fun"];
    order *order = self.customerOrder[indexPath.row];
    cell.order = order;
    cell.dishName.text = order.dish.name;
    cell.dishType.text = order.dish.type;
    cell.dishDescription.text = order.dish.dishDescription;
    cell.amount.text = [NSString stringWithFormat:@"%.0f", order.amount];
    PFFileObject *dishImageFile = (PFFileObject *)order.dish.image;
    [dishImageFile getDataInBackgroundWithBlock:^(NSData *imageData, NSError *error) {
        if(!error){
            cell.image.image = [UIImage imageWithData:imageData];
        }
    }];
    return cell;
}
- (IBAction)didSubmit:(UIButton *)sender {
    [self updateWithOrder:self.customerOrder];
     [self performSegueWithIdentifier:@"toReceipt" sender:self];
}
- (void) updateWithOrder: ( NSMutableArray <order*> *)orderList{
    for (int i = 0; i < orderList.count; i++){
        if (orderList[i].customerRating != -1){
            float totalRating = [orderList[i].dish.rating floatValue];
            orderList[i].dish.rating = [NSNumber numberWithFloat: (orderList[i].customerRating + totalRating)];
        }
        if (!([orderList[i].customerComments isEqualToString:@""])){
            orderList[i].dish.comments=[orderList[i].dish.comments arrayByAddingObject:orderList[i].customerComments];
        }
        float totalFrequency = [orderList[i].dish.orderFrequency floatValue];
        orderList[i].dish.orderFrequency = [NSNumber numberWithFloat: (orderList[i].amount + totalFrequency)];
        [orderList[i].dish saveInBackground];
    }
    if (orderList[0].waiterRating != -1){
        float totalRating = [orderList[0].waiter.rating floatValue];
        orderList[0].waiter.rating = [NSNumber numberWithFloat: (orderList[0].waiterRating + totalRating)];
    }
    if (!([orderList[0].waiterReview isEqualToString:@""])){
        orderList[0].waiter.comments=[orderList[0].waiter.comments arrayByAddingObject:orderList[0].waiterReview];
    }
    float numOfCustomers = [orderList[0].waiter.numOfCustomers floatValue];
    orderList[0].waiter.numOfCustomers = [NSNumber numberWithFloat: ([self.customerNumber floatValue] + numOfCustomers)];
    orderList[0].waiter.tableTops = [NSNumber numberWithFloat: ([orderList[0].waiter.tableTops floatValue] + 1)];
    [orderList[0].waiter saveInBackground];
}

-(void)textViewDidChange:(UITextView *)textView{
    NSLog(@"%@", self.waiterComments.text);
    self.customerOrder[0].waiterReview = self.waiterComments.text;
    self.customerOrder[0].waiterRating = 2;
    NSLog(@"%@", self.customerOrder[0].waiterReview);
    //handle text editing finished
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    int characterLimit = 140;
    NSString *newText = [self.waiterComments.text stringByReplacingCharactersInRange:range withString:text];
    self.charsRemaining.text = [NSString stringWithFormat: @"%d", (int)(characterLimit - newText.length)];
    return newText.length < characterLimit;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    ReceiptViewController *recVC = [segue destinationViewController];
    //recVC.customerOrders = self.customerOrder;

}



@end
