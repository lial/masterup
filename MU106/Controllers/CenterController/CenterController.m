//
//  CenterController.m
//  MU106
//
//  Created by Alex Lifantyev on 04.11.13.
//  Copyright (c) 2013 Instup.com. All rights reserved.
//

#import "CenterController.h"

@interface CenterController ()

@end

@implementation CenterController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.polylines = [[NSMutableArray alloc] init];
    [self.map setShowsUserLocation:YES];
    [self.map setUserTrackingMode:MKUserTrackingModeFollow animated:YES];
    
	if ([[ApiRouteClient sharedInstance] isNeedUpdateRoutes]){
        self.navigationItem.leftBarButtonItem.enabled = NO;
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        
        [[ApiRouteClient sharedInstance] updateRoutesListWithSuccess:^{
            NSLog(@"Updated routes from server");
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            self.navigationItem.leftBarButtonItem.enabled = YES;
        } andFail:^(NSError *error) {
            NSLog(@"Update routes from server: Error %@", error);
        }];
    }
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationRouteSelected:) name:kNotificationRouteSelected object:nil];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (IBAction)addToFavorites:(id)sender {
    
}

- (void)notificationRouteSelected:(NSNotification *)notification
{
    [self.map removeOverlays:self.polylines];
    [self.polylines removeAllObjects];
    self.routeSelected = (Route *)notification.object;
    self.title = self.routeSelected.title;
    NSData *routePath = [self.routeSelected.path dataUsingEncoding:NSUTF8StringEncoding];
    NSArray *path = [NSJSONSerialization JSONObjectWithData:routePath options:0 error:nil];
    
    if (path) {
        CLLocationCoordinate2D coords[[path count]];
        int i=0;
        for (NSDictionary *coord in path) {
            coords[i++] = CLLocationCoordinate2DMake([[coord objectForKey:@"x"] floatValue], [[coord objectForKey:@"y"] floatValue]);
        }
        MKPolyline *polyline = [MKPolyline polylineWithCoordinates:coords count:[path count]];
        [self.map addOverlay:polyline];
        [self.polylines addObject:polyline];
        
        MKPolygon *polygon = [MKPolygon polygonWithPoints:polyline.points count:polyline.pointCount];
        [self.map setRegion:MKCoordinateRegionForMapRect([polygon boundingMapRect]) animated:YES];
        }
    NSLog(@"DATA = %@", path);
}

- (MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay:(id<MKOverlay>)overlay
{
    if ([overlay isKindOfClass:[MKPolyline class]]) {
        MKPolyline *polyline = (MKPolyline *)overlay;
        MKPolylineView *polylineView = [[MKPolylineView alloc] initWithPolyline:polyline];
        polylineView.strokeColor = [UIColor redColor];
        polylineView.lineWidth = 3;
        
        return polylineView;
    }
    return nil;
}

@end
