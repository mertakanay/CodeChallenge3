//
//  MapViewController.m
//  CodeChallenge3
//
//  Created by Vik Denic on 10/16/14.
//  Copyright (c) 2014 Mobile Makers. All rights reserved.
//

#import "MapViewController.h"
#import <MapKit/MapKit.h>
#import "BikeStation.h"

@interface MapViewController () <MKMapViewDelegate, CLLocationManagerDelegate, UIAlertViewDelegate>

@property (strong, nonatomic) IBOutlet MKMapView *mapView;
@property MKPointAnnotation *bikeStationAnnotation;
@property CLLocationManager *locationManager;

@property NSString *alertString;

@end

@implementation MapViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.locationManager = [[CLLocationManager alloc]init];
    [self.locationManager requestWhenInUseAuthorization];
    self.locationManager.delegate = self;

    self.mapView.showsUserLocation = YES;

    double latitude = self.station.latitude.doubleValue;
    double longitude = self.station.longitude.doubleValue;
    NSString *name = self.station.stationName;

    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(latitude, longitude);
    self.bikeStationAnnotation = [[MKPointAnnotation alloc]init];
    self.bikeStationAnnotation.title = name;
    self.bikeStationAnnotation.coordinate = coordinate;

    [self.mapView addAnnotation:self.bikeStationAnnotation];

    [self zoom:&latitude :&longitude];

    [self getDistance];


}

-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    MKPinAnnotationView *pinAnnotation = [[MKPinAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:nil];
    if ([annotation isEqual:self.bikeStationAnnotation]) {
        pinAnnotation.image = [UIImage imageNamed:@"bikeImage"];
    }else if([annotation isEqual:mapView.userLocation]){
        return nil;
    }

    pinAnnotation.canShowCallout = YES;
    pinAnnotation.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    return pinAnnotation;


}

-(void)getDistance;
{
    CLLocation *locA = [[CLLocation alloc] initWithLatitude:self.station.latitude.doubleValue longitude:self.station.longitude.doubleValue];

    CLLocationDistance distance = [locA distanceFromLocation:self.locationManager.location];
    self.station.distance = distance; //NEED TO FIX AND RUN THIS CODE 
    
    
}

-(void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    [self getDirections];
}

-(void)getDirections
{

    MKDirectionsRequest *request = [MKDirectionsRequest new];
    request.source = [MKMapItem mapItemForCurrentLocation];
    MKPlacemark *destinationPlacemark = [[MKPlacemark alloc]initWithCoordinate:self.bikeStationAnnotation.coordinate addressDictionary:nil];
    request.destination = [[MKMapItem alloc]initWithPlacemark:destinationPlacemark];
    MKDirections *direction = [[MKDirections alloc]initWithRequest:request];
    [direction calculateDirectionsWithCompletionHandler:^(MKDirectionsResponse *response, NSError *error) {
        NSArray *routes = response.routes;
        MKRoute *theRoute = [routes objectAtIndex:0];

        NSMutableString *stepString = [NSMutableString new];
        int stepCount = 1;
        for (MKRouteStep *step in theRoute.steps)
        {
            [stepString appendFormat:@"%i. %@\n", stepCount, step.instructions];
            stepCount++;
        }
        self.alertString = stepString;

        UIAlertController *ac  = [UIAlertController alertControllerWithTitle:@"Directions:" message:self.alertString preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        }];
        [ac addAction:action];
        [self presentViewController:ac animated:false completion:nil];
    }];

}

-(void)zoom:(double *)latitude :(double *)logitude
{
    MKCoordinateRegion region;
    region.center.latitude = *latitude;
    region.center.longitude = *logitude;
    region.span.latitudeDelta = 0.05;
    region.span.longitudeDelta = 0.05;
    region = [self.mapView regionThatFits:region];
    [self.mapView setRegion:region animated:YES];
}


@end
