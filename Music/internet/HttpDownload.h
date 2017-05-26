//
//  HttpDownload.h
//  415proj
//
//  Created by rrrr on 13-4-15.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASIHTTPRequest.h"

@interface HttpDownload : NSObject<ASIHTTPRequestDelegate>
{
    
}
@property (nonatomic,readonly) NSMutableData *downloadData;
@property (nonatomic,assign) id delegate;
@property (nonatomic,assign) SEL method;
@property (nonatomic,assign) NSInteger apiType;

-(id)init;

-(void)downloadFromUrlWithASI:(NSString *)url;

@end
