//
//  CustomTabBarView.m
//  Player
//
//  Created by 毛毛虫 on 13-4-25.
//  Copyright (c) 2013年 qianfeng. All rights reserved.
//

#import "CustomTabBarView.h"

@implementation CustomTabBarView
@synthesize delegate;

- (id)initWithFrame:(CGRect)frame AndBtnImgDic:(NSDictionary *)_imgDic
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        //tabBarView = [[UIView alloc] initWithFrame:CGRectMake(0, rect.size.height-44, rect.size.width, 44)];
//        self.backgroundColor = [UIColor blackColor];
        UIImageView *bg = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"navi_bg.png"]];
        bg.frame = CGRectMake(0, 0, 320, 44);
        [self addSubview:bg];
        for (int i = 1; i < 5; i++) {
            UIButton * b = [UIButton buttonWithType:UIButtonTypeCustom];
            [b setImage:[[_imgDic objectForKey:@"Normal"] objectAtIndex:i-1] forState:UIControlStateNormal];
            [b setFrame:CGRectMake((i-1)*80, 0, 80, 44)];
            [b setTag:i];
            [b addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
            
            [self addSubview:b];
        }
    }
    return self;
}

- (void)btnClick:(UIButton *)btn
{
    int tag = btn.tag;
    if (delegate && [delegate respondsToSelector:@selector(btnClickChangeViewWithTag:)]) {
        [delegate performSelector:@selector(btnClickChangeViewWithTag:) withObject:[NSString stringWithFormat:@"%d",tag]];
    }

}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
