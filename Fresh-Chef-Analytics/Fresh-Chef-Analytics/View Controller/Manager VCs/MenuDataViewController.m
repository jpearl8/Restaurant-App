//
//  MenuDataViewController.m
//  Fresh-Chef-Analytics
//
//  Created by jpearl on 7/16/19.
//  Copyright © 2019 julia@ipearl.net. All rights reserved.
//

#import "MenuDataViewController.h"
#import "MenuManager.h"


@interface MenuDataViewController ()
@property (strong, nonatomic) NSArray *dishes;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segcontrol;
@property (weak, nonatomic) IBOutlet UIView *scatterContainer;
@property (weak, nonatomic) IBOutlet UIView *histogramContainer;
@property (weak, nonatomic) IBOutlet UIView *top3Bot3Container;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;


@end

@implementation MenuDataViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    CGRect frame = self.segcontrol.frame;
    [self.segcontrol setFrame:CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, frame.size.height*2)];
    self.segcontrol.tintColor = [UIColor orangeColor];
    self.titleLabel.text = @"Scatter Plot";
    

}
- (IBAction)showContainer:(id)sender {
    NSInteger selectedIndex = self.segcontrol.selectedSegmentIndex;
    if (selectedIndex == 0)
    {
        self.titleLabel.text = @"SCATTER CHART";
        [UIView animateWithDuration:0.5 animations:^{
            self.scatterContainer.alpha = 1;
            self.histogramContainer.alpha = 0;
            self.top3Bot3Container.alpha = 0;
        }];
    }
    else if (selectedIndex == 1)
    {
        self.titleLabel.text = @"HISTOGRAM CHART";
        [UIView animateWithDuration:0.5 animations:^{
            self.scatterContainer.alpha = 0;
            self.histogramContainer.alpha = 1;
            self.top3Bot3Container.alpha = 0;
        }];
    }
    else if (selectedIndex == 2)
    {
        self.titleLabel.text = @"TOP 3 BOTTOM 3";
        [UIView animateWithDuration:0.5 animations:^{
            self.scatterContainer.alpha = 0;
            self.histogramContainer.alpha = 0;
            self.top3Bot3Container.alpha = 1;
        }];
    }
    else
    {
        self.titleLabel.text = @"SCATTER CHART";
        NSLog(@"no selected view, scatter chart will appear");
    }
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
