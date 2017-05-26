//
//  SingerViewController.m
//  415proj
//
//  Created by rrrr on 13-4-15.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import "SingerViewController.h"
#import "CONST.h"


@implementation SingerViewController
@synthesize i=_i;
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
    singersArray = [[NSMutableArray alloc] init];
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 35)];
    headerView.backgroundColor = [UIColor colorWithRed:0.11 green:0.43 blue:0.64 alpha:0.5];
    [self.view addSubview:headerView];
    NSLog(@"i=%d,_i=%d",i,_i);
    
    singersTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, headerView.frame.size.height, 320, self.view.frame.size.height - headerView.frame.size.height) style:UITableViewStylePlain];
    singersTableView.delegate = self;
    singersTableView.dataSource = self;
    [self.view addSubview:singersTableView];
    
    if (!downloadData)
    {
        downloadData = [[HttpDownload alloc] init];
    }
    downloadData.delegate = self;
    downloadData.apiType = GROUP_SINGERS_TYPE;
    downloadData.method = @selector(downloadComplete:);
    
    NSString *url = [NSString stringWithFormat:@"%@/get_singer.php?group_id=4&page=1&number=10",HOST_URL];
    
    [downloadData downloadFromUrlWithASI:url];
    
//    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
//    btn.frame = CGRectMake(0, 0, 64, 30);
//    btn.backgroundColor = [UIColor clearColor];
//    [btn setTitle:@"返回" forState:UIControlStateNormal];
//    btn.tag = i;
//    [btn addTarget:self action:@selector(btnclicked:) forControlEvents:UIControlEventTouchUpInside];
//    btn.titleLabel.textColor = [UIColor blackColor];
//    [headerView addSubview:btn];
//    [btn release];
    
//    NSLog(@"url= %@",url);
}

//-(void)btnClicked:(UIButton *)btn
//{
//    [self dismissViewControllerAnimated:YES completion:^{
//        
//    }];
//}

-(void)downloadComplete:(HttpDownload *)hd
{
    if (hd.apiType==GROUP_SINGERS_TYPE) 
    {
        NSDictionary*dict=[NSJSONSerialization JSONObjectWithData:hd.downloadData options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"%@",[dict objectForKey:@"TotalCount"]);
        NSLog(@"dict=%@",dict);
        
        [singersArray addObjectsFromArray:[dict objectForKey:@"List"]];
//        NSLog(@"singerArray=%@",singersArray);
        
        [singersTableView reloadData];
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
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
    if ([singersArray count] > 0)
    {
        NSDictionary *dict = [singersArray objectAtIndex:indexPath.row];
        if (dict)
        {    
            cell.textLabel.text = [dict objectForKey:@"Name"];
            cell.detailTextLabel.text = [dict objectForKey:@"ID"];
            
//            NSURL *imageUrl = [dict objectForKey:@"PicUrl"];
//            NSLog(@"imageUrl = %@",imageUrl);
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
