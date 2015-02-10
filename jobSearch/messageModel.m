//
//  messageModel.m
//  jobSearch
//
//  Created by 田原 on 15/2/9.
//  Copyright (c) 2015年 麻辣工作室. All rights reserved.
//

#import "messageModel.h"

@implementation messageModel
-(messageModel *)initWithDictionary:(NSDictionary *)initDictionary{
    self = [super init];
    NSString *tempstring = Nil;
    if (self) {
        
        //        tempstring = [initDictionary objectForKey:messageModel_jobBirthdayMonthYear];
        //        jobBirthdayMonthYear = [DateUtil dateFromString:tempstring];
        
        tempstring = [initDictionary objectForKey:messageModel_jobBeginTime];
        jobBeginTime = [DateUtil dateFromString:tempstring];
        
        tempstring = [initDictionary objectForKey:messageModel_jobEndTime];
        jobEndTime = [DateUtil dateFromString:tempstring];
        
        jobId = [initDictionary objectForKey:messageModel_jobID];
        jobWorkTime = [initDictionary objectForKey:messageModel_jobWorkTime];
        jobWorkPlaceGeoPoint = [initDictionary objectForKey:messageModel_jobWorkPlaceGeoPoint];
        jobWorkPlaceProvince = [initDictionary objectForKey:messageModel_jobWorkPlaceProvince];
        jobWorkPlaceCity = [initDictionary objectForKey:messageModel_jobWorkPlaceCity];
        jobWorkPlaceDistrict = [initDictionary objectForKey:messageModel_jobWorkPlaceDistrict];
        jobWorkAddressDetail = [initDictionary objectForKey:messageModel_jobWorkAddressDetail];
        jobTitle = [initDictionary objectForKey:messageModel_jobTitle];
        jobRecruitNum = [initDictionary objectForKey:messageModel_jobRecruitNum];
        jobType = [initDictionary objectForKey:messageModel_jobType];
        jobSalaryRange = [initDictionary objectForKey:messageModel_jobSalaryRange];
        jobSettlementWay = [initDictionary objectForKey:messageModel_jobSettlementWay];
        jobIntroduction = [initDictionary objectForKey:messageModel_jobIntroduction];
        jobAgeStartReq = [initDictionary objectForKey:messageModel_jobAgeStartReq];
        jobAgeEndReq = [initDictionary objectForKey:messageModel_jobAgeEndReq];
        jobHeightStartReq = [initDictionary objectForKey:messageModel_jobHeightStartReq];
        jobHeightEndReq = [initDictionary objectForKey:messageModel_jobHeightEndReq];
        jobEnterpriseName = [initDictionary objectForKey:messageModel_jobEnterpriseName];
        jobEnterpriseIndustry = [initDictionary objectForKey:messageModel_jobEnterpriseIndustry];
        jobEnterpriseAddress = [initDictionary objectForKey:messageModel_jobEnterpriseAddress];
        jobEnterpriseIntroduction = [initDictionary objectForKey:messageModel_jobEnterpriseIntroduction];
        jobDegreeReq = [initDictionary objectForKey:messageModel_jobDegreeReq];
        jobPhone = [initDictionary objectForKey:messageModel_jobPhone];
        jobHasAccepted=[initDictionary objectForKey:messageModel_jobHasAccepted];
        jobHasRejected=[initDictionary objectForKey:messageModel_jobHasRejected];
        //        jobEmail = [initDictionary objectForKey:messageModel_jobEmail];
        jobGenderReq=[initDictionary objectForKey:messageModel_jobGenderReq];
        tempstring = [initDictionary objectForKey:messageModel_created_at];
        created_at = [DateUtil dateFromString:tempstring];
        
        jobContactName = [initDictionary objectForKey:messageModel_jobContactName];
        jobEnterpriseImageURL = [initDictionary objectForKey:messageModel_jobEnterpriseImageURL];
        jobEnterpriseLogoURL = [initDictionary objectForKey:messageModel_jobEnterpriseLogoURL];
        
        tempstring = [initDictionary objectForKey:messageModel_updated_at];
        updated_at = [DateUtil dateFromString:tempstring];
        
        invite_id = [initDictionary objectForKey:messageModel_invite_id];
        inviteStatus = [initDictionary objectForKey:messageModel_inviteStatus];
        
        
    }
    return self;
}
//-(NSDate *)getjobBirthdayMonthYear{
//    return jobBirthdayMonthYear;
//}
-(NSDate *)getjobBeginTime{
    return jobBeginTime;
}
-(NSDate *)getjobEndTime{
    return jobEndTime;
}
-(NSDate *)getcreated_at{
    return created_at;
}
-(NSArray *)getjobWorkTime{
    return jobWorkTime;
}
-(NSArray *)getjobWorkPlaceGeoPoint{
    return jobWorkPlaceGeoPoint;
}
-(NSArray *)getjobType{
    return jobType;
}
-(NSNumber *)getjobRecruitNum{
    return jobRecruitNum;
}
-(NSNumber *)getjobSalaryRange{
    return jobSalaryRange;
}
-(NSString *)getjobWorkPlaceProvince{
    return jobWorkPlaceProvince;
}
-(NSString *)getjobWorkPlaceCity{
    return jobWorkPlaceCity;
}
-(NSString *)getjobWorkPlaceDistrict{
    return jobWorkPlaceDistrict;
}
-(NSString *)getjobWorkAddressDetail{
    return jobWorkAddressDetail;
}
-(NSString *)getjobTitle{
    return jobTitle;
}
-(NSString *)getjobSettlementWay{
    return jobSettlementWay;
}
-(NSString *)getjobIntroduction{
    return jobIntroduction;
}
-(NSString *)getjobAgeStartReq{
    return jobAgeStartReq;
}
-(NSString *)getjobAgeEndReq{
    return jobAgeEndReq;
}
-(NSString *)getjobHeightStartReq{
    return jobHeightStartReq;
}
-(NSString *)getjobHeightEndReq{
    return jobHeightEndReq;
}
-(NSString *)getjobEnterpriseName{
    return jobEnterpriseName;
}
-(NSString *)getjobEnterpriseIndustry{
    return jobEnterpriseIndustry;
}
-(NSString *)getjobEnterpriseAddress{
    return jobEnterpriseAddress;
}
-(NSString *)getjobEnterpriseIntroduction{
    return jobEnterpriseIntroduction;
}
-(NSString *)getjobDegreeReq{
    return jobDegreeReq;
}
-(NSString *)getjobPhone{
    return jobPhone;
}
//-(NSString *)getjobEmail{
//    return jobEmail;
//}
-(NSString *)getjobID{
    return jobId;
}
-(NSString *)getjobContactName{
    return jobContactName;
}
-(NSString *)getjobEnterpriseImageURL{
    return jobEnterpriseImageURL;
}
-(NSString *)getjobEnterpriseLogoURL{
    return jobEnterpriseLogoURL;
}
-(NSDate *)getupdated_at{
    return updated_at;
}
-(NSNumber*)getjobHasAccepted{
    return jobHasAccepted;
}
-(NSNumber*)getjobHasRejected{
    return jobHasRejected;
}

- (NSString*)getjobGenderReq{
    return jobGenderReq;
}

-(NSString *)getinvite_id{
    return invite_id;
}
-(NSNumber *)getinviteStatus{
    return inviteStatus;
}
@end
