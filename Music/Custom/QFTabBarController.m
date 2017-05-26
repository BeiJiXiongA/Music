//
//  QFTabBarController.m
//  Player
//
//  Created by qianfeng on 13-4-25.
//  Copyright (c) 2013年 qianfeng. All rights reserved.
//

#import "QFTabBarController.h"
#import "PlayViewController.h"
#import "PlayViewController.h"


@interface QFTabBarController ()

@end
@implementation QFTabBarController
{
    UILabel *musicLabel;
    PlayViewController *playerVC;
}

@synthesize tabBarView;
@synthesize buttomView;

- (void)dealloc
{
    [imgDic release];
    [controllArr release];
    [currentView release];
    
    tabBarView.delegate = nil;
    [tabBarView release];
    [buttomView release];
    
    [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithQFTabBarControllerSetImg:(NSDictionary *)_imgDic AndViewControllerArr:(NSArray *)_controllerArr
{
    self = [super init];
    if (self) {
        imgDic = [_imgDic retain];
        controllArr = [_controllerArr retain];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    CGRect rect = self.view.bounds;
//    self.view.backgroundColor = [UIColor grayColor];
    
    play = YES;
    
    currentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, rect.size.width, rect.size.height-50)];
//    currentView.backgroundColor =[UIColor redColor];
    currentView.autoresizesSubviews = YES;
    currentView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:currentView];
    
    tabBarView = [[CustomTabBarView alloc] initWithFrame:CGRectMake(0, 0, rect.size.width, 64) AndBtnImgDic:imgDic];
    tabBarView.delegate = self;
    
    [self.view addSubview:tabBarView];
    
    [self btnClickChangeViewWithTag:@"1"];
    
    buttomView = [[ButtomView alloc] init];
    buttomView.frame = CGRectMake(0, self.view.frame.size.height-50, 320, 50);
    UIImageView *buttomImageView = [[UIImageView alloc]init];
    buttomImageView.frame = CGRectMake(0, 0, 320, 50);
    [buttomImageView setImage:[UIImage imageNamed:@"navi_bg.png"]];
    [buttomView addSubview:buttomImageView];
    [self.view addSubview:buttomView];
    
    NSArray *buttomNormalImages = [NSArray arrayWithObjects:@"artist_photo_frame@2x.png",@"play.png",@"next.png",@"list.png", nil];
    
    for (int i=0; i<4; i++)
    {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        if (i==0)
        {
            [button setImage:[UIImage imageNamed:[buttomNormalImages objectAtIndex:i]] forState:UIControlStateNormal];
            button.frame = CGRectMake(5, 5, 40, 40);
        }
        else
        {
            [button setImage:[UIImage imageNamed:[buttomNormalImages objectAtIndex:i]] forState:UIControlStateNormal];
            button.frame = CGRectMake(80+(40+20)*i , 5, 40, 40);
            
            
        }
        button.tag = 200 +i;
        [button addTarget:self action:@selector(buttomClick:) forControlEvents:UIControlEventTouchUpInside];
        [buttomView addSubview:button];
    }
//    musicLabel = [[UILabel alloc]init];
    musicLabel.text = playerVC.musicName;
    musicLabel.textColor = [UIColor whiteColor];
    musicLabel.font = [UIFont systemFontOfSize:10];
    musicLabel.frame = CGRectMake(50, 10, 80, 30);
    musicLabel.backgroundColor = [UIColor clearColor];
    [buttomView addSubview:musicLabel];
}

-(void)buttomClick:(UIButton *)button
{
    playerVC = [PlayViewController sharedPlayerViewController];
    playerVC.gono = YES;
    
    NSLog(@"%d",playerVC.currentMusic);
    
    if (button.tag == 200)
    {
        [self presentModalViewController:playerVC animated:YES];
    }
    else if(button.tag == 201)
    {
        if (play == YES)
        {
            [button setImage:[UIImage imageNamed:@"play.png"] forState:UIControlStateNormal];
            play = NO;
        }
        else if(play == NO)
        {
            [button setImage:[UIImage imageNamed:@"pause.png"] forState:UIControlStateNormal];
            play = YES;
        }
        [playerVC controlMusic:button];
    }
    else if(button.tag == 202)
    {
        
        [playerVC nextMusic:button];
    }
    else if(button.tag == 203)
    {
        [playerVC listClick:button];
    }
    musicLabel.text = playerVC.musicName;
    
}

- (void)btnClickChangeViewWithTag:(NSString *)_tag
{
    int tag = [_tag intValue];
    for (int i = 1; i < 5; i++)
    {
        UIButton * b = (UIButton *)[self.view viewWithTag:i];
        if (tag == i) {
             [b setImage:[[imgDic objectForKey:@"Select"] objectAtIndex:tag-1] forState:UIControlStateNormal];
        }
        else
            [b setImage:[[imgDic objectForKey:@"Normal"] objectAtIndex:i-1] forState:UIControlStateNormal];
    }
    
    UIViewController * ctl = [controllArr objectAtIndex:tag-1];
    //NSLog(@"ctl is %@.....tag is %d...",ctl,tag);
    UIView * v = [ctl view];
    [v setFrame:currentView.bounds];
    for (UIView *vv in [currentView subviews]) {
        [vv removeFromSuperview];
    }
    [currentView addSubview:v];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
