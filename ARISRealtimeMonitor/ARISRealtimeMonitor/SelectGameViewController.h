//
//  SelectGameViewController.h
//  ARISRealtimeMonitor
//
//  Created by Justin Moeller on 6/4/13.
//  Copyright (c) 2013 Nick Heindl. All rights reserved.
//

#import "GameViewController.h"

@interface SelectGameViewController : UIViewController

@property (strong, nonatomic) GameViewController *gameViewController;
@property (weak, nonatomic) IBOutlet UITableView *selectGameTableView;
@property (strong, nonatomic) NSString *editorId;
@property (strong, nonatomic) NSString *editorToken;

@end
