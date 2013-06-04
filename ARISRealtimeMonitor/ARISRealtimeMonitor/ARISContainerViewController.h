//
//  ARISContainerViewController.h
//  ARIS
//
//  Created by Phil Dougherty on 5/7/13.
//
//

#import <UIKit/UIKit.h>

@interface ARISContainerViewController : UIViewController
{
    UIViewController *currentChildViewController;
}

@property (strong, nonatomic) UIViewController* currentChildViewController;

- (void) displayContentController:(UIViewController*)content;

- (void) cycleFromViewController:(UIViewController*)oldC toViewController:(UIViewController*)newC;

@end
