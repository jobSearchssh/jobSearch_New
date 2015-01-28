//
//  URLOperation.h
//  wowilling
//
//  Created by 田原 on 14-3-7.
//  Copyright (c) 2014年 田原. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "URLReturnModel.h"
@interface URLOperation : NSOperation{
    NSData *postInfo;
    NSString *postLoca;
    id target;
    SEL action;
    BOOL isPost;
}
//data为post数据 postFunction为post地址 target为目标引用 action为回调函数
- (id)initWithURL:(NSData*)getInfo serveceFunction:(NSString *)getPostLoca target:(id)getTarget action:(SEL)getAction isPost:(BOOL)postOrGet;
@end
