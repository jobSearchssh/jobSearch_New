//
//  MLDatePickerView.h
//  jobSearch
//
//  Created by RAY on 15/2/19.
//  Copyright (c) 2015年 麻辣工作室. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MLDatePickerView;

@protocol MLDatePickerDelegate <NSObject>

@optional
- (void)timePickerDidChangeStatus:(UIDatePicker *)picker;
- (void)timePickerDidCancel;
@end

@interface MLDatePickerView : UIView

@property (weak, nonatomic) IBOutlet UIDatePicker *MLDatePicker;
@property (assign, nonatomic) id <MLDatePickerDelegate> delegate;

- (id)initWithStyle:(UIDatePickerMode)pickerMode delegate:(id <MLDatePickerDelegate>)delegate;
- (void)showInView:(UIView *)view;
- (void)cancelPicker;
- (void)setBirthday:(NSDate*)dat;
@end
