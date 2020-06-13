//
//  FunFormViewController.m
//  Fresh-Chef-Analytics
//
//  Created by jpearl on 7/16/19.
//  Copyright © 2019 julia@ipearl.net. All rights reserved.
//

#import "FunFormViewController.h"
#import "ReceiptViewController.h"
#import "Helpful_funs.h"
#import "WaiterCell.h"
#import "UIRefs.h"


@interface FunFormViewController () <UITableViewDelegate, UITableViewDataSource, UITextViewDelegate, FunCellDelegate>

@property (weak, nonatomic) IBOutlet UITableView *menuRatings;
//@property (weak, nonatomic) IBOutlet UILabel *waiterNameLabel;
//@property (weak, nonatomic) IBOutlet UITextView *waiterComments;
//@property (weak, nonatomic) IBOutlet UILabel *charsRemaining;
@property (strong, nonatomic) NSNumber *waiterRating;
//@property (weak, nonatomic) IBOutlet UIImageView *waiterPic;
@property (strong, nonatomic) NSMutableArray *customerRatingsArray;
@property (strong, nonatomic) NSMutableArray *customerComments;
@property (strong, nonatomic) NSString *waiterComments;

//@property (weak, nonatomic) IBOutlet UIButton *b010;
//@property (weak, nonatomic) IBOutlet UIButton *b08;
//@property (weak, nonatomic) IBOutlet UIButton *b06;
//@property (weak, nonatomic) IBOutlet UIButton *b04;
//@property (weak, nonatomic) IBOutlet UIButton *b02;
//@property (weak, nonatomic) IBOutlet UIButton *b00;

@end

@implementation FunFormViewController
//
//@property (nonatomic, strong) NSArray *dishes;
//@property (nonatomic, strong) NSArray *amounts;
//@property (nonatomic, strong) Waiter *waiter;
//@property (nonatomic, strong) PFUser *restaurant;
//@property (nonatomic, strong) NSString *restaurantId;
//@property (nonatomic, strong) NSNumber *table;
//@property (nonatomic, strong) NSNumber *numCustomers;
- (void)viewDidLoad {
    [super viewDidLoad];
    //[self.waiter fetchIfNeeded];
    self.menuRatings.delegate = self;
    self.menuRatings.dataSource = self;
//    self.waiterNameLabel.text = self.waiter.name;
//    self.waiterComments.delegate = self;
//    self.waiterComments.placeholder = @"Comments on your waiter";
//    self.waiterComments.placeholderColor = [UIColor lightGrayColor];
    
    self.customerRatingsArray = [[NSMutableArray alloc] init];
    self.customerComments =[[NSMutableArray alloc] init];
    for (int i = 0; i < self.openOrders.count; i++){
        [self.customerRatingsArray addObject:[NSNull null]];
        [self.customerComments addObject:[NSNull null]];
    }
    
    // Do any additional setup after loading the view.
}
- (IBAction)onTap:(id)sender {
    [self.view endEditing:(YES)];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return (self.openOrders.count + 1);
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0){
        return 223;
    } else {
        return 250;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0){
        WaiterCell *cell = [tableView dequeueReusableCellWithIdentifier: @"Waiter" forIndexPath:indexPath];
        cell.waiter = self.waiter;
        cell.waiterDelegate = self;
        cell.aView.layer.borderWidth = .5f;
        cell.aView.layer.borderColor = [[UIRefs shared] colorFromHexString:[UIRefs shared].purpleAccent].CGColor;
        cell.waiterNameLabel.text = cell.waiter.name;
        PFFileObject *waiterImageFile = (PFFileObject *)self.waiter.image;
        [waiterImageFile getDataInBackgroundWithBlock:^(NSData *imageData, NSError *error) {
            if(!error){
                cell.waiterPic.image = [UIImage imageWithData:imageData];
            }
        }];
        return cell;
    } else {
        FunTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: @"Fun1" forIndexPath:indexPath];
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
        cell.customerRatings = self.customerRatingsArray;
        cell.customerComments = self.customerComments;
        cell.funDelegate = self;
        cell.amount.text = [NSString stringWithFormat:@"%@", amount];
        cell.specialView.layer.borderWidth = .5f;
        cell.specialView.layer.borderColor = [[UIRefs shared] colorFromHexString:[UIRefs shared].purpleAccent].CGColor;
        NSArray <UIButton *>* buttons = @[cell.b0, cell.b2, cell.b4, cell.b6, cell.b8, cell.b10];
            for (int i = 0; i < buttons.count; i++){
                if (self.customerRatingsArray.count > 0 && (int)self.customerRatingsArray[indexPath.row - 1] == i*2){
                    [[Helpful_funs shared] defineSelect:buttons[i] withSelect:YES];
                    
                } else {
                    [[Helpful_funs shared] defineSelect:buttons[i] withSelect:NO];
                }
            }
        return cell;
    }
}

