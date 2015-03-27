//
//  SystemMessageCell.m
//  jobSearch
//
//  Created by Leione on 15/3/25.
//  Copyright (c) 2015年 麻辣工作室. All rights reserved.
//

#import "SystemMessageCell.h"

@implementation SystemMessageCell

- (void)awakeFromNib {
    // Initialization code
}

- (CGFloat)getHighWithString:(NSString *)string
{
    //设置 属性字典
    NSDictionary *dic = @{NSFontAttributeName:[UIFont systemFontOfSize:17]};
    
    CGRect rect = [string boundingRectWithSize:CGSizeMake([UIScreen mainScreen].bounds.size.width - 20, 100000000) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:dic context:nil];
    //如果 传入的字符串长度为 0 就返回0
    if ([string length] == 0) {
        return 0;
    }
    return rect.size.height;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
