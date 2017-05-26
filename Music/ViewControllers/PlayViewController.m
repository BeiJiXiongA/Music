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

@class MusicListViewController;

static PlayViewController *playerVC;

@implementation PlayViewController
{
    AVAudioPlayer *player;
}
@synthesize currentMusic = _currentMusic;
@synthesize songsArray=_songsArray;
@synthesize path;
@synthesize timer;
//@synthesize player;
@synthesize songs;
@synthesize musicName = _musicName;
@synthesize musicFileName = _musicFileName;
@synthesize gono=_gono;


+(id)sharedPlayerViewController
{
    if (!playerVC)
    {
        playerVC = [[PlayViewController alloc]init];
    }
    return playerVC;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

-(void)dealloc
{
    [musicNameLabel release];
    forwardButton = nil;
    playButton = nil;
    backwordButton = nil;
    [soundSlider release];
    soundSlider = nil;
    [progressSlider release];
    progressSlider = nil;
    btnShowNav = nil;
    [timer release];
    timer = nil;
    path = nil;
    [songs release];
    songs = nil;
    [player release];
    [musicListTableView release];
    [super dealloc];
}

#pragma mark - View lifecycle

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/

-(void)playMusic:(NSString *)musicName;
{    
    NSString *musicNameLabelText = [musicName substringToIndex:[musicName rangeOfString:@"."].location];
    musicNameLabel.text = musicNameLabelText;
    self.navigationItem.title = musicName;
    [player stop];
//    Dele = (zwAppDelegate *)[UIApplication sharedApplication].delegate;
//    player = Dele.player;    
    
    [timer invalidate];
    NSArray *documentsPath = [NSArray arrayWithArray:NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)];
    
    NSString *documentDir = [documentsPath objectAtIndex:0];
    documentDir = [documentDir stringByAppendingPathComponent:[NSString stringWithFormat:@"/%@",_musicFileName]];    
    self.path = [NSString stringWithFormat:@"%@/%@",documentDir,musicName];
    NSURL *fileURL = [NSURL fileURLWithPath:self.path];
    
    player = [[AVAudioPlayer alloc] init];
    [player initWithContentsOfURL:fileURL error:nil];
    timeFormatter = [[NSDateFormatter alloc]init];
    [timeFormatter setDateFormat:@"m:s"];
    sec = [player duration];
    leftSec = sec;
    currentSec = 0.0;
    currentDate = [NSDate dateWithTimeIntervalSinceReferenceDate:currentSec];
    currentTime = [timeFormatter stringFromDate:currentDate];
    leftDate = [NSDate dateWithTimeIntervalSinceReferenceDate:leftSec];
    leftTime = [timeFormatter stringFromDate:leftDate];
    [player prepareToPlay];
    [player play];
    player.volume = soundSlider.value;
    timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(progressRefresh) userInfo:nil repeats:YES];
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
    
    for (int i=0;i<[array count];i++)
    {
        CAMediaTimingFunction *tf = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        CABasicAnimation *fader = [CABasicAnimation animationWithKeyPath:@"opacity"];
        [fader setFromValue:[NSNumber numberWithFloat:1.0]];
        [fader setToValue:[NSNumber numberWithFloat:0.0]];
        
        CABasicAnimation *mover = [CABasicAnimation animationWithKeyPath:@"position"];
        //        [mover setFromValue:[NSValue valueWithCGPoint:CGPointMake(160, 0)]];
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
        midLabel.textColor = [UIColor blueColor];
        midLabel.textAlignment = UITextAlignmentCenter;
        midLabel.backgroundColor = [UIColor clearColor];
        midLabel.font = [UIFont systemFontOfSize:12];
//        [lyricsScrollView addSubview:midLabel];
        [[midLabel layer] addAnimation:group forKey:@"hehe"];
        [midLabel release];
    }

}

