//
//  ReceiptViewController.h
//  Fresh-Chef-Analytics
//
//  Created by jpearl on 7/16/19.
//  Copyright © 2019 julia@ipearl.net. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "order.h"
#import "OpenOrder.h"
#import "ClosedOrder.h"

NS_ASSUME_NONNULL_BEGIN

@interface ReceiptViewController : UIViewController
@property (strong, nonatomic) NSMutableArray <order *>* customerOrder;
@property (strong, nonatomic) OpenOrder *openOrder;
@end

NS_ASSUME_NONNULL_END
