//
//  NSString+StringSize.h
//  Music
//
//  Created by rrrr on 13-4-25.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (StringSize)
-(CGRect)getSize:(NSString *)string andFontSize:(CGFloat)fontSize;
@end
