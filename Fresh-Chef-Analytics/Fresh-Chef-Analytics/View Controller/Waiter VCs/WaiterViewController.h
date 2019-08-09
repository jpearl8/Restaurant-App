//
//  WaiterViewController.h
//  
//
//  Created by jpearl on 7/16/19.
//

#import <UIKit/UIKit.h>
#import "EditOrderViewController.h"


NS_ASSUME_NONNULL_BEGIN

@interface WaiterViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIButton *button;
@property (weak, nonatomic) IBOutlet UITableView *waiterTable;
- (IBAction)selectedWaiter:(UIButton *)sender;
@property (strong, nonatomic) NSNumber *customerLevelNumber;
@property (strong, nonatomic) NSString *customerEmail;
@property (strong, nonatomic) IBOutlet UIButton *customerLevel;
@property (nonatomic, weak) id <VCDelegate> vcDelegate;
@end

NS_ASSUME_NONNULL_END
