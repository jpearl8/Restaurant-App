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

-(Waiter *)getWaiter;
-(NSNumber *)getTable;
-(NSNumber *)getCustomerNum;
-(NSMutableArray <OpenOrder *>*)getEditableOpenOrders;
-(NSArray <OpenOrder *>*)getOldOpenOrders;

@end

@interface AddItemViewController : UIViewController
@property (nonatomic, weak) id <AddOrdersDelegate> delegate;
@property (strong, nonatomic) NSNumber *index;
@property (strong, nonatomic) NSArray <OpenOrder *>* openOrders;


@end

NS_ASSUME_NONNULL_END
