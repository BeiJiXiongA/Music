//
//  PlayerView.h
//  Music
//
//  Created by rrrr on 13-4-28.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>
#import <MediaPlayer/MediaPlayer.h>

@interface PlayerView : UIViewController<AVAudioPlayerDelegate,MPMediaPickerControllerDelegate,UIScrollViewDelegate>
{
    AVAudioPlayer *player;
    NSTimer *timer;
    NSArray *listArray;
    NSString *musicFileName;
    NSString *path;
    
    NSTimeInterval sec;
    NSTimeInterval currentSec;
    NSTimeInterval leftSec;
    NSDateFormatter *timeFormatter;
    NSDate *currentDate;
    NSDate *leftDate;
    NSString *currentTime;
    NSString *leftTime;
    
    IBOutlet UILabel *musicNameLabel;
    IBOutlet UILabel *musicTimeLabel;

}
@property (nonatomic,retain)NSArray *listArray;
@property (nonatomic,copy)NSString *musicFileName;
@property (nonatomic,copy)NSString *musicName;
//@property (nonatomic,copy)NSString *path;
@property (retain, nonatomic) IBOutlet UILabel *musicNameLabel;
@property (retain, nonatomic) IBOutlet UILabel *musicTimeLabel;
- (IBAction)progressSliderValueChange:(id)sender;

- (IBAction)favClick:(id)sender;
- (IBAction)addToClick:(id)sender;
- (IBAction)downloadClick:(id)sender;
- (IBAction)sharedClick:(id)sender;
- (IBAction)playModel:(id)sender;
- (IBAction)preClick:(id)sender;
- (IBAction)playClick:(id)sender;
- (IBAction)nextClick:(id)sender;
- (IBAction)listClick:(id)sender;
- (IBAction)backClick:(UIButton *)backClick;

@end
