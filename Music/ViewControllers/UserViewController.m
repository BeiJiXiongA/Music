//
//  UserViewController.m
//  Music
//
//  Created by rrrr on 13-5-1.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import "UserViewController.h"
#import "MusicListViewController.h"
#import "CONST.h"
#import "MusicCell.h"

@implementation UserViewController

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
    zwAppDelegate * Dele = (zwAppDelegate *)[UIApplication sharedApplication].delegate;
    NSArray *arr = Dele.myTabBarController.view.subviews;
    for (UIView * v in arr) 
    {
        if ([v isKindOfClass:[CustomTabBarView class]] || [v isKindOfClass:[ButtomView class]]) 
        {
            [v setHidden:NO];
        }
    }

}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    
//    self.view.backgroundColor = [UIColor greenColor];
    userTableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
    userTableView.frame = CGRectMake(0, 88, 320, self.view.frame.size.height-44-50);
    userTableView.delegate = self;
    userTableView.dataSource =self;
    [self.view addSubview:userTableView];
    
    UIView *loginView = [[UIView alloc]initWithFrame:CGRectMake(0, 44, 320, 44)];
    [self.view addSubview:loginView];
    UIImageView *loginImageView = [[UIImageView alloc]initWithFrame:CGRectMake(5, 2, 40, 40)];
    loginImageView.image = [UIImage imageNamed:@"default_portrait.png"];
    [loginView addSubview:loginImageView];
    
    UIButton *loginButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    loginButton.frame = CGRectMake(70, 12, 100, 20);
    [loginButton setTitle:@"登陆" forState:UIControlStateNormal];
    [loginView addSubview:loginButton];
    
    UIButton *resignButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    resignButton.frame = CGRectMake(190, 12, 100, 20);
    [resignButton setTitle:@"注册" forState:UIControlStateNormal];
    [loginView addSubview:resignButton];
    
    if (!musicList)
    {
        musicList = [[MusicListViewController alloc]init];
    }
    
    self.navigationController.navigationBar.barStyle = UIBarStyleBlackTranslucent;
    UIImage *navImage = [UIImage imageNamed:@"navi_bg.png"];
    [self.navigationController.navigationBar setBackgroundImage:navImage forBarMetrics:UIBarMetricsDefault];     
}



-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 57;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellName = @"userCell";
    MusicCell *cell = [tableView dequeueReusableCellWithIdentifier:cellName];
    if (cell == nil)
    {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"MusicCell" owner:self options:nil] lastObject];
    }
    switch (indexPath.row)
    {
        case 0:
        {
            cell.imageView.backgroundColor = [UIColor greenColor];
            [cell.imageView setImage:[UIImage imageNamed:@"local_list.png"]];
            cell.textLabel.text = @"本地列表";
            cell.detailLabel.text = [NSString stringWithFormat:@"%d个列表",1];
            
        }
            break;
        case 1:
        {
            cell.imageView.backgroundColor = [UIColor yellowColor];
            [cell.imageView setImage:[UIImage imageNamed:@"download_list.png"]];
            cell.textLabel.text = @"我的下载";
            cell.detailLabel.text = [NSString stringWithFormat:@"%d首歌曲",3];
        }
            break;
        case 2:
        {
            cell.imageView.backgroundColor = [UIColor blueColor];
            [cell.imageView setImage:[UIImage imageNamed:@"recent_list.png"]];
            cell.textLabel.text = @"最近播放";
            cell.detailLabel.text = [NSString stringWithFormat:@"%d首歌曲",11];
        }
            break;
        case 3:
        {
            cell.imageView.backgroundColor = [UIColor orangeColor];
            [cell.imageView setImage:[UIImage imageNamed:@"radio_list.png"]];
            cell.textLabel.text = @"我的电台";
            cell.detailLabel.text = [NSString stringWithFormat:@"%d个电台",1];
        }
            break;
        case 4:
        {
            cell.imageView.backgroundColor = [UIColor grayColor];
            [cell.imageView setImage:[UIImage imageNamed:@"add_to@2x.png"]];
            cell.textLabel.text = @"创建列表";
        }
            break;
//        case 5:
//        {
//            
//            cell.image = [UIImage imageNamed:@""];
//            cell.textLabel.text = @"WiFi传歌";
//            cell.detailTextLabel.text = @"省时，省心，省流量";
//        }
//            break;
        default:
            break;
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

/*
 异步
 交互
 */

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0)
    {
        musicList.listType =  MUSIC_FILE_LIST;
        musicList.viewType = LIST_VIEW_CONTROLLER;
        
        [self.navigationController pushViewController:musicList animated:YES];
    }
    else if(indexPath.row == 1)
    {
        musicList.listType = LOCAL_MUSIC_LIST;
        musicList.viewType = LIST_VIEW_CONTROLLER;
        musicList.musicFile = @"download";
        [self.navigationController pushViewController:musicList animated:YES];
    }
    zwAppDelegate * Dele = (zwAppDelegate *)[UIApplication sharedApplication].delegate;
    NSArray *arr = Dele.myTabBarController.view.subviews;
    for (UIView * v in arr) 
    {
        if ([v isKindOfClass:[CustomTabBarView class]]) 
        {
            [v setHidden:YES];
        }
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
