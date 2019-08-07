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
#import "YelpLinkViewController.h"
#import "Link.h"
#import "Coordinate.h"

@interface MapViewController () <MKMapViewDelegate>
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic) Coordinate * me;
@property (strong, nonatomic) NSMutableArray* businesses;
@property (strong, nonatomic) NSMutableArray *annotations;
@property (strong, nonatomic) NSArray *iconTypes;
@property (weak, nonatomic) IBOutlet UIPickerView *pickerView;
@property (strong, nonatomic) NSArray *categories;
@property (strong, nonatomic) NSArray *showBy;
@property (weak, nonatomic) IBOutlet UIButton *meButton;
@property (assign, nonatomic) MKCoordinateRegion meRegion;
@end

@implementation MapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.meButton.backgroundColor = [UIColor colorWithRed:.976 green:.356 blue:.27 alpha:.8];
    self.meButton.layer.cornerRadius = self.meButton.frame.size.width/2;
    
    CABasicAnimation *theAnimation;
    
    theAnimation=[CABasicAnimation animationWithKeyPath:@"opacity"];
    theAnimation.duration=1.0;
    theAnimation.repeatCount=HUGE_VALF;
    theAnimation.autoreverses=YES;
    theAnimation.fromValue=[NSNumber numberWithFloat:1.0];
    theAnimation.toValue=[NSNumber numberWithFloat:0.0];
    [self.meButton.layer addAnimation:theAnimation forKey:@"animateOpacity"];
    self.mapView.delegate = self;
    
    self.iconTypes = @[@"rating-40", @"pizza-40", @"price-40"];
    self.showBy = @[@"All Competitors", @"By Rating", @"By Category", @"By Price"];
    self.annotations = [[NSMutableArray alloc] initWithCapacity:9];
    self.me = [[YelpAPIManager shared] restaurantCoordinates];
    CLLocationCoordinate2D meCoordinates = CLLocationCoordinate2DMake(self.me.latitude, self.me.longitude);
    self.meRegion = MKCoordinateRegionMake(meCoordinates, MKCoordinateSpanMake(0.1, 0.1));
    self.pickerView.delegate = self;
    self.pickerView.dataSource = self;
//        MKCoordinateRegion meRegion =  MKCoordinateRegionMakeWithDistance(meCoordinates, 50, 50);
    [self.mapView setRegion:self.meRegion animated:NO];
    self.businesses = [[YelpAPIManager shared] competitorArray];
    
    PhotoAnnotation *restaurantAnnotation = [[PhotoAnnotation alloc]initWithLocation:meCoordinates andImage:@"restaurant-40"];
    [self.mapView addAnnotation:restaurantAnnotation];
    [self populateMapWithBusinesses];
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
//        UIButton *linkButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
//        linkButton addTarget:self action:@selector(handlebutt) forControlEvents:<#(UIControlEvents)#>
        return annotationView;
    }
    else
    {
        return nil;
    }
}
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [self.showBy count];
}
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return self.showBy[row];
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    [self.mapView removeAnnotations:self.annotations];
    [self.annotations removeAllObjects];
    if ([self.showBy[row] isEqualToString:@"All Competitors"])
    {
        [self populateMapWithBusinesses];
        
    }
    else
    {
        [self populateMapWithBusinessesBy:self.showBy[row]];
        
    }
    [self.mapView addAnnotations:self.annotations];
    [self.mapView showAnnotations:self.annotations animated:YES];
}
- (void) populateMapWithBusinesses
{
    int count = 0;
    NSString *imageName;
    for (NSMutableArray *specificBusinesses in self.businesses)
    {
        imageName = self.iconTypes[count];
        for (NSMutableDictionary *business in specificBusinesses)
        {
            
            [self setCoordinatePointWithLatitudeForBusiness:business andImage:imageName];
            
        }
        count+=1;
    }
}
- (void) populateMapWithBusinessesBy : (NSString *) type
{
    NSString *imageName;
    for (NSMutableDictionary *business in self.businesses[([self.showBy indexOfObject:type]-1)])
    {
        imageName = self.iconTypes[([self.showBy indexOfObject:type]-1)];
        [self setCoordinatePointWithLatitudeForBusiness:business andImage:imageName];
    }
}
- (void) setCoordinatePointWithLatitudeForBusiness : (NSMutableDictionary *) business andImage : (NSString *) imageName
{
    CLLocationCoordinate2D coordinates = CLLocationCoordinate2DMake([business[@"coordinates"][@"latitude"] doubleValue], [business[@"coordinates"][@"longitude"] doubleValue]);
    PhotoAnnotation *annotation = [[PhotoAnnotation alloc] initWithLocation:coordinates andImage:imageName andLink:business[@"url"] andTitle:business[@"name"]];
    [self.annotations addObject:annotation];
    [self mapView:self.mapView viewForAnnotation:annotation];
    
}
- (IBAction)returnToMe:(id)sender {
    [self.mapView setRegion:self.meRegion animated:NO];

}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view
{
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(calloutTapped:)];
    [view addGestureRecognizer:tapGesture];
//    [self performSegueWithIdentifier:@"yelpInfo" sender:view];
}
- (void) calloutTapped:(UITapGestureRecognizer *)sender
{
    MKAnnotationView *view = (MKAnnotationView *)sender.view;
    id <MKAnnotation> annotation = [view annotation];
    if ([annotation isKindOfClass:[PhotoAnnotation class]])
    {
        [self performSegueWithIdentifier:@"yelpInfo" sender:annotation];
    }
}


 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
     if ([[segue identifier] isEqualToString:@"yelpInfo"])
     {
         YelpLinkViewController *yelpTab = [segue destinationViewController];
         yelpTab.yelpLink = ((PhotoAnnotation *)sender).yelpLink;
     }
 }


@end
