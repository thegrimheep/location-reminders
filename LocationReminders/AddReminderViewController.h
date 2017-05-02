//
//  AddReminderViewController.h
//  LocationReminders
//
//  Created by David Porter on 5/2/17.
//  Copyright © 2017 David Porter. All rights reserved.
//

#import <UIKit/UIKit.h>
@import MapKit;

@interface AddReminderViewController : UIViewController

@property(strong, nonatomic) NSString *annotationTitle;
@property(nonatomic) CLLocationCoordinate2D *coordinate;

@end
