//
//  zwAppDelegate.m
//  Music
//
//  Created by rrrr on 13-4-22.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import "zwAppDelegate.h"
#import "StartViewController.h"
#import "CONST.h"
#import "NewViewController.h"
#import "SearchViewController.h"
#import "UserViewController.h"
#import "SettingViewController.h"

@implementation zwAppDelegate
@synthesize window = _window;
//@synthesize player;
@synthesize myTabBarController;
- (void)dealloc
{
    
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch

    NSMutableArray *navNormal = [NSMutableArray arrayWithObjects:@"tab_new.png",@"tab_search.png",@"tab_user.png",@"tab_setting.png", nil];
    NSMutableArray *navSelected = [NSMutableArray arrayWithObjects:@"tab_new2.png",@"tab_search2.png",@"tab_user2.png",@"tab_setting2.png", nil];
    NSMutableArray *navNormalImages = [[NSMutableArray alloc] initWithCapacity:4];
    NSMutableArray *navSelectedImages = [[NSMutableArray alloc]initWithCapacity:4];
    
    for (int i=0; i<4; i++)
    {
        UIImage *normalImage = [UIImage imageNamed:[navNormal objectAtIndex:i]];
        [navNormalImages addObject:normalImage];
        UIImage *selectedImage = [UIImage imageNamed:[navSelected objectAtIndex:i]];
        [navSelectedImages addObject:selectedImage];
    }
    NSDictionary *imageDict = [NSDictionary dictionaryWithObjectsAndKeys:navNormalImages,@"Normal",navSelectedImages,@"Select", nil];
    
    NewViewController *newVC = [[NewViewController alloc]init];
    UINavigationController *newNav = [[UINavigationController alloc]initWithRootViewController:newVC];
    
    SearchViewController *searchVC = [[SearchViewController alloc]init];
    UINavigationController *searchNav = [[UINavigationController alloc]initWithRootViewController:searchVC];
    
    UserViewController *userVC = [[UserViewController alloc]init];
    UINavigationController *userNav = [[UINavigationController alloc]initWithRootViewController:userVC];
    
    SettingViewController *settingVC = [[SettingViewController alloc]init];
    UINavigationController *settingNav = [[UINavigationController alloc]initWithRootViewController:settingVC];
    
    NSArray *viewArray= [NSArray arrayWithObjects: newNav,searchNav,userNav,settingNav, nil];
    
    myTabBarController = [[QFTabBarController alloc] initWithQFTabBarControllerSetImg:imageDict AndViewControllerArr:viewArray];
    
    self.window.rootViewController = myTabBarController;
   
//    player = [[AVAudioPlayer alloc] init];
    
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
}

@end
