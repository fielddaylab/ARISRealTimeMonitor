//
//  LoginViewController.m
//  ARISRealtimeMonitor
//
//  Created by Justin Moeller on 5/22/13.
//  Copyright (c) 2013 Nick Heindl. All rights reserved.
//

#import "LoginViewController.h"
#import "LostPasswordViewController.h"
#import "ARISRealtimeMonitorMasterViewController.h"
#import "LoginTableCell.h"
#import "AppModel.h"
#import "AppServices.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

@synthesize lostPassword;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)userTappedOnLostPassword:(UIGestureRecognizer*)gestureRecognizer
{
    LostPasswordViewController *lostPasswordView = [[LostPasswordViewController alloc] initWithNibName:@"LostPasswordViewController" bundle:nil];
    
    [self.navigationController pushViewController:lostPasswordView animated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    NSDictionary *underlineAttribute = @{NSUnderlineStyleAttributeName: @1};
    lostPassword.attributedText = [[NSAttributedString alloc] initWithString:@"Lost Password" attributes:underlineAttribute];
    
    UITapGestureRecognizer* gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(userTappedOnLostPassword:)];
    [lostPassword setUserInteractionEnabled:YES];
    [lostPassword addGestureRecognizer:gesture];
    
    
    // Do any additional setup after loading the view from its nib.
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section == 0){
        return 2;
    }
    else{
        return 1;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if([indexPath section] == 0){
        static NSString *CellIdentifier = @"TextFieldCell";
        LoginTableCell *cell = (LoginTableCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if(cell == nil){
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"LoginTableCell" owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
        
        if(indexPath.row == 0){
            cell.textField.placeholder = @"Username";
        }
        else{
            cell.textField.placeholder = @"Password";
            cell.textField.secureTextEntry = YES;
            [cell.textField setReturnKeyType:UIReturnKeyGo];
        }
        
        return cell;
    }
    else{
        static NSString *CellIdentifier = @"Cell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if(cell == nil){
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        cell.textLabel.text = @"Login";
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        return cell;
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return NO;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    //    if (editingStyle == UITableViewCellEditingStyleDelete) {
    //        [_objects removeObjectAtIndex:indexPath.row];
    //        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    //    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
    //        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    //    }
}

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
 {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if([indexPath section] != 0){
        
        //grab the username and password from the textfields, verify that they are correct
        
        LoginTableCell *loginUsernameCell = (LoginTableCell *)[tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
        LoginTableCell *loginPasswordCell = (LoginTableCell *)[tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
        
        NSString *username = [[loginUsernameCell textField] text];
        NSString *password = [[loginPasswordCell textField] text];
        
        ARISRealtimeMonitorMasterViewController *masterViewController = [[ARISRealtimeMonitorMasterViewController alloc] initWithNibName:@"ARISRealtimeMonitorMasterViewController_iPhone" bundle:nil];
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:masterViewController];
        UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
        [cell.textLabel resignFirstResponder];
        
        //this will need to be moved
        [[AppModel instance] setGameEvents:[[NSMutableArray alloc]init]];
        
        [self presentViewController:navigationController animated:YES completion:nil];
    }
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}
@end
