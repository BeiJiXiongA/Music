//
//  NetListViewController.m
//  Music
//
//  Created by rrrr on 13-4-23.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import "NetListViewController.h"
#import "CONST.h"

@implementation NetListViewController

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
    
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 35)];
    headerView.backgroundColor = [UIColor colorWithRed:0.11 green:0.43 blue:0.64 alpha:0.5];
    [self.view addSubview:headerView];
    
    myTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 35, 320, 460-35) style:UITableViewStylePlain];
    myTableView.delegate = self;
    myTableView.dataSource = self;
    [self.view addSubview:myTableView];
    
    groupArray = [[NSMutableArray alloc] init];
    
    if (!downloadData)
    {
        downloadData = [[HttpDownload alloc] init];
    }
    downloadData.delegate = self;
    downloadData.method = @selector(downloadComplete:);
    downloadData.apiType = SINGER_GROUP_TYPE;
    
    NSString *url = [NSString stringWithFormat:@"%@%@",HOST_URL,SINGER_GROUP_URL];
    
    [downloadData downloadFromUrlWithASI:url];
    
    
    NSArray *array = [NSArray arrayWithObjects:@"新歌",@"排行",@"歌手",@"电台",@"收藏", nil];
    
    int i;
    for (i=0; i<5; i++)
    {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(64*i, 0, 64, 35);
        btn.backgroundColor = [UIColor clearColor];
        [btn setTitle:[array objectAtIndex:i] forState:UIControlStateNormal];
        btn.titleLabel.textColor = [UIColor blackColor];
        btn.tag = 100+i;
        [btn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btn];
        [btn release];
    }
}

-(void)btnClicked:(id)sender
{
    UIButton *button = (UIButton *)sender;
    switch (button.tag)
    {
        case 100:
        {
            
        }
            break;
        case 101:
        {
            
        }
            break;
        
        default:
            break;
    }
}

-(void)downloadComplete:(HttpDownload *)hd
{
    if (hd.apiType==SINGER_GROUP_TYPE) 
    {
        NSDictionary*dict=[NSJSONSerialization JSONObjectWithData:hd.downloadData options:NSJSONReadingMutableContainers error:nil];
        
        [groupArray addObjectsFromArray:[dict objectForKey:@"List"]];
        NSLog(@"%d",[groupArray count]);
        [myTableView reloadData];
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [groupArray count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellName = @"dataCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellName];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellName] ;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    if ([groupArray count] > 0)
    {
        NSDictionary *dict = [groupArray objectAtIndex:indexPath.row];
        if (dict)
        {    
            cell.textLabel.text = [dict objectForKey:@"Name"];
            cell.detailTextLabel.text = [dict objectForKey:@"ID"];
        }
    }
    return cell;

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
