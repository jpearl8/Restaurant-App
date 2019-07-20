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

@property (weak, nonatomic) IBOutlet UIImageView *waiterPic;
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
    [[Helpful_funs shared] updateWithOrder:self.customerOrder withNumberString:self.customerNumber];
     [self performSegueWithIdentifier:@"toReceipt" sender:self];
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
        self.customerOrder[0].waiterRating = 0;
    } else{
    self.customerOrder[0].waiterRating = [sender.restorationIdentifier floatValue] / 10.0;
    }
}






@end
