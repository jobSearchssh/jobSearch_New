//
//  userReturnModel.m
//  jobSearch
//
//  Created by 田原 on 15/2/7.
//  Copyright (c) 2015年 麻辣工作室. All rights reserved.
//

#import "userReturnModel.h"

@implementation userReturnModel
-(userReturnModel *)initWithData:(NSData *)mainData{
    self = [super init];
    if (self) {
        NSString *receiveStr = [[NSString alloc]initWithData:mainData encoding:NSUTF8StringEncoding];
        NSLog(@"%@",receiveStr);
        NSError *error;
        NSData* aData = [receiveStr dataUsingEncoding: NSASCIIStringEncoding];
        NSDictionary *a = Nil;
        BOOL flag = TRUE;
        @try {
            a = [NSJSONSerialization JSONObjectWithData:aData options:NSJSONReadingMutableLeaves error:&error];
        }
        @catch (NSException *exception) {
            a = Nil;
            flag = false;
        }
        if (flag) {
            @try {
                status = [a objectForKey:@"status"];
                info = [a objectForKey:@"info"];
                user_id = [a objectForKey:@"datas"];
            }@catch (NSException *exception) {
                flag = false;
            }
        }
        if (!flag) {
            status = [NSNumber numberWithInt:STATIS_NO];
            info = @"解析错误,请重新尝试";
            user_id = @"-1";
        }
    }
    return self;
}
-(userReturnModel *)initWithError:(NSNumber *)getStatus info:(NSString *)error usrID:(NSString *)defaultID{
    self = [super init];
    if (self) {
        status = getStatus;
        info = error;
        user_id = defaultID;
    }
    return self;
}
-(NSString *)getUserID{
    return user_id;
}
@end
