//
//  PlayViewController.m
//  Music
//
//  Created by rrrr on 13-4-24.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import "PlayViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>
#import <MediaPlayer/MediaPlayer.h>
#import "UIView+SetRect.h"
#import "UIImage+ImageFromColor.h"

@class MusicListViewController;

static PlayViewController *playerVC;

@implementation PlayViewController
{
    AVAudioPlayer *player;
}

@synthesize timer,songsArray,musicName,currentMusicPath;

+(id)sharedPlayerViewController
{
    if (!playerVC)
    {
        playerVC = [[PlayViewController alloc]init];
    }
    return playerVC;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

-(void)searchLyrics:(NSString *)time
{
    NSRange range1 = [lyrics rangeOfString:time];
    if (range1.location != NSNotFound)
    {
        labelText=[lyrics substringFromIndex:[lyrics rangeOfString:time].location];
        
    }
}

-(NSArray *)handleLyrics:(NSString *)musicLyrics
{
    NSArray *lyricsArray = [musicLyrics componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"[]"]];
    int i;
    
    NSMutableString *lyricsStr = [[NSMutableString alloc]initWithCapacity:0];
    
    for (i=0;i<[lyricsArray count];i++)
    {
        NSString *str1 = [lyricsArray objectAtIndex:i];
        
        if ([str1 length]!=0 && [str1 characterAtIndex:0] >= '0' && [str1 characterAtIndex:0] <= '9' )
        {
            [lyricsStr insertString:[NSString stringWithFormat:@"%@#",str1] atIndex:[lyricsStr length]];
            int t=i+1;
            for (; t<[lyricsArray count]; t++)
            {
                NSString *str2 = [lyricsArray objectAtIndex:t];
                if ([str2 length]!=0 && !([str2 characterAtIndex:0] >= '0' && [str2 characterAtIndex:0] <= '9'))
                {
                    [lyricsStr insertString:[NSString stringWithFormat:@"%@*",str2] atIndex:[lyricsStr length]]; 
                    i++;
                    break;
                }
                
            }
        }
    }
    
    NSMutableArray *array = [NSMutableArray arrayWithArray:[lyricsStr componentsSeparatedByString:@"*"]];
    NSMutableArray *mArray = [[NSMutableArray alloc]initWithCapacity:0];
    
    for (i = 0 ; i< [array count]-1; i++)
    {
        NSString *str = [array objectAtIndex:i];
        
        NSArray *array = [str componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@":.#"]];
        int secondTime = [[array objectAtIndex:0] intValue]*60*100+[[array objectAtIndex:1] intValue]*100+[[array objectAtIndex:2]intValue];
        
        NSString *head = [NSString stringWithFormat:@"%d#%@",secondTime,[array objectAtIndex:3]];
        [mArray addObject:head];
    }
    
    NSMutableArray *mArray2 = [[NSMutableArray alloc]initWithCapacity:0];
    for (i=0;i<[mArray count]; i++)
    {
        NSString *minstr = [mArray objectAtIndex:i];
        int value1 = [minstr intValue];
        for (int j=i+1; j<[mArray count]; j++)
        {
            NSString *str = [mArray objectAtIndex:j];
            int value2 = [str intValue];
            if (value1 > value2)
            {
                minstr = str;
                break;
            }
        }
        [mArray2 addObject:minstr];
        [mArray removeObject:minstr];
        i=0;
    }
    return mArray2;
}

-(void)scrollLyrics:(NSArray *)array
{
    
    for (int i = 0; i < [array count]; i++)
    {
        CAMediaTimingFunction *tf = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        CABasicAnimation *fader = [CABasicAnimation animationWithKeyPath:@"opacity"];
        [fader setFromValue:[NSNumber numberWithFloat:1.0]];
        [fader setToValue:[NSNumber numberWithFloat:0.0]];
        
        CABasicAnimation *mover = [CABasicAnimation animationWithKeyPath:@"position"];
        [mover setFromValue:[NSValue valueWithCGPoint:CGPointMake(160, 0)]];
        [mover setToValue:[NSValue valueWithCGPoint:CGPointMake(160, -20)]];
        
        CAAnimationGroup *group = [CAAnimationGroup animation];
        group.duration = 15;
        [group setAnimations:[NSArray arrayWithObjects:fader,mover, nil]];
        group.repeatCount = 5;
        [group setTimingFunction:tf];
        
        UILabel *midLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, i*30, 320, 20)];
        
        NSString *labelStr = [array objectAtIndex:i];
        NSArray *labelArray = [labelStr componentsSeparatedByString:@"#"];
        [lyricsDict setObject:[labelArray objectAtIndex:1] forKey:[labelArray objectAtIndex:0]];
        midLabel.text = [labelArray objectAtIndex:1];
        midLabel.textColor = [UIColor whiteColor];
        midLabel.textAlignment = NSTextAlignmentCenter;
        midLabel.backgroundColor = [UIColor clearColor];
        midLabel.font = [UIFont systemFontOfSize:12];
        [lyricsScrollView addSubview:midLabel];
        [[midLabel layer] addAnimation:group forKey:@"hehe"];
    }

}

