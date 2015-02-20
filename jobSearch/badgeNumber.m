//
//  badgeNumber.m
//  jobSearch
//
//  Created by RAY on 15/2/20.
//  Copyright (c) 2015年 麻辣工作室. All rights reserved.
//

#import "badgeNumber.h"
#import "netAPI.h"

static NSString *userId = @"54d76bd496d9aece6f8b4568";

@implementation badgeNumber

static  badgeNumber *thisObject=nil;

+ (badgeNumber*)sharedInstance{
    if (thisObject==nil) {
        thisObject=[[badgeNumber alloc]init];
    }
    return thisObject;
}

- (void)refreshCount{
    
    NSUserDefaults *mySettingData = [NSUserDefaults standardUserDefaults];
    
    self.messageCount=[mySettingData objectForKey:@"badgeInviteNum"];
    self.applyCount=[mySettingData objectForKey:@"badgeMessageNum"];
    
    [netAPI getNotReadMessageNum:userId withBlock:^(badgeModel *badgeModel) {
        if ([badgeModel.getStatus intValue]==0) {
            self.messageCount=badgeModel.getinviteNotRead;
            self.applyCount=badgeModel.getapplyNotRead;         
            
            [mySettingData setObject:self.messageCount forKey:@"badgeInviteNum"];
            [mySettingData setObject:self.applyCount forKey:@"badgeMessageNum"];
            [mySettingData synchronize];

        }
    }];
}

@end
