//
//  HistogramViewController.m
//  Fresh-Chef-Analytics
//
//  Created by selinons on 7/22/19.
//  Copyright © 2019 julia@ipearl.net. All rights reserved.
//

#import "HistogramViewController.h"

@interface HistogramViewController ()
@property (weak, nonatomic) IBOutlet UIView *dataView;
@property (strong, nonatomic) NSArray *dishes;
@property (strong, nonatomic) NSMutableDictionary *categoriesOfDishes;
@property (strong, nonatomic) PNRadarChart *radarChart;
@property (strong, nonatomic) NSMutableArray *legend;
@property (strong, nonatomic) NSArray *ratingsForDishes;
@property (strong, nonatomic) NSArray *frequencyForDishes;
@property (strong, nonatomic) NSArray *profitForDishes;
@property (strong, nonatomic) NSArray *colorsFromUI;
@property (strong, nonatomic) NSArray *chartColors;
@property (strong, nonatomic) CAShapeLayer *ratingPlot;
@property (strong, nonatomic) CAShapeLayer *frequencyPlot;
@property (strong, nonatomic) CAShapeLayer *profitPlot;
@property (strong, nonatomic) NSArray *ratingItems;
@property (strong, nonatomic) NSArray *frequencyItems;
@property (strong, nonatomic) NSArray *profitItems;
@property (weak, nonatomic) IBOutlet UIPickerView *categoryPicker;
@property (strong, nonatomic) NSArray *statCats;
@property (weak, nonatomic) IBOutlet UITextView *infoView;
@property (strong, nonatomic) NSString *menCatSelected;
@property (strong, nonatomic) NSString *statCatSelected;

@end

