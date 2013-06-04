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
    
    [lostPassword setTextColor:[UIColor redColor]];
    
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



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if([indexPath section] != 0){
        
        //grab the username and password from the textfields, verify that they are correct
        
        LoginTableCell *loginUsernameCell = (LoginTableCell *)[tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
        LoginTableCell *loginPasswordCell = (LoginTableCell *)[tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
        
        NSString *username = [[loginUsernameCell textField] text];
        NSString *password = [[loginPasswordCell textField] text];

        //[self attemptLoginWithUsername:username andPassword:password];
        
        ARISRealtimeMonitorMasterViewController *masterViewController = [[ARISRealtimeMonitorMasterViewController alloc] initWithNibName:@"ARISRealtimeMonitorMasterViewController_iPhone" bundle:nil];
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:masterViewController];
        UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
        [cell.textLabel resignFirstResponder];
        

        
        [self presentViewController:navigationController animated:YES completion:nil];
    }
}

- (void) attemptLoginWithUsername:(NSString *)username andPassword:(NSString *)password
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginResponseReady:) name:@"LoginResponseReady" object:nil];
    [[AppServices sharedAppServices] loginUserName:username password:password userInfo:nil];
}

- (void) loginResponseReady:(NSNotification *)n
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"LoginResponseReady" object:nil];
    NSLog(@"Login Response YES");
//    ServiceResult *r = (ServiceResult *)[n.userInfo objectForKey:@"result"];
//    if(!r.data || r.data == [NSNull null])
//        [[ARISAlertHandler sharedAlertHandler] showAlertWithTitle:@"Login Unsuccessful" message:@"Username/Password not found"];
//    else
//    {
//        Player *p = [[Player alloc] initWithDictionary:(NSMutableDictionary *)r.data];
//        if(location) p.location = location;
//        [delegate loginCredentialsApprovedForPlayer:p toGame:gameId newPlayer:newPlayer disableLeaveGame:disableLeaveGame];
//    }
}


-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}
@end
