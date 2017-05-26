//
//  SingerViewController.h
//  415proj
//
//  Created by rrrr on 13-4-15.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HttpDownload.h"
@interface SingerViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
    HttpDownload *downloadData;
    NSMutableArray *singersArray;
    UITableView *singersTableView;
    int i;
    int *count;
}
@property (nonatomic,assign)int i;
@end
