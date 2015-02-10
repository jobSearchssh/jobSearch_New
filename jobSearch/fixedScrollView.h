//
//  fixedScrollView.h
//  jobSearch
//
//  Created by 田原 on 15/2/3.
//  Copyright (c) 2015年 麻辣工作室. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface fixedScrollView : UIScrollView{
    id target;
    SEL action;
}
-(void)setTarget:(id)sTarget selector:(SEL)sAction;
@end
