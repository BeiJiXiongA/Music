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


@implementation MusicListViewController
@synthesize viewType = _viewType;
@synthesize listArray = _listArray;
@synthesize listType=_listType;
@synthesize apiType = _apiType;
@synthesize musicFile = _musicFile;
-(void)dealloc
{

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

-(void)viewWillAppear:(BOOL)animated
{        
    [super viewWillAppear:animated];
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    listTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT - UI_NAV_BAR_HEIGHT - UI_TAB_BAR_HEIGHT) style:UITableViewStylePlain];
    listTableView.backgroundColor = [UIColor whiteColor];
    listTableView.delegate = self;
    listTableView.dataSource = self;
    [self.view addSubview:listTableView];
    
    UIImage *backImage = [UIImage imageNamed:@"back_nav"];
    UIImageView *backImageview = [[UIImageView alloc]initWithImage:backImage];
    UITapGestureRecognizer *backTgr = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(backClick)];
    backImageview.userInteractionEnabled = YES;
    [backImageview addGestureRecognizer:backTgr];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backImageview];
    self.navigationItem.leftBarButtonItem = backItem;
    
    UIImage *addImage = [UIImage imageNamed:@"add_to"];
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

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellName = @"musicCell";
    MusicCell *cell = [tableView dequeueReusableCellWithIdentifier:cellName];
    if (cell == nil)
    {
        cell = [[MusicCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"musicCell"];
    }
    NSString *fileName = [_listArray objectAtIndex:indexPath.row];
    NSString *name = [[fileName lastPathComponent] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    cell.nameLabel.text = [name stringByDeletingPathExtension];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    zwAppDelegate * Dele = (zwAppDelegate *)[UIApplication sharedApplication].delegate;
    NSArray *arr = Dele.myTabBarController.view.subviews;
    for (UIView * v in arr)
    {
        if ([v isKindOfClass:[ButtomView class]])
        {
            [v setHidden:YES];
            NSArray *array = v.subviews;
            for (UIView *view in array)
            {
                if ([view isKindOfClass:[UIImageView class]])
                {
                    [view removeFromSuperview];
                }
            }
            v.backgroundColor = [UIColor clearColor];
        }
    }
    NSString *selectMusicPath = [_listArray objectAtIndex:indexPath.row ];
    playVC = [PlayViewController sharedPlayerViewController];
    playVC.currentMusicPath = selectMusicPath;
    playVC.songsArray = _listArray;
    [playVC playMusic:selectMusicPath];
    [self presentViewController:playVC animated:YES completion:nil];
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
