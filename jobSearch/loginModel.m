//
//  loginModel.m
//  jobSearch
//
//  Created by 田原 on 15/2/1.
//  Copyright (c) 2015年 麻辣工作室. All rights reserved.
//

#import "loginModel.h"
#import "MLTextUtils.h"

@implementation loginModel

-(loginModel *)initWithError:(NSNumber *)getStatus info:(NSString *)error usrID:(NSString *)defaultID{
    self = [super init];
    if (self) {
        status = getStatus;
        info = error;
        usrID = defaultID;
    }
    return self;
}

-(loginModel *)initWithData:(NSData *)mainData{
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
                usrID = [a objectForKey:@"datas"];
                
            }@catch (NSException *exception) {
                flag = false;
            }
        }
        
        if (flag && status.intValue == STATIS_OK) {
            do{
                NSDictionary *dictionary = nil;
                @try {
                    dictionary = [a objectForKey:@"userdata"];
                }
                @catch (NSException *exception) {
                    NSLog(@"datas 解析不成功");
                    dictionary = Nil;
                    flag = false;
                }
                if (dictionary == Nil) {
                    NSLog(@"datas 为空");
                    flag = false;
                    break;
                }
                
                @try {
                    NSArray *arr=[dictionary objectForKey:@"ImageFileURL"];
                    if ([arr count]>0) {
                        usrLogoUrl=[arr objectAtIndex:0];
                    }else
                        usrLogoUrl=nil;
                }
                @catch (NSException *exception) {
                    NSLog(@"无图片信息");
                    usrLogoUrl=nil;
                    break;
                }
                
            }while (FALSE);
            
        }
        
        if (!flag) {
            status = [NSNumber numberWithInt:STATIS_NO];
            info = ANALYZE_ERROR;
            usrID = @"-1";
            usrLogoUrl=nil;
        }
    }
    return self;
}
-(NSNumber *)getStatus{
    return status;
}
-(NSString *)getInfo{
    return info;
}
-(NSString *)getUsrID{
    return usrID;
}
-(NSString *)getusrLogoUrl{
    return usrLogoUrl;
}
@end
