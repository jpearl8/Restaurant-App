//
//  Coordinate.h
//  Fresh-Chef-Analytics
//
//  Created by selinons on 8/5/19.
//  Copyright © 2019 julia@ipearl.net. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Coordinate : NSObject
+ (instancetype)shared;
@property (assign, nonatomic) float latitude;
@property (assign, nonatomic) float longitude;
- (Coordinate *) setCoordinateValuesWithLatitude:(float) latitude andLongitude: (float) longitude;

@end

NS_ASSUME_NONNULL_END
