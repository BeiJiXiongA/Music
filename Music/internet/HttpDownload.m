//
//  HttpDownload.m
//  415proj
//
//  Created by rrrr on 13-4-15.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import "HttpDownload.h"

@implementation HttpDownload
@synthesize downloadData = _downloadData,delegate = _delegate,method = _method,apiType = _apiType;

-(id)init
{
    if (self = [super init]) 
    {
        _downloadData = [[NSMutableData alloc] init];
    }
    return self;
}

-(void)downloadFromUrlWithASI:(NSString *)url
{
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:[url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
    request.delegate = self;
    [request startAsynchronous];
}

-(void)requestFinished:(ASIHTTPRequest *)request
{
    [_downloadData setLength:0];
    [_downloadData appendData:[request responseData]];
    
    if ([self.delegate respondsToSelector:self.method]) {
        [self.delegate performSelector:self.method withObject:self];
    }
    else{
        NSLog(@"回调方法%@不存在",NSStringFromSelector(self.method));
    }
}
-(void)requestFailed:(ASIHTTPRequest *)request
{
    
    NSLog(@"请求失败: 状态码:%d,原因:%@",[request responseStatusCode],[[request error] localizedDescription]);
    
    [_downloadData setLength:0];
    
    if ([self.delegate respondsToSelector:self.method]) {
        [self.delegate performSelector:self.method withObject:self];
    }
    else{
        NSLog(@"回调方法%@不存在",NSStringFromSelector(self.method));
    }
}


@end
