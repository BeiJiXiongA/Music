//
//  StartViewController.m
//  Music
//
//  Created by rrrr on 13-4-22.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import "StartViewController.h"
#import "CONST.h"
#import "NewViewController.h"
#import "SearchViewController.h"
#import "UserViewController.h"
#import "SettingViewController.h"

@implementation StartViewController

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

#pragma mark - View lifecycle

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIView *navView = [[UIView alloc]initWithFrame:CGRectMake(0, 20, 320, 40)];
    [self.view addSubview:navView];
    UIImageView *navImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 40)];
    navImageView.image = [UIImage imageNamed:@"navi_bg.png"];
    [navView addSubview:navImageView];

    NSArray *navNormalImages = [NSArray arrayWithObjects:@"tab_new.png",@"tab_search.png",@"tab_user.png",@"tab_setting.png", nil];
    NSArray *navSelectedImages = [NSArray arrayWithObjects:@"tab_new2.png",@"tab_search2.png",@"tab_user2.png",@"tab_setting2.png", nil];

    for (int i=0; i<4; i++)
    {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(75*i, 0, 75, 40);
        [button setImage:[UIImage imageNamed:[navNormalImages objectAtIndex:i]] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:[navSelectedImages objectAtIndex:i]] forState:UIControlEventTouchUpInside];
        [button addTarget:self action:@selector(navClick:) forControlEvents:UIControlEventTouchUpInside];
        button.tag = 100+i;
        [navView addSubview:button];
    }
    
    

    UIView *buttomView = [[UIView alloc]init];
    buttomView.frame = CGRectMake(0, self.view.frame.size.height-50, 320, 50);
    UIImageView *buttomImageView = [[UIImageView alloc]init];
    buttomImageView.frame = CGRectMake(0, 0, 320, 50);
    [buttomImageView setImage:[UIImage imageNamed:@"navi_bg.png"]];
    [buttomView addSubview:buttomImageView];
    [self.view addSubview:buttomView];

    NSArray *buttomNormalImages = [NSArray arrayWithObjects:@"artist_photo_frame@2x.png",@"play.png",@"next.png",@"list.png", nil];
    NSArray *buttomSelectedImages = [NSArray arrayWithObjects:@"",@"pause.png",@"next2.png",@"list2.png", nil];
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
            [button setImage:[UIImage imageNamed:[buttomSelectedImages objectAtIndex:i]] forState:UIControlEventTouchUpInside];
            button.frame = CGRectMake(80+(40+20)*i , 10, 40, 40);


        }
        button.tag = 200 +i;
        [button addTarget:self action:@selector(buttomClick:) forControlEvents:UIControlEventTouchUpInside];
        [buttomView addSubview:button];
    }
    
//    [self.view addSubview:startTabBarController];
    
    UIImageView *startImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"start_bg.jpg"]];
    [self.view addSubview:startImageView];
    
    CGFloat heightSpace = 60;
    CGFloat widthSpace = 60;
    CGFloat imageHeight = 60;
    CGFloat imageWidth = 60;
    
    UIImage *image = [UIImage imageNamed:@"17.jpg"];
    

    UIButton *localMusicListButton = [UIButton buttonWithType:UIButtonTypeCustom];
    localMusicListButton.frame = CGRectMake(80, 80, imageWidth,imageHeight);
    localMusicListButton.tag = 100;
    [localMusicListButton addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [localMusicListButton setImage:image forState:UIControlStateNormal];
    [localMusicListButton setImage:[UIImage imageNamed:@"TQTPWeatherBGRain@2x.jpg"] forState:UIControlStateSelected];
    [self.view addSubview:localMusicListButton];
    
    UIButton *netMusicListButton = [UIButton buttonWithType:UIButtonTypeCustom];
    netMusicListButton.frame = CGRectMake(200, 80+widthSpace+imageWidth-30, imageWidth,imageHeight);
    netMusicListButton.tag = 101;
    [netMusicListButton addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [netMusicListButton setImage:image forState:UIControlStateNormal];
    [self.view addSubview:netMusicListButton];
    
    UIButton *btn3 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn3.frame = CGRectMake(80, 80+heightSpace+imageHeight, imageWidth,imageHeight);
    btn3.tag = 102;
    [btn3 addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [btn3 setImage:image forState:UIControlStateNormal];
    [self.view addSubview:btn3];
    
    UIButton *btn4 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn4.frame = CGRectMake(200, 80+(widthSpace+imageWidth)*2-30, imageWidth,imageHeight);
    btn4.tag = 103;
    [btn4 addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [btn4 setImage:image forState:UIControlStateNormal];
    [self.view addSubview:btn4];
    
}

-(void)btnClick:(UIButton *)btn
{
    if (!musicList)
    {
        musicList = [[MusicListViewController alloc]init];
    }
    switch (btn.tag)
    {
        case 100:
        {
            musicList.viewType = LIST_VIEW_CONTROLLER;
            musicList.listType = MUSIC_FILE_LIST;
            [self.navigationController pushViewController:musicList animated:YES];
        }
            break;
        case 101:
        {
            musicList.viewType = ADD_MUSIC_TO_LIST;
            musicList.listType = LOCAL_MUSIC_LIST;
            [self.navigationController pushViewController:musicList animated:YES];
        }
            break;
        case 102:
        {
            musicList.listType = NET_CLASS_LIST;
            musicList.viewType = LIST_VIEW_CONTROLLER;
            [self.navigationController pushViewController:musicList animated:YES];
        }
            break;
        case 103:
        {
            
        }
            break;
        default:
            break;
    }
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
