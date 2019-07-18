//
//  FunFormViewController.m
//  Fresh-Chef-Analytics
//
//  Created by jpearl on 7/16/19.
//  Copyright © 2019 julia@ipearl.net. All rights reserved.
//

#import "FunFormViewController.h"

@interface FunFormViewController () <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *menuRatings;
@property (weak, nonatomic) IBOutlet UILabel *waiterNameLabel;

@property (weak, nonatomic) IBOutlet UIImageView *waiterPic;

@end

@implementation FunFormViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.menuRatings.delegate = self;
    self.menuRatings.dataSource = self;
    self.waiterNameLabel.text = self.waiterName;
    
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
    [self updateDishesWithOrder:self.customerOrder];
     [self performSegueWithIdentifier:@"toReceipt" sender:nil];
}
- (void) updateDishesWithOrder: ( NSMutableArray <order*> *)orderList{
    for (int i = 0; i < orderList.count; i++){
        if (orderList[i].customerRating != -1){
            float totalRating = [orderList[i].dish.rating floatValue];
            orderList[i].dish.rating = [NSNumber numberWithFloat: (orderList[i].customerRating + totalRating)];
        }
        if (!([orderList[i].customerComments isEqualToString:@""])){
            orderList[i].dish.comments=[orderList[i].dish.comments arrayByAddingObject:orderList[i].customerComments];
        }
        float totalFrequency = [orderList[i].dish.orderFrequency floatValue];
        orderList[i].dish.orderFrequency = [NSNumber numberWithFloat: (orderList[i].amount + totalFrequency)];
        [orderList[i].dish saveInBackground];
    }
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


@end
