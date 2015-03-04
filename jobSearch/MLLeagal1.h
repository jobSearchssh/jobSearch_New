//
//  MLLeagal1.h
//  jobSearch
//
//  Created by RAY on 15/3/4.
//  Copyright (c) 2015年 麻辣工作室. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol legalDelegate <NSObject>
@required
- (void)legalBack;
@end

@interface MLLeagal1 : UIViewController

@property(nonatomic,weak) id<legalDelegate> delegate;

@end
