//
//  MLSelectJobTypeVC.h
//  jobSearch
//
//  Created by RAY on 15/2/4.
//  Copyright (c) 2015年 麻辣工作室. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol finishSelectDelegate <NSObject>
@required
- (void)finishSelect:(NSMutableArray*)type SelectName:(NSMutableArray*)nameArray;
@end

@interface MLSelectJobTypeVC : UITableViewController

@property (nonatomic,strong) NSMutableArray *selectedTypeArray;
@property (nonatomic,strong) NSMutableArray *selectedTypeName;
@property(nonatomic,weak) id<finishSelectDelegate> selectDelegate;
@end
