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


@interface FunFormViewController () <UITableViewDelegate, UITableViewDataSource, UITextViewDelegate, FunCellDelegate>
@property (weak, nonatomic) IBOutlet UITableView *menuRatings;
@property (weak, nonatomic) IBOutlet UILabel *waiterNameLabel;
@property (weak, nonatomic) IBOutlet UITextView *waiterComments;
@property (weak, nonatomic) IBOutlet UILabel *charsRemaining;
@property (strong, nonatomic) NSNumber *waiterRating;
@property (weak, nonatomic) IBOutlet UIImageView *waiterPic;
@property (strong, nonatomic) NSMutableArray *customerRatingsArray;
@property (strong, nonatomic) NSMutableArray *customerComments;


@property (weak, nonatomic) IBOutlet UIButton *b010;
@property (weak, nonatomic) IBOutlet UIButton *b08;
@property (weak, nonatomic) IBOutlet UIButton *b06;
@property (weak, nonatomic) IBOutlet UIButton *b04;
@property (weak, nonatomic) IBOutlet UIButton *b02;
@property (weak, nonatomic) IBOutlet UIButton *b00;

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
    self.waiterNameLabel.text = self.waiter.name;
    self.waiterComments.delegate = self;
    self.waiterComments.placeholder = @"Comments on your waiter";
    self.waiterComments.placeholderColor = [UIColor lightGrayColor];
    self.customerRatingsArray = [[NSMutableArray alloc] init];
    self.customerComments =[[NSMutableArray alloc] init];
    for (int i = 0; i < self.openOrders.count; i++){
        [self.customerRatingsArray addObject:[NSNull null]];
        [self.customerComments addObject:[NSNull null]];
    }
    self.customerComments = [[NSMutableArray alloc] init];
    // Do any additional setup after loading the view.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.openOrders.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FunTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: @"Fun" forIndexPath:indexPath];
    Dish *dish = self.dishArray[indexPath.row];
    NSNumber *amount = self.openOrders[indexPath.row].amount;

    cell.dishName.text = dish.name;
    cell.dishType.text = dish.type;
    cell.dishDescription.text = dish.dishDescription;
    cell.index = (int)indexPath.row;
    cell.customerRatings = self.customerRatingsArray;
    cell.customerComments = self.customerComments;

    cell.delegate = self;
    cell.amount.text = [NSString stringWithFormat:@"%@", amount];
    PFFileObject *dishImageFile = (PFFileObject *)dish.image;
    [dishImageFile getDataInBackgroundWithBlock:^(NSData *imageData, NSError *error) {
        if(!error){
            cell.image.image = [UIImage imageWithData:imageData];
        }
    }];
    NSArray <UIButton *>* buttons = @[cell.b0, cell.b2, cell.b4, cell.b6, cell.b8, cell.b10];
        for (int i = 0; i < buttons.count; i++){
            if (self.customerRatingsArray.count > 0 && self.customerRatingsArray[indexPath.row] == i*2){
                [[Helpful_funs shared] defineSelect:buttons[i] withSelect:YES];
                
            } else {
                [[Helpful_funs shared] defineSelect:buttons[i] withSelect:NO];
            }
        }
    return cell;
}


-(void)textViewDidChange:(UITextView *)textView{

    //handle text editing finished
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    int characterLimit = 140;
    NSString *newText = [self.waiterComments.text stringByReplacingCharactersInRange:range withString:text];
    self.charsRemaining.text = [NSString stringWithFormat: @"%d", (int)(characterLimit - newText.length)];
    return newText.length < characterLimit;
}


- (IBAction)buttonTouch:(UIButton *)sender {
    NSArray <UIButton *>* buttons = @[self.b00, self.b02, self.b04, self.b06, self.b08, self.b010];
    for (int i = 0; i < buttons.count; i++){
        if ([buttons[i].restorationIdentifier isEqualToString:sender.restorationIdentifier]){
            [[Helpful_funs shared] defineSelect:buttons[i] withSelect:YES];
            
        } else {
            [[Helpful_funs shared] defineSelect:buttons[i] withSelect:NO];
        }
    }
    if ([sender.restorationIdentifier floatValue]< 0){
        self.waiterRating = 0;
    } else{
        self.waiterRating = [NSNumber numberWithDouble:([sender.restorationIdentifier floatValue] / 10.0)];
    }
}

- (IBAction)didSubmit:(UIButton *)sender {
    for (int i = 0; i < self.openOrders.count; i++){
        float totalRating = [((Dish *)self.dishArray[i]).rating floatValue];
        if (!totalRating){
            totalRating = 0;
        }
        float placeHolder = 0;
        if (!([self.customerRatingsArray[i] isEqual:[NSNull null]])){
            placeHolder = [self.customerRatingsArray[i] floatValue];
        }
        ((Dish *)self.dishArray[i]).rating = [NSNumber numberWithFloat: ((placeHolder * [((NSNumber *)self.openOrders[i].amount) floatValue])  + totalRating)];
        if (!([self.customerComments[i] isEqualToString:@""])){
            ((Dish *)self.dishArray[i]).comments =[((Dish *)self.dishArray[i]).comments arrayByAddingObject:self.customerComments[i]];
        }
        float totalFrequency = [((Dish *)self.dishArray[i]).orderFrequency floatValue];
        ((Dish *)self.dishArray[i]).orderFrequency = [NSNumber numberWithFloat: ( [self.openOrders[i][@"amount"] floatValue] + totalFrequency)];
        NSLog(@"%@", ((Dish *)self.dishArray[i]));
        [((Dish *)self.dishArray[i]) saveInBackground];
        
    }
    float totalRating = [self.waiter.rating floatValue];
    if (!totalRating){
        totalRating = 0;
    }
    self.waiter.rating = [NSNumber numberWithFloat: ([self.waiterRating floatValue] + totalRating)];
    
    if (!([self.waiterComments.text isEqualToString:@""])){
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
    recVC.dishArray = self.dishArray;

    
    
}


@end
