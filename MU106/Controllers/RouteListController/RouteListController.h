//
//  RouteListController.h
//  MU106
//
//  Created by Alex Lifantyev on 29.10.13.
//  Copyright (c) 2013 Instup.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Model.h"
#import "Classes.h"
#import "MBProgressHUD.h"

@interface RouteListController : UITableViewController

    @property (strong, nonatomic) IBOutlet UITableView *tableView;

- (IBAction)toggleFavorites:(UITapGestureRecognizer *)sender;

@end
