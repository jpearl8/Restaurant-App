
//
//  PhotoAnnotation.m
//  PhotoMap
//
//  Created by selinons on 7/8/19.
//  Copyright © 2019 Codepath. All rights reserved.
//

#import "PhotoAnnotation.h"

@interface PhotoAnnotation()

@property (nonatomic) CLLocationCoordinate2D coordinate;

@end

@implementation PhotoAnnotation
+ (instancetype)shared {
    static PhotoAnnotation *sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[self alloc] init];
    });
    
    return sharedManager;
}
- (id) initWithLocation:(CLLocationCoordinate2D)location andImage: (NSString *) imageName andLink : (NSString *) link andTitle : (NSString *) title
{
    self = [super init];
    if (self)
    {
        self.coordinate = location;
        self.imageName = imageName;
        self.yelpLink = link;
        self.businessTitle = title;
    }
    return self;
}
- (NSString *)title {
    return self.businessTitle;
}
- (id) initWithLocation:(CLLocationCoordinate2D)location andImage: (NSString *) imageName
{
    self = [super init];
    if (self)
    {
        self.coordinate = location;
        self.imageName = imageName;
    }
    return self;
}
- (MKAnnotationView *)selfAnnotationView
{
//    UILabel *businessText = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 150, 20)];
    MKAnnotationView *annotationView = [[MKAnnotationView alloc] initWithAnnotation:self reuseIdentifier:@"Photo Annotation"];
    annotationView.enabled = YES;
    annotationView.canShowCallout = YES;
//    businessText.text = self.businessTitle;
//    businessText.numberOfLines = 0;
//    businessText.lineBreakMode = NSLineBreakByWordWrapping;
//    [businessText setFont:[UIFont systemFontOfSize:10]];
//    [businessText setBackgroundColor:[UIColor whiteColor]];
//
//    [annotationView addSubview:businessText];
    annotationView.backgroundColor = [UIColor colorWithRed:225 green:234 blue:254 alpha:1];
    annotationView.image = [UIImage imageNamed:self.imageName];
    return annotationView;
}
@end
