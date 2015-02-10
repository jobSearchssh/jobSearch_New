//
//  jobApplyModel.m
//  jobSearch
//
//  Created by 田原 on 15/2/9.
//  Copyright (c) 2015年 麻辣工作室. All rights reserved.
//

#import "jobApplyModel.h"

@implementation jobApplyModel
-(jobApplyModel *)initWithData:(NSData *)mainData{
    self = [super init];
    if (self) {
        NSString *receiveStr = [[NSString alloc]initWithData:mainData encoding:NSUTF8StringEncoding];
//        NSLog(@"%@",receiveStr);
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
                @try {
                    NSDictionary *datas = [a objectForKey:@"datas"];
                    if (datas != Nil) {
                        apply_id = [datas objectForKey:@"apply_id"];
                        recieve_id = [datas objectForKey:@"recieve_id"];
                    }
                }
                @catch (NSException *exception) {
                    
                }
            }@catch (NSException *exception) {
                flag = false;
            }
        }
        if (!flag) {
            status = [NSNumber numberWithInt:BASE_FAILED];
            info = @"解析错误,请重新尝试";
        }
    }
    return self;
}
-(jobApplyModel *)initWithError:(NSNumber *)getStatus info:(NSString *)error{
    self = [super init];
    if (self) {
        status = getStatus;
        info = error;
    }
    return self;
}
-(NSString *)getapply_id{
    return apply_id;
}
-(NSString *)getrecieve_id{
    return recieve_id;
}

@end
