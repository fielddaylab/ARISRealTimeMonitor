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
#import "Game.h"
#import "JSON.h"

@interface SelectGameViewController ()

@end

@implementation SelectGameViewController

@synthesize gameViewController, selectGameTableView, editorId, editorToken;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"NavBarGameSelect", nil);
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
            self.contentSizeForViewInPopover = CGSizeMake(320.0, 600.0);
        }
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"NavBarToLoginFromGameSelect", nil) style:UIBarButtonItemStyleBordered target:self action:@selector(logoutAction)];
}

-(void)viewWillAppear:(BOOL)animated{
    //attempt to get games list
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gamesListReady:) name:@"GamesListReady" object:nil];
    [[AppServices sharedAppServices] getGamesForEditor:editorId editorToken:editorToken];
}

- (void) gamesListReady:(NSNotification *)n{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"GamesListReady" object:nil];
    [selectGameTableView reloadData];
    NSLog(@"gamesListReady");
}

    
- (void)logoutAction
{ 
    [self.navigationController popViewControllerAnimated:YES];    
    //exit(0);
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
    return [[[AppModel sharedAppModel] listOfPlayersGames] count];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}




// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.selectGameTableView setScrollsToTop:NO];
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
//    Event *tempEvent = [[[AppModel sharedAppModel] events] objectAtIndex:indexPath.row];
//    cell.textLabel.text = [self displayPlayer:tempEvent];
//    cell.detailTextLabel.text = [self displayEvent:tempEvent];
//    return cell;
    
    Game *game = [[[AppModel sharedAppModel] listOfPlayersGames] objectAtIndex:indexPath.row];
    cell.textLabel.text = game.name;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    
    NSString *stringPlayer = NSLocalizedString(@"LabelGameSelectPlayer", nil);
    NSString *stringPlayers = NSLocalizedString(@"LabelGameSelectPlayers", nil);
    cell.detailTextLabel.text = (game.numPlayers == 1)? [NSString stringWithFormat:@"%@: %i", stringPlayer, game.numPlayers]: [NSString stringWithFormat:@"%@: %i", stringPlayers, game.numPlayers];

    return cell;
}



//// Customize the appearance of table view cells.
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    
//    static NSString *CellIdentifier = @"SimpleTableItem";
//    SimpleTableCell *cell = (SimpleTableCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
//    if (cell == nil) {
//        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"SimpleTableCell" owner:self options:nil];
//        cell = [nib objectAtIndex:0];
//        
//    }
//    
//    Game *game = [[[AppModel sharedAppModel] listOfPlayersGames] objectAtIndex:indexPath.row];
//    cell.gameLabel.text = game.name;
//    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
//    //the number of players in the game will always be 0 because the server isn't currently returning the number of players
//    //commented out because its not working, will put back in later
//    cell.playersLabel.text = (game.numPlayers == 1)? [NSString stringWithFormat:@"%i player", game.numPlayers]: [NSString stringWithFormat:@"%i players", game.numPlayers];
//    //cell.playersLabel.text = [NSString stringWithFormat:@"%i players", game.numPlayers];
//    return cell;
//}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.backgroundColor = (indexPath.row%2)?[UIColor colorWithRed:210.0/255.0 green:214.0/255.0 blue:217.0/255.0 alpha:1.0]:[UIColor clearColor];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
 
    Game *game = [[[AppModel sharedAppModel] listOfPlayersGames] objectAtIndex:indexPath.row];
    
    self.gameViewController = [[GameViewController alloc] initWithNibName:@"GameViewController" bundle:nil];
    self.gameViewController.game = game;
    
    //Set the 'GAMES' back button for Map/TableViews here.
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"NavBarToGameSelect", nil) style:UIBarButtonItemStyleBordered target:nil action:nil];
    
    [self.navigationController pushViewController:self.gameViewController animated:YES];
    
}
@end
