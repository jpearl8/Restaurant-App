//
//  WaitTableViewCell.h
//  Fresh-Chef-Analytics
//
//  Created by jpearl on 7/17/19.
//  Copyright © 2019 julia@ipearl.net. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Dish.h"
#import "BEMCheckBox.h"

NS_ASSUME_NONNULL_BEGIN

@interface WaitTableViewCell : UITableViewCell 
    @property (assign, nonatomic) int orderAmount;

- (IBAction)didStep:(UIStepper *)sender;

@property (nonatomic, strong) Dish *dish;
//   @property (weak, nonatomic) IBOutlet BEMCheckBox *checkBox;
    @property (weak, nonatomic) IBOutlet UIImageView *image;
    @property (weak, nonatomic) IBOutlet UILabel *name;
    @property (weak, nonatomic) IBOutlet UILabel *type;
    @property (weak, nonatomic) IBOutlet UILabel *dishDescription;
    @property (weak, nonatomic) IBOutlet UITextField *amount;

@end

NS_ASSUME_NONNULL_END
