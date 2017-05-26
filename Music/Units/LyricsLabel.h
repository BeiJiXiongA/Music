//
//  LyricsLabel.h
//  Music
//
//  Created by rrrr on 13-4-28.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LyricsLabel : NSObject
{
    NSString *key;
    NSString *object;
}
@property (nonatomic,copy)NSString *key;
@property (nonatomic,copy)NSString *object;
@end
