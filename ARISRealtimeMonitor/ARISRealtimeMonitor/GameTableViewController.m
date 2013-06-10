//
//  GameTableViewController.m
//  ARISRealtimeMonitor
//
//  Created by Nick Heindl on 5/22/13.
//  Copyright (c) 2013 Nick Heindl. All rights reserved.
//

#import "GameTableViewController.h"

#import "AppModel.h"
#import "AppServices.h"
#import "Event.h"

static const int TIME_INTERVAL = 3;

@interface GameTableViewController ()

@property (nonatomic, strong) NSTimer *myTimer;

@end

@implementation GameTableViewController

@synthesize game;
@synthesize table;
@synthesize myTimer;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void) eventsReady:(NSNotification *)n{
    //NSLog(@"Events Ready");
    NSLog(@"Size of events: %i", [[[AppModel sharedAppModel] events] count]);
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"EventsReady" object:nil];
    [self.table reloadData];
}

-(void)updateEvents{
    NSLog(@"Update events");
//    [[AppModel sharedAppModel] setEvents:[[NSMutableArray alloc] init]];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(eventsReady:) name:@"EventsReady" object:nil];
   [[AppServices sharedAppServices] getLogsForGame:[NSString stringWithFormat:@"%i", self.game.gameId] minutes:[NSString stringWithFormat:@"%i", 3]];
}

- (void)viewWillDisappear:(BOOL)animated{
    [myTimer invalidate];
    myTimer = nil;
    [AppModel sharedAppModel].events = [[NSMutableArray alloc] init];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:NO];
    self.table.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
    
    //get the events for the past 5 minutes
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(eventsReady:) name:@"EventsReady" object:nil];
    [[AppServices sharedAppServices] getLogsForGame:[NSString stringWithFormat:@"%i", game.gameId] minutes:[NSString stringWithFormat:@"%i", 5]];
    
    myTimer = [NSTimer scheduledTimerWithTimeInterval:3.0
                                               target:self
                                             selector:@selector(updateEvents)
                                             userInfo:nil
                                              repeats:YES];
}

- (void)viewDidLoad
{

    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
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
    return [[[AppModel sharedAppModel] events] count];
    //return 32;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.table setScrollsToTop:NO];
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    Event *tempEvent = [[[AppModel sharedAppModel] events] objectAtIndex:indexPath.row];
    cell.textLabel.text = [self displayEvent:tempEvent];
    //cell.detailTextLabel.text = @"Arsenal Player";
    return cell;
}

-(NSString *)displayEvent:(Event *)event{
    
    //change these to localized strings
    if([event.eventType isEqualToString:@"VIEW_MAP"]){
        return [NSString stringWithFormat:@"%@ viewed the map", event.username];
    }
    else if([event.eventType isEqualToString:@"PICKUP_ITEM"]){
        return [NSString stringWithFormat:@"%@ picked up an item", event.username];
    }
    else if([event.eventType isEqualToString:@"DROP_ITEM"]){
        return [NSString stringWithFormat:@"%@ dropped an item", event.username];
    }
    else if([event.eventType isEqualToString:@"DROP_NOTE"]){
        return [NSString stringWithFormat:@"%@ dropped a note", event.username];
    }
    else if([event.eventType isEqualToString:@"DESTROY_ITEM"]){
        return [NSString stringWithFormat:@"%@ destroyed an item", event.username];
    }
    else if([event.eventType isEqualToString:@"VIEW_ITEM"]){
        return [NSString stringWithFormat:@"%@ viewed an item", event.username];
    }
    else if([event.eventType isEqualToString:@"VIEW_NODE"]){
        return [NSString stringWithFormat:@"%@ viewed a node", event.username];
    }
    else if([event.eventType isEqualToString:@"VIEW_NPC"]){
        return [NSString stringWithFormat:@"%@ viewed a character", event.username];
    }
    else if([event.eventType isEqualToString:@"VIEW_WEBPAGE"]){
        return [NSString stringWithFormat:@"%@ viewed a webpage", event.username];
    }
    else if([event.eventType isEqualToString:@"VIEW_AUGBUBBLE"]){
        return [NSString stringWithFormat:@"%@ viewed an augbubble", event.username];
    }
    else if([event.eventType isEqualToString:@"VIEW_QUESTS"]){
        return [NSString stringWithFormat:@"%@ viewed their quests", event.username];
    }
    else if([event.eventType isEqualToString:@"VIEW_INVENTORY"]){
        return [NSString stringWithFormat:@"%@ viewed their inventory", event.username];
    }
    else if([event.eventType isEqualToString:@"ENTER_QRCODE"]){
        return [NSString stringWithFormat:@"%@ entered a qrcode", event.username];
    }
    else if([event.eventType isEqualToString:@"UPLOAD_MEDIA_ITEM"]){
        return [NSString stringWithFormat:@"%@ uploaded media", event.username];
    }
    else if([event.eventType isEqualToString:@"UPLOAD_MEDIA_ITEM_IMAGE"]){
        return [NSString stringWithFormat:@"%@ uploaded an image", event.username];
    }
    else if([event.eventType isEqualToString:@"UPLOAD_MEDIA_ITEM_AUDIO"]){
        return [NSString stringWithFormat:@"%@ uploaded an audio clip", event.username];
    }
    else if([event.eventType isEqualToString:@"UPLOAD_MEDIA_ITEM_VIDEO"]){
        return [NSString stringWithFormat:@"%@ uploaded an video clip", event.username];
    }
    else if([event.eventType isEqualToString:@"RECEIVE_WEBHOOK"]){
        return [NSString stringWithFormat:@"%@ received a webhook", event.username];
    }
    else if([event.eventType isEqualToString:@"SEND_WEBHOOK"]){
        return [NSString stringWithFormat:@"%@ sent a webhook", event.username];
    }
    else if([event.eventType isEqualToString:@"COMPLETE_QUEST"]){
        return [NSString stringWithFormat:@"%@ completed a quest", event.username];
    }
    else if([event.eventType isEqualToString:@"GET_NOTE"]){
        return [NSString stringWithFormat:@"%@ got a note", event.username];
    }
    else if([event.eventType isEqualToString:@"GIVE_NOTE_LIKE"]){
        return [NSString stringWithFormat:@"%@ liked a note", event.username];
    }
    else if([event.eventType isEqualToString:@"GET_NOTE_LIKE"]){
        return [NSString stringWithFormat:@"%@ received a like on their note", event.username];
    }
    else if([event.eventType isEqualToString:@"GIVE_NOTE_COMMENT"]){
        return [NSString stringWithFormat:@"%@ commented on a note", event.username];
    }
    else if([event.eventType isEqualToString:@"GET_NOTE_COMMENT"]){
        return [NSString stringWithFormat:@"%@ received a comment on their note", event.username];
    }
    else{
        return event.eventType;
    }
    
    
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //do something when a cell is pressed
}


//this can be deleted
- (IBAction)addEntry:(id)sender {
    
    //[self.table reloadData];
}
@end
