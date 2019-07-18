//
//  WaitTableViewCell.h
//  Fresh-Chef-Analytics
//
//  Created by jpearl on 7/17/19.
//  Copyright © 2019 julia@ipearl.net. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Dish.h"
#import "specialStepper.h"


NS_ASSUME_NONNULL_BEGIN

@interface WaitTableViewCell : UITableViewCell 
 
- (IBAction)didStep:(specialStepper *)sender;
@property (weak, nonatomic) IBOutlet specialStepper *stepper;


@property (nonatomic, strong) Dish *dish;
//   @property (weak, nonatomic) IBOutlet BEMCheckBox *checkBox;
    @property (weak, nonatomic) IBOutlet UIImageView *image;
    @property (weak, nonatomic) IBOutlet UILabel *name;
    @property (weak, nonatomic) IBOutlet UILabel *type;
    @property (weak, nonatomic) IBOutlet UILabel *dishDescription;
    @property (weak, nonatomic) IBOutlet UITextField *amount;
- (void) prepareForReuse;
@end

NS_ASSUME_NONNULL_END
