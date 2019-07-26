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


@interface FunFormViewController () <UITableViewDelegate, UITableViewDataSource, UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *menuRatings;
@property (weak, nonatomic) IBOutlet UILabel *waiterNameLabel;
@property (weak, nonatomic) IBOutlet UITextView *waiterComments;
@property (weak, nonatomic) IBOutlet UILabel *charsRemaining;
@property (strong, nonatomic) NSNumber *waiterRating;
@property (weak, nonatomic) IBOutlet UIImageView *waiterPic;
@property (strong, nonatomic) NSMutableArray *customerRatings;
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
    FunTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: @"Fun"];
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
    [dishImageFile getDataInBackgroundWithBlock:^(NSData *imageData, NSError *error) {
        if(!error){
            cell.image.image = [UIImage imageWithData:imageData];
        }
    }];
    NSArray <UIButton *>* buttons = @[cell.b0, cell.b2, cell.b4, cell.b6, cell.b8, cell.b10];
        for (int i = 0; i < buttons.count; i++){
            if ((int)cell.customerRatings[indexPath.row] == i*2){
                [[Helpful_funs shared] defineSelect:buttons[i] withSelect:YES];
                
            } else {
                [[Helpful_funs shared] defineSelect:buttons[i] withSelect:NO];
            }
        }
    return cell;
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
    self.openOrders[0].waiter.rating = [NSNumber numberWithFloat: ([self.waiterRating floatValue] + totalRating)];
    
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
    recVC.customerOrder = self.customerOrder;
    recVC.openOrders = self.openOrders;
    
    
}


@end
