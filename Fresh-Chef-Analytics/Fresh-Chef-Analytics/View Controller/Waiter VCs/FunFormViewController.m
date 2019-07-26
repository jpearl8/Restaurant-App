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
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    return self.openOrder.amounts.count;
//}
//
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    FunTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: @"Fun"];
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
//    NSArray <UIButton *>* buttons = @[cell.b0, cell.b2, cell.b4, cell.b6, cell.b8, cell.b10];
//        for (int i = 0; i < buttons.count; i++){
//            if ((int)cell.customerRatings[indexPath.row] == i*2){
//                [[Helpful_funs shared] defineSelect:buttons[i] withSelect:YES];
//                
//            } else {
//                [[Helpful_funs shared] defineSelect:buttons[i] withSelect:NO];
//            }
//        }
//    return cell;
//}
//
//
//-(void)textViewDidChange:(UITextView *)textView{
//    self.customerOrder[0].waiterReview = self.waiterComments.text;
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
//
//- (IBAction)didSubmit:(UIButton *)sender {
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
//    self.openOrder.waiter.rating = [NSNumber numberWithFloat: ([self.waiterRating floatValue] + totalRating)];
//    
//    if (!([self.waiterComments.text isEqualToString:@""])){
//        self.openOrder.waiter.comments =[self.openOrder.waiter.comments arrayByAddingObject:self.waiterComments.text];
//    }
//    float numOfCustomers = [self.openOrder.waiter.numOfCustomers floatValue];
//    self.openOrder.waiter.numOfCustomers = [NSNumber numberWithFloat: ([self.customerNumber floatValue] + numOfCustomers)];
//    self.openOrder.waiter.tableTops = [NSNumber numberWithFloat: ([self.openOrder.waiter.tableTops floatValue] + 1)];
//    [self.openOrder.waiter saveInBackground];
//    
//    [self performSegueWithIdentifier:@"toReceipt" sender:self];
//}
//
//- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
//    ReceiptViewController *recVC = [segue destinationViewController];
//    recVC.customerOrder = self.customerOrder;
//    recVC.openOrder = self.openOrder;
//    
//    
//}


@end
