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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (IBAction)addToFavorites:(id)sender {
    
}
@end