//-(void)viewWillAppear:(BOOL)animated
//{
//    if (_gono == YES)
//    {
//        return;
//    }
//    
//    [super viewWillAppear:animated];
//    NSLog(@"viewWillAppear");
//    if ([_timer isValid])
//    {
//        NSLog(@"timer");
//    }
//    [self scrollLyrics:[self handleLyrics:lyrics]];
//    [self playMusic];
//    [musicListTableView reloadData];
//}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    play = YES;
    soundShow = NO;
    showList = NO;
        
    self.navigationController.navigationBarHidden = YES;
    
    lyricsDict = [[NSMutableDictionary alloc]init];
    
    UIImageView *backImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, self.view.frame.size.height)];
    backImageView.image = [UIImage imageNamed:@"player_bg.jpg"];
    [self.view addSubview:backImageView];
    
    musicNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 20, WIDTH - 40, 40)];
    musicNameLabel.textColor = [UIColor whiteColor];
    musicNameLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:musicNameLabel];
    
    lyrics = @"[ti:裂痕]\r\n[ar:张惠妹]\r\n[al:]\r\n[by:]\r\n[0:0.39]张惠妹 - 裂痕\r\n[0:1.41]—王子、小天、制作—\r\n[0:3.9]王子—小天— qq568663812\r\n[0:20.75]我认输 我觉悟 我犯贱 我在赌\r\n[0:28.59]我狂笑 我 狂哭 我有病 我高兴\r\n[0:36.84]赌我总有一天拿到好牌\r\n[0:40.70][1:46.55]对 于爱情的腐败金刚不坏\r\n[0:44.40]如果未来我要远离麻烦 现在我得是个麻烦 \r\n[0:52.71][1:58.35][2:48.61]我愤怒 我厌恶 对危险不屑一顾\r\n[1:0.74]不计较 不啰嗦 我在裂痕上狂舞\r\n[1:8.57][2:14.70][3:4.77]我清楚 我反顾 别管我什么 态度\r\n[1:16.76][2:22.72][3:12.74]多混乱 多绚烂我在裂痕上狂舞 \r\n[1:23.48][3:21.69]—听流行音乐、qq568663812\r\n[1:26.78]我困住 我挣脱 我无聊\r\n[1:32.62]又被捕我中毒 我麻木我登出\r\n[1:40.50]又登入赌我总有一天拿到好牌\r\n[1:50.58]如果未来我要远离麻烦\r\n[1:54.49]现在我得是个麻烦 \r\n[2:6.71][2:56.71]不计较 不罗嗦 我在裂痕上狂舞\r\n";
    NSArray *array =  [self handleLyrics:lyrics];
    lyricsScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, musicNameLabel.bottom+20, WIDTH,HEIGHT - musicNameLabel.bottom - 20 - 120)];
    NSLog(@"%d",[array count]);
    lyricsScrollView.contentSize = CGSizeMake(320, [array count]*20+100);
    lyricsScrollView.contentOffset = CGPointMake(0, 0);
    lyricsScrollView.backgroundColor = [UIColor clearColor];
    lyricsScrollView.delegate = self;
    [self scrollLyrics:[self handleLyrics:lyrics]];
    [self.view addSubview:lyricsScrollView];
    
    //音乐控制
    UIView *controlView = [[UIView alloc]init];
    controlView.frame = CGRectMake(0, HEIGHT - 100, WIDTH, 80);
    controlView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:controlView];
    
    progressSlider = [[UISlider alloc]initWithFrame:CGRectMake(50, 0, WIDTH - 100, 40)];
    progressSlider.backgroundColor = [UIColor clearColor];
    progressSlider.tag = 201;
    progressSlider.maximumValue = sec;
    progressSlider.minimumValue =0;
    [progressSlider setMinimumTrackImage:[UIImage imageNamed:@"player_slider_playback_left.png"] forState:UIControlStateNormal];
    [progressSlider setMaximumTrackImage:[UIImage imageNamed:@"player_slider_playback_right.png"] forState:UIControlStateNormal];
    [progressSlider setThumbImage:[UIImage imageNamed:@"player_slider_playback_thumb.png"] forState:UIControlStateNormal];
    [progressSlider addTarget:self action:@selector(valueChanged:) forControlEvents:UIControlEventValueChanged];
    [controlView addSubview:progressSlider];
    
    progressLeftLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, progressSlider.top, 40, 40)];
    progressLeftLabel.textColor = [UIColor whiteColor];
    progressLeftLabel.font = [UIFont systemFontOfSize:10];
    progressLeftLabel.textAlignment = NSTextAlignmentCenter;
    progressLeftLabel.text = currentTime;
    progressLeftLabel.backgroundColor = [UIColor clearColor];
    [controlView addSubview:progressLeftLabel];
    
    progressRightLabel = [[UILabel alloc]initWithFrame:CGRectMake(progressSlider.right, progressLeftLabel.top, 40, 40)];
    progressRightLabel.font = [UIFont systemFontOfSize:10];
    progressRightLabel.textColor = [UIColor whiteColor];
    progressRightLabel.text = leftTime;
    progressRightLabel.textAlignment = NSTextAlignmentCenter;
    progressRightLabel.backgroundColor = [UIColor clearColor];
    [controlView addSubview:progressRightLabel];

    backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(20, 42, 37, 37);
    [backButton setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [backButton setImage:[UIImage imageNamed:@"back2"] forState:UIControlEventTouchUpInside];
    [backButton addTarget:self action:@selector(backClick:) forControlEvents:UIControlEventTouchUpInside];
    [controlView addSubview:backButton];
    
    playButton = [UIButton buttonWithType:UIButtonTypeCustom];
    playButton.backgroundColor = [UIColor clearColor];
    [playButton setImage:[UIImage imageNamed:@"pause"] forState:UIControlStateNormal];
    playButton.frame = CGRectMake(controlView.width/2 - 18.5, backButton.top,  37, 37);
    [playButton addTarget:self action:@selector(controlMusic:) forControlEvents:UIControlEventTouchUpInside];
    [controlView addSubview:playButton];
    
    backwordButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backwordButton setImage:[UIImage imageNamed:@"prev"] forState:UIControlStateNormal];
    [backwordButton setImage:[UIImage imageNamed:@"prev2"] forState:UIControlEventTouchUpInside];
    backwordButton.frame = CGRectMake(playButton.left - 57, backButton.top, 37, 37);
    [backwordButton addTarget:self action:@selector(preMusic:) forControlEvents:UIControlEventTouchUpInside];
    backwordButton.backgroundColor = [UIColor clearColor];
    [controlView addSubview:backwordButton];
    
    forwardButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [forwardButton setImage:[UIImage imageNamed:@"next"] forState:UIControlStateNormal];
    [forwardButton setImage:[UIImage imageNamed:@"next2"] forState:UIControlEventTouchUpInside];
    [forwardButton addTarget:self action:@selector(nextMusic:) forControlEvents:UIControlEventTouchUpInside];
    forwardButton.backgroundColor = [UIColor clearColor];
    forwardButton.frame = CGRectMake(playButton.right + 20, backButton.top,  37, 37);
    [controlView addSubview:forwardButton];
    
    listButton = [UIButton buttonWithType:UIButtonTypeCustom];
    listButton.frame = CGRectMake(WIDTH - 57, backButton.top, 37, 37);
    [listButton setImage:[UIImage imageNamed:@"list"] forState:UIControlStateNormal];
    [listButton setImage:[UIImage imageNamed:@"list2"] forState:UIControlEventTouchUpInside];
    [listButton addTarget:self action:@selector(listClick:) forControlEvents:UIControlEventTouchUpInside];
    [controlView addSubview:listButton];
    
    UIVisualEffectView *effectView =[[UIVisualEffectView alloc]initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleProminent]];
    //这里一定要设置frame 不然不会显示效果
    effectView.frame = CGRectMake(0, 0, 200, 100);
    
    musicListTableView = [[UITableView alloc] initWithFrame:CGRectMake(WIDTH + 200, musicNameLabel.bottom, 200, HEIGHT/2) style:UITableViewStylePlain];
    musicListTableView.delegate = self;
    musicListTableView.dataSource = self;
    musicListTableView.layer.cornerRadius = 6;
    musicListTableView.clipsToBounds = YES;
    musicListTableView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
    [self.view addSubview:musicListTableView];
    [musicListTableView setBackgroundView:effectView];
    
    timeFormatter = [[NSDateFormatter alloc]init];
    [timeFormatter setDateFormat:@"mm:ss"];
}

