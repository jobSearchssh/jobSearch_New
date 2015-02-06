//
//  URLOperation.m
//  wowilling
//
//  Created by 田原 on 14-3-7.
//  Copyright (c) 2014年 田原. All rights reserved.
//

#import "URLOperation.h"
static NSString *baseURL = @"http://123.57.5.113:8081/";

@implementation URLOperation
- (id)initWithURL:(NSData*)getInfo serveceFunction:(NSString *)getPostLoca target:(id)getTarget action:(SEL)getAction isPost:(BOOL)postOrGet{
    self = [super init];
    if (self) {
        postInfo = getInfo;
        postLoca = getPostLoca;
        target = getTarget;
        action = getAction;
        isPost = postOrGet;
    }
    return self;
}

- (void)main{
    @try {
        //第一步，生成链接地址
        NSURL *url = [NSURL URLWithString:[[NSString alloc]initWithFormat:@"%@%@",baseURL,postLoca]];
        
        //第二步，创建请求
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:3];
        
        if (isPost) {
            [request setHTTPMethod:@"POST"];
        }else{
            [request setHTTPMethod:@"GET"];
        }
        
        
        if (postInfo != Nil) {
            [request setHTTPBody:postInfo];
        }
        

        NSURLSessionDataTask *task = [[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                URLReturnModel *objRe = [[URLReturnModel alloc]initWithData:data error:error];
                [target performSelectorOnMainThread:action withObject:objRe waitUntilDone:NO];
        }];
        
        [task resume];
    }
    @catch (NSException *exception) {
        NSLog(@"网络错误");
    }
}

@end