@implementation HistogramViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.categoryPicker.delegate = self;
    self.categoryPicker.dataSource = self;
    self.infoView.hidden = YES;
    self.dishes = [[MenuManager shared] dishes];
    self.menCatSelected = @"All categories";
    self.statCatSelected = @"All Statistics";
    self.colorsFromUI = @[@"#FF0000", @"#00FF00", @"#00FFFF", @"#FF00FF", @"#FCAF0B", @"#800BFC", @"#0B30FC", @"0B30FC"];
    self.chartColors = @[@"#FE0EBC", @"#0E62FE", @"#FEDD0E"];
    self.statCats = @[@"All Statistics", @"Profit", @"Rating", @"Popularity"];
    self.categoriesOfDishes = [[MenuManager shared] categoriesOfDishes];
    self.legend = [NSMutableArray arrayWithArray:[[[MenuManager shared] categoriesOfDishes] allKeys]];
    
    [self.legend insertObject:@"All categories" atIndex:0];
    [self.legend arrayByAddingObjectsFromArray:[[[MenuManager shared] categoriesOfDishes] allKeys]];
    
    
    if (self.categoriesOfDishes != nil && [[[MenuManager shared] dishes] count] >= 3)
    {
        
        NSArray *checkDishFromArray = self.categoriesOfDishes[self.legend[1]];
        Dish *checkDish = checkDishFromArray[0];
        if (![checkDish.name isEqualToString:@"test"]){

            // contents are name, rating, frequency, profit //
            NSArray *dataArray = [self populateDataForAllCategories:@"All Statistics"];
            [self makeItemsWithData:dataArray withStats:@"All Statistics"];
            [self setUpChartWithData : @"All Statistics"];
        }
    }
}
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 2;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (component == 0)
    {
        return [self.legend count];
    }
    else if (component == 1)
    {
        return [self.statCats count];
    }
    return 1;

}
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (component == 0)
    {
        return self.legend[row];
    }
    else if (component == 1)
    {
        return self.statCats[row];
    }
    return nil;
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    NSArray *viewsToRemove = [self.dataView subviews];
    for (UIView *v in viewsToRemove) {
        [v removeFromSuperview];
    }
    __block BOOL continueFlow = NO;
    NSArray *dataArray;
    NSString *selectedMenCat = [self.legend objectAtIndex:[self.categoryPicker selectedRowInComponent:0]];
    self.menCatSelected = selectedMenCat;
    NSString *selectedStatCat = [self.statCats objectAtIndex:[self.categoryPicker selectedRowInComponent:1]];
    self.statCatSelected = selectedStatCat;
    [self updateInfo];
    if ([selectedMenCat isEqual: @"All categories"] && [[[MenuManager shared] dishes] count] >= 3)
    {
        dataArray = [self populateDataForAllCategories:selectedStatCat];
        continueFlow = YES;
    }
    else if ([self.categoriesOfDishes[selectedMenCat] count] >= 3)
    {
        dataArray = [self populateDataForCategory:selectedMenCat withStats:selectedStatCat];
        continueFlow = YES;
    }
    else
    {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Cannot render chart" message:@"Add more dishes to render chart."
                                                                preferredStyle:(UIAlertControllerStyleAlert)];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK"
                                                           style:UIAlertActionStyleDefault
                                                         handler:^(UIAlertAction * _Nonnull action) {
                                                             // handle response here.
                                                         }];
        // add the OK action to the alert controller
        [alert addAction:okAction];
        [self presentViewController:alert animated:YES completion:^{
        }];
    }
    if (continueFlow)
    {
        self.categoriesTableView.hidden = YES;
        [self makeItemsWithData:dataArray withStats:selectedStatCat];
        [self setUpChartWithData: selectedStatCat];
    }
}
- (NSArray *) populateDataForCategory : (NSString *) category withStats: (NSString *) stats
{

    NSMutableArray *dataForRadar = [NSMutableArray array];
    NSMutableArray *ratingData = [NSMutableArray array];
    NSMutableArray *frequencyData = [NSMutableArray array];
    NSMutableArray *profitData = [NSMutableArray array];
    NSMutableArray *dishNames = [NSMutableArray array];
    CGFloat dishRating;
    CGFloat dishProfit;
    if ([self.categoriesOfDishes[category] count] >= 1)
    {
        for (Dish *dish in self.categoriesOfDishes[category])
        {
            [dishNames addObject:dish.name];
            dishProfit = [dish.price floatValue] * [dish.orderFrequency floatValue];
            if (dish.rating == nil)
            {
                dishRating = 0;
                
            }
            else
            {
                dishRating = [dish.rating floatValue] / [dish.orderFrequency floatValue];
            }
            [ratingData addObject:[NSNumber numberWithFloat:dishRating]];
            [frequencyData addObject:dish.orderFrequency];
            [profitData addObject:[NSNumber numberWithFloat:dishProfit]];
        }
        [dataForRadar addObject:dishNames];
        
        if ([stats isEqualToString:@"All Statistics"])
        {
            [dataForRadar addObject:ratingData];
            [dataForRadar addObject:frequencyData];
            [dataForRadar addObject:profitData];

        }
        else if ([stats isEqualToString:@"Rating"])
        {
            [dataForRadar addObject:ratingData];
        }
        else if ([stats isEqualToString:@"Profit"])
        {
            [dataForRadar addObject:profitData];
        }
        else if ([stats isEqualToString:@"Popularity"])
        {
            [dataForRadar addObject:frequencyData];
        }

        return dataForRadar;
    }
    return nil;
    
}
- (NSArray *) populateDataForAllCategories : (NSString *) stats
{

    NSMutableArray *dataForRadar = [NSMutableArray array];
    NSMutableArray *ratingData = [NSMutableArray array];
    NSMutableArray *frequencyData = [NSMutableArray array];
    NSMutableArray *profitData = [NSMutableArray array];
    NSMutableArray *categoryNames = [NSMutableArray array];

    NSString *category;
    CGFloat categoryRating;
    CGFloat categoryFrequency;
    CGFloat categoryProfit;
    CGFloat dishProfit;
    CGFloat dishRating;
    for (int i = 1; i < self.legend.count; i++)
    {
        category = self.legend[i];
        [categoryNames addObject:category];
        categoryProfit = 0;
        categoryRating = 0;
        categoryFrequency = 0;
        for (Dish *dish in self.categoriesOfDishes[category])
        {
            dishProfit = [dish.price floatValue] * [dish.orderFrequency floatValue];
            if (dish.rating == nil)
            {
                dishRating = 0;

            }
            else {
                dishRating = [dish.rating floatValue] / [dish.orderFrequency floatValue];
            }
            categoryRating += dishRating;
            categoryFrequency += [dish.orderFrequency floatValue];
            categoryProfit += dishProfit;
        }
        [ratingData addObject:[NSNumber numberWithFloat:categoryRating]];
        [frequencyData addObject:[NSNumber numberWithFloat:categoryFrequency]];
        [profitData addObject:[NSNumber numberWithFloat:categoryProfit]];
    }
    [dataForRadar addObject:categoryNames];
    if ([stats isEqualToString:@"All Statistics"])
    {
        [dataForRadar addObject:ratingData];
        [dataForRadar addObject:frequencyData];
        [dataForRadar addObject:profitData];
        
    }
    else if ([stats isEqualToString:@"Rating"])
    {
        [dataForRadar addObject:ratingData];
    }
    else if ([stats isEqualToString:@"Profit"])
    {
        [dataForRadar addObject:profitData];
    }
    else if ([stats isEqualToString:@"Popularity"])
    {
        [dataForRadar addObject:frequencyData];
    }
    return dataForRadar;
}

