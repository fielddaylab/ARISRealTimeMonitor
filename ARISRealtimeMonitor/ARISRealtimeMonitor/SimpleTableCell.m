//
//  SimpleTableCell.m
//  ARISRealtimeMonitor
//
//  Created by Justin Moeller on 5/23/13.
//  Copyright (c) 2013 Nick Heindl. All rights reserved.
//

#import "SimpleTableCell.h"

@implementation SimpleTableCell

@synthesize gameLabel;
@synthesize playersLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
