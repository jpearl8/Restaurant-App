//
//  PhotoAnnotation.h
//  PhotoMap
//
//  Created by selinons on 7/8/19.
//  Copyright © 2019 Codepath. All rights reserved.
//

// PhotoAnnotation.h
#import <Foundation/Foundation.h>
@import MapKit;

@interface PhotoAnnotation : NSObject <MKAnnotation>
@property (readonly, nonatomic) CLLocationCoordinate2D coordinate;
@property (assign, nonatomic) NSString *businessTitle;
@property (assign, nonatomic) NSString *imageName;
@property (assign, nonatomic) NSString *yelpLink;
- (MKAnnotationView *)selfAnnotationView;
+ (instancetype)shared;
- (id) initWithLocation:(CLLocationCoordinate2D)location andImage: (NSString *) imageName;
- (id) initWithLocation:(CLLocationCoordinate2D)location andImage: (NSString *) imageName andLink : (NSString *) link andTitle : (NSString *) title;

@end
