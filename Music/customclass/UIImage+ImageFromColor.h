//
//  UIImage+ImageFromColor.h
//  SpaceHome
//
//  Created by ZhangWei-SpaceHome on 15/9/8.
//
//

#import <UIKit/UIKit.h>

@interface UIImage (ImageFromColor)

+ (UIImage *)createImageWithColor:(UIColor *)color;

+ (UIImage *)createImageWithColor:(UIColor *)color andSize:(CGSize)size;

@end
