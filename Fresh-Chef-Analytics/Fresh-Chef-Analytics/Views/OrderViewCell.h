//
//  OrderViewCell.h
//  Fresh-Chef-Analytics
//
//  Created by jpearl on 7/28/19.
//  Copyright © 2019 julia@ipearl.net. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OpenOrder.h"

NS_ASSUME_NONNULL_BEGIN
@protocol OrderViewCellDelegate <NSObject>
- (void)editForIndex:(NSNumber *)index;
- (void)completeForIndex:(NSNumber *)index;
-(void)orderForIndex:(NSIndexPath *)indexPath;
@property (strong, nonatomic) NSArray<Dish *>*dishArray;
@property (strong, nonatomic) Waiter* waiter;
@property (strong, nonatomic) NSArray<OpenOrder *>* openOrders;
@end


@interface OrderViewCell : UITableViewCell
@property (assign, nonatomic) NSNumber *index;
@property (strong, nonatomic) IBOutlet UIButton *ordersButton;
@property (strong, nonatomic) NSIndexPath *indexPath;
@property (strong, nonatomic) IBOutlet UIButton *customerLevel;
@property (nonatomic, weak) id <OrderViewCellDelegate> delegate;
@property (nonatomic, weak) IBOutlet UIButton *edit;
@property (nonatomic, weak) IBOutlet UIButton *complete;
@property (nonatomic, weak) IBOutlet UIView *myContentView;

@property (nonatomic, strong) NSString *itemText;
- (void)openCell;
@property (strong, nonatomic) NSArray<OpenOrder *>* openOrders;
@property (weak, nonatomic) IBOutlet UILabel *tableNumber;
@property (weak, nonatomic) IBOutlet UILabel *customerNumber;
@property (weak, nonatomic) IBOutlet UILabel *waiterName;
@property (strong, nonatomic) Waiter* waiter;
@property (strong, nonatomic) IBOutlet UILabel *dishes;
@property (strong, nonatomic) IBOutlet UILabel *amounts;
@property (assign, nonatomic) BOOL isExpanded;

@end

NS_ASSUME_NONNULL_END
