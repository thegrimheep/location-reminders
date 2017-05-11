//
//  ViewController.m
//  LocationReminders
//
//  Created by David Porter on 5/1/17.
//  Copyright © 2017 David Porter. All rights reserved.
//

#import "ViewController.h"
#import "AddReminderViewController.h"
#import "LocationControllerDelegate.h"
#import "LocationController.h"

@import Parse;
@import MapKit;
@import CoreLocation;
@import ParseUI;
@import Twitter;

@interface ViewController () <CLLocationManagerDelegate, MKMapViewDelegate, LocationControllerDelegate, PFLogInViewControllerDelegate, PFSignUpViewControllerDelegate>
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UIButton *homeButtonEffects;
@property (weak, nonatomic) IBOutlet UIButton *codeFellowsEffects;
@property (weak, nonatomic) IBOutlet UIButton *momEffects;
@property (weak, nonatomic) IBOutlet UIButton *myLocationEffects;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    LocationController *locationController = [LocationController shared];
    locationController.delegate = self;
    
    self.mapView.showsUserLocation = YES;
    self.mapView.delegate = self;
    self.homeButtonEffects.layer.cornerRadius = 10;
    self.codeFellowsEffects.layer.cornerRadius = 10;
    self.momEffects.layer.cornerRadius = 10;
    self.myLocationEffects.layer.cornerRadius = 10;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reminderSavedToParse:) name:@"ReminderSavedToParse" object:nil];
    
    if (![PFUser currentUser]) {
        PFLogInViewController *loginViewController = [[PFLogInViewController alloc]init];
        loginViewController.delegate = self;
        loginViewController.signUpController.delegate = self;
        
        loginViewController.fields = PFLogInFieldsLogInButton | PFLogInFieldsSignUpButton | PFLogInFieldsUsernameAndPassword | PFLogInFieldsTwitter;
        
        [self presentViewController:loginViewController animated:YES completion:nil];
    }
    
    PFQuery *query = [PFQuery queryWithClassName:@"Reminder"];
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        if (error) {
            NSLog(@"Error Fetching The Reminder %@", error.localizedDescription);
        } else {
            NSLog(@"%@", objects);
            
        }
    }];
}

-(void)reminderSavedToParse:(id)sender {
    
    NSLog(@"Do Some stuff since our reminder was saved to parse");
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    [super prepareForSegue:segue sender:sender];
    
    if ([segue.identifier isEqualToString:@"AddReminderViewController"] && [sender isKindOfClass:[MKPinAnnotationView class]]) {
        MKAnnotationView *annotationView = (MKAnnotationView *)sender;
        AddReminderViewController *newReminderViewController = (AddReminderViewController *)segue.destinationViewController;
        
        newReminderViewController.coordinate = annotationView.annotation.coordinate;
        newReminderViewController.annotationTitle = annotationView.annotation.title;
        newReminderViewController.title = annotationView.annotation.title;
        __weak typeof (self) bruce = self;
        newReminderViewController.completion = ^(MKCircle *circle) {
            __strong typeof(bruce) hulk = bruce;
            
            [hulk.mapView removeAnnotation: annotationView.annotation];
            [hulk.mapView addOverlay:circle];
        };
    }
}

-(void)dealloc {
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"ReminderSavedToParse" object:nil];
}

- (IBAction)location1Pressed:(id)sender {
    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(47.560009, -122.388459);
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(coordinate, 500.0, 500.0);
    MKPointAnnotation *point = [[MKPointAnnotation alloc]init];
    point.coordinate = coordinate;
    point.title = @"Home";
    [self.mapView addAnnotation:point];
    
    [self.mapView setRegion:region animated:YES];
}

- (IBAction)codeFellowsPressed:(id)sender {
    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(47.618217, -122.351832);
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(coordinate, 500.0, 500.0);
    MKPointAnnotation *point = [[MKPointAnnotation alloc]init];
    point.coordinate = coordinate;
    point.title = @"Code Fellows";
    [self.mapView addAnnotation:point];
    
    [self.mapView setRegion:region animated:YES];
}

- (IBAction)momPressed:(id)sender {
    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(36.319423, -82.375835);
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(coordinate, 500.0, 500.0);
    MKPointAnnotation *point = [[MKPointAnnotation alloc]init];
    point.coordinate = coordinate;
    point.title = @"Mom";
    
    [self.mapView addAnnotation:point];
    
    
    [self.mapView setRegion:region animated:YES];
}

- (IBAction)myLocationPressed:(id)sender {
    self.mapView.showsUserLocation = YES;
    [[LocationController shared] updateLocation];
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

-(void)locationControllerUpdatedLocation:(CLLocation *)location {
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(location.coordinate, 500.0, 500.0);
    [self.mapView setRegion:region animated:YES];
}

-(MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay {
    MKCircleRenderer *renderer = [[MKCircleRenderer alloc]initWithCircle:overlay];
    
//    renderer.strokeColor = [UIColor blueColor];
    renderer.fillColor = [UIColor blueColor];
    renderer.alpha = 0.3;
    return renderer;
}

-(void)logInViewController:(PFLogInViewController *)logInController didLogInUser:(PFUser *)user {
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)signUpViewController:(PFSignUpViewController *)signUpController didSignUpUser:(PFUser *)user {
    [self dismissViewControllerAnimated:YES completion:nil];
}



@end