- (NSArray *) populateDataItemsWithArray : (NSArray *) dataArray forDescriptions : (NSArray *) descriptionsArray
{
    NSMutableArray *dataItems = [NSMutableArray array];
    for (int i = 0; i < dataArray.count; i++)
    {
        [dataItems addObject:[PNRadarChartDataItem dataItemWithValue:[dataArray[i] floatValue] description:descriptionsArray[i]]];
    }
    return dataItems;
}
- (IBAction)chooseCategory:(id)sender {
    self.categoriesTableView.hidden = !(self.categoriesTableView.hidden);
}
- (IBAction)toggleInfo:(id)sender {
    self.infoView.hidden = !(self.infoView.hidden);

    [self updateInfo];
}
- (void) updateInfo
{
    NSDictionary *descriptionsOfStats = [[NSDictionary alloc] initWithObjectsAndKeys:
                                         @"the total number of orders multiplied by the price for every item in the category.", @"Profit", @"the total customer ratings for every dish in the category divided by the amount of dish orders.", @"Rating", @"the total number of dish orders for all the dishes in the category.", @"Popularity", nil];
    if (self.infoView.hidden==NO)
    {
        if ([self.statCatSelected isEqualToString:@"All Statistics"])
        {
            self.infoView.text = @"This radar chart is comparing the dishes in the selected category of the menu based on the statistics you choose to show. Profit is in yellow, Rating is in pink, and Popularity is in blue.";
        }
        else
        {
            NSString *firstPart = [NSString stringWithFormat:@"This radar chart is comparing the dishes in the selected category of the menu based on the statistics you choose to show. You chose %@,",  self.statCatSelected];
            self.infoView.text = [firstPart stringByAppendingString:[NSString stringWithFormat:@"which is %@", descriptionsOfStats[self.statCatSelected]]];
            
        }
        
    }
}
- (void)makeItemsWithData : (NSArray *) dataArray withStats: (NSString *) stats
{
    bool returnAlert = NO;
    if ([stats isEqualToString:@"All Statistics"])
    {
        [[Helpful_funs shared] scaleArrayByMax:dataArray[1]];
        self.ratingItems = [self populateDataItemsWithArray:dataArray[1] forDescriptions:dataArray[0]];
        [[Helpful_funs shared] scaleArrayByMax:dataArray[2]];
        self.frequencyItems = [self populateDataItemsWithArray:dataArray[2] forDescriptions:dataArray[0]];
        [[Helpful_funs shared] scaleArrayByMax:dataArray[3]];
        self.profitItems = [self populateDataItemsWithArray:dataArray[3] forDescriptions:dataArray[0]];
    }
    else if ([stats isEqualToString:@"Rating"])
    {
        returnAlert = [[Helpful_funs shared] scaleArrayByMax:dataArray[1]];
        self.ratingItems = [self populateDataItemsWithArray:dataArray[1] forDescriptions:dataArray[0]];
    }
    else if ([stats isEqualToString:@"Popularity"])
    {
        returnAlert = [[Helpful_funs shared] scaleArrayByMax:dataArray[1]];
        self.frequencyItems = [self populateDataItemsWithArray:dataArray[1] forDescriptions:dataArray[0]];
    }
    else if ([stats isEqualToString:@"Profit"])
    {
        returnAlert = [[Helpful_funs shared] scaleArrayByMax:dataArray[1]];
        self.profitItems = [self populateDataItemsWithArray:dataArray[1] forDescriptions:dataArray[0]];
    }
    if (returnAlert)
    {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Chart is empty" message:@"This means that there is no data for this category. Either there have been no orders or this category needs improvement."
                                                                preferredStyle:(UIAlertControllerStyleAlert)];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK"
                                                           style:UIAlertActionStyleDefault
                                                         handler:^(UIAlertAction * _Nonnull action) {
                                                             // handle response here.
                                                         }];
        // add the OK action to the alert controller
        [alert addAction:okAction];
        [self presentViewController:alert animated:YES completion:^{
        }];
    }
    
    
}
- (void)setUpChartWithData : (NSString *) stats
{
    if ([stats isEqualToString:@"All Statistics"])
    {
        self.radarChart = [[PNRadarChart alloc] initWithFrameAndColor:CGRectMake(0, 0, self.dataView.bounds.size.width, self.dataView.bounds.size.height) items:self.ratingItems valueDivider:0.25 withColor:[[[Helpful_funs shared] colorFromHexString:self.chartColors[0]] colorWithAlphaComponent:0.4]];
        [self.radarChart addPlotWithData:self.frequencyItems withColor:[[[Helpful_funs shared] colorFromHexString:self.chartColors[1]] colorWithAlphaComponent:0.4]];
        [self.radarChart addPlotWithData:self.profitItems withColor:[[[Helpful_funs shared] colorFromHexString:self.chartColors[2]] colorWithAlphaComponent:0.4]];
    }
    else if ([stats isEqualToString:@"Rating"])
    {
        self.radarChart = [[PNRadarChart alloc] initWithFrameAndColor:CGRectMake(0, 0, self.dataView.bounds.size.width, self.dataView.bounds.size.height) items:self.ratingItems valueDivider:0.25 withColor:[[[Helpful_funs shared] colorFromHexString:self.chartColors[0]] colorWithAlphaComponent:0.4]];
    }
    else if ([stats isEqualToString:@"Popularity"])
    {
        self.radarChart = [[PNRadarChart alloc] initWithFrameAndColor:CGRectMake(0, 0, self.dataView.bounds.size.width, self.dataView.bounds.size.height) items:self.frequencyItems valueDivider:0.25 withColor:[[[Helpful_funs shared] colorFromHexString:self.chartColors[1]] colorWithAlphaComponent:0.4]];
    }
    else if ([stats isEqualToString:@"Profit"])
    {
        self.radarChart = [[PNRadarChart alloc] initWithFrameAndColor:CGRectMake(0, 0, self.dataView.bounds.size.width, self.dataView.bounds.size.height) items:self.profitItems valueDivider:0.25 withColor:[[[Helpful_funs shared] colorFromHexString:self.chartColors[2]] colorWithAlphaComponent:0.4]];
    }
    [self.dataView addSubview:self.radarChart];
}



@end
