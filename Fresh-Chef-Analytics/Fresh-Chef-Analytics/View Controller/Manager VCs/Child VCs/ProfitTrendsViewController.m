//
//  ProfitTrendsViewController.m
//  Fresh-Chef-Analytics
//
//  Created by rgallardo on 7/26/19.
//  Copyright © 2019 julia@ipearl.net. All rights reserved.
//

#import "ProfitTrendsViewController.h"
#import "OrderManager.h"
#import "PNChartDelegate.h"

@interface ProfitTrendsViewController ()
@property (weak, nonatomic) IBOutlet UIView *dataView;
@property (weak, nonatomic) IBOutlet UIPickerView *categoryPicker;
@property (strong, nonatomic) PNLineChart *lineChart;
@property (strong, nonatomic) UIView *legend;
@property (strong, nonatomic) UIBezierPath *vertLine;
@property (strong, nonatomic) CAShapeLayer *vertShapeLayer;
@property (strong, nonatomic) NSMutableDictionary *profitByDay;
@property (strong, nonatomic) NSMutableDictionary *busynessByDay;
@property (strong, nonatomic) NSMutableArray *currentXLabels;
@property (strong, nonatomic) NSMutableArray *originalXLabels;
@property (strong, nonatomic) NSMutableArray *profitDataArray;
@property (strong, nonatomic) NSMutableArray *originalProfit;
@property (strong, nonatomic) NSMutableArray *busynessDataArray;
@property (strong, nonatomic) NSMutableArray *originalBusyness;

// Corrected arrays used for displaying data so they only have values
// for the points displayed on the plot
@property (strong, nonatomic) NSMutableArray *correctedWeekXLabels;
@property (strong, nonatomic) NSMutableArray *correctedWeekProfit;
@property (strong, nonatomic) NSMutableArray *correctedWeekBusyness;

@property (strong, nonatomic) NSMutableArray *correctedMonthXLabels;
@property (strong, nonatomic) NSMutableArray *correctedMonthProfit;
@property (strong, nonatomic) NSMutableArray *correctedMonthBusyness;

@property (strong, nonatomic) NSMutableArray *correctedYearXLabels;
@property (strong, nonatomic) NSMutableArray *correctedYearProfit;
@property (strong, nonatomic) NSMutableArray *correctedYearBusyness;

@property (strong, nonatomic) NSMutableArray *dates;
@property (strong, nonatomic) NSArray *timeSpans;
@property (strong, nonatomic) NSArray *dataCategories;
@property (weak, nonatomic) IBOutlet UILabel *selectedPointLabel;

@end

@implementation ProfitTrendsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.categoryPicker.delegate = self;
    self.categoryPicker.dataSource = self;
    self.profitByDay = [[NSMutableDictionary alloc] init];
    self.profitByDay = [[OrderManager shared] profitByDateTest];
    self.originalProfit = [[NSMutableArray alloc] init];
    self.originalProfit = [[OrderManager shared] originalProfitByDate];
    self.busynessByDay = [[NSMutableDictionary alloc] init];
    self.busynessByDay = [[OrderManager shared] busynessByDateTest];
    self.originalBusyness = [[NSMutableArray alloc] init];
    self.originalBusyness = [[OrderManager shared] originalBusynessByDate];
    self.originalXLabels = [[NSMutableArray alloc] init];
    self.originalXLabels = [[OrderManager shared] originalXLabels];
    self.currentXLabels = [[NSMutableArray alloc] init];
    self.profitDataArray = [[NSMutableArray alloc] init];
    self.busynessDataArray = [[NSMutableArray alloc] init];
    self.timeSpans = @[@"Week", @"Month", @"Year"];
    self.dataCategories = @[@"Revenue", @"Busyness", @"Both"];
    self.timeSpanSelected = @"Week";
    self.selectedDataDisplay = @"Revenue";
    // initialize vertical line
    self.vertLine = [UIBezierPath bezierPath];
    self.vertShapeLayer = [CAShapeLayer layer];
    
    [self setupData];
    [self loadGraph];
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
        return [self.dataCategories count]; // profit, busyness, both
    }
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (component == 0) {
        return self.timeSpans[row];
    } else if (component == 1) {
        return self.dataCategories[row];
    } else {
        NSLog(@"There shouldn't be a component in the picker at: %ld", (long)component);
        return nil;
    }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    NSString *timeSpanSelected = [self.timeSpans objectAtIndex:[self.categoryPicker selectedRowInComponent:0]];
    self.timeSpanSelected = timeSpanSelected;
    NSString *selectedDataDisplay = [self.dataCategories objectAtIndex:[self.categoryPicker selectedRowInComponent:1]];
    self.selectedDataDisplay = selectedDataDisplay;
    // change display based on picked picker
    
    [self loadGraph];
}

