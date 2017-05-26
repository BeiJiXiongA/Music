//
//  zwAppDelegate.h
//  Music
//
//  Created by rrrr on 13-4-22.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>
#import <MediaPlayer/MediaPlayer.h>

#import "QFTabBarController.h"


@interface zwAppDelegate : UIResponder <UIApplicationDelegate,AVAudioPlayerDelegate>
{
    QFTabBarController *myTabBarController;
    
//    AVAudioPlayer *player;

}
@property (strong, nonatomic) UIWindow *window;
@property (nonatomic,retain) QFTabBarController * myTabBarController;
//@property (nonatomic,retain) AVAudioPlayer *player;
@end
