//
//  UserViewController.h
//  Music
//
//  Created by rrrr on 13-5-1.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QFTabBarController.h"
#import "MusicListViewController.h"

@interface UserViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *userTableView;
    MusicListViewController *musicList;
}
@end
