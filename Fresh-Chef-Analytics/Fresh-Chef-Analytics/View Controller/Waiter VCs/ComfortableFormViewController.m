//
//  ComfortableFormViewController.m
//  Fresh-Chef-Analytics
//
//  Created by jpearl on 7/16/19.
//  Copyright © 2019 julia@ipearl.net. All rights reserved.
//
#import "HCSStarRatingView.h"
#import "ComfortableFormViewController.h"
#import "ReceiptViewController.h"
#import "Helpful_funs.h"
#import "ComfortableTableViewCell.h"

@interface ComfortableFormViewController () <UITableViewDelegate, UITableViewDataSource, UITextViewDelegate>
@property (weak, nonatomic) IBOutlet HCSStarRatingView *waiterRating;

@property (weak, nonatomic) IBOutlet UITableView *menuRatings;
@property (weak, nonatomic) IBOutlet UILabel *waiterNameLabel;
@property (weak, nonatomic) IBOutlet UITextView *waiterComments;
@property (weak, nonatomic) IBOutlet UILabel *charsRemaining;
@property (weak, nonatomic) IBOutlet UIImageView *waiterPic;
@property (strong, nonatomic) NSMutableArray *customerRatings;
@property (strong, nonatomic) NSMutableArray *customerComments;
@property (assign, nonatomic) NSNumber *waiterRatingNum;

@end

@implementation ComfortableFormViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.menuRatings.delegate = self;
    self.menuRatings.dataSource = self;
    self.waiterNameLabel.text = self.openOrder.waiter.name;
    self.waiterComments.delegate = self;
    self.waiterComments.placeholder = @"Comments on your waiter";
    self.waiterComments.placeholderColor = [UIColor lightGrayColor];
    self.customerRatings = [[NSMutableArray alloc] init];
    self.customerComments = [[NSMutableArray alloc] init];
    // Do any additional setup after loading the view.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 6 ;//self.openOrder.amounts.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ComfortableTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: @"Comfortable"];
//    order *order = self.customerOrder[indexPath.row];
//    Dish *dish = self.openOrder.dishes[indexPath.row];
//    NSNumber *amount = self.openOrder.amounts[indexPath.row];
//    cell.order = order;
//    cell.dishName.text = dish.name;
//    cell.dishType.text = dish.type;
//    cell.dishDescription.text = dish.dishDescription;
//    cell.index = (int)indexPath.row;
//    cell.customerRatings = self.customerRatings;
//    cell.customerComments = self.customerComments;
//    cell.amount.text = [NSString stringWithFormat:@"%@", amount];
//    PFFileObject *dishImageFile = (PFFileObject *)dish.image;
//    [dishImageFile getDataInBackgroundWithBlock:^(NSData *imageData, NSError *error) {
//        if(!error){
//            cell.image.image = [UIImage imageWithData:imageData];
//        }
//    }];
//    cell.customerRating.value = ([self.customerRatings[indexPath.row] floatValue] / 2);
    return cell;
}

- (IBAction)changeWaiterRating:(HCSStarRatingView *)sender {
    NSLog(@"%f", sender.value);
    self.waiterRatingNum = [NSNumber numberWithDouble:(2*sender.value)];
}

-(void)textViewDidChange:(UITextView *)textView{
    self.customerOrder[0].waiterReview = self.waiterComments.text;
    //handle text editing finished
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    int characterLimit = 140;
    NSString *newText = [self.waiterComments.text stringByReplacingCharactersInRange:range withString:text];
    self.charsRemaining.text = [NSString stringWithFormat: @"%d", (int)(characterLimit - newText.length)];
    return newText.length < characterLimit;
}


- (IBAction)didSubmit:(UIButton *)sender {
//    NSArray *dishes = self.openOrder.dishes;
//    NSArray *amounts = self.openOrder.amounts;
//    for (int i = 0; i < self.openOrder.amounts.count; i++){
//        float totalRating = [((Dish *)dishes[i]).rating floatValue];
//        if (!totalRating){
//            totalRating = 0;
//        }
//        ((Dish *)dishes[i]).rating = [NSNumber numberWithFloat: (([self.customerRatings[i] floatValue] * [amounts[i] floatValue])  + totalRating)];
//        if (!([self.customerComments[i] isEqualToString:@""])){
//            ((Dish *)dishes[i]).comments=[((Dish *)dishes[i]).comments arrayByAddingObject:self.customerComments[i]];
//        }
//        float totalFrequency = [((Dish *)dishes[i]).orderFrequency floatValue];
//        ((Dish *)dishes[i]).orderFrequency = [NSNumber numberWithFloat: (((int)amounts[i]) + totalFrequency)];
//        [(Dish*)dishes[i] saveInBackground];
//    }
//    float totalRating = [self.openOrder.waiter.rating floatValue];
//    if (!totalRating){
//        totalRating = 0;
//    }
//    self.openOrder.waiter.rating = [NSNumber numberWithFloat: ([self.waiterRatingNum floatValue] + totalRating)];
//    
//    if (!([self.waiterComments.text isEqualToString:@""])){
//        self.openOrder.waiter.comments =[self.openOrder.waiter.comments arrayByAddingObject:self.waiterComments.text];
//    }
//    float numOfCustomers = [self.openOrder.waiter.numOfCustomers floatValue];
//    self.openOrder.waiter.numOfCustomers = [NSNumber numberWithFloat: ([self.customerNumber floatValue] + numOfCustomers)];
//    self.openOrder.waiter.tableTops = [NSNumber numberWithFloat: ([self.openOrder.waiter.tableTops floatValue] + 1)];
//    [self.openOrder.waiter saveInBackground];
    
    [self performSegueWithIdentifier:@"toReceipt" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    ReceiptViewController *recVC = [segue destinationViewController];
    recVC.customerOrder = self.customerOrder;
    recVC.openOrder = self.openOrder;
    
}


@end
