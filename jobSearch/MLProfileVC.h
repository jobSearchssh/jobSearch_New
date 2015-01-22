//
//  MLProfileVC.h
//  jobSearch
//
//  Created by RAY on 15/1/19.
//  Copyright (c) 2015年 麻辣工作室. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KVNMaskedPageControl.h"

@interface MLProfileVC : UIViewController<KVNMaskedPageControlDataSource,UIScrollViewDelegate>

@property (weak, nonatomic) KVNMaskedPageControl *pageControl;
@property (nonatomic)NSInteger pages;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;


@end
