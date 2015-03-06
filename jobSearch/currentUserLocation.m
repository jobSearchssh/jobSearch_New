//
//  currentUserLocation.m
//  jobSearch
//
//  Created by RAY on 15/3/6.
//  Copyright (c) 2015年 麻辣工作室. All rights reserved.
//

#import "currentUserLocation.h"

@implementation currentUserLocation

static  currentUserLocation *thisObject=nil;

+ (currentUserLocation*)sharedInstance{
    if (thisObject==nil) {
        thisObject=[[currentUserLocation alloc]init];
    }
    return thisObject;
}

@end
