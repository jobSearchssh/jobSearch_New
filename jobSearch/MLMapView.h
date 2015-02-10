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

@protocol showDetailDelegate <NSObject>
@required
- (void)showDetail:(NSInteger)tag;
@end


@interface MLMapView : UIView<MAMapViewDelegate,AMapSearchDelegate,UIGestureRecognizerDelegate>
{
    NSMutableArray *pointAnnoArray;
    int nowTag;

}
@property(nonatomic, retain) MAMapView *mapView;

- (void)addAnnotation:(NSArray*)point Title:(NSString*)title tag:(int)tag;
- (void)removeAllAnnotations;

@property(nonatomic,weak) id<showDetailDelegate> showDetailDelegate;

@end
