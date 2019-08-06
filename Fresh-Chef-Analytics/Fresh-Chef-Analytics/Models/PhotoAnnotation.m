
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
    annotationView.canShowCallout = NO;
    annotationView.backgroundColor = [UIColor redColor];
    annotationView.image = [UIImage imageNamed:self.imageName];
    return annotationView;
}
@end
