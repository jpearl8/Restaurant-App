
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
    MKAnnotationView *annotationView = [[MKAnnotationView alloc] initWithAnnotation:self reuseIdentifier:@"Photo Annotation"];
    annotationView.enabled = YES;
    annotationView.canShowCallout = YES;
    if ([self.imageName isEqualToString:@"pizza-40"])
    {
        annotationView.backgroundColor = [UIColor colorWithRed:(0.61) green:(0.99) blue:(0.796) alpha:0.8];
    }
    else if ([self.imageName isEqualToString:@"rating-40"])
    {
        annotationView.backgroundColor = [UIColor colorWithRed:(0.98) green:(0.61) blue:(0.99) alpha:0.8];
    }
    else if ([self.imageName isEqualToString:@"price-40"])
    {
        annotationView.backgroundColor = [UIColor colorWithRed:(.73) green:(.61) blue:(0.99) alpha:0.8];
    }
    annotationView.image = [UIImage imageNamed:self.imageName];
    annotationView.layer.cornerRadius = annotationView.frame.size.width/2;

    return annotationView;
}
@end
