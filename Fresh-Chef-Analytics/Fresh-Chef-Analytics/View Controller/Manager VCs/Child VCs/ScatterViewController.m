//
//  ScatterViewController.m
//  Fresh-Chef-Analytics
//
//  Created by selinons on 7/22/19.
//  Copyright © 2019 julia@ipearl.net. All rights reserved.
//

#import "ScatterViewController.h"

@interface ScatterViewController ()
@property (weak, nonatomic) IBOutlet UIView *dataView;
@property (strong, nonatomic) NSArray *dishes;
@property (strong, nonatomic) PNScatterChart *scatterChart;

@end

@implementation ScatterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dishes = [[MenuManager shared] dishes];
    NSArray * dataArray = [self populateDataByRatingAndFreq];
    //For Scatter Chart
    self.scatterChart = [[PNScatterChart alloc] initWithFrame:CGRectMake(0, 0, self.dataView.bounds.size.width, self.dataView.bounds.size.height)];
    [self.scatterChart setAxisXWithMinimumValue:0 andMaxValue:10 toTicks:10];
    [self.scatterChart setAxisYWithMinimumValue:0 andMaxValue:50 toTicks:10];
    PNScatterChartData *data01 = [PNScatterChartData new];
    data01.strokeColor = PNGreen;
    data01.fillColor = PNFreshGreen;
    data01.size = 2;
    data01.itemCount = [[dataArray objectAtIndex:0] count];
    data01.inflexionPointStyle = PNScatterChartPointStyleCircle;
    __block NSMutableArray *XAr1 = [NSMutableArray arrayWithArray:[dataArray objectAtIndex:1]];
    __block NSMutableArray *YAr1 = [NSMutableArray arrayWithArray:[dataArray
                                                                   objectAtIndex:2]];
    data01.getData = ^(NSUInteger index) {
        CGFloat xValue = [[XAr1 objectAtIndex:index] floatValue];
        CGFloat yValue = [[YAr1 objectAtIndex:index] floatValue];
        return [PNScatterChartDataItem dataItemWithX:xValue AndWithY:yValue];
    };
    
    [self.scatterChart setup];
    self.scatterChart.chartData = @[data01];
    self.scatterChart.delegate = self;
    
    [self.dataView addSubview:self.scatterChart];
    
}

- (NSArray *)populateDataByRatingAndFreq
{
    NSMutableArray *theData = [NSMutableArray array];
    NSMutableArray *allRatings = [NSMutableArray array];
    NSMutableArray *allFrequencies = [NSMutableArray array];
    NSMutableArray *allNames = [NSMutableArray array];
    for (Dish *dish in self.dishes)
    {
        NSNumber *rating;
        if (dish.rating==nil)
        {
            rating = @(0);
        }
        else
        {
            rating = [NSNumber numberWithFloat:[dish.rating floatValue]/[dish.orderFrequency floatValue]];
        }
        [allRatings addObject:rating];
        [allFrequencies addObject:dish.orderFrequency];
        [allNames addObject:dish.name];
    }
    [theData addObject:allNames];
    [theData addObject:allRatings];
    [theData addObject:allFrequencies];
    return theData;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
