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


@interface ElegantFormViewController () <UITableViewDelegate, UITableViewDataSource, UITextViewDelegate, ElegantCellDelegate>
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
    //[self.waiterRating setThumbImage:[UIImage imageNamed:@"thumb_image"] forState:UIControlStateNormal];
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
    ElegantTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: @"Elegant"];
    NSNumber *amount = self.openOrders[indexPath.row][@"amount"];
    int index = [[Helpful_funs shared] findDishItem:(int)indexPath.row withDishArray:self.dishesArray withOpenOrders:self.openOrders];
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

    cell.index = (int)indexPath.row;
    cell.customerRatings = self.customerRatings;
    cell.customerComments = self.customerComments;
    cell.delegate = self;
    cell.amount.text = [NSString stringWithFormat:@"%@", amount];
    cell.customerRating.value = 5;
    cell.customerRating.value = [self.customerRatings[indexPath.row] floatValue];
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
   // self.customerOrder[0].waiterRating = sender.value;
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
    self.waiter.rating = [NSNumber numberWithFloat: (self.waiterRating.value  + totalRating)];
    
    if (!([self.waiterComments.text isEqual:[NSNull null]] || [self.waiterComments.text isEqualToString:@""])){
        self.waiter.comments =[self.waiter.comments arrayByAddingObject:self.waiterComments.text];
    }
    float numOfCustomers = [self.waiter.numOfCustomers floatValue];
    self.waiter.numOfCustomers = [NSNumber numberWithFloat: ([self.customerNumber floatValue] + numOfCustomers)];
    self.waiter.tableTops = [NSNumber numberWithFloat: ([self.waiter.tableTops floatValue] + 1)];
    NSLog(@"%@", self.waiter);
    [self.waiter saveInBackground];
    
    [self performSegueWithIdentifier:@"toReceipt" sender:self];
    
}
- (void)customerCommentForIndex:(int)index withComment:(NSString *)comment{
    self.customerComments[index] = comment;
}
- (void)customerRatingForIndex:(int)index withRating:(NSNumber *)rating{
    self.customerRatings[index] = rating;
}
- (IBAction)onTap:(id)sender {
    [self.view endEditing:(YES)];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    ReceiptViewController *recVC = [segue destinationViewController];
    recVC.openOrders = self.openOrders;
    recVC.waiter = self.waiter;
    recVC.dishesArray = self.dishesArray;
    
}
@end
