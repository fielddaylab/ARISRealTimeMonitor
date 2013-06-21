//
//  LoginTableCell.m
//  ARISRealtimeMonitor
//
//  Created by Justin Moeller on 5/23/13.
//  Copyright (c) 2013 Nick Heindl. All rights reserved.
//

#import "LoginTableCell.h"

@implementation LoginTableCell

@synthesize textField;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}


@end
