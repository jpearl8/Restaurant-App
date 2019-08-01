//
//  ProfitTrendsViewController.m
//  Fresh-Chef-Analytics
//
//  Created by rgallardo on 7/26/19.
//  Copyright © 2019 julia@ipearl.net. All rights reserved.
//

#import "ProfitTrendsViewController.h"
#import "OrderManager.h"
//#import "FCADate.h"

@interface ProfitTrendsViewController ()
@property (weak, nonatomic) IBOutlet UIView *dataView;
@property (weak, nonatomic) IBOutlet UIPickerView *categoryPicker;
@property (strong, nonatomic) NSMutableDictionary *profitByDay;
@property (strong, nonatomic) NSMutableArray *currentXLabels;
@property (strong, nonatomic) NSMutableArray *currentYLabels;
@property (strong, nonatomic) NSMutableArray *currentDataArray;
@property (strong, nonatomic) NSMutableArray *dates;
@property (strong, nonatomic) NSArray *timeRange;
@property (strong, nonatomic) NSArray *timeSpans;

@end

@implementation ProfitTrendsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.categoryPicker.delegate = self;
    self.categoryPicker.dataSource = self;
    self.profitByDay = [[OrderManager shared] profitByDateTest];
    self.currentXLabels = [[NSMutableArray alloc] init];
    self.currentDataArray = [[NSMutableArray alloc] init];
    self.timeSpans = @[@"Week", @"Month", @"Year"];
    [self setGraph];
}




/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (NSInteger)numberOfComponentsInPickerView:(nonnull UIPickerView *)pickerView {
    return 2;
}

- (NSInteger)pickerView:(nonnull UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (component == 0) {
        return [self.timeSpans count];
    } else {
        return 3; // profit, busyness, both
    }
}

- (void)setGraph
{
    
    PNLineChart * lineChart = [[PNLineChart alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH * 0.9, 250.0)];
    
    // Set x labels
    // if week is selected, labels = days of week

    NSArray *unsortedArr1 = [self.profitByDay allKeys];
    self.currentXLabels = [[unsortedArr1 sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)] mutableCopy];
    for(NSString *key in self.currentXLabels){
        [self.currentDataArray addObject:self.profitByDay[key]];
        //        NSLog(@"%@, %@", key, dict[key]);
    }
    // check selected Timespan then set x labels appropriately
    
    // Make this Profit
//    NSArray * data01Array = @[@60.1, @160.1, @126.4, @262.2, @186.2, @100.1, @100.0];
    int startIdx = 0;
    int range = [self.currentDataArray count] - 1;
    
    NSArray * data01Array = [self.currentDataArray subarrayWithRange:NSMakeRange(startIdx, range)];
    [lineChart setXLabels:[self.currentXLabels subarrayWithRange:NSMakeRange(startIdx, range)]];
    PNLineChartData *data01 = [PNLineChartData new];
    data01.color = PNFreshGreen;
    data01.itemCount = lineChart.xLabels.count;
    data01.getData = ^(NSUInteger index) {
        CGFloat yValue = [data01Array[index] floatValue];
        return [PNLineChartDataItem dataItemWithY:yValue];
    };
    
    // Make this Crowdedness
//    NSArray * data02Array = @[@20.1, @180.1, @26.4, @202.2, @126.2, @202.2, @126.2];
//    PNLineChartData *data02 = [PNLineChartData new];
//    data02.color = PNTwitterColor;
//    data02.itemCount = lineChart.xLabels.count;
//    data02.getData = ^(NSUInteger index) {
//        CGFloat yValue = [data02Array[index] floatValue];
//        return [PNLineChartDataItem dataItemWithY:yValue];
//    };
    
    lineChart.chartData = @[data01];
    [lineChart strokeChart];
    lineChart.showSmoothLines = YES;
    
    [self.dataView addSubview:lineChart];
    
    
}

@end
