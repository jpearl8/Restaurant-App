//
//  DataViewTableViewController.m
//  Fresh-Chef-Analytics
//
//  Created by rgallardo on 7/24/19.
//  Copyright © 2019 julia@ipearl.net. All rights reserved.
//

#import "DataViewTableViewController.h"

@interface DataViewTableViewController ()
@property (weak, nonatomic) IBOutlet UIButton *t3b3Button;
@property (weak, nonatomic) IBOutlet UIButton *scatterButton;
@property (weak, nonatomic) IBOutlet UIButton *radarButton;
@property (weak, nonatomic) IBOutlet UIButton *histogramButton;
@property (weak, nonatomic) IBOutlet UIButton *trendButton;


@property (assign, nonatomic) __block double t3b3Mult;
@property (assign, nonatomic) __block double scatterMult;
@property (assign, nonatomic) __block double radarMult;
@property (assign, nonatomic) __block double histogramMult;
@property (assign, nonatomic) __block double trendMult;


@property (strong, nonatomic) IBOutlet UIView *selectedView;


@property (weak, nonatomic) IBOutlet UIView *t3b3View;
@property (weak, nonatomic) IBOutlet UIView *coverT3B3;

@property (weak, nonatomic) IBOutlet UIView *scatterView;
@property (weak, nonatomic) IBOutlet UIView *coverScatter;

@property (weak, nonatomic) IBOutlet UIView *radarView;
@property (weak, nonatomic) IBOutlet UIView *coverRadar;

@property (weak, nonatomic) IBOutlet UIView *histogramView;
@property (weak, nonatomic) IBOutlet UIView *coverHistogram;

@property (weak, nonatomic) IBOutlet UIView *trendView;
@property (weak, nonatomic) IBOutlet UIView *coverTrend;



@end

@implementation DataViewTableViewController {
    BOOL isCellExpanded;
    NSIndexPath *selectedIndexPath;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    isCellExpanded = NO;
    self.t3b3Mult = 1;
    self.scatterMult = 1;
    self.radarMult = 1;
    self.histogramMult = 1;
    self.trendMult = 1;
    
    isCellExpanded = NO;
    self.tableView.scrollEnabled = YES;
    self.coverT3B3.hidden = NO;
    self.coverScatter.hidden = NO;
    self.coverRadar.hidden = NO;
    self.coverHistogram.hidden = NO;
    self.coverTrend.hidden = NO;
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 6;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
- (IBAction)didTapMenu:(id)sender {
    [self performSegueWithIdentifier:@"menu" sender:nil];
}

- (IBAction)didTapT3B3:(id)sender {
    self.t3b3Mult *= -1;
    self.selectedView = self.t3b3View;
    self.coverT3B3.hidden = !(self.coverT3B3.hidden);
    [self didSelectCellAtIndex:1 inSection:0];
}
- (IBAction)didTapSPHeader:(id)sender {
    self.scatterMult *= -1;
    self.selectedView = self.scatterView;
    self.coverScatter.hidden = !(self.coverScatter.hidden);
    [self didSelectCellAtIndex:2 inSection:0];
}
- (IBAction)didTapRCHeader:(id)sender {
    self.radarMult *= -1;
    self.selectedView = self.radarView;
    self.coverRadar.hidden = !(self.coverRadar.hidden);
    [self didSelectCellAtIndex:3 inSection:0];
}
- (IBAction)didTapHistHeader:(id)sender {
    self.histogramMult *= -1;
    self.selectedView = self.histogramView;
    self.coverHistogram.hidden = !(self.coverHistogram.hidden);
    [self didSelectCellAtIndex:4 inSection:0];
}
- (IBAction)didTapPTHeader:(id)sender {
    self.trendMult *= -1;
    self.selectedView = self.trendView;
    self.coverTrend.hidden = !(self.coverTrend.hidden);
    [self didSelectCellAtIndex:5 inSection:0];
}

- (void)didSelectCellAtIndex:(NSInteger)index inSection:(NSInteger)section {
    selectedIndexPath = [NSIndexPath indexPathForRow:index inSection:section];
    if(isCellExpanded){
        isCellExpanded = NO;
        self.tableView.scrollEnabled = YES;
    } else {

        isCellExpanded = YES;
        self.tableView.scrollEnabled = NO;
    }
    [self.tableView beginUpdates];
    [self.tableView endUpdates];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:section];
    [self.tableView scrollToRowAtIndexPath:indexPath
                          atScrollPosition:UITableViewScrollPositionTop
                                  animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    if([indexPath compare:selectedIndexPath] == NSOrderedSame) {
    if(indexPath.row == selectedIndexPath.row) {
        if(isCellExpanded == YES){
            return self.selectedView.frame.size.height + 100;
//            return self.view.frame.size.height - ([UIScreen mainScreen].bounds.size.height /
//                                                  6);
        } else {
            return ([UIScreen mainScreen].bounds.size.height /
            6)-20;
        }
    } else {
        return ([UIScreen mainScreen].bounds.size.height / 6)-20;
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
