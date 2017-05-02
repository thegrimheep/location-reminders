//
//  LocationControllerDelegate.h
//  LocationReminders
//
//  Created by David Porter on 5/2/17.
//  Copyright © 2017 David Porter. All rights reserved.
//

#import <Foundation/Foundation.h>
@import CoreLocation;

@protocol LocationControllerDelegate <NSObject>

- (void)locationControllerUpdatedLocation:(CLLocation *)location;

@end
