//
//  MusicListViewController.h
//  Music
//
//  Created by rrrr on 13-4-22.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PlayViewController.h"
#import "HttpDownload.h"
#import "MusicListViewController.h"
#import "PlayerView.h"

@interface MusicListViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate>
{
    UITableView *listTableView;
    NSMutableArray *_listArray;
    HttpDownload *httpdownload;
    NSInteger listType;
    PlayViewController *playVC;
    NSInteger apiType;
    NSString *musicFile;
    MusicListViewController *musicList;
    PlayerView *playerView;
    
}
@property (nonatomic,copy)NSString *musicFile;
@property (nonatomic,assign)NSInteger apiType;
@property (nonatomic,assign)NSInteger listType;
@property (nonatomic,assign)NSInteger  viewType;
@property (nonatomic,retain)NSMutableArray *listArray;
@end