-(void)listClick:(UIButton *)button
{
    if (showList == NO)
    {
        [UIView animateWithDuration:1 delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:0.5 options:UIViewAnimationOptionLayoutSubviews animations:^{
            musicListTableView.left = WIDTH - musicListTableView.width;
        } completion:^(BOOL finished) {
            
        }];
        showList = YES;
    }
    else if(showList == YES)
    {
        [UIView animateWithDuration:1 delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:0.5 options:UIViewAnimationOptionLayoutSubviews animations:^{
            musicListTableView.left = WIDTH + musicListTableView.width;
        } completion:^(BOOL finished) {
            
        }];
        showList = NO;
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [songsArray count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellName = @"cellName";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellName];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellName];
    }
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    cell.textLabel.textColor = [UIColor whiteColor];
    NSString *name = [[[songsArray objectAtIndex:indexPath.row] lastPathComponent]stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    cell.textLabel.text = [name stringByDeletingPathExtension];;
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    cell.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self playMusic:[songsArray objectAtIndex:indexPath.row]];
    [self listClick:nil];
}

-(void)backClick:(UIBarButtonItem *)backItem
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - 播放
-(void)playMusic:(NSString *)musicPath
{
    currentMusicPath = musicPath;
    if ([player isPlaying]) {
        [player stop];
        [timer invalidate];
        timer = nil;
    }
    NSString *name = [[musicPath lastPathComponent] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    musicNameLabel.text = [name stringByDeletingPathExtension];
    
    [[AVAudioSession sharedInstance] setCategory: AVAudioSessionCategoryPlayAndRecord error: nil];
    
    NSURL *url = [NSURL URLWithString:musicPath];
    
    player = [[AVAudioPlayer alloc]initWithContentsOfURL:url error:nil];
    
    player.delegate = self;
    
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    
    NSError *error = nil;
    
    [audioSession setCategory :AVAudioSessionCategoryPlayback error:&error];
    
    if ([player prepareToPlay]) {
        [player play];
        timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(progressRefresh) userInfo:nil repeats:YES];
    }else{
        NSLog(@"error %@",error);
    }
    sec = [player duration];
    leftSec = sec;
    currentSec = 0.0;
    
    currentDate = [NSDate dateWithTimeIntervalSinceReferenceDate:currentSec];
    currentTime = [timeFormatter stringFromDate:currentDate];
    leftDate = [NSDate dateWithTimeIntervalSinceReferenceDate:leftSec];
    leftTime = [timeFormatter stringFromDate:leftDate];
}

