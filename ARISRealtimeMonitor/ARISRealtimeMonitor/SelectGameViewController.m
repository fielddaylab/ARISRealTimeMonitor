//
//  SelectGameViewController.m
//  ARISRealtimeMonitor
//
//  Created by Justin Moeller on 6/4/13.
//  Copyright (c) 2013 Nick Heindl. All rights reserved.
//

#import "SelectGameViewController.h"
#import "SimpleTableCell.h"
#import "AppModel.h"
#import "AppServices.h"

@interface SelectGameViewController ()

@end

@implementation SelectGameViewController

@synthesize gameViewController, loginViewController;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"Select a Game";
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
            self.contentSizeForViewInPopover = CGSizeMake(320.0, 600.0);
        }
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
//    //attempt to get games list
//    NSString *editorId = @"2140";
//    NSString *editorToken = @"qGcc01sKSIcFrrkXoy09T5pDU7QWgrGwXJyOARojprOHIYuXmlW6gcz19fNgxjCk";
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gamesListReady:) name:@"GamesListReady" object:nil];
//    [[AppServices sharedAppServices] getGamesForEditor:editorId editorToken:editorToken];
    
    
    [[AppModel sharedAppModel] setGamesList:[[AppServices sharedAppServices] getGamesList]];
    [[AppModel sharedAppModel] setPlayersList:[[AppServices sharedAppServices] getPlayersList]];
    
    //this will need to be moved
    [[AppModel sharedAppModel] setGameEvents:[[NSMutableArray alloc]init]];
    
   // toolbar.autoresizingMask |= UIViewAutoresizingFlexibleWidth;
}

- (void)logoutAction
{ 
    self.loginViewController = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
    [self presentViewController:self.loginViewController animated:YES completion:nil];

    //exit(0);
}

- (void) gamesListReady:(NSNotification *)n{
    NSLog(@"gamesListReady");
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[[AppModel sharedAppModel] gamesList] count];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    //    if([indexPath section] == 0){
    static NSString *CellIdentifier = @"SimpleTableItem";
    SimpleTableCell *cell = (SimpleTableCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"SimpleTableCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
        
    }
    cell.gameLabel.text = [[[AppModel sharedAppModel] gamesList] objectAtIndex:indexPath.row];
    cell.playersLabel.text = [[[AppServices sharedAppServices] getPlayersList] objectAtIndex:0];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
 
    NSString *game = [[[AppModel sharedAppModel] gamesList] objectAtIndex:indexPath.row];
    //NSString *game = [[[AppServices instance] getGamesList] objectAtIndex:indexPath.row];
    
    
    self.gameViewController = [[GameViewController alloc] initWithNibName:@"GameViewController" bundle:nil];
    self.gameViewController.game = game;
    
    
    //Set the 'GAMES' back button for Map/TableViews here.
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Games" style:UIBarButtonItemStyleBordered target:nil action:nil];
    
    
    if([[[AppModel sharedAppModel] gameEvents] count] <= indexPath.row){
        self.gameViewController.gameAccessNum = [[[AppModel sharedAppModel] gameEvents] count];
        [[[AppModel sharedAppModel] gameEvents] addObject:[[AppServices sharedAppServices] getGameEventsForGame:indexPath.row]];
    }
    else{
        NSMutableArray *eventsToInsert = [[[AppModel sharedAppModel] gameEvents] objectAtIndex:indexPath.row];
        if(![[[AppModel sharedAppModel] gameEvents] containsObject:eventsToInsert]){
            self.gameViewController.gameAccessNum = [[[AppModel sharedAppModel] gameEvents] count];
            [[[AppModel sharedAppModel] gameEvents] addObject:[[AppServices sharedAppServices] getGameEventsForGame:indexPath.row]];
        }
        else{
            self.gameViewController.gameAccessNum = [[[AppModel sharedAppModel] gameEvents] indexOfObject:eventsToInsert];
        }
    }
    
    [self.navigationController pushViewController:self.gameViewController animated:YES];
    
}
@end
