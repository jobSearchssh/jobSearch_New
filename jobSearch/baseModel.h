//
//  baseModel.h
//  jobSearch
//
//  Created by 田原 on 15/2/1.
//  Copyright (c) 2015年 麻辣工作室. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MLTextUtils.h"

#define BASE_SUCCESS 0
#define BASE_FAILED 1
#define BASE_SPAN 10

@interface baseModel : NSObject{
    NSNumber *status;
    NSString *info;
    NSNumber *count;
}

-(NSNumber *)getStatus;
-(NSNumber *)getCount;
-(NSString *)getInfo;

@end
