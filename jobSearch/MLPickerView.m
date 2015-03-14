//
//  MLPickerView.m
//  jobSearch
//
//  Created by RAY on 15/3/13.
//  Copyright (c) 2015年 麻辣工作室. All rights reserved.
//

#import "MLPickerView.h"

@implementation MLPickerView

- (id)initWithDelegate:(id <MLPickerDelegate>)delegate{
    
    self = [[[NSBundle mainBundle] loadNibNamed:@"MLPickerView" owner:self options:nil] objectAtIndex:0];
    if (self) {
        self.delegate=delegate;
        pickerArray=[NSArray arrayWithObjects:@"初中及以下",@"高中",@"大专",@"本科",@"硕士",@"博士及以上", nil];
        _degree=1;
    }
    return self;
}

- (void)showInView:(UIView *)view
{
    self.pickerView.delegate=self;
    
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

- (IBAction)touchOK:(id)sender {
    [self.delegate pickerDidChangeStatus:_degree];
    [self cancelPicker];
}

- (IBAction)touchCancel:(id)sender {
    [self.delegate pickerDidCancel];
    [self cancelPicker];
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}
-(NSInteger) pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return [pickerArray count];
}
-(NSString*) pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    return [pickerArray objectAtIndex:row];
}

- (void) pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    _degree=(int)row+1;
}

@end
