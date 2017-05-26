//
//  PlayerView.m
//  Music
//
//  Created by rrrr on 13-4-28.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import "PlayerView.h"

@implementation PlayerView
@synthesize musicNameLabel = _musicNameLabel;
@synthesize musicTimeLabel = _musicTimeLabel;
@synthesize musicName = _musicName;
@synthesize musicFileName = _musicFileName;
@synthesize listArray = _listArray;
//@synthesize path;

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

-(void)playMusic:(NSString *)musicName;
{
    self.navigationItem.title = musicName;
    NSLog(@"play %@",musicName);
//    if (player)
//    {
//        [player stop];
//    }
//    if ([timer isValid])
//    {
//        [timer invalidate];
//    }
    
    NSArray *documentsPath = [NSArray arrayWithArray:NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)];
    
    NSString *documentDir = [documentsPath objectAtIndex:0];
    documentDir = [documentDir stringByAppendingPathComponent:[NSString stringWithFormat:@"/%@",_musicFileName]];    
    path = [NSString stringWithFormat:@"%@/%@",documentDir,musicName];
    NSURL *fileURL = [NSURL fileURLWithPath:path];
    NSLog(@"%@",path);
    
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
    player.volume = 1;
    [player prepareToPlay];
    [player play];
//    player.volume = soundSlider.value;
    timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(progressRefresh) userInfo:nil repeats:YES];
}
-(void)progressRefresh
{
    leftSec--;
    currentSec = sec - leftSec;
//    [self isFinished];
    
//    progressSlider.value = currentSec;
    
    currentDate = [NSDate dateWithTimeIntervalSinceReferenceDate:currentSec];
    currentTime = [timeFormatter stringFromDate:currentDate];
    leftDate = [NSDate dateWithTimeIntervalSinceReferenceDate:leftSec];
    leftTime = [timeFormatter stringFromDate:leftDate];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSLog(@"viewWillAppear");
    if ([timer isValid])
    {
        NSLog(@"timer");
    }
//    [self scrollLyrics:[self handleLyrics:lyrics]];
    [self playMusic:_musicName];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationController.navigationBarHidden = YES;
    [self playMusic:_musicName];
}

- (void)viewDidUnload
{
    [self setMusicNameLabel:nil];
    [self setMusicName:nil];
    [self setMusicTimeLabel:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


- (IBAction)addToClick:(id)sender {
    NSLog(@"add");
}

- (IBAction)downloadClick:(id)sender {
    NSLog(@"download");
}

- (IBAction)sharedClick:(id)sender {
}

- (IBAction)playModel:(id)sender {
}

- (IBAction)preClick:(id)sender {
}

- (IBAction)playClick:(id)sender {
}

- (IBAction)nextClick:(id)sender {
}

- (IBAction)listClick:(id)sender {
}

- (IBAction)backClick:(id)sender {
    UIButton *button = (UIButton *)sender;
    NSLog(@"back %d",button.tag);
    if (button.tag == 101)
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}

- (IBAction)progressSliderValueChange:(id)sender {
}

- (IBAction)favClick:(id)sender {
}
- (IBAction)searchClick:(id)sender {
}

//- (void)dealloc {
//    [musicNameLabel release];
//    [musicTime release];
//    [musicTimeLabel release];
//    [super dealloc];
//}
@end
