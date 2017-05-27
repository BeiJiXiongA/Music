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

@interface UserViewController ()
@property (nonatomic, strong) NSMutableArray *resourceMusicList;
@property (nonatomic, strong) NSMutableArray *documentMusicList;
@end

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
    
    _resourceMusicList = [[NSMutableArray alloc] init];
    _documentMusicList = [[NSMutableArray alloc] init];
    
//    self.view.backgroundColor = [UIColor greenColor];
    userTableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
    userTableView.frame = CGRectMake(0, 0, WIDTH, HEIGHT - UI_NAV_BAR_HEIGHT - UI_TAB_BAR_HEIGHT);
    userTableView.delegate = self;
    userTableView.dataSource =self;
    [self.view addSubview:userTableView];
    userTableView.tableFooterView = [[UIView alloc] init];
    
    if (!musicList)
    {
        musicList = [[MusicListViewController alloc]init];
    }
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *documentDir = [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:@""];;
    NSError *error = nil;
    NSArray *fileList = [fileManager contentsOfDirectoryAtURL:[NSURL URLWithString:documentDir] includingPropertiesForKeys:nil options:nil error:&error];
    for (NSURL *file in fileList) {
        if ([[file absoluteString] hasSuffix:@"m4a"]) {
            [_resourceMusicList addObject:[file absoluteString]];
        }
    }
    self.navigationController.navigationBar.barStyle = UIBarStyleBlackTranslucent;
    UIImage *navImage = [UIImage imageNamed:@"navi_bg"];
    [self.navigationController.navigationBar setBackgroundImage:navImage forBarMetrics:UIBarMetricsDefault];     
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
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
        cell = [[MusicCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"userCell"];
    }
    switch (indexPath.row)
    {
        case 0:
        {
            cell.iconImageView.backgroundColor = [UIColor greenColor];
            [cell.iconImageView setImage:[UIImage imageNamed:@"local_list.png"]];
            cell.nameLabel.text = @"本地列表";
            cell.detailLabel.text = [NSString stringWithFormat:@"%zi个列表",_documentMusicList.count];
            
        }
            break;
        case 1:
        {
            cell.iconImageView.backgroundColor = [UIColor blueColor];
            [cell.iconImageView setImage:[UIImage imageNamed:@"recent_list"]];
            cell.nameLabel.text = @"资源文件";
            cell.detailLabel.text = [NSString stringWithFormat:@"%d首歌曲",_resourceMusicList.count];
        }
            break;
        default:
            break;
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        musicList.listArray = _documentMusicList;
    }else if(indexPath.row == 1){
        musicList.listArray = _resourceMusicList;
    }
    [self.navigationController pushViewController:musicList animated:YES];
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
