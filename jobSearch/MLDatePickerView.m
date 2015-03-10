//
//  MLDatePickerView.m
//  jobSearch
//
//  Created by RAY on 15/2/19.
//  Copyright (c) 2015年 麻辣工作室. All rights reserved.
//

#import "MLDatePickerView.h"

@implementation MLDatePickerView

- (id)initWithStyle:(UIDatePickerMode)pickerMode delegate:(id <MLDatePickerDelegate>)delegate{
    
    self = [[[NSBundle mainBundle] loadNibNamed:@"MLDatePickerView" owner:self options:nil] objectAtIndex:0];
    if (self) {
        self.MLDatePicker.datePickerMode=pickerMode;
        self.delegate=delegate;
    }
    return self;
}

- (void)showInView:(UIView *)view
{
    self.frame = CGRectMake(0, view.frame.size.height, [[UIScreen mainScreen] bounds].size.width, self.frame.size.height);
    [view addSubview:self];
    
    [UIView animateWithDuration:0.4 animations:^{
        self.frame = CGRectMake(0, view.frame.size.height - self.frame.size.height, [[UIScreen mainScreen] bounds].size.width, self.frame.size.height);
    }];
    
}

- (void)cancelPicker
{
    [UIView animateWithDuration:0.4
                     animations:^{
                         self.frame = CGRectMake(0, self.frame.origin.y+self.frame.size.height, self.frame.size.width, self.frame.size.height);
                     }
                     completion:^(BOOL finished){
                         [self removeFromSuperview];
                         
                     }];
}

- (void)setBirthday:(NSDate*)dat{
    [self.MLDatePicker setDate:dat];
}

- (IBAction)touchCancel:(id)sender {
    [self.delegate timePickerDidCancel];
    [self cancelPicker];
}
- (IBAction)touchOK:(id)sender {
    [self.delegate timePickerDidChangeStatus:self.MLDatePicker];
    [self cancelPicker];
}
 
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