-(void)viewWillAppear:(BOOL)animated
{
    if (_gono == YES)
    {
        return;
    }
    
    [super viewWillAppear:animated];
    NSLog(@"viewWillAppear");
    if ([timer isValid])
    {
        NSLog(@"timer");
    }
    [self scrollLyrics:[self handleLyrics:lyrics]];
    [self playMusic:_musicName];
    [musicListTableView reloadData];
}

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
    [backImageView release];
    
    musicListTableView = [[UITableView alloc]initWithFrame:CGRectMake(180, 200, 200, 100) style:UITableViewStylePlain];
    musicListTableView.hidden = YES;
    musicListTableView.delegate = self;
    musicListTableView.dataSource = self;
    musicListTableView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:musicListTableView];
    
    musicNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 20, 280, 40)];
    musicNameLabel.textColor = [UIColor grayColor];
    musicNameLabel.textAlignment = UITextAlignmentCenter;
    musicNameLabel.backgroundColor = [UIColor clearColor];
    [self.view addSubview:musicNameLabel];
    
    CGFloat buttonSpace = 160/5;
    CGFloat buttonWidth = 40;
    CGFloat buttonHeight = 30;

    UIButton *modelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [modelButton setImage:[UIImage imageNamed:@"cycled.png"] forState:UIControlStateNormal];
    [modelButton setImage:[UIImage imageNamed:@"cycled2.png"] forState:UIControlEventTouchUpInside];
    modelButton.frame = CGRectMake(buttonSpace, 70, buttonWidth, buttonHeight);
    [modelButton addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    modelButton.tag = 300;
    modelButton.backgroundColor = [UIColor clearColor];
    [self.view addSubview:modelButton];
    
    UIButton *addButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [addButton setImage:[UIImage imageNamed:@"add_to.png"] forState:UIControlStateNormal];
    [addButton setImage:[UIImage imageNamed:@"add_to2.png"] forState:UIControlEventTouchUpInside];
    addButton.frame = CGRectMake((buttonSpace*2+buttonWidth), 70, buttonWidth, buttonHeight);
    [addButton addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    addButton.tag = 301;
    addButton.backgroundColor = [UIColor clearColor];
    [self.view addSubview:addButton];
    
    UIButton *downloadButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [downloadButton setImage:[UIImage imageNamed:@"download.png"] forState:UIControlStateNormal];
    [downloadButton setImage:[UIImage imageNamed:@"download2.png"] forState:UIControlEventTouchUpInside];
    downloadButton.frame = CGRectMake((buttonSpace+buttonWidth)*2+buttonSpace, 70,  buttonWidth, buttonHeight);
    [downloadButton addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    downloadButton.tag = 302;
    downloadButton.backgroundColor = [UIColor clearColor];
    [self.view addSubview:downloadButton];
    
    UIButton *searchButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [searchButton setTitle:@"搜索" forState:UIControlStateNormal];
    searchButton.frame = CGRectMake((buttonSpace+buttonWidth)*3+buttonSpace, 70,  buttonWidth, buttonHeight);
    [searchButton addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    searchButton.tag = 303;
    searchButton.backgroundColor = [UIColor clearColor];
    [self.view addSubview:searchButton];
    
    progressSlider = [[UISlider alloc]initWithFrame:CGRectMake(40, 380, 240, 10)];
    progressSlider.backgroundColor = [UIColor clearColor];
    progressSlider.tag = 201;
    progressSlider.maximumValue = sec;
    progressSlider.minimumValue =0;
    [progressSlider addTarget:self action:@selector(valueChanged:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:progressSlider];
    progressLeftLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 370, 30, 40)];
    progressLeftLabel.textColor = [UIColor whiteColor];
    progressLeftLabel.font = [UIFont systemFontOfSize:10];
    progressLeftLabel.textAlignment = UITextAlignmentRight;
    progressLeftLabel.text = currentTime;
    progressLeftLabel.backgroundColor = [UIColor clearColor];
    [self.view addSubview:progressLeftLabel];
    progressRightLabel = [[UILabel alloc]initWithFrame:CGRectMake(280, 370, 50, 40)];
    progressRightLabel.font = [UIFont systemFontOfSize:10];
    progressRightLabel.textColor = [UIColor whiteColor];
    progressRightLabel.text = leftTime;
    progressRightLabel.backgroundColor = [UIColor clearColor];
    [self.view addSubview:progressRightLabel];

    lyrics = @"[ti:裂痕]\r\n[ar:张惠妹]\r\n[al:]\r\n[by:]\r\n[0:0.39]张惠妹 - 裂痕\r\n[0:1.41]—王子、小天、制作—\r\n[0:3.9]王子—小天— qq568663812\r\n[0:20.75]我认输 我觉悟 我犯贱 我在赌\r\n[0:28.59]我狂笑 我 狂哭 我有病 我高兴\r\n[0:36.84]赌我总有一天拿到好牌\r\n[0:40.70][1:46.55]对 于爱情的腐败金刚不坏\r\n[0:44.40]如果未来我要远离麻烦 现在我得是个麻烦 \r\n[0:52.71][1:58.35][2:48.61]我愤怒 我厌恶 对危险不屑一顾\r\n[1:0.74]不计较 不啰嗦 我在裂痕上狂舞\r\n[1:8.57][2:14.70][3:4.77]我清楚 我反顾 别管我什么 态度\r\n[1:16.76][2:22.72][3:12.74]多混乱 多绚烂我在裂痕上狂舞 \r\n[1:23.48][3:21.69]—听流行音乐、qq568663812\r\n[1:26.78]我困住 我挣脱 我无聊\r\n[1:32.62]又被捕我中毒 我麻木我登出\r\n[1:40.50]又登入赌我总有一天拿到好牌\r\n[1:50.58]如果未来我要远离麻烦\r\n[1:54.49]现在我得是个麻烦 \r\n[2:6.71][2:56.71]不计较 不罗嗦 我在裂痕上狂舞\r\n";
    NSArray *array =  [self handleLyrics:lyrics];
    lyricsScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 20, midScrollView.frame.size.width,midScrollView.frame.size.height-40)];
    NSLog(@"%d",[array count]);
    lyricsScrollView.contentSize = CGSizeMake(320, [array count]*20+100);
    lyricsScrollView.contentOffset = CGPointMake(0, 0);
    lyricsScrollView.backgroundColor = [UIColor clearColor];
    lyricsScrollView.delegate = self;
    
    [self scrollLyrics:[self handleLyrics:lyrics]];
    
    [midScrollView bringSubviewToFront:lyricsScrollView];
    [midScrollView insertSubview:lyricsScrollView aboveSubview:midImageView];
    
    soundSlider = [[UISlider alloc]initWithFrame:CGRectMake(30, 350, 250, 30)];
    soundSlider.maximumValue = 1.0;
    soundSlider.minimumValue = 0.0;
    soundSlider.value = 0.3;
    soundSlider.tag = 200;
    [soundSlider addTarget:self action:@selector(valueChanged:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:soundSlider];
    soundValueLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, 350, 30, 30)];
    soundValueLabel.textColor = [UIColor whiteColor];
    soundValueLabel.text = [NSString stringWithFormat:@"%.0f",soundSlider.value*100];
    soundValueLabel.backgroundColor = [UIColor clearColor];
    soundValueLabel.font = [UIFont systemFontOfSize:10];
    [self.view addSubview:soundValueLabel];
    soundSlider.hidden = YES;
    soundValueLabel.hidden = YES;
    
    UIButton *soundButton = [UIButton buttonWithType:UIButtonTypeCustom];
    soundButton.frame = CGRectMake(280, 350, 30, 30);
    [soundButton setImage:[UIImage imageNamed:@"volume_increase.png"] forState:UIControlStateNormal];
    [soundButton addTarget:self action:@selector(soundClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:soundButton];
    
    
    UIView *controlView = [[UIView alloc]init];
    controlView.frame = CGRectMake(20, 300, 320, 40);
    controlView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:controlView];
    
    backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(0, 200, 37, 37);
    [backButton setImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    [backButton setImage:[UIImage imageNamed:@"back2.png"] forState:UIControlEventTouchUpInside];
    [backButton addTarget:self action:@selector(backClick:) forControlEvents:UIControlEventTouchUpInside];
    [controlView addSubview:backButton];
    
    backwordButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backwordButton setImage:[UIImage imageNamed:@"prev.png"] forState:UIControlStateNormal];
    [backwordButton setImage:[UIImage imageNamed:@"prev2.png"] forState:UIControlEventTouchUpInside];
    backwordButton.frame = CGRectMake(80, 2, 37, 37);
    [backwordButton addTarget:self action:@selector(preMusic:) forControlEvents:UIControlEventTouchUpInside];
    backwordButton.backgroundColor = [UIColor clearColor];
    [controlView addSubview:backwordButton];
    
    playButton = [UIButton buttonWithType:UIButtonTypeCustom];
    playButton.backgroundColor = [UIColor clearColor];
    [playButton setImage:[UIImage imageNamed:@"pause.png"] forState:UIControlStateNormal];
    playButton.frame = CGRectMake(130, 2,  37, 37);
    [playButton addTarget:self action:@selector(controlMusic:) forControlEvents:UIControlEventTouchUpInside];
    [controlView addSubview:playButton];
    
    forwardButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [forwardButton setImage:[UIImage imageNamed:@"next.png"] forState:UIControlStateNormal];
    [forwardButton setImage:[UIImage imageNamed:@"next2.png"] forState:UIControlEventTouchUpInside];
    [forwardButton addTarget:self action:@selector(nextMusic:) forControlEvents:UIControlEventTouchUpInside];
    forwardButton.backgroundColor = [UIColor clearColor];
    forwardButton.frame = CGRectMake(180, 2,  37, 37);
    [controlView addSubview:forwardButton];
    
    listButton = [UIButton buttonWithType:UIButtonTypeCustom];
    listButton.frame = CGRectMake(260, 2, 37, 37);
    [listButton setImage:[UIImage imageNamed:@"list.png"] forState:UIControlStateNormal];
    [listButton setImage:[UIImage imageNamed:@"list2.png"] forState:UIControlEventTouchUpInside];
    [listButton addTarget:self action:@selector(listClick:) forControlEvents:UIControlEventTouchUpInside];
    [controlView addSubview:listButton];
    
    if (_gono == YES)
    {
        return;
    }
    [self playMusic:_musicName];
    
}

