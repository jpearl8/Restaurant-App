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


@interface ComfortableFormViewController () <UITableViewDelegate, UITableViewDataSource, UITextViewDelegate, ComfortableCellDelegate>

@property (weak, nonatomic) IBOutlet UITableView *menuRatings;
@property (weak, nonatomic) IBOutlet UILabel *waiterNameLabel;
@property (weak, nonatomic) IBOutlet UITextView *waiterComments;
@property (weak, nonatomic) IBOutlet UILabel *charsRemaining;
@property (weak, nonatomic) IBOutlet UIImageView *waiterPic;
@property (strong, nonatomic) NSMutableArray *customerRatings;
@property (strong, nonatomic) NSMutableArray *customerComments;
@property (assign, nonatomic) NSNumber *waiterRatingNum;
@property (weak, nonatomic) IBOutlet HCSStarRatingView *waiterRating;
@end

@implementation ComfortableFormViewController

- (void)viewDidLoad {
     [super viewDidLoad];
    self.menuRatings.delegate = self;
    self.menuRatings.dataSource = self;
    self.waiterNameLabel.text = self.waiter.name;
    self.waiterComments.delegate = self;
    self.waiterComments.placeholder = @"Comments on your waiter";
    self.waiterComments.placeholderColor = [UIColor lightGrayColor];
    self.customerRatings = [[NSMutableArray alloc] init];
    self.customerComments = [[NSMutableArray alloc] init];
    NSNumber *defaultRating = [NSNumber numberWithFloat:5];
    for (int i = 0; i < self.openOrders.count; i++){
        [self.customerRatings addObject:defaultRating];
        [self.customerComments addObject:[NSNull null]];
    }
   
    // Do any additional setup after loading the view.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.openOrders.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ComfortableTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: @"Comf" forIndexPath:indexPath];
    Dish *dish = self.dishesArray[indexPath.row];
    NSNumber *amount = self.openOrders[indexPath.row].amount;
    
    cell.dishName.text = dish.name;
    cell.dishType.text = dish.type;
    cell.dishDescription.text = dish.dishDescription;
    cell.index = (int)indexPath.row;
    cell.customerComments = self.customerComments;
    
    cell.delegate = self;
    cell.amount.text = [NSString stringWithFormat:@"%@", amount];
    PFFileObject *dishImageFile = (PFFileObject *)dish.image;
    [dishImageFile getDataInBackgroundWithBlock:^(NSData *imageData, NSError *error) {
        if(!error){
            cell.image.image = [UIImage imageWithData:imageData];
        }
    }];
    cell.customerRating.value = ([self.customerRatings[indexPath.row] floatValue]/ 2);
    return cell;
}

- (IBAction)changeWaiterRating:(HCSStarRatingView *)sender {
    NSLog(@"%f", sender.value);
    self.waiterRatingNum = [NSNumber numberWithDouble:(2*sender.value)];
}

-(void)textViewDidChange:(UITextView *)textView{
    //self.customerOrder[0].waiterReview = self.waiterComments.text;
    //handle text editing finished
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    int characterLimit = 140;
    NSString *newText = [self.waiterComments.text stringByReplacingCharactersInRange:range withString:text];
    self.charsRemaining.text = [NSString stringWithFormat: @"%d", (int)(characterLimit - newText.length)];
    return newText.length < characterLimit;
}


- (IBAction)didSubmit:(UIButton *)sender {
    for (int i = 0; i < self.openOrders.count; i++){
        float totalRating = [((Dish *)self.dishesArray[i]).rating floatValue];
        if (!totalRating){
            totalRating = 0;
        }
        float placeHolder = 0;
        if (!([self.customerRatings[i] isEqual:[NSNull null]])){
            placeHolder = [self.customerRatings[i] floatValue];
        }
        ((Dish *)self.dishesArray[i]).rating = [NSNumber numberWithFloat: ((placeHolder * [((NSNumber *)self.openOrders[i].amount) floatValue])  + totalRating)];
        if (!([self.customerComments[i] isEqual:[NSNull null]] || [self.customerComments[i] isEqualToString:@""])){
            ((Dish *)self.dishesArray[i]).comments =[((Dish *)self.dishesArray[i]).comments arrayByAddingObject:self.customerComments[i]];
            
        }
        float totalFrequency = [((Dish *)self.dishesArray[i]).orderFrequency floatValue];
        ((Dish *)self.dishesArray[i]).orderFrequency = [NSNumber numberWithFloat: ( [self.openOrders[i][@"amount"] floatValue] + totalFrequency)];
        NSLog(@"%@", ((Dish *)self.dishesArray[i]));
        [((Dish *)self.dishesArray[i]) saveInBackground];
    }
    float totalRating = [self.waiter.rating floatValue];
    if (!totalRating){
        totalRating = 0;
    }
    self.waiter.rating = [NSNumber numberWithFloat: ([self.waiterRatingNum floatValue] + totalRating)];
    
    if (!([self.waiterComments.text isEqual:[NSNull null]] || [self.waiterComments.text isEqualToString:@""])){
        self.waiter.comments = [self.waiter.comments arrayByAddingObject:self.waiterComments.text];
    }
    float numOfCustomers = [self.waiter.numOfCustomers floatValue];
    self.waiter.numOfCustomers = [NSNumber numberWithFloat: ([self.customerNumber floatValue] + numOfCustomers)];
    self.waiter.tableTops = [NSNumber numberWithFloat: ([self.waiter.tableTops floatValue] + 1)];
    [self.waiter saveInBackground];
    
    [self performSegueWithIdentifier:@"toReceipt" sender:self];
    
    
}
- (void)customerCommentForIndex:(int)index withComment:(NSString *)comment{
    self.customerComments[index] = comment;
    // [self.customerComments replaceObjectAtIndex:index withObject:comment];
}
- (void)customerRatingForIndex:(int)index withRating:(NSNumber *)rating{
    self.customerRatings[index] = rating;
    
    //[self.customerRatingsArray replaceObjectAtIndex:index withObject:rating];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    ReceiptViewController *recVC = [segue destinationViewController];
    recVC.openOrders = self.openOrders;
    recVC.waiter = self.waiter;
    recVC.dishesArray = self.dishesArray;
    
}


@end
