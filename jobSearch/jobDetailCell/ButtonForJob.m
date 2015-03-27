//
//  ButtonForJob.m
//  jobSearch
//
//  Created by Leione on 15/3/26.
//  Copyright (c) 2015年 麻辣工作室. All rights reserved.
//

#import "ButtonForJob.h"

@implementation ButtonForJob

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
    
        self.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.8f];
        
        CGFloat kWidth = [UIScreen mainScreen].bounds.size.width;
        
        _sendButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        _sendButton.frame = CGRectMake(30, 0, (kWidth - 90)/2, frame.size.height);
//        _sendButton.backgroundColor = [UIColor grayColor];
        [_sendButton setTitle:@"投递简历" forState: UIControlStateNormal];
        _sendButton.font = [UIFont systemFontOfSize:20.0f];
        [self addSubview:_sendButton];
        
        _callButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        _callButton.frame = CGRectMake(60 + (kWidth - 90)/2, 0, (kWidth - 90)/2, frame.size.height);
//        _callButton.backgroundColor = [UIColor grayColor];
        [_callButton setTitle:@"拨打电话" forState: UIControlStateNormal];
        _callButton.font = [UIFont systemFontOfSize:20.0f];
        [self addSubview:_callButton];
    }
    return self;
}

@end
