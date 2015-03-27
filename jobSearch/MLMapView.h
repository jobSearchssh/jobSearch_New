//
//  MLMapView.h
//  jobSearch
//
//  Created by RAY on 15/1/17.
//  Copyright (c) 2015年 麻辣工作室. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MAMapKit/MAMapKit.h>
#import <AMapSearchKit/AMapSearchAPI.h>
#import "CalloutMapAnnotation.h"
#import "BasicMapAnnotation.h"
@protocol showDetailDelegate <NSObject>
@required
- (void)showDetail:(NSInteger)tag;
@end

@interface MLMapView : UIView<MAMapViewDelegate,AMapSearchDelegate,UIGestureRecognizerDelegate>
{
    NSMutableArray *pointAnnoArray;
    NSMutableDictionary *pointAnnoDic;
    int nowTag;
    BOOL firstLoad;
    BOOL requestUserLocation;
}
@property(nonatomic, retain) MAMapView *mapView;

- (void)addAnnotation:(NSArray*)point Title:(NSString*)title peopleCount:(NSString *)peopleCount tag:(int)tag SetToCenter:(BOOL)isCenter;
- (void)removeAllAnnotations;
//主动请求定位
- (void)setShowUserLocation:(BOOL)isShow;

@property(nonatomic,weak) id<showDetailDelegate> showDetailDelegate;

@end
