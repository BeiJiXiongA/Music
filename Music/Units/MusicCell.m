//
//  MusicCell.m
//  Music
//
//  Created by rrrr on 13-4-22.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import "MusicCell.h"

@implementation MusicCell
//@synthesize musicNameLabel,singerNameLabel,btn;
@synthesize textLabel;
@synthesize detailLabel;
@synthesize imageView;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        textLabel.font = [UIFont systemFontOfSize:12];
        detailLabel.font = [UIFont systemFontOfSize:10];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end