//
//  MLCell4.h
//  jobSearch
//
//  Created by RAY on 15/2/4.
//  Copyright (c) 2015年 麻辣工作室. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MLCell4 : UITableViewCell
{
    BOOL selected;
}
@property (weak, nonatomic) IBOutlet UIImageView *selectedImageView;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (nonatomic)BOOL selecting;


@end
