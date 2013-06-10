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
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gamesListReady:) name:@"GamesListReady" object:nil];
    [[AppServices sharedAppServices] getGamesForEditor:editorId editorToken:editorToken];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Logout" style:UIBarButtonItemStyleBordered target:self action:@selector(logoutAction)];
    
    //this will need to be moved
    [[AppModel sharedAppModel] setGameEvents:[[AppServices sharedAppServices] getGameEvents]];
    
    
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
    
    //    if([indexPath section] == 0){
    static NSString *CellIdentifier = @"SimpleTableItem";
    SimpleTableCell *cell = (SimpleTableCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"SimpleTableCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
        
    }
    Game *game = [[[AppModel sharedAppModel] listOfPlayersGames] objectAtIndex:indexPath.row];
    cell.gameLabel.text = game.name;
    //the number of players in the game will always be 0 because the server isn't currently returning the number of players
    cell.playersLabel.text = [NSString stringWithFormat:@"%i players", game.numPlayers];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
 
    Game *game = [[[AppModel sharedAppModel] listOfPlayersGames] objectAtIndex:indexPath.row];
    
    self.gameViewController = [[GameViewController alloc] initWithNibName:@"GameViewController" bundle:nil];
    self.gameViewController.game = game;
    
    
    //Set the 'GAMES' back button for Map/TableViews here.
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Games" style:UIBarButtonItemStyleBordered target:nil action:nil];
    
    [self.navigationController pushViewController:self.gameViewController animated:YES];
    
}
@end
