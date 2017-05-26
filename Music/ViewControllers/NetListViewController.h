//
//  NetListViewController.h
//  Music
//
//  Created by rrrr on 13-4-23.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HttpDownload.h"

@interface NetListViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
    HttpDownload *downloadData;
    NSArray *groupImageArray;
    NSMutableArray *groupArray;
    UITableView *myTableView;
}
@end
