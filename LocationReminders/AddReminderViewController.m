//
//  AddReminderViewController.m
//  LocationReminders
//
//  Created by David Porter on 5/2/17.
//  Copyright © 2017 David Porter. All rights reserved.
//

#import "AddReminderViewController.h"

@interface AddReminderViewController ()

@end

@implementation AddReminderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSLog(@"Annotation Title:%@", self.annotationTitle);
    NSLog(@"Coordinates: %f, %f", self.coordinate.latitude, self.coordinate.longitude);
}



@end
