//
//  MusicCell.m
//  Music
//
//  Created by rrrr on 13-4-22.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import "MusicCell.h"

@implementation MusicCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        _iconImageView = [[UIImageView alloc] init];
        _iconImageView.frame = CGRectMake(10, 10, 40, 40);
        [self.contentView addSubview:_iconImageView];
        
        
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.frame = CGRectMake(_iconImageView.right + 5, _iconImageView.top, WIDTH - _iconImageView.right - 10 - 12, 20);
        _nameLabel.font = [UIFont systemFontOfSize:16];
        [self.contentView addSubview:_nameLabel];
        
        _detailLabel = [[UILabel alloc] init];
        _detailLabel.frame = CGRectMake( _nameLabel.left, _iconImageView.centerY, _nameLabel.width, 15);
        _detailLabel.textColor = [UIColor lightGrayColor];
        _detailLabel.font = [UIFont systemFontOfSize:13];
        [self.contentView addSubview:_detailLabel];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
