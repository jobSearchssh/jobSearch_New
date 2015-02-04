//
//  nearByJobListModel.m
//  jobSearch
//
//  Created by 田原 on 15/2/1.
//  Copyright (c) 2015年 麻辣工作室. All rights reserved.
//

#import "nearByJobListModel.h"

@implementation nearByJobListModel
-(nearByJobListModel *)initWithData:(NSData *)mainData{
    self = [super init];
    if (self) {
        BOOL flag = TRUE;
        do{
            NSString *receiveStr = [[NSString alloc]initWithData:mainData encoding:NSUTF8StringEncoding];
            NSError *error;
            NSData* aData = [receiveStr dataUsingEncoding: NSASCIIStringEncoding];
            NSDictionary *a = Nil;
            @try {
                a = [NSJSONSerialization JSONObjectWithData:aData options:NSJSONReadingMutableLeaves error:&error];
            }
            @catch (NSException *exception) {
                a = Nil;
                flag = false;
            }
            
            //super
            if (flag) {
                @try {
                    status = [a objectForKey:@"status"];
                    info = [a objectForKey:@"info"];
                    count = [a objectForKey:@"count"];
                }
                @catch (NSException *exception) {
                    flag = false;
                }
            }

            if (flag) {
                if (status.intValue == BASE_FAILED) {
                    break;
                }
                nearByJobList = [[NSMutableArray alloc]init];
                NSArray *jobsJSON = [a objectForKey:@"datas"];
                for (NSDictionary *dictionary in jobsJSON) {
                    @try {
                        nearByJobModel *job = [[nearByJobModel alloc]initWithDictionary:dictionary];
                        if (job != Nil) {
                            [nearByJobList addObject:job];
                        }
                    }
                    @catch (NSException *exception) {
                        NSLog(@"nearByJobListModel-error");
                        continue;
                    }
                }
            }
        }while (FALSE);
        
        if (!flag) {
            status = [NSNumber numberWithInt:BASE_FAILED];
            info = @"解析错误,请重新尝试";
        }
    }
    return self;
}

-(nearByJobListModel *)initWithError:(NSNumber *)getStatus info:(NSString *)error{
    self = [super init];
    if (self) {
        status = getStatus;
        info = error;
    }
    return self;
}

-(NSMutableArray *)getnearByJobListArray{
    return nearByJobList;
}
@end
