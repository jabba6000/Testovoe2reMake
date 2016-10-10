//
//  ContactsViewController.m
//  TestovoeRestaurant
//
//  Created by Uri Fuholichev on 10/8/16.
//  Copyright © 2016 Andrei Karpenia. All rights reserved.
//

#import "ContactsViewController.h"
#import "SWRevealViewController.h"
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>

@interface ContactsViewController() <CLLocationManagerDelegate, MKMapViewDelegate> {
    CLLocationManager *locationManager;
}
@property (strong, nonatomic) IBOutlet MKMapView *mapView;
@property (nonatomic) CLLocationCoordinate2D restOneCoordinates;
@property (nonatomic) CLLocationCoordinate2D restTwoCoordinates;

@end

@implementation ContactsViewController

- (void)viewDidLoad {
    //These line of code were added to connect VC with sideMenuController
    SWRevealViewController *revealViewController = self.revealViewController;
    if ( revealViewController ){
        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    }
    self.mapView.delegate = self;
    locationManager = [[CLLocationManager alloc] init];
    [locationManager requestWhenInUseAuthorization];
    [locationManager startUpdatingLocation];
    // Here we add annotation for the first restaurant coordinates
    _restOneCoordinates = CLLocationCoordinate2DMake(47.650323, -122.349433);
    MKPointAnnotation *annotationOne = [[MKPointAnnotation alloc] init];
    [annotationOne setCoordinate:_restOneCoordinates];
    [annotationOne setTitle:@"Restaurant"];
    [annotationOne setSubtitle:@"First"];
    [self.mapView addAnnotation:annotationOne];
    // Here we add annotation for the second restaurant coordinates
    _restTwoCoordinates = CLLocationCoordinate2DMake(47.650529, -122.350785);
    MKPointAnnotation *annotationTwo = [[MKPointAnnotation alloc] init];
    [annotationTwo setCoordinate:_restTwoCoordinates];
    [annotationTwo setTitle:@"Restaurant"];
    [annotationTwo setSubtitle:@"Second"];
    [self.mapView addAnnotation:annotationTwo];
}

// Next buttons are to show current user's location and 2 restaurants' positions
- (IBAction)addressOneButton:(UIButton *)sender {
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(_restOneCoordinates, 400, 400);
    [self.mapView setRegion:[self.mapView regionThatFits:region] animated:YES];
}

- (IBAction)addressTwoButton:(UIButton *)sender {
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(_restTwoCoordinates, 400, 400);
    [self.mapView setRegion:[self.mapView regionThatFits:region] animated:YES];
}

- (IBAction)currentLocationButton:(UIButton *)sender {
    [self.mapView setUserTrackingMode:MKUserTrackingModeFollow animated:YES];
    CLLocationCoordinate2D userCoordinate = [[locationManager location] coordinate];;
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(userCoordinate, 200, 200);
    [self.mapView setRegion:[self.mapView regionThatFits:region] animated:YES];
}

@end
