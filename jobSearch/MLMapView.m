//
//  MLMapView.m
//  jobSearch
//
//  Created by RAY on 15/1/17.
//  Copyright (c) 2015年 麻辣工作室. All rights reserved.
//

#import "MLMapView.h"
#import "CustomAnnotationView.h"

@implementation MLMapView
@synthesize mapView=_mapView;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self KeyCheck];
        _mapView = [[MAMapView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        [self addSubview:_mapView];
        _mapView.userInteractionEnabled=YES;
        _mapView.delegate = self;
        
        pointAnnoArray=[[NSMutableArray alloc]init];
        
    }
    return self;
}

- (void)KeyCheck{
    [MAMapServices sharedServices].apiKey =@"c38130d72c3068f07be6c23c7e791f47";
}

- (void)addAnnotation:(NSArray*)point Title:(NSString*)title tag:(int)tag{
    MAPointAnnotation *sellerPoint = [[MAPointAnnotation alloc] init];
    nowTag=tag;
    [pointAnnoArray addObject:sellerPoint];
    CLLocationCoordinate2D coord=CLLocationCoordinate2DMake([[point objectAtIndex:1] doubleValue], [[point objectAtIndex:0] doubleValue]);
    sellerPoint.coordinate = coord;
    sellerPoint.title=title;
    
    [_mapView addAnnotation:sellerPoint];
    
    _mapView.region = MACoordinateRegionMake(coord,MACoordinateSpanMake(0.005, 0.005));
}

- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation
{
    if ([annotation isKindOfClass:[MAPointAnnotation class]])
    {
        static NSString *reuseIndetifier = @"annotationReuseIndetifier";
        CustomAnnotationView *annotationView = (CustomAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:reuseIndetifier];
        if (annotationView == nil)
        {
            annotationView = [[CustomAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:reuseIndetifier];
        }
        annotationView.image = [UIImage imageNamed:@"annotation"];
        
        // 设置为NO，用以调用自定义的calloutView
        annotationView.canShowCallout = YES;
        
        // 设置中心点偏移，使得标注底部中间点成为经纬度对应点
        annotationView.centerOffset = CGPointMake(0, -18);
        
        UIButton *btn=[[UIButton alloc]initWithFrame:annotationView.frame];
        btn.tag=nowTag;
        
        [btn setImage:[UIImage imageNamed:@"mapDetail"] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(showDetails:) forControlEvents:UIControlEventTouchUpInside];
        annotationView.rightCalloutAccessoryView=btn;
        
        return annotationView;
    }
    return nil;
}


- (void)showDetails:(id)sender{
    
    UIButton *button = (UIButton *)sender;
    [self.showDetailDelegate showDetail:button.tag];
    
}

- (void)removeAllAnnotations{
    [_mapView removeAnnotations:pointAnnoArray];
    [pointAnnoArray removeAllObjects];
}

@end

