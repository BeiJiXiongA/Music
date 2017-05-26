//
//  QFTabBarController.h
//  Player
//
//  Created by qianfeng on 13-4-25.
//  Copyright (c) 2013年 qianfeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomTabBarView.h"
#import "ButtomView.h"

@interface QFTabBarController : UIViewController<btnClickDelegate>
{ 
    NSDictionary * imgDic;
    NSArray *controllArr;
    
    UIView *currentView;
    CustomTabBarView * tabBarView;
    ButtomView *buttomView;
    BOOL play;
}

@property (nonatomic,retain)CustomTabBarView *tabBarView;
@property (nonatomic,retain)ButtomView *buttomView;
- (id)initWithQFTabBarControllerSetImg:(NSDictionary *)_imgDic AndViewControllerArr:(NSArray *)_controllerArr;

@end
