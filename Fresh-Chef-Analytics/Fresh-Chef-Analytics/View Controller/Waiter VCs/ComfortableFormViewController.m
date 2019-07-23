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

@end

@implementation ComfortableFormViewController

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
    ComfortableTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: @"Comfortable"];
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
    cell.customerRating.value = (order.customerRating / 2);
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

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    ReceiptViewController *recVC = [segue destinationViewController];
    recVC.customerOrder = self.customerOrder;
    
}

- (IBAction)didSubmit:(UIButton *)sender {
    [[Helpful_funs shared] updateWithOrder:self.customerOrder withNumberString:self.customerNumber];
    [self performSegueWithIdentifier:@"toReceipt" sender:self];
}

- (IBAction)changeWaiterRating:(HCSStarRatingView *)sender {
    NSLog(@"%f", sender.value);
    self.customerOrder[0].waiterRating = 2*sender.value;
}

@end