- (void)setupData
{
    NSArray *unsortedArr1 = [self.profitByDay allKeys];
    self.currentXLabels = [[unsortedArr1 sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)] mutableCopy];
    for(NSString *key in self.currentXLabels){
        [self.profitDataArray addObject:self.profitByDay[key]];
        [self.busynessDataArray addObject:self.busynessByDay[key]];
    }
    
    self.correctedWeekXLabels = [[NSMutableArray alloc] init];
    self.correctedWeekProfit = [[NSMutableArray alloc] init];
    self.correctedWeekBusyness = [[NSMutableArray alloc] init];
    [self makeCorrectedXLabelArr:self.correctedWeekXLabels andProfitArr:self.correctedWeekProfit andBusyArr:self.correctedWeekBusyness overDays:7];
    self.correctedMonthXLabels = [[NSMutableArray alloc] init];
    self.correctedMonthProfit = [[NSMutableArray alloc] init];
    self.correctedMonthBusyness = [[NSMutableArray alloc] init];
    [self makeCorrectedXLabelArr:self.correctedMonthXLabels andProfitArr:self.correctedMonthProfit andBusyArr:self.correctedMonthBusyness overDays:30];
    self.correctedYearXLabels = [[NSMutableArray alloc] init];
    self.correctedYearProfit = [[NSMutableArray alloc] init];
    self.correctedYearBusyness = [[NSMutableArray alloc] init];
    [self makeCorrectedXLabelArr:self.correctedYearXLabels andProfitArr:self.correctedYearProfit andBusyArr:self.correctedYearBusyness overDays:365];
}

- (void)loadGraph
{
    //view setup
    [self.legend removeFromSuperview];
    //set initial values
    int startIdx = 0;
    int range = (int)[self.profitDataArray count];
    if (self.timeSpanSelected == nil){
        self.timeSpanSelected = @"Week";
    }
    if (self.selectedDataDisplay == nil) {
        self.selectedDataDisplay = @"Revenue";
    }
    // set x axis ranges
    if ([self.timeSpanSelected isEqualToString:@"Week"]) {
        range = 7;
        startIdx = (int)[self.profitDataArray count] - range;
    } else if ([self.timeSpanSelected isEqualToString:@"Month"]) {
        range = 31;
        startIdx = (int)[self.profitDataArray count] - range;
    } else if ([self.timeSpanSelected isEqualToString:@"Year"]) {
        range = 365;
        startIdx = (int)[self.profitDataArray count] - range;
    } else {
        range = (int)[self.profitDataArray count];
        startIdx = 0;
    }
    // initialize chart
    self.lineChart = [[PNLineChart alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, self.dataView.frame.size.height)];
    self.lineChart.delegate = self;
    // set up Profit data
    NSArray * data01Array = [self.profitDataArray subarrayWithRange:NSMakeRange(startIdx, range)];
    [self.lineChart setXLabels:[self.currentXLabels subarrayWithRange:NSMakeRange(startIdx, range)]];
    
    PNLineChartData *data01 = [PNLineChartData new];
    data01.color = PNFreshGreen;
    data01.inflexionPointColor = UIColor.blueColor;
    data01.itemCount = self.lineChart.xLabels.count;
    if (![self.timeSpanSelected isEqualToString:@"Year"]) {
        data01.inflexionPointStyle = PNLineChartPointStyleTriangle;
    }
    data01.getData = ^(NSUInteger index) {
        CGFloat yValue = [data01Array[index] floatValue];
        return [PNLineChartDataItem dataItemWithY:yValue];
    };
    
    NSArray * data02Array = [self.busynessDataArray subarrayWithRange:NSMakeRange(startIdx, range)];
    PNLineChartData *data02 = [PNLineChartData new];
    data02.color = UIColor.magentaColor;
    data02.inflexionPointColor = UIColor.orangeColor;
    data02.itemCount = self.lineChart.xLabels.count;
    if (![self.timeSpanSelected isEqualToString:@"Year"]) {
        data02.inflexionPointStyle = PNLineChartPointStyleTriangle;
    }
    data02.getData = ^(NSUInteger index) {
        CGFloat yValue = [data02Array[index] floatValue];
        return [PNLineChartDataItem dataItemWithY:yValue];
    };
    
//    data01.showPointLabel = YES; // show label when screen is touched
    NSArray *dataArray;
    if ([self.selectedDataDisplay isEqualToString:@"Revenue"]) {
        dataArray = @[data01];
        data01.dataTitle = @"Revenue";
        data02.dataTitle = @"";
    } else if ([self.selectedDataDisplay isEqualToString:@"Busyness"]){
        dataArray = @[data02];
        data01.dataTitle = @"";
        data02.dataTitle = @"Busyness";
    } else {
        dataArray = @[data01, data02];
        data01.dataTitle = @"Revenue";
        data02.dataTitle = @"Busyness";
    }
    self.lineChart.chartData = dataArray;
//    self.lineChart.showSmoothLines = YES;
    [self.lineChart strokeChart];
    //LEGEND
    self.lineChart.legendStyle = PNLegendItemStyleSerial;
    self.legend = [self.lineChart getLegendWithMaxWidth:320];
    //Move legend to the desired position and add to view
    [self.legend setFrame:CGRectMake(100, self.dataView.frame.origin.y + self.dataView.frame.size.height, self.legend.frame.size.width, self.legend.frame.size.height)];
    [self.view addSubview:self.legend];
    
    //GRID LINES
    self.lineChart.showYGridLines = YES;
    self.lineChart.yGridLinesColor = [UIColor grayColor];

    [self.dataView addSubview:self.lineChart];
}

