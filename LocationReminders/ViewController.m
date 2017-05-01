//
//  ViewController.m
//  LocationReminders
//
//  Created by David Porter on 5/1/17.
//  Copyright © 2017 David Porter. All rights reserved.
//

#import "ViewController.h"

@import Parse;
@import MapKit;

@interface ViewController ()
@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    PFObject *testObject = [PFObject objectWithClassName:@"TestObject"];
    
    testObject[@"testName"] = @"David Porter";
    
    [testObject saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        if (succeeded) {
            NSLog(@"Success Saving test object");
        } else {
            NSLog(@"There was a problem saving. Save Error: %@", error.localizedDescription);
        }
    }];
    
//    PFQuery *query = [PFQuery queryWithClassName:@"TestObject"];
//    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
//        if (error) {
//            NSLog(@"%", error.localizedDescription);
//        } else {
//            NSLog(@"Query Results %@", objects);
//        }
//    }];
}
- (IBAction)location1Pressed:(id)sender {
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
