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
//#import "FCADate.h"

@interface ProfitTrendsViewController ()
@property (weak, nonatomic) IBOutlet UIView *dataView;
@property (weak, nonatomic) IBOutlet UIPickerView *categoryPicker;
@property (strong, nonatomic) PNLineChart *lineChart;
@property (strong, nonatomic) UIView *legend;
@property (strong, nonatomic) NSMutableDictionary *profitByDay;
@property (strong, nonatomic) NSMutableDictionary *busynessByDay;
@property (strong, nonatomic) NSMutableArray *currentXLabels;
@property (strong, nonatomic) NSMutableArray *currentYLabels;
@property (strong, nonatomic) NSMutableArray *currentDataArray;
@property (strong, nonatomic) NSMutableArray *busynessDataArray;
@property (strong, nonatomic) NSMutableArray *dates;
@property (strong, nonatomic) NSArray *timeSpans;
@property (strong, nonatomic) NSArray *dataCategories;

@end

@implementation ProfitTrendsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.categoryPicker.delegate = self;
    self.categoryPicker.dataSource = self;
    
//    self.lineChart.dataSource = self;
    self.profitByDay = [[NSMutableDictionary alloc] init];
    self.profitByDay = [[OrderManager shared] profitByDate];
    self.busynessByDay = [[NSMutableDictionary alloc] init];
    self.busynessByDay = [[OrderManager shared] busynessByDate];
    self.currentXLabels = [[NSMutableArray alloc] init];
    self.currentDataArray = [[NSMutableArray alloc] init];
    self.busynessDataArray = [[NSMutableArray alloc] init];
    self.timeSpans = @[@"Week", @"Month", @"Year"]; // could use an enum with integers representing the days
    self.dataCategories = @[@"Profit", @"Busyness", @"Both"];
    self.timeSpanSelected = @"Week";
    self.selectedDataDisplay = @"Profit";
//    self.legend = [self.lineChart getLegendWithMaxWidth:320];
//    //Move legend to the desired position and add to view
//    [self.legend setFrame:CGRectMake(100, 400, self.legend.frame.size.width, self.legend.frame.size.height)];
//    [self.view addSubview:self.legend];
    
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
//    PNLineChart * lineChart = [[PNLineChart alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH * 0.9, 250.0)];
    // Set x labels
    // if week is selected, labels = days of week
    NSArray *unsortedArr1 = [self.profitByDay allKeys];
    self.currentXLabels = [[unsortedArr1 sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)] mutableCopy];
    for(NSString *key in self.currentXLabels){
        [self.currentDataArray addObject:self.profitByDay[key]];
        [self.busynessDataArray addObject:self.busynessByDay[key]];
    }
}

- (void)loadGraph
{
    //view setup
    [self.view willRemoveSubview:self.legend];
    //set initial values
    int startIdx = 0;
    int range = (int)[self.currentDataArray count];
    if (self.timeSpanSelected == nil){
        self.timeSpanSelected = @"Week";
    }
    if (self.selectedDataDisplay == nil) {
        self.selectedDataDisplay = @"Profit";
    }
    // set x axis ranges
    if ([self.timeSpanSelected isEqualToString:@"Week"]) {
        range = 7;
        startIdx = (int)[self.currentDataArray count] - range;
    } else if ([self.timeSpanSelected isEqualToString:@"Month"]) {
        range = 31;
        startIdx = (int)[self.currentDataArray count] - range;
    } else if ([self.timeSpanSelected isEqualToString:@"Year"]) {
        range = 365;
        startIdx = (int)[self.currentDataArray count] - range;
    } else {
        range = (int)[self.currentDataArray count];
        startIdx = 0;
    }
    // initialize chart
    self.lineChart = [[PNLineChart alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH * 0.95, 250.0)];
    self.lineChart.delegate = self;
    // set up Profit data
    NSArray * data01Array = [self.currentDataArray subarrayWithRange:NSMakeRange(startIdx, range)];
//    [lineChart setXLabels:@[@"Mon", @"Tues", @"Wed", @"Thurs"]];
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
    
    
    NSArray *dataArray;
    if ([self.selectedDataDisplay isEqualToString:@"Profit"]) {
        dataArray = @[data01];
        data01.dataTitle = @"Profit";
        data02.dataTitle = @"";
    } else if ([self.selectedDataDisplay isEqualToString:@"Busyness"]){
        dataArray = @[data02];
        data01.dataTitle = @"";
        data02.dataTitle = @"Busyness";
    } else {
        dataArray = @[data01, data02];
        data01.dataTitle = @"Profit";
        data02.dataTitle = @"Busyness";
    }
    self.lineChart.chartData = dataArray;
//    self.lineChart.showSmoothLines = YES;
    [self.lineChart strokeChart];
    //LEGEND
    self.lineChart.legendStyle = PNLegendItemStyleSerial;
    self.legend = [self.lineChart getLegendWithMaxWidth:320];
    //Move legend to the desired position and add to view
    [self.legend setFrame:CGRectMake(100, 400, self.legend.frame.size.width, self.legend.frame.size.height)];
    [self.view addSubview:self.legend];
    
    //GRID LINES
    self.lineChart.showYGridLines = YES;
    self.lineChart.yGridLinesColor = [UIColor grayColor];

    [self.dataView addSubview:self.lineChart];
}

- (void)fixNilValuesInArrays
{
    //For any nil value in self.currentDataArray set them equal to the average of the points on either side
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


@end
