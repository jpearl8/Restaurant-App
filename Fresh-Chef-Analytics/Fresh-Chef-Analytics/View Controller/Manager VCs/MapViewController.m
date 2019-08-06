//
//  MapViewController.m
//  Fresh-Chef-Analytics
//
//  Created by selinons on 8/5/19.
//  Copyright © 2019 julia@ipearl.net. All rights reserved.
//

#import "MapViewController.h"
#import "YelpAPIManager.h"
#import <MapKit/MapKit.h>

@interface MapViewController ()
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic) Coordinate * me;
@end

@implementation MapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.me = [[YelpAPIManager shared] restaurantCoordinates];
    NSLog(@"Longitude of restaurant is %f", self.me.longitude);
    NSLog(@"Latitude of restaurant is %f", self.me.latitude);
    CLLocation *meLocation = [[CLLocation alloc] initWithLatitude:self.me.latitude longitude:self.me.longitude];
    MKCoordinateRegion meRegion = MKCoordinateRegionMake(meLocation.coordinate, MKCoordinateSpanMake(0.1, 0.1));
    [self.mapView setRegion:meRegion];
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