- (void)waiterComment:(NSString *)comment{
    self.waiterComments = comment;
}

- (void)waiterRating:(NSNumber *)rating{
    self.waiterRating = [NSNumber numberWithDouble:([rating doubleValue])];
}
//-(void)textViewDidChange:(UITextView *)textView{
//
//    //handle text editing finished
//}
//
//- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
//    int characterLimit = 140;
//    NSString *newText = [self.waiterComments.text stringByReplacingCharactersInRange:range withString:text];
//    self.charsRemaining.text = [NSString stringWithFormat: @"%d", (int)(characterLimit - newText.length)];
//    return newText.length < characterLimit;
//}
//
//
//- (IBAction)buttonTouch:(UIButton *)sender {
//    NSArray <UIButton *>* buttons = @[self.b00, self.b02, self.b04, self.b06, self.b08, self.b010];
//    for (int i = 0; i < buttons.count; i++){
//        if ([buttons[i].restorationIdentifier isEqualToString:sender.restorationIdentifier]){
//            [[Helpful_funs shared] defineSelect:buttons[i] withSelect:YES];
//
//        } else {
//            [[Helpful_funs shared] defineSelect:buttons[i] withSelect:NO];
//        }
//    }
//    if ([sender.restorationIdentifier floatValue]< 0){
//        self.waiterRating = 0;
//    } else{
//        self.waiterRating = [NSNumber numberWithDouble:([sender.restorationIdentifier floatValue] / 10.0)];
//    }
//}

- (IBAction)didSubmit:(UIButton *)sender {
    for (int i = 0; i < self.openOrders.count; i++){
        float totalRating = [((Dish *)self.dishesArray[i]).rating floatValue];
        if (!totalRating){
            totalRating = 0;
        }
        float placeHolder = 0;
        if (!([self.customerRatingsArray[i] isEqual:[NSNull null]])){
            placeHolder = [self.customerRatingsArray[i] floatValue];
        }
        ((Dish *)self.dishesArray[i]).rating = [NSNumber numberWithFloat: ((placeHolder * [((NSNumber *)self.openOrders[i].amount) floatValue])  + totalRating)];
        if (!([self.customerComments[i] isEqual:[NSNull null]] || [self.customerComments[i] isEqualToString:@""])){
            ((Dish *)self.dishesArray[i]).comments =[((Dish *)self.dishesArray[i]).comments arrayByAddingObject:self.customerComments[i]];
        }
        float totalFrequency = [((Dish *)self.dishesArray[i]).orderFrequency floatValue];
        ((Dish *)self.dishesArray[i]).orderFrequency = [NSNumber numberWithFloat: ( [self.openOrders[i][@"amount"] floatValue] + totalFrequency)];
        [((Dish *)self.dishesArray[i]) saveInBackground];
        
    }
    float totalRating = [self.waiter.rating floatValue];
    if (!totalRating){
        totalRating = 0;
    }
    self.waiter.rating = [NSNumber numberWithFloat: ([self.waiterRating floatValue] + totalRating)];
    
    if (!(self.waiterComments == nil || [self.waiterComments isEqualToString:@""])){
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
    self.customerRatingsArray[index] = rating;

    //[self.customerRatingsArray replaceObjectAtIndex:index withObject:rating];
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
   ReceiptViewController *recVC = [segue destinationViewController];
    recVC.openOrders = self.openOrders;
    recVC.waiter = self.waiter;
    recVC.dishesArray = self.dishesArray;

    
    
}




@end
