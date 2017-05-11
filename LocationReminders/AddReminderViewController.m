//
//  AddReminderViewController.m
//  LocationReminders
//
//  Created by David Porter on 5/2/17.
//  Copyright © 2017 David Porter. All rights reserved.
//

#import "AddReminderViewController.h"
#import "Reminder.h"
#import "LocationController.h"

@interface AddReminderViewController ()
@property (weak, nonatomic) IBOutlet UITextField *addReminderTextField;
@property (weak, nonatomic) IBOutlet UITextField *radiusTextField;

@end

@implementation AddReminderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIBarButtonItem *doneButton = [[[UIBarButtonItem alloc]init]initWithTitle:@"Save" style:UIBarButtonItemStyleDone target:self action:@selector(savePressedDismissReminderViewController)];
    [[self navigationItem] setRightBarButtonItem:doneButton];
}

-(void)saveReminder {
    Reminder *newReminder = [Reminder object];
    
    newReminder.name = self.annotationTitle;
    newReminder.location = [PFGeoPoint geoPointWithLatitude:self.coordinate.latitude longitude:self.coordinate.longitude];
    
    [newReminder saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        NSLog(@"Annotation Title:%@", self.annotationTitle);
        NSLog(@"Coordinates: %f, %f", self.coordinate.latitude, self.coordinate.longitude);
        NSLog(@"Save Reminder Successful:%i - Error: %@", succeeded, error.localizedDescription);
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ReminderSavedToParse" object:nil];
        
        if (self.completion) {
            CGFloat radius = 100; //coming from UISlider or textfield
            MKCircle *circle = [MKCircle circleWithCenterCoordinate:self.coordinate radius:radius];
            
            if ([CLLocationManager isMonitoringAvailableForClass:[CLCircularRegion class]]) {
                CLCircularRegion *region = [[CLCircularRegion alloc]initWithCenter:self.coordinate radius:radius identifier:newReminder.name];
                
                [LocationController.shared startMonitoringForRegion:region];
            }
            
            self.completion(circle);
            [self.navigationController popViewControllerAnimated:YES];
        }
    }];
}

-(NSNumber *)numberFromString:(NSString *)string {
    NSNumberFormatter *formatString = [[NSNumberFormatter alloc]init];
    [formatString setNumberStyle:NSNumberFormatterDecimalStyle];
    return  [formatString numberFromString:string];
}

@end
