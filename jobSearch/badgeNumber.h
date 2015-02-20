//
//  badgeNumber.h
//  jobSearch
//
//  Created by RAY on 15/2/20.
//  Copyright (c) 2015年 麻辣工作室. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface badgeNumber : NSObject

@property (nonatomic) NSString *messageCount;
@property (nonatomic) NSString *applyCount;

- (void)refreshCount;
+ (badgeNumber*)sharedInstance;

@end
