//
//  ViewController.m
//  LocationReminders
//
//  Created by David Porter on 5/1/17.
//  Copyright © 2017 David Porter. All rights reserved.
//

#import "ViewController.h"
#import "AddReminderViewController.h"

@import Parse;
@import MapKit;
@import CoreLocation;

@interface ViewController () <CLLocationManagerDelegate, MKMapViewDelegate>
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UIButton *homeButtonEffects;
@property (weak, nonatomic) IBOutlet UIButton *codeFellowsEffects;
@property (weak, nonatomic) IBOutlet UIButton *momEffects;
@property (weak, nonatomic) IBOutlet UIButton *myLocationEffects;

@property (strong, nonatomic) CLLocationManager *locationManager;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
//    
//    PFObject *testObject = [PFObject objectWithClassName:@"TestObject"];
//    
//    testObject[@"testName"] = @"David Porter";
//    
//    [testObject saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
//        if (succeeded) {
//            NSLog(@"Success Saving test object");
//        } else {
//            NSLog(@"There was a problem saving. Save Error: %@", error.localizedDescription);
//        }
//    }];
    
//    PFQuery *query = [PFQuery queryWithClassName:@"TestObject"];
//    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
//        if (error) {
//            NSLog(@"%", error.localizedDescription);
//        } else {
//            NSLog(@"Query Results %@", objects);
//        }
//    }];
    
    [self requestPermissions];
    self.mapView.showsUserLocation = YES;
    
    self.mapView.delegate = self;
    
    self.homeButtonEffects.layer.cornerRadius = 10;
    self.codeFellowsEffects.layer.cornerRadius = 10;
    self.momEffects.layer.cornerRadius = 10;
    self.myLocationEffects.layer.cornerRadius = 10;
}

-(void)requestPermissions {
    self.locationManager = [[CLLocationManager alloc]init];
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    self.locationManager.distanceFilter = 100;
    self.locationManager.delegate = self;
    
    [self.locationManager requestAlwaysAuthorization];
    [self.locationManager startUpdatingLocation];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    [super prepareForSegue:segue sender:sender];
    
    if ([segue.identifier isEqualToString:@"AddReminderViewCOntroller"] && [sender isKindOfClass:[MKPinAnnotationView class]]) {
        MKAnnotationView *annotationView = (MKAnnotationView *)sender;
        AddReminderViewController *newReminderViewController = (AddReminderViewController *)segue.destinationViewController;
        
        newReminderViewController.coordinate = annotationView.annotation.coordinate;
        newReminderViewController.annotationTitle = annotationView.annotation.title;
        newReminderViewController.title = annotationView.annotation.title;
    }
}

- (IBAction)location1Pressed:(id)sender {
    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(47.560009, -122.388459);
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(coordinate, 500.0, 500.0);
//    MKPointAnnotation *point = [[MKPointAnnotation alloc]init];
//    point.coordinate = coordinate;
//    point.title = @"Home";
//    [self.mapView addAnnotation:point];
    
    [self.mapView setRegion:region animated:YES];
}

- (IBAction)codeFellowsPressed:(id)sender {
    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(47.618217, -122.351832);
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(coordinate, 500.0, 500.0);
//    MKPointAnnotation *point = [[MKPointAnnotation alloc]init];
//    point.coordinate = coordinate;
//    point.title = @"Code Fellows";
//    [self.mapView addAnnotation:point];
    
    [self.mapView setRegion:region animated:YES];
}

- (IBAction)momPressed:(id)sender {
    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(36.319423, -82.375835);
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(coordinate, 500.0, 500.0);
//    MKPointAnnotation *point = [[MKPointAnnotation alloc]init];
//    point.coordinate = coordinate;
//    point.title = @"Mom";
//    [self.mapView addAnnotation:point];
    
    [self.mapView setRegion:region animated:YES];
}

- (IBAction)myLocationPressed:(id)sender {
    MKCoordinateRegion mapRegion;
    mapRegion.center = _mapView.userLocation.coordinate;
    mapRegion.span.latitudeDelta = 0.025;
    mapRegion.span.longitudeDelta = 0.025;
    
    [_mapView setRegion:mapRegion animated:YES];
}

- (IBAction)userLongPressed:(UILongPressGestureRecognizer *)sender {
    if (sender.state == UIGestureRecognizerStateBegan) {
        CGPoint touchPoint = [sender locationInView:self.mapView];
        CLLocationCoordinate2D coordinate = [self.mapView convertPoint:touchPoint toCoordinateFromView:self.mapView];
        MKPointAnnotation *newPoint = [[MKPointAnnotation alloc]init];
        newPoint.coordinate = coordinate;
        newPoint.title = @"New Location";
        [self.mapView addAnnotation:newPoint];
    }
}


-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    CLLocation *location = locations.lastObject;
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(location.coordinate, 500.0, 500.0);
    
    [self.mapView setRegion:region animated:YES];
}

-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    if ([annotation isKindOfClass:[MKUserLocation class]]) {
        return nil;
    }
    MKPinAnnotationView *annotationView = (MKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:@"annotationView"];
    
    annotationView.annotation = annotation;
    
    if (!annotationView) {
        annotationView = [[MKPinAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:@"annotationView"];
    }
    annotationView.canShowCallout = YES;
    annotationView.animatesDrop = YES;
    
    UIButton *rightCalloutAccessory = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];  //callout button
    annotationView.rightCalloutAccessoryView = rightCalloutAccessory;
    return annotationView;
}


-(void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control {
    NSLog(@"acessory Tapped");
    [self performSegueWithIdentifier:@"AddReminderViewController" sender:view];
}



@end
