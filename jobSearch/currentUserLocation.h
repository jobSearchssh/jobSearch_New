//
//  currentUserLocation.h
//  jobSearch
//
//  Created by RAY on 15/3/6.
//  Copyright (c) 2015年 麻辣工作室. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MLMapView.h"
@interface currentUserLocation : NSObject
@property (nonatomic) CLLocationCoordinate2D currentUserLocation;

+ (currentUserLocation*)sharedInstance;

@end
