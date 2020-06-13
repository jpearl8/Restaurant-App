//
//  ProfitTrendsViewController.h
//  Fresh-Chef-Analytics
//
//  Created by rgallardo on 7/26/19.
//  Copyright © 2019 julia@ipearl.net. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PNChart.h"
#import "PNLineChart.h"

NS_ASSUME_NONNULL_BEGIN

@interface ProfitTrendsViewController : UIViewController <UIPickerViewDelegate, UIPickerViewDataSource, PNChartDelegate>
@property (strong, nonatomic) NSString *timeSpanSelected;
@property (strong, nonatomic) NSString *selectedDataDisplay;
@end

NS_ASSUME_NONNULL_END
