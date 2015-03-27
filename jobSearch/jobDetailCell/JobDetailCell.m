//
//  JobDetailCell.m
//  jobSearch
//
//  Created by Leione on 15/3/24.
//  Copyright (c) 2015年 麻辣工作室. All rights reserved.
//

#import "JobDetailCell.h"
#import "DateUtil.h"
@implementation JobDetailCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setJobmodel:(jobModel *)jobmodel
{
//    @property (weak, nonatomic) IBOutlet UILabel *longLabel;
    
    self.jobTitle.text=jobmodel.getjobTitle;
    self.addressLabel.text=[NSString stringWithFormat:@"%@%@",jobmodel.getjobWorkPlaceCity,jobmodel.getjobWorkPlaceDistrict];
    self.dateLabel.text=[NSString stringWithFormat:@"起止日期:%@至%@",[self exchangeString:[DateUtil birthdayStringFromDate:jobmodel.getjobBeginTime]],[self exchangeString:[DateUtil birthdayStringFromDate:jobmodel.getjobBeginTime]]];
    
    NSString *distanceStr = nil;
    
    if ([jobModel getDistance:jobmodel.getjobWorkPlaceGeoPoint] < 1000) {
        
        distanceStr = [NSString stringWithFormat:@"%.1fm",[jobModel getDistance:jobmodel.getjobWorkPlaceGeoPoint]];
    }else{
        distanceStr = [NSString stringWithFormat:@"%.1fkm",[jobModel getDistance:jobmodel.getjobWorkPlaceGeoPoint]/1000];
    }
    self.distanceLabel.text=distanceStr;
    
    int num=[jobmodel.getjobRecruitNum intValue]-[jobmodel.getjobHasAccepted intValue];
    if (num<0) {
        num=0;
    }
    
    NSString *settlement;
    NSString *str=[NSString stringWithFormat:@"%@",jobmodel.getjobSettlementWay];
    
    if ([str isEqualToString:@"0"])
        settlement=@"日";
    else if ([str isEqualToString:@"1"])
        settlement=@"周";
    else if ([str isEqualToString:@"2"])
        settlement=@"月";
    else if ([str isEqualToString:@"3"])
        settlement=@"项目";
    
    self.priceLabel.text=[NSString stringWithFormat:@"%@",jobmodel.getjobSalaryRange];
    self.priceLabel.textAlignment = NSTextAlignmentRight;
    self.unitLabel.text = [NSString stringWithFormat:@"元/%@",settlement];
    
    self.peopleLabel.text=[NSString stringWithFormat:@"招募%d人",num];
}

//处理 Date, 转换成3-12格式
- (NSString *)exchangeString:(NSString *)dateString
{
    NSString *purStr = [dateString substringFromIndex:5];
    
    NSInteger tempInter = [[purStr substringToIndex:2] integerValue];
    
    if (tempInter < 10) {
        purStr = [purStr substringFromIndex:1];
    }
    return purStr;
}
@end
