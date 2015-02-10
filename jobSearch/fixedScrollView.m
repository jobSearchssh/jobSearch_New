//
//  fixedScrollView.m
//  jobSearch
//
//  Created by 田原 on 15/2/3.
//  Copyright (c) 2015年 麻辣工作室. All rights reserved.
//

#import "fixedScrollView.h"

@implementation fixedScrollView
-(void)setTarget:(id)sTarget selector:(SEL)sAction{
    target = sTarget;
    action = sAction;
}
-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [super touchesBegan:touches withEvent:event];
    if ( !self.dragging )
    {
        [[self nextResponder] touchesBegan:touches withEvent:event];
    }
    if ([target respondsToSelector:action]) {
            [target performSelector:action];
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
