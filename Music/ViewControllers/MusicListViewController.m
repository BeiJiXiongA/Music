//
//  MusicListViewController.m
//  Music
//
//  Created by rrrr on 13-4-22.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import "MusicListViewController.h"
#import "CONST.h"
#import "MusicItem.h"
#import "MusicCell.h"
#import "PlayViewController.h"
#import "CONST.h"
#import "NetListViewController.h"


@implementation MusicListViewController
@synthesize viewType = _viewType;
@synthesize listArray = _listArray;
@synthesize listType=_listType;
@synthesize apiType = _apiType;
@synthesize musicFile = _musicFile;
-(void)dealloc
{
    [listTableView release];
    [_listArray release];
    _musicFile = nil;
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

-(void)getFlieList
{
    if (!_listArray)
    {
        _listArray = [[NSMutableArray alloc] init];
    }
    
    if (_listType == MUSIC_FILE_LIST && _viewType == LIST_VIEW_CONTROLLER)
    {
        NSFileManager *fileMgr = [NSFileManager defaultManager];
        NSArray *documentsPath = [NSArray arrayWithArray:NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)];
        
        NSError *error = nil;
        
        NSString *documentDir = [documentsPath objectAtIndex:0];
        _listArray = [[NSArray arrayWithArray:[fileMgr contentsOfDirectoryAtPath:documentDir error:&error ]] retain];
    }
    if (_listType == LOCAL_MUSIC_LIST && _viewType == LIST_VIEW_CONTROLLER)
    {
        NSLog(@"_musicFile %@",_musicFile);
        NSFileManager *fileMgr = [NSFileManager defaultManager];
        NSArray *documentsPath = [NSArray arrayWithArray:NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)];
        
        NSError *error = nil;
        
        NSString *documentDir = [documentsPath objectAtIndex:0];
        documentDir = [documentDir stringByAppendingPathComponent:[NSString stringWithFormat:@"/%@",_musicFile]];
        _listArray = [[NSArray arrayWithArray:[fileMgr contentsOfDirectoryAtPath:documentDir error:&error ]] retain];
    }
    [listTableView reloadData];
}

-(void)viewWillAppear:(BOOL)animated
{        
    [self getFlieList];
    
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    listTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 44, 320, 460-50-44) style:UITableViewStylePlain];
    listTableView.backgroundColor = [UIColor clearColor];
    [listTableView setBackgroundView:[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"TQTPWeatherBGSunny@2x.jpg"]]];
    [self getFlieList];
    listTableView.delegate = self;
    listTableView.dataSource = self;
    [self.view addSubview:listTableView];
    
    UIImage *backImage = [UIImage imageNamed:@"back.png"];
    UIImageView *backImageview = [[UIImageView alloc]initWithImage:backImage];
    UITapGestureRecognizer *backTgr = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(backClick)];
    backImageview.userInteractionEnabled = YES;
    [backImageview addGestureRecognizer:backTgr];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backImageview];
    self.navigationItem.leftBarButtonItem = backItem;
    
    UIImage *addImage = [UIImage imageNamed:@"add_to.png"];
    UIButton *addButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [addButton setImage:addImage forState:UIControlStateNormal];
    [addButton addTarget:self action:@selector(addClick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *editItem = [[UIBarButtonItem alloc]initWithCustomView:addButton];
    self.navigationItem.rightBarButtonItem = editItem;
    
}

-(void)addClick:(UIButton *)button
{
//    NSFileManager *fileManager = [NSFileManager defaultManager];
    
}

-(void)backClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_listArray count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 57;
}

//#define LOCAL_MUSIC_LIST 6
//#define NET_MUSIC_LIST 9
//#define NET_CLASS_LIST 7
//#define SINGER_LIST 8

//-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    
//}
//
//-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    
//}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_viewType == ADD_MUSIC_TO_LIST && _listType == LOCAL_MUSIC_LIST)
    {
        
    }
    else if(_listType == MUSIC_FILE_LIST && _viewType == LIST_VIEW_CONTROLLER)
    {
        if (!musicList)
        {
            musicList = [[MusicListViewController alloc]init];
        }
        musicList.listType = LOCAL_MUSIC_LIST;
        musicList.viewType = LIST_VIEW_CONTROLLER;
        musicList.musicFile = [_listArray objectAtIndex:indexPath.row];
        [self.navigationController pushViewController:musicList animated:YES];
    }
    else if(_listType == LOCAL_MUSIC_LIST)
    {
        zwAppDelegate * Dele = (zwAppDelegate *)[UIApplication sharedApplication].delegate;
        NSArray *arr = Dele.myTabBarController.view.subviews;
        for (UIView * v in arr) 
        {
            if ([v isKindOfClass:[ButtomView class]]) 
            {
                [v setHidden:YES];
//                NSArray *array = v.subviews;
//                for (UIView *view in array)
//                {
//                    if ([view isKindOfClass:[UIImageView class]])
//                    {
//                        [view removeFromSuperview];
//                    }
//                }
//                v.backgroundColor = [UIColor clearColor];
            }
        }        
        playVC = [PlayViewController sharedPlayerViewController];
        playVC.gono = NO;
        playVC.musicName = [_listArray objectAtIndex:indexPath.row ];
        playVC.songsArray = _listArray;
        playVC.musicFileName = _musicFile;
        playVC.currentMusic = indexPath.row;
        
        [self presentModalViewController:playVC animated:YES];
    }    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellName = @"musicCell";
    MusicCell *cell = [tableView dequeueReusableCellWithIdentifier:cellName];
    if (cell == nil)
    {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"MusicCell" owner:self options:nil] lastObject];
    }
    if ([_listArray count]>0)
    {
        if (_viewType == LIST_VIEW_CONTROLLER)
        {
//            [cell.btn setImage:[UIImage imageNamed:@"toolbar_stop_highlighted.png"] forState:UIControlStateNormal];
//            [cell.btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
            
        }
        else if(_viewType == ADD_MUSIC_TO_LIST)
        {
//            cell.btn.tag = 201;
//            [cell.btn setImage:[UIImage imageNamed:@"selected_gray.png"] forState:UIControlStateNormal];
//            [cell.btn setImage:[UIImage imageNamed:@"selected.png"] forState:UIControlStateSelected];
//            [cell.btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        }
        if (_listType == LOCAL_MUSIC_LIST)
        {
            NSString *fileName = [_listArray objectAtIndex:indexPath.row];
            cell.textLabel.text = fileName;
        }
        else if(_listType == MUSIC_FILE_LIST)
        {
            NSString *fileName = [_listArray objectAtIndex:indexPath.row];
            cell.textLabel.text = fileName;
        }
    }
    return cell;
}

-(void)btnClick:(UIButton *)btn
{
    if (btn.tag == 200)
    {
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"选择操作" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"添加至歌单",@"删除歌曲", nil];
        actionSheet.actionSheetStyle = UIActionSheetStyleDefault;
        [actionSheet showInView:self.view];
    }
    else if(btn.tag == 201)
    {
        btn.selected = !btn.selected;
    }
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
    {
        NSLog(@"addtolist");
    }
    else if(buttonIndex == 1)
    {
        NSLog(@"delete");
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
//        NSArray *array = [[NSArray arrayWithArray:[fileMgr contentsOfDirectoryAtPath:documentDir error:&error ]] retain];
//        for (NSString *name in array)
//        {
//            NSLog(@"%c",[name characterAtIndex:0]);
//            if ([name characterAtIndex:0] != '.')
//            {
//                NSLog(@"%@",name);
//                [_listArray addObject:name];
//            }
