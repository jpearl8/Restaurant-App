//
//  Coordinate.m
//  Fresh-Chef-Analytics
//
//  Created by selinons on 8/5/19.
//  Copyright © 2019 julia@ipearl.net. All rights reserved.
//

#import "Coordinate.h"

@implementation Coordinate
+ (instancetype)shared {
    static Coordinate *sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[self alloc] init];
    });
    return sharedManager;
}
- (Coordinate *) setCoordinateValuesWithLatitude:(float) latitude andLongitude: (float) longitude
{
    Coordinate *coordinate = [[Coordinate alloc] init];
    coordinate.latitude = latitude;
    coordinate.longitude = longitude;
    return coordinate;
}

@end