-(void)listClick:(UIButton *)button
{
    if (showList == NO)
    {
        musicListTableView.hidden = NO;
        showList = YES;
    }
    else if(showList == YES)
    {
        musicListTableView.hidden = YES;
        showList = NO;
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_songsArray count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 20;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellName = @"cellName";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellName];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellName];
    }
    cell.textLabel.font = [UIFont systemFontOfSize:8];
    cell.textLabel.textColor = [UIColor blueColor];
    cell.textLabel.text = [_songsArray objectAtIndex:indexPath.row];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self playMusic:[_songsArray objectAtIndex:indexPath.row]];
    musicListTableView.hidden = YES;
    showList = NO;
}

-(void)soundClick:(UIButton *)button
{
    if (soundShow == NO)
    {
        soundSlider.hidden = NO;
        soundValueLabel.hidden = NO;
        soundShow = YES;
    }
    else if(soundShow == YES)
    {
        soundSlider.hidden = YES;
        soundValueLabel.hidden = YES;
        soundShow = NO;
    }
}

-(void)backClick:(UIBarButtonItem *)backItem
{
    zwAppDelegate * Dele = (zwAppDelegate *)[UIApplication sharedApplication].delegate;
    NSArray *arr = Dele.myTabBarController.view.subviews;
    for (UIView * v in arr) 
    {
        if ([v isKindOfClass:[ButtomView class]]) 
        {
//            [v setHidden:NO];
            
        }
    }        
    [self dismissModalViewControllerAnimated:YES];
}


