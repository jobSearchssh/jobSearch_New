//
//  URLReturnModel.m
//  wowilling
//
//  Created by 田原 on 14-3-7.
//  Copyright (c) 2014年 田原. All rights reserved.
//

#import "URLReturnModel.h"


@implementation URLReturnModel
@synthesize object;
@synthesize error;
- (URLReturnModel *)initWithData:(BOOL)isSuccess data:(NSData *)getObject error:(NSError *)getError{
    self = [super init];
    if (self) {
        flag = isSuccess;
        object = getObject;
        error = getError;
    }
    return self;
}
- (BOOL)getFlag{
    return flag;
}
- (NSData *)getData{
    return object;
}
- (NSError *)getError{
    return error;
}
@end
