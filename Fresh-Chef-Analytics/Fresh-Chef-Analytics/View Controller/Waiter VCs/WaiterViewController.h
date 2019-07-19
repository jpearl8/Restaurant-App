//
//  WaiterViewController.h
//  
//
//  Created by jpearl on 7/16/19.
//

#import <UIKit/UIKit.h>


NS_ASSUME_NONNULL_BEGIN

@interface WaiterViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIButton *button;
@property (weak, nonatomic) IBOutlet UITableView *waiterTable;
- (UIColor *)colorFromHexString:(NSString *)hexString;
- (IBAction)selectedWaiter:(UIButton *)sender;

@end

NS_ASSUME_NONNULL_END
