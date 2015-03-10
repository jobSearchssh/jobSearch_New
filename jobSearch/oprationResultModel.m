//
//  oprationResultModel.m
//  jobSearch
//
//  Created by 田原 on 15/2/1.
//  Copyright (c) 2015年 麻辣工作室. All rights reserved.
//

#import "oprationResultModel.h"
#import "MLTextUtils.h"

@implementation oprationResultModel
-(oprationResultModel *)initWithData:(NSData *)mainData{
    self = [super init];
    if (self) {
        NSString *receiveStr = [[NSString alloc]initWithData:mainData encoding:NSUTF8StringEncoding];
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
                datas = [a objectForKey:@"datas"];
            }@catch (NSException *exception) {
                flag = false;
            }
        }
        if (!flag) {
            status = [NSNumber numberWithInt:BASE_FAILED];
            info =ANALYZE_ERROR;
        }
    }
    return self;
}
-(oprationResultModel *)initWithError:(NSNumber *)getStatus info:(NSString *)error{
    self = [super init];
    if (self) {
        status = getStatus;
        info = error;
    }
    return self;
}
-(NSString *)getOprationID{
    return datas;
}
@end
