//
//  CustomTabBarView.h
//  Player
//
//  Created by 毛毛虫 on 13-4-25.
//  Copyright (c) 2013年 qianfeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol btnClickDelegate <NSObject>
- (void)btnClickChangeViewWithTag:(NSString *)tag;
@end

@interface CustomTabBarView : UIView
@property(nonatomic,assign)id <btnClickDelegate>delegate;

- (id)initWithFrame:(CGRect)frame AndBtnImgDic:(NSDictionary *)_imgDic;

@end
