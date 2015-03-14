//
//  MLPickerView.h
//  jobSearch
//
//  Created by RAY on 15/3/13.
//  Copyright (c) 2015年 麻辣工作室. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MLPickerView;

@protocol MLPickerDelegate <NSObject>

@optional
- (void)pickerDidChangeStatus:(int)degree;
- (void)pickerDidCancel;
@end

@interface MLPickerView : UIView<UIPickerViewDelegate,UIPickerViewDataSource>
{
    int _degree;
    NSArray *pickerArray;
}
@property (strong, nonatomic) IBOutlet UIPickerView *pickerView;
@property (assign, nonatomic) id <MLPickerDelegate> delegate;

- (id)initWithDelegate:(id <MLPickerDelegate>)delegate;
- (void)showInView:(UIView *)view;
- (void)cancelPicker;

@end
