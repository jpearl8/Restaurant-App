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
#import "WaiterCell.h"
#import "UIRefs.h"

@interface ComfortableFormViewController () <UITableViewDelegate, UITableViewDataSource, UITextViewDelegate, ComfortableCellDelegate>

@property (weak, nonatomic) IBOutlet UITableView *menuRatings;
//@property (weak, nonatomic) IBOutlet UILabel *waiterNameLabel;
//@property (weak, nonatomic) IBOutlet UITextView *waiterComments;
//@property (weak, nonatomic) IBOutlet UILabel *charsRemaining;
//@property (weak, nonatomic) IBOutlet UIImageView *waiterPic;
@property (strong, nonatomic) IBOutlet UIButton *submit;
@property (strong, nonatomic) NSMutableArray *customerRatings;
@property (strong, nonatomic) NSMutableArray *customerComments;
@property (assign, nonatomic) NSNumber *waiterRatingNum;
@property (strong, nonatomic) NSString *waiterComments;
//@property (weak, nonatomic) IBOutlet HCSStarRatingView *waiterRating;
@end

@implementation ComfortableFormViewController

- (void)viewDidLoad {
     [super viewDidLoad];
    self.menuRatings.delegate = self;
    self.menuRatings.dataSource = self;
//    self.waiterNameLabel.text = self.waiter.name;
//    self.waiterComments.delegate = self;
//    self.waiterComments.placeholder = @"Comments on your waiter";
//    self.waiterComments.placeholderColor = [UIColor lightGrayColor];
    self.customerRatings = [[NSMutableArray alloc] init];
    self.customerComments = [[NSMutableArray alloc] init];
    NSNumber *defaultRating = [NSNumber numberWithFloat:5];
    for (int i = 0; i < self.openOrders.count; i++){
        [self.customerRatings addObject:defaultRating];
        [self.customerComments addObject:[NSNull null]];
    }
    self.submit.layer.borderWidth = .5f;
    self.submit.layer.borderColor = [[UIRefs shared] colorFromHexString:[UIRefs shared].purpleAccent].CGColor;
    // Do any additional setup after loading the view.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return (self.openOrders.count + 1);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0){
        WaiterCell *cell = [tableView dequeueReusableCellWithIdentifier: @"Waiter" forIndexPath:indexPath];
        cell.waiter = self.waiter;
        cell.waiterDelegate = self;
        cell.waiterNameLabel.text = cell.waiter.name;
        PFFileObject *waiterImageFile = (PFFileObject *)self.waiter.image;
        [waiterImageFile getDataInBackgroundWithBlock:^(NSData *imageData, NSError *error) {
            if(!error){
                cell.waiterPic.image = [UIImage imageWithData:imageData];
            }
        }];
        return cell;
        
    } else {
        ComfortableTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: @"Comf" forIndexPath:indexPath];
        NSNumber *amount = self.openOrders[indexPath.row - 1][@"amount"];
        int index = [[Helpful_funs shared] findDishItem:((int)indexPath.row - 1) withDishArray:self.dishesArray withOpenOrders:self.openOrders];
        if (index != -1){
            Dish *dish = self.dishesArray[index];
            
        
            cell.dishName.text = dish.name;
            cell.dishType.text = dish.type;
            cell.dishDescription.text = dish.dishDescription;
            PFFileObject *dishImageFile = (PFFileObject *)dish.image;
            [dishImageFile getDataInBackgroundWithBlock:^(NSData *imageData, NSError *error) {
                if(!error){
                    cell.image.image = [UIImage imageWithData:imageData];
                }
            }];
        }
        cell.index = (int)indexPath.row - 1;
        cell.customerComments = self.customerComments;
        
        cell.delegate = self;
        cell.amount.text = [NSString stringWithFormat:@"%@", amount];
        
        cell.customerRating.value = ([self.customerRatings[indexPath.row - 1] floatValue]/ 2);
        return cell;
    }
}

- (void)waiterComment:(NSString *)comment{
    self.waiterComments = comment;
}

- (void)waiterRating:(NSNumber *)rating{
    self.waiterRatingNum = [NSNumber numberWithDouble:(2*[rating doubleValue])];
}
//- (IBAction)changeWaiterRating:(HCSStarRatingView *)sender {
//    NSLog(@"%f", sender.value);
//    self.waiterRatingNum = [NSNumber numberWithDouble:(2*sender.value)];
//}

//-(void)textViewDidChange:(UITextView *)textView{
//    //self.customerOrder[0].waiterReview = self.waiterComments.text;
//    //handle text editing finished
//}
//
//- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
//    int characterLimit = 140;
//    NSString *newText = [self.waiterComments.text stringByReplacingCharactersInRange:range withString:text];
//    self.charsRemaining.text = [NSString stringWithFormat: @"%d", (int)(characterLimit - newText.length)];
//    return newText.length < characterLimit;
//}


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
    NSLog(@"%d", self.waiterComments==nil);
    if (!(self.waiterComments==nil || [self.waiterComments isEqualToString:@""])){
        self.waiter.comments = [self.waiter.comments arrayByAddingObject:self.waiterComments];
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