- (NSString *)getTimeSpanSelected
{
    NSString *selectedSpan = self.timeSpanSelected;
    return selectedSpan;
}
- (NSString *)getSelectedDataDisplay
{
    NSString *selectedDisplay = self.selectedDataDisplay;
    return selectedDisplay;
}

- (void)drawVertLineAtPoint:(CGPoint)point
{
    [self.vertShapeLayer removeFromSuperlayer]; // should call these two lines when user releases touch
    [self.vertLine removeAllPoints];
//    NSLog(@"Draw virtical line at x-cord: %f", point.x);
//    UIBezierPath *vertLine = [UIBezierPath bezierPath];
    [self.vertLine moveToPoint:CGPointMake(point.x, 100)];
    [self.vertLine addLineToPoint:CGPointMake(point.x, 325)];
    self.vertShapeLayer.path = [self.vertLine CGPath];
    self.vertShapeLayer.strokeColor = [[UIColor lightGrayColor] CGColor];
    self.vertShapeLayer.lineWidth = 0.5;
    self.vertShapeLayer.fillColor = [[UIColor clearColor] CGColor];
    [self.view.layer addSublayer:self.vertShapeLayer];
}

- (void)makeCorrectedXLabelArr:(NSMutableArray *)arr1 andProfitArr:(NSMutableArray *)arr2 andBusyArr:(NSMutableArray *)arr3 overDays:(int)numDays
{
    // WEEK - take last 7 values from xlabels and profitDataArray
    //        then add them to a new array with -2's
    NSMutableArray *tempArr1 = [[NSMutableArray alloc] initWithArray:self.currentXLabels];
    NSMutableArray *tempArr2 = [[NSMutableArray alloc] initWithArray:self.profitDataArray];
    NSMutableArray *tempArr3 = [[NSMutableArray alloc] initWithArray:self.busynessDataArray];
    
    for (int i = [tempArr1 count] - numDays - 1; i < [tempArr1 count]; i++) {
        if ([tempArr2[i] integerValue] != -2) {
            // remove data point from arrays so it will match num points displayed on graph
            [arr1 addObject:tempArr1[i]];
            [arr2 addObject:tempArr2[i]];
            [arr3 addObject:tempArr3[i]];
        }
    }
}

- (void)updateSelectedPointDisplayForIdx:(int)idx
{
    NSMutableArray *tempXLabs = [[NSMutableArray alloc] init];
    NSMutableArray *tempProfitArr = [[NSMutableArray alloc] init];
    NSMutableArray *tempBusynessArr = [[NSMutableArray alloc] init];
    if ([self.timeSpanSelected isEqualToString:@"Week"]) {
        [tempXLabs addObjectsFromArray:self.correctedWeekXLabels];
        [tempProfitArr addObjectsFromArray:self.correctedWeekProfit];
        [tempBusynessArr addObjectsFromArray:self.correctedWeekBusyness];
    } else if ([self.timeSpanSelected isEqualToString:@"Month"]) {
        [tempXLabs addObjectsFromArray:self.correctedMonthXLabels];
        [tempProfitArr addObjectsFromArray:self.correctedMonthProfit];
        [tempBusynessArr addObjectsFromArray:self.correctedMonthBusyness];
    } else {
        [tempXLabs addObjectsFromArray:self.correctedYearXLabels];
        [tempProfitArr addObjectsFromArray:self.correctedYearProfit];
        [tempBusynessArr addObjectsFromArray:self.correctedYearBusyness];
    }
    
    if ([tempProfitArr[idx] integerValue] != -1) {
        if ([self.selectedDataDisplay isEqualToString:@"Revenue"]) {
            self.selectedPointLabel.text = [NSString stringWithFormat:@"Date: %@ \nRevenue: $%@", tempXLabs[idx], tempProfitArr[idx]];
        } else if ([self.selectedDataDisplay isEqualToString:@"Busyness"]) {
            self.selectedPointLabel.text = [NSString stringWithFormat:@"Date: %@ \nCustomers: %@", tempXLabs[idx], tempBusynessArr[idx]];
        } else { //both is selected
            self.selectedPointLabel.text = [NSString stringWithFormat:@"Date: %@ \nRevenue: $%@ \nCustomers: %@", tempXLabs[idx], tempProfitArr[idx], tempBusynessArr[idx]];
        }
    } else {
        self.selectedPointLabel.text = [NSString stringWithFormat:@"No Data For, %@", tempXLabs[idx]];
    }
//    CGSize labelSize = [self.selectedPointLabel.text sizeWithAttributes:@{NSFontAttributeName:self.selectedPointLabel.font}];
//
//    self.selectedPointLabel.frame = CGRectMake(
//                             self.selectedPointLabel.frame.origin.x, self.selectedPointLabel.frame.origin.y,
//                             self.selectedPointLabel.frame.size.width, labelSize.height);
    
}

@end