#pragma mark - 上一首
-(void)preMusic:(UIButton *)button
{
    NSInteger currentIndex = [songsArray indexOfObject:currentMusicPath];
    if (currentIndex == 0) {
        [self playMusic:[songsArray objectAtIndex:songsArray.count - 1]];
    }else{
        [self playMusic:[songsArray objectAtIndex:--currentIndex]];
    }
}

#pragma mark - 下一首
-(void)nextMusic:(UIButton *)button
{
    NSInteger currentIndex = [songsArray indexOfObject:currentMusicPath];
    if (currentIndex == songsArray.count - 1) {
        [self playMusic:[songsArray objectAtIndex:0]];
    }else{
        [self playMusic:[songsArray objectAtIndex:++currentIndex]];
    }
}

#pragma mark - 播放、暂停音乐
-(void)controlMusic:(UIButton *)button
{
    if (![player isPlaying]){
        [player play];
        timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(progressRefresh) userInfo:nil repeats:YES];
        [playButton setImage:[UIImage imageNamed:@"pause"] forState:UIControlStateNormal];
    }else{
        [player pause];
        [timer invalidate];
        [playButton setImage:[UIImage imageNamed:@"play"] forState:UIControlStateNormal];
    }
}

-(void)progressRefresh
{
    leftSec--;
    currentSec = sec - leftSec;
    if (leftSec == 0) {
        [self nextMusic:nil];
        return;
    }
    
    progressSlider.value = currentSec;
    currentDate = [NSDate dateWithTimeIntervalSinceReferenceDate:currentSec];
    currentTime = [timeFormatter stringFromDate:currentDate];
    leftDate = [NSDate dateWithTimeIntervalSinceReferenceDate:leftSec];
    leftTime = [timeFormatter stringFromDate:leftDate];
    progressLeftLabel.text = currentTime;
    progressRightLabel.text = leftTime;
}

-(void)valueChanged:(UISlider *)slider
{
    if (slider.tag == 201)
    {
        currentSec = progressSlider.value;
        [player setCurrentTime:currentSec];
        
        currentDate = [NSDate dateWithTimeIntervalSinceReferenceDate:currentSec];
        currentTime = [timeFormatter stringFromDate:currentDate];
        leftSec = sec - currentSec;
        leftDate = [NSDate dateWithTimeIntervalSinceReferenceDate:leftSec];
        leftTime = [timeFormatter stringFromDate:leftDate];
        progressLeftLabel.text = currentTime;
        progressRightLabel.text = leftTime;
    }
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    NSLog(@"viewDidUnload");
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
//    return (interfaceOrientation == UIInterfaceOrientationPortrait);
    return YES;
}

-(void)dealloc
{
    
}

@end
