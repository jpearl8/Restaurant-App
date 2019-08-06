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
@protocol StepperCell  <NSObject>
-(void)stepperIncrement:(double)amount withDish:(Dish*)dish;

@end
@interface WaitTableViewCell : UITableViewCell 



@property (strong, nonatomic) IBOutlet UIButton *plus;
- (IBAction)plusDish:(UIButton *)sender;

- (IBAction)minusDish:(UIButton *)sender;

@property (strong, nonatomic) IBOutlet UIButton *minus;



@property (nonatomic, strong) Dish *dish;
//   @property (weak, nonatomic) IBOutlet BEMCheckBox *checkBox;
    @property (weak, nonatomic) IBOutlet UIImageView *image;
    @property (nonatomic, weak) id <StepperCell> delegate;
    @property (weak, nonatomic) IBOutlet UILabel *name;
    @property (weak, nonatomic) IBOutlet UILabel *type;
    @property (weak, nonatomic) IBOutlet UILabel *dishDescription;
    @property (weak, nonatomic) IBOutlet UITextField *amount;
@property (nonatomic, assign) double value;
- (void) prepareForReuse;
@end

NS_ASSUME_NONNULL_END
