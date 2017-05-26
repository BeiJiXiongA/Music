//
//  MusicItem.m
//  Music
//
//  Created by rrrr on 13-4-22.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import "MusicItem.h"

@implementation MusicItem
@synthesize musicName = _musicName,singerName = _singerName;
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
