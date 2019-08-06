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
#import "PhotoAnnotation.h"

@interface MapViewController () <MKMapViewDelegate>
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic) Coordinate * me;
@property (strong, nonatomic) NSMutableArray* businesses;
@property (strong, nonatomic) NSMutableArray *annotations;
@end

@implementation MapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.mapView.delegate = self;
    self.annotations = [[NSMutableArray alloc] initWithCapacity:9];
    self.me = [[YelpAPIManager shared] restaurantCoordinates];
    CLLocationCoordinate2D meCoordinates = CLLocationCoordinate2DMake(self.me.latitude, self.me.longitude);
//    MKCoordinateRegion meRegion = MKCoordinateRegionMake(meCoordinates, MKCoordinateSpanMake(0.1, 0.1));
        MKCoordinateRegion meRegion =  MKCoordinateRegionMakeWithDistance(meCoordinates, 50, 50);
    [self.mapView setRegion:meRegion animated:NO];
    self.businesses = [[YelpAPIManager shared] competitorArray];
    [self populateMapWithBusinesses];
    PhotoAnnotation *restaurantAnnotation = [[PhotoAnnotation alloc]initWithLocation:meCoordinates andImage:@"restaurant-40"];
    [self.annotations addObject:restaurantAnnotation];
    [self.mapView addAnnotations:self.annotations];
    [self.mapView showAnnotations:self.annotations animated:YES];
}
- (MKAnnotationView *) mapView: (MKMapView *)mapView viewForAnnotation:(nonnull id<MKAnnotation>)annotation
{
    if ([annotation isKindOfClass:[PhotoAnnotation class]])
    {
        PhotoAnnotation *myLocation = (PhotoAnnotation *)annotation;
        MKAnnotationView *annotationView = [mapView dequeueReusableAnnotationViewWithIdentifier:@"Photo Annotation"];
        if (annotationView == nil)
        {
            annotationView = [myLocation selfAnnotationView];
        }
        else
        {
            annotationView.annotation = annotation;
        }
        return annotationView;
    }
    else
    {
        return nil;
    }
}
- (void) populateMapWithBusinesses
{
    for (NSMutableArray *specificBusinesses in self.businesses)
    {
        for (NSMutableDictionary *business in specificBusinesses)
        {
            
            [self setCoordinatePointWithLatitudeForBusiness:business andImage:@"restaurant-40"];
            
        }
    }
}
- (void) setCoordinatePointWithLatitudeForBusiness : (NSMutableDictionary *) business andImage : (NSString *) imageName
{
    CLLocationCoordinate2D coordinates = CLLocationCoordinate2DMake([business[@"coordinates"][@"latitude"] doubleValue], [business[@"coordinates"][@"longitude"] doubleValue]);
    PhotoAnnotation *annotation = [[PhotoAnnotation alloc] initWithLocation:coordinates andImage:imageName];
    [self.annotations addObject:annotation];
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