-(void)preMusic:(UIButton *)button
{
    if (_currentMusic == 0) 
    {
        _currentMusic = [_songsArray count];
    }
    _currentMusic--;
    [self playMusic:[_songsArray objectAtIndex:_currentMusic]];
}

-(void)controlMusic:(UIButton *)button
{
    if (play == NO)
    {
        [player play];
        timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(progressRefresh) userInfo:nil repeats:YES];
        [playButton setImage:[UIImage imageNamed:@"pause.png"] forState:UIControlStateNormal];
        play = YES;
    }
    else if(play == YES)
    {
        [player pause];
        [timer invalidate];
        [playButton setImage:nil forState:UIControlEventTouchUpInside];
        [playButton setImage:[UIImage imageNamed:@"play.png"] forState:UIControlStateNormal];
        play = NO;
    }
}

-(void)nextMusic:(UIButton *)button
{
    if (_currentMusic == [_songsArray count]-1) {
        _currentMusic = -1;
    }
    _currentMusic++;
    [self playMusic:[_songsArray objectAtIndex:_currentMusic]];
}

//http://192.168.88.8/app/music/kugou.com/api/get_singer.php?group_id=1&page=1&number=10
//http://192.168.88.8/app/music/kugou.com/api/get_music.php?singer_id=1&page=1&number=10

-(void)isFinished
{
    if ((int)leftSec == 0)
    {
        if (_currentMusic == [_songsArray count]-1) 
        {
            _currentMusic = 0;
        }
        _currentMusic++;
        [self playMusic:[_songsArray objectAtIndex:_currentMusic]];
    }
}

-(void)progressRefresh
{
    leftSec--;
    currentSec = sec - leftSec;
    [self isFinished];
    
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
    if (slider.tag == 200)
    {
        soundValueLabel.text = [NSString stringWithFormat:@"%.0f",slider.value*100];
        player.volume = soundSlider.value;
    }
    if (slider.tag == 201)
    {
        currentSec = progressSlider.value;
        [player playAtTime:currentSec];
        progressLeftLabel.text = currentTime;
        progressRightLabel.text = leftTime;
    }
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    NSLog(@"viewDidDisappear");

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

@end
