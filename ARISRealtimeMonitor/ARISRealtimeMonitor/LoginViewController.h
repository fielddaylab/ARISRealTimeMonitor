//
//  LoginViewController.h
//  ARISRealtimeMonitor
//
//  Created by Justin Moeller on 5/22/13.
//  Copyright (c) 2013 Nick Heindl. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginViewController : UIViewController
- (IBAction)dismissKeyboard:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *lostPassword;

@end
