//
//  FunFormViewController.h
//  Fresh-Chef-Analytics
//
//  Created by jpearl on 7/16/19.
//  Copyright © 2019 julia@ipearl.net. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "order.h"
#import "FunTableViewCell.h"


NS_ASSUME_NONNULL_BEGIN

@interface FunFormViewController : UIViewController

- (IBAction)didSubmit:(UIButton *)sender;
-(void) updateDishesWithOrder: ( NSMutableArray <order*> *)orderList;
@property (strong, nonatomic) NSMutableArray <order *>*customerOrder;
@property (strong, nonatomic) NSString *waiterName;
@property (strong, nonatomic) NSString *customerNumber;
@end

NS_ASSUME_NONNULL_END
