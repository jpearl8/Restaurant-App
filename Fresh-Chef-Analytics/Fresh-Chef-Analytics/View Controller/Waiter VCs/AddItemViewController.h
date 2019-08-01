//
//  AddItemViewController.h
//  Fresh-Chef-Analytics
//
//  Created by jpearl on 7/31/19.
//  Copyright © 2019 julia@ipearl.net. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OpenOrder.h"

NS_ASSUME_NONNULL_BEGIN
@protocol AddOrdersDelegate <NSObject>
-(void)addOpenOrders:(NSMutableArray <OpenOrder *>*)additionalOrders;
@property (strong, nonatomic) Waiter *waiter;
@property (strong, nonatomic) NSNumber *table;
@property (strong, nonatomic) NSNumber *customerNum;
@end

@interface AddItemViewController : UIViewController
@property (nonatomic, weak) id <AddOrdersDelegate> delegate;


@end

NS_ASSUME_NONNULL_END
