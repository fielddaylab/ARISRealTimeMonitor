//
//  ARISRealtimeMonitorMasterViewController.h
//  ARISRealtimeMonitor
//
//  Created by Nick Heindl on 5/22/13.
//  Copyright (c) 2013 Nick Heindl. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ARISRealtimeMonitorDetailViewController;

@interface ARISRealtimeMonitorMasterViewController : UITableViewController

@property (strong, nonatomic) ARISRealtimeMonitorDetailViewController *detailViewController;

@end
