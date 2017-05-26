//
//  PlayViewController.h
//  Music
//
//  Created by rrrr on 13-4-24.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MusicListViewController;

@interface PlayViewController : UIViewController<AVAudioPlayerDelegate,MPMediaPickerControllerDelegate,UIScrollViewDelegate,UITableViewDataSource,UITableViewDelegate>
{
    
    BOOL Hidden;
    UIButton *btnShowNav;
    
    UISlider *soundSlider;
    UISlider *progressSlider;
    
    UILabel *musicNameLabel;
    UILabel *soundValueLabel;
    UILabel *progressLeftLabel;
    UILabel *progressRightLabel;
    
    UIButton *backButton;
    UIButton *backwordButton;
    UIButton *playButton;
    UIButton *forwardButton;
    UIButton *listButton;
    
    UIScrollView *midScrollView;
    BOOL show;
    UIImageView *midImageView;
    
    NSTimer *timer;
    BOOL play;
    
    NSString *path;
    MPMediaItemCollection *songs;
//    AVAudioPlayer *Player;
    NSTimeInterval sec;
    NSTimeInterval currentSec;
    NSTimeInterval leftSec;
    NSDateFormatter *timeFormatter;
    NSDate *currentDate;
    NSDate *leftDate;
    NSString *currentTime;
    NSString *leftTime;
    
    NSString *lyrics;
    UIScrollView *lyricsScrollView;
    UILabel *label;
    NSString *labelText;
    NSMutableDictionary *lyricsDict;
    
    BOOL soundShow;
    BOOL showList;
    
    NSString *musicFileName;
    
    UITableView *musicListTableView;
    
}
+(id)sharedPlayerViewController;
@property (nonatomic,copy)NSString *musicFileName;
@property (nonatomic,assign)NSInteger currentMusic;
@property (nonatomic,retain)NSArray *songsArray;
@property (nonatomic,retain)NSTimer *timer;
@property (nonatomic,copy)NSString *path;
//@property (nonatomic,retain)AVAudioPlayer *player;
@property (nonatomic,retain)MPMediaItemCollection *songs;
@property (nonatomic,copy)NSString *musicName;
@property (nonatomic,assign)BOOL gono;

-(void)preMusic:(UIButton *)button;
-(void)controlMusic:(UIButton *)button;
-(void)nextMusic:(UIButton *)button;
-(void)listClick:(UIButton *)button;

@end
