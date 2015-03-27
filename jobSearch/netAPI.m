//
//  netAPI.m
//  wowilling
//
//  Created by 田原 on 14-3-7.
//  Copyright (c) 2014年 田原. All rights reserved.
//

#import "netAPI.h"
#import "MLTextUtils.h"
#import <CommonCrypto/CommonDigest.h>

//login&register
#define LOGIN_FUNCTION @"user/userLogin"
#define REGISTER_FUNCTION @"user/userRegister"
//list
#define SAVEJOBLIST_FUNCTION @"userService/queryUserSaveList"
#define NEARBYJOBLIST_FUNCTION @"userService/queryNearestJobs"
#define NEWESTJOBLIST_FUNCTION @"userService/queryNewestJobs"
#define APPLYJOBLIST_FUNCTION @"userService/queryUserApplys"
#define DISTANCEJOBLIST_FUNCTION @"userService/queryJobsByDistance"
#define WORKINGHOURSJOBLIST_FUNCTION @"userService/queryJobsByWorkingHours"//需要变动,等待后台提供数据
#define CITYJOBLIST_FUNCTION @"userService/queryJobsByCity"//需要变动,等待后台提供数据
#define SALARYJOBLIST_FUNCTION @"userService/queryJobsSalary"//需要变动,等待后台提供数据
#define TYPEJOBLIST_FUNCTION @"userService/queryJobsByJobType"
#define TYPEANDDISJOBLIST_FUNCTION @"userService/queryJobsByDistanceAndJobType"
#define KEYWORDJOBLIST_FUNCTION @"userService/queryJobsByCondition"
#define messageList_FUNCTION @"userService/messageList"
#define JINGLINGMATCH_FUNCTION @"userService/queryJingLingMatch"
//opration
#define SAVEJOB_FUNCTION @"user/createSaveList"
#define DELETEJOB_FUNCTION @"user/createDeleteList"
#define APPLYJOB_FUNCTION @"user/createJobApply"
#define editUserDetail_FUNCTION @"user/editUserDetail"
#define getUserDetail_FUNCTION @"user/getUserDetail"
#define acceptedInvite_FUNCTION @"userService/acceptedInvite"
#define refusedInvite_FUNCTION @"userService/refusedInvite"
#define GETBADGENUM_FUNCTION @"user/userNumIsNotRead"
#define SETREAD_FUNCTION @"user/userIsRead"
#define DELETEAPPLYJOB_FUCTION @"user/deleteOneApply"
#define DELETEMATCHJOB_FUNCTION @"user/addToDeleteList"


@implementation netAPI

//MD5加密
+ (NSString *)md5:(NSString *)str
{
    const char *cStr = [str UTF8String];
    unsigned char result[16];
    CC_MD5(cStr, (CC_LONG)strlen(cStr), result); // This is the md5 call
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
}

//用户登录
+(void)usrLogin:(NSString *)name usrPassword:(NSString *)password withBlock:(loginReturnBlock)loginBlock{
    NSString *str = [[NSString alloc]initWithFormat:@"userPhone=%@&userPassword=%@",name,[netAPI md5:password]];
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    [self testAPIPostTestWithBlock:data getFunction:LOGIN_FUNCTION block:^(URLReturnModel *returnModel) {
        if (returnModel != Nil && [returnModel getFlag]) {
            loginModel *a = [[loginModel alloc]initWithData:[returnModel getData]];
            loginBlock(a);
        }else{
            loginModel *a=[[loginModel alloc]initWithError:[NSNumber numberWithInt:STATIS_NO] info:networkError usrID:nil];
            loginBlock(a);
        }
    }];
}

//重置用户密码
+(void)usrResetPassword:(NSString *)name usrPassword:(NSString *)password withBlock:(oprationReturnBlock)oprationReturnBlock{
    NSString *str = [[NSString alloc]initWithFormat:@"userPhone=%@&userPassword=%@&type=%@",name,[netAPI md5:password],@"1"];
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    [self testAPIPostTestWithBlock:data getFunction:LOGIN_FUNCTION block:^(URLReturnModel *returnModel) {
        if (returnModel != Nil && [returnModel getFlag]) {
            oprationResultModel *a = [[oprationResultModel alloc]initWithData:[returnModel getData]];
            oprationReturnBlock(a);
        }else{
            oprationResultModel *a = [[oprationResultModel alloc]initWithError:[NSNumber numberWithInt:STATIS_NO] info:networkError];
            oprationReturnBlock(a);
        }
    }];
}

//用户注册
+(void)usrRegister:(NSString *)name usrPassword:(NSString *)password withBlock:(registerReturnBlock)registerBlock{
    NSString *str = [[NSString alloc]initWithFormat:@"userPhone=%@&userPassword=%@",name,[netAPI md5:password]];
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    [self testAPIPostTestWithBlock:data getFunction:REGISTER_FUNCTION block:^(URLReturnModel *returnModel) {
        if (returnModel != Nil && [returnModel getFlag]) {
            registerModel *a = [[registerModel alloc]initWithData:[returnModel getData]];
            registerBlock(a);
        }else{
            registerModel *a = [[registerModel alloc]initWithError:[NSNumber numberWithInt:STATIS_NO] info:networkError usrID:[NSString stringWithFormat:@"-1"]];
            registerBlock(a);
        }
    }];
}

//保存的job列表
+(void)getSaveJobList:(NSString *)usrID start:(int)start length:(int)length withBlock:(jobListReturnBlock)saveJobListBlock{
    NSString *str = [[NSString alloc]initWithFormat:@"_id=%@&start=%d&length=%d",usrID,start,length];
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    [self testAPIPostTestWithBlock:data getFunction:SAVEJOBLIST_FUNCTION block:^(URLReturnModel *returnModel) {
        if (returnModel != Nil && [returnModel getFlag]) {
            jobListModel *a = [[jobListModel alloc]initWithData:[returnModel getData]];
            saveJobListBlock(a);
        }else{
            jobListModel *a = [[jobListModel alloc]initWithError:[NSNumber numberWithInt:STATIS_NO] info:networkError];
            saveJobListBlock(a);
        }
    }];
}

//附近的兼职信息
+(void)getNearByJobs:(NSString *)usrID longtitude:(double)longtitude latitude:(double)latitude start:(int)start length:(int)length withBlock:(jobListReturnBlock)nearByBlock{
    NSString *str = [[NSString alloc]initWithFormat:
                     @"_id=%@&start=%d&length=%d&lon=%f&lat=%f",usrID,start,length,longtitude,latitude];
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    [self testAPIPostTestWithBlock:data getFunction:NEARBYJOBLIST_FUNCTION block:^(URLReturnModel *returnModel) {
        if (returnModel != Nil && [returnModel getFlag]) {
            jobListModel *a = [[jobListModel alloc]initWithData:[returnModel getData]];
            nearByBlock(a);
        }else{
            jobListModel *a = [[jobListModel alloc]initWithError:[NSNumber numberWithInt:STATIS_NO] info:networkError];
            nearByBlock(a);
        }
    }];
}

//最新的兼职信息
+(void)getNewestJobs:(NSString *)usrID start:(int)start length:(int)length withBlock:(jobListReturnBlock)newestJobListBlock{
    NSString *str = [[NSString alloc]initWithFormat:@"_id=%@&start=%d&length=%d",usrID,start,length];
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    [self testAPIPostTestWithBlock:data getFunction:NEWESTJOBLIST_FUNCTION block:^(URLReturnModel *returnModel) {
        if (returnModel != Nil && [returnModel getFlag]) {
            jobListModel *a = [[jobListModel alloc]initWithData:[returnModel getData]];
            newestJobListBlock(a);
        }else{
            jobListModel *a = [[jobListModel alloc]initWithError:[NSNumber numberWithInt:STATIS_NO] info:networkError];
            newestJobListBlock(a);
        }
    }];
}

//精灵匹配
//用户id，回调block
+(void)queryJingLingMatch:(NSString *)usrID start:(int)start length:(int)length withBlock:(jobListReturnBlock)newestJobListBlock{
    NSString *str = [[NSString alloc]initWithFormat:@"_id=%@&start=%d&length=%d",usrID,start,length];
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    [self testAPIPostTestWithBlock:data getFunction:JINGLINGMATCH_FUNCTION block:^(URLReturnModel *returnModel) {
        if (returnModel != Nil && [returnModel getFlag]) {
            jobListModel *a = [[jobListModel alloc]initWithData:[returnModel getData]];
            newestJobListBlock(a);
        }else{
            jobListModel *a = [[jobListModel alloc]initWithError:[NSNumber numberWithInt:STATIS_NO] info:networkError];
            newestJobListBlock(a);
        }
    }];
}

//根据关键字
+(void)getJobByKeyWord:(NSString *)usrID start:(int)start length:(int)length keyWord:(NSString *)keyWord withBlock:(jobListReturnBlock)bykeyBlock{
    NSString *str = [[NSString alloc]initWithFormat:@"_id=%@&start=%d&length=%d&keyword=%@",usrID,start,length,keyWord];
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    [self testAPIPostTestWithBlock:data getFunction:KEYWORDJOBLIST_FUNCTION block:^(URLReturnModel *returnModel) {
        if (returnModel != Nil && [returnModel getFlag]) {
            jobListModel *a = [[jobListModel alloc]initWithData:[returnModel getData]];
            bykeyBlock(a);
        }else{
            jobListModel *a = [[jobListModel alloc]initWithError:[NSNumber numberWithInt:STATIS_NO] info:networkError];
            bykeyBlock(a);
        }
    }];
}

//申请的兼职信息
+(void)getApplyJobs:(NSString *)usrID start:(int)start length:(int)length withBlock:(jobAppliedListReturnBlock)applyJobListBlock{
    NSString *str = [[NSString alloc]initWithFormat:@"_id=%@&start=%d&length=%d",usrID,start,length];
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    [self testAPIPostTestWithBlock:data getFunction:APPLYJOBLIST_FUNCTION block:^(URLReturnModel *returnModel) {
        if (returnModel != Nil && [returnModel getFlag]) {
            jobAppliedListModel *a = [[jobAppliedListModel alloc]initWithData:[returnModel getData]];
            applyJobListBlock(a);
        }else{
            jobAppliedListModel *a = [[jobAppliedListModel alloc]initWithError:[NSNumber numberWithInt:STATIS_NO] info:networkError];
            applyJobListBlock(a);
        }
    }];
}

//用户消息列表
+(void)getMessageList:(NSString *)usrID start:(int)start length:(int)length withBlock:(messageListReturnBlock)messageListBlock{
    NSString *str = [[NSString alloc]initWithFormat:@"_id=%@&start=%d&length=%d",usrID,start,length];
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    [self testAPIPostTestWithBlock:data getFunction:messageList_FUNCTION block:^(URLReturnModel *returnModel) {
        if (returnModel != Nil && [returnModel getFlag]) {
            messageListModel *a = [[messageListModel alloc]initWithData:[returnModel getData]];
            messageListBlock(a);
        }else{
            messageListModel *a = [[messageListModel alloc]initWithError:[NSNumber numberWithInt:STATIS_NO] info:networkError];
            messageListBlock(a);
        }
    }];
}

//保存该job到用户save列表
//用户id，jobid，回调block
+(void)saveTheJob:(NSString *)usrID jobID:(NSString *)jobID withBlock:(oprationReturnBlock)oprationReturnBlock{
    NSString *str = [[NSString alloc]initWithFormat:@"job_id=%@&job_user_id=%@",jobID,usrID];
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    [self testAPIPostTestWithBlock:data getFunction:SAVEJOB_FUNCTION block:^(URLReturnModel *returnModel) {
        if (returnModel != Nil && [returnModel getFlag]) {
            oprationResultModel *a = [[oprationResultModel alloc]initWithData:[returnModel getData]];
            oprationReturnBlock(a);
        }else{
            oprationResultModel *a = [[oprationResultModel alloc]initWithError:[NSNumber numberWithInt:STATIS_NO] info:networkError];
            oprationReturnBlock(a);
        }
    }];
}

//根据距离
//lon:经度坐标;lat:纬度坐标;start:起始位置;length:获取长度;distance:距离长度(km);_id:用户唯一标示;回调block;
+(void)getJobByDistance:(NSString *)usrID longtitude:(double)longtitude latitude:(double)latitude start:(int)start length:(int)length distance:(int)distance withBlock:(jobListReturnBlock)distanceBlock{
    NSString *str = [[NSString alloc]initWithFormat:
                     @"_id=%@&start=%d&length=%d&lon=%f&lat=%f&distance=%d",usrID,start,length,longtitude,latitude,distance];
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    [self testAPIPostTestWithBlock:data getFunction:DISTANCEJOBLIST_FUNCTION block:^(URLReturnModel *returnModel) {
        if (returnModel != Nil && [returnModel getFlag]) {
            jobListModel *a = [[jobListModel alloc]initWithData:[returnModel getData]];
            distanceBlock(a);
        }else{
            jobListModel *a = [[jobListModel alloc]initWithError:[NSNumber numberWithInt:STATIS_NO] info:networkError];
            distanceBlock(a);
        }
    }];
}


//根据工作时间
//start:起始位置;length:获取长度;workingHours:工作时间,不能为空;
+(void)getJobByWorkingHours:(NSString *)usrID longtitude:(double)longtitude latitude:(double)latitude start:(int)start length:(int)length  workingHours:(NSString *)workingHours withBlock:(jobListReturnBlock)distanceBlock
{
    NSString *str = [[NSString alloc]initWithFormat:
                     @"_id=%@&start=%d&length=%d&lon=%f&lat=%f&workingHours=%@",usrID,start,length,longtitude,latitude,workingHours];
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    
    [self testAPIPostTestWithBlock:data getFunction:WORKINGHOURSJOBLIST_FUNCTION block:^(URLReturnModel *returnModel) {
        if (returnModel != Nil && [returnModel getFlag]) {
            jobListModel *a = [[jobListModel alloc]initWithData:[returnModel getData]];
            distanceBlock(a);
        }else{
            jobListModel *a = [[jobListModel alloc]initWithError:[NSNumber numberWithInt:STATIS_NO] info:networkError];
            distanceBlock(a);
        }
    }];
}

//根据薪资
+(void)getJobBySalary:(NSString *)usrID longtitude:(double)longtitude latitude:(double)latitude start:(int)start length:(int)length  Salary:(int)salary withBlock:(jobListReturnBlock)distanceBlock
{
    NSString *str = [[NSString alloc]initWithFormat:
                     @"_id=%@&start=%d&length=%d&lon=%f&lat=%f&salary=%d",usrID,start,length,longtitude,latitude,salary];
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    
    [self testAPIPostTestWithBlock:data getFunction:SALARYJOBLIST_FUNCTION block:^(URLReturnModel *returnModel) {
        if (returnModel != Nil && [returnModel getFlag]) {
            jobListModel *a = [[jobListModel alloc]initWithData:[returnModel getData]];
            distanceBlock(a);
        }else{
            jobListModel *a = [[jobListModel alloc]initWithError:[NSNumber numberWithInt:STATIS_NO] info:networkError];
            distanceBlock(a);
        }
    }];
    
}

//根据城市
+(void)getJobByCity:(NSString *)usrID longtitude:(double)longtitude latitude:(double)latitude start:(int)start length:(int)length  City:(NSString *)city withBlock:(jobListReturnBlock)distanceBlock
{
    NSString *str = [[NSString alloc]initWithFormat:
                     @"_id=%@&start=%d&length=%d&lon=%f&lat=%f&city=%@",usrID,start,length,longtitude,latitude,city];
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    
    [self testAPIPostTestWithBlock:data getFunction:city block:^(URLReturnModel *returnModel) {
        if (returnModel != Nil && [returnModel getFlag]) {
            jobListModel *a = [[jobListModel alloc]initWithData:[returnModel getData]];
            distanceBlock(a);
        }else{
            jobListModel *a = [[jobListModel alloc]initWithError:[NSNumber numberWithInt:STATIS_NO] info:networkError];
            distanceBlock(a);
        }
    }];
}
//根据工作类型
//start:起始位置;length:获取长度;typeArray:如[1,2,3];回调block;
+(void)getJobByJobType:(NSString *)usrID start:(int)start length:(int)length jobType:(NSMutableArray *)typeArray withBlock:(jobListReturnBlock)byTypeBlock{
    NSMutableString *getType = [[NSMutableString alloc]initWithFormat:@""];
    for (int index = 0; index < [typeArray count] ; index++ ) {
        NSNumber *number = [typeArray objectAtIndex:index];
        [getType appendFormat:@"%d",number.intValue];
        if (index != ([typeArray count] -1)) {
            [getType appendFormat:@","];
        }
    }
    
    NSString *str = [[NSString alloc]initWithFormat:
                     @"_id=%@&start=%d&length=%d&jobType=%@",usrID,start,length,getType];
    NSLog(@"%@",str);
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    [self testAPIPostTestWithBlock:data getFunction:TYPEJOBLIST_FUNCTION block:^(URLReturnModel *returnModel) {
        if (returnModel != Nil && [returnModel getFlag]) {
            jobListModel *a = [[jobListModel alloc]initWithData:[returnModel getData]];
            byTypeBlock(a);
        }else{
            jobListModel *a = [[jobListModel alloc]initWithError:[NSNumber numberWithInt:STATIS_NO] info:networkError];
            byTypeBlock(a);
        }
    }];
}

//根据工作类型与距离
//lon:经度坐标;lat:纬度坐标;distance:距离长度(km);start:起始位置;length:获取长度;typeArray:如[1,2,3]m,不为空，nsnumber类型;回调block;
+(void)getJobByTypeAndDistance:(NSString *)usrID start:(int)start length:(int)length longtitude:(double)longtitude latitude:(double)latitude distance:(int)distance jobType:(NSMutableArray *)typeArray withBlock:(jobListReturnBlock)byTypeAndDisBlock{
    NSMutableString *getType = [[NSMutableString alloc]initWithFormat:@""];
    for (int index = 0; index < [typeArray count] ; index++ ) {
        NSNumber *number = [typeArray objectAtIndex:index];
        [getType appendFormat:@"%d",number.intValue];
        if (index != ([typeArray count] -1)) {
            [getType appendFormat:@","];
        }
    }
    //    [getType appendFormat:@""];
    
    NSString *str = [[NSString alloc]initWithFormat:
                     @"_id=%@&start=%d&length=%d&jobType=%@&lon=%f&lat=%f&distance=%d",usrID,start,length,getType,longtitude,latitude,distance];
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    [self testAPIPostTestWithBlock:data getFunction:TYPEANDDISJOBLIST_FUNCTION block:^(URLReturnModel *returnModel) {
        if (returnModel != Nil && [returnModel getFlag]) {
            jobListModel *a = [[jobListModel alloc]initWithData:[returnModel getData]];
            byTypeAndDisBlock(a);
        }else{
            jobListModel *a = [[jobListModel alloc]initWithError:[NSNumber numberWithInt:STATIS_NO] info:networkError];
            byTypeAndDisBlock(a);
        }
    }];
}

//编辑用户简历
+(void)editUserDetail:(userModel *)usr withBlock:(userReturnBlock)userReturnBlock{
    NSData *data = [[usr getBaseString] dataUsingEncoding:NSUTF8StringEncoding];
    [self testAPIPostTestWithBlock:data getFunction:editUserDetail_FUNCTION block:^(URLReturnModel *returnModel) {
        if (returnModel != Nil && [returnModel getFlag]) {
            userReturnModel *a = [[userReturnModel alloc]initWithData:[returnModel getData]];
            userReturnBlock(a);
        }else{
            userReturnModel *a = [[userReturnModel alloc]initWithError:[NSNumber numberWithInt:STATIS_NO] info:networkError usrID:[NSString stringWithFormat:@"-1"]];
            userReturnBlock(a);
        }
    }];
}

//获取用户简历
+(void)getUserDetail:(NSString *)usrid withBlock:(userBlock)userBlock{
    NSString *str = [[NSString alloc]initWithFormat:@"job_user_id=%@",usrid];
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    [self testAPIPostTestWithBlock:data getFunction:getUserDetail_FUNCTION block:^(URLReturnModel *returnModel) {
        if (returnModel != Nil && [returnModel getFlag]) {
            userModel *a = [[userModel alloc]initWithData:[returnModel getData]];
            userBlock(a);
        }else{
            userModel *a = [[userModel alloc]initWithError:[NSNumber numberWithInt:STATIS_NO] info:networkError];
            userBlock(a);
        }
    }];
}

//从save列表删除该job
//用户id，jobid，回调block
+(void)deleteTheJob:(NSString *)usrID jobID:(NSString *)jobID withBlock:(oprationReturnBlock)oprationReturnBlock{
    NSString *str = [[NSString alloc]initWithFormat:@"job_id=%@&job_user_id=%@",jobID,usrID];
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    [self testAPIPostTestWithBlock:data getFunction:DELETEJOB_FUNCTION block:^(URLReturnModel *returnModel) {
        if (returnModel != Nil && [returnModel getFlag]) {
            oprationResultModel *a = [[oprationResultModel alloc]initWithData:[returnModel getData]];
            oprationReturnBlock(a);
        }else{
            oprationResultModel *a = [[oprationResultModel alloc]initWithError:[NSNumber numberWithInt:STATIS_NO] info:networkError];
            oprationReturnBlock(a);
        }
    }];
}

//申请该兼职
//用户id，jobid，回调block
+(void)applyTheJob:(NSString *)usrID jobID:(NSString *)jobID withBlock:(jobApplyReturnBlock)applyReturnBlock{
    NSString *str = [[NSString alloc]initWithFormat:@"job_id=%@&job_user_id=%@",jobID,usrID];
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    [self testAPIPostTestWithBlock:data getFunction:APPLYJOB_FUNCTION block:^(URLReturnModel *returnModel) {
        if (returnModel != Nil && [returnModel getFlag]) {
            jobApplyModel *a = [[jobApplyModel alloc]initWithData:[returnModel getData]];
            applyReturnBlock(a);
        }else{
            jobApplyModel *a = [[jobApplyModel alloc]initWithError:[NSNumber numberWithInt:STATIS_NO] info:networkError];
            applyReturnBlock(a);
        }
    }];
}

//接受企业邀请
+(void)acceptedInvite:(NSString *)invite_id withBlock:(oprationReturnBlock)oprationReturnBlock{
    NSString *str = [[NSString alloc]initWithFormat:@"invite_id=%@",invite_id];
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    [self testAPIPostTestWithBlock:data getFunction:acceptedInvite_FUNCTION block:^(URLReturnModel *returnModel) {
        if (returnModel != Nil && [returnModel getFlag]) {
            oprationResultModel *a = [[oprationResultModel alloc]initWithData:[returnModel getData]];
            oprationReturnBlock(a);
        }else{
            oprationResultModel *a = [[oprationResultModel alloc]initWithError:[NSNumber numberWithInt:STATIS_NO] info:networkError];
            oprationReturnBlock(a);
        }
    }];
}

//拒绝企业邀请
+(void)refusedInvite:(NSString *)invite_id withBlock:(oprationReturnBlock)oprationReturnBlock{
    NSString *str = [[NSString alloc]initWithFormat:@"invite_id=%@",invite_id];
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    [self testAPIPostTestWithBlock:data getFunction:refusedInvite_FUNCTION block:^(URLReturnModel *returnModel) {
        if (returnModel != Nil && [returnModel getFlag]) {
            oprationResultModel *a = [[oprationResultModel alloc]initWithData:[returnModel getData]];
            oprationReturnBlock(a);
        }else{
            oprationResultModel *a = [[oprationResultModel alloc]initWithError:[NSNumber numberWithInt:STATIS_NO] info:networkError];
            oprationReturnBlock(a);
        }
    }];
}

//获取未读消息数
+(void)getNotReadMessageNum:(NSString*)userId withBlock:(badgeBlock)badgeReturnBlock{
    NSString *str = [[NSString alloc]initWithFormat:@"job_user_id=%@",userId];
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    [self testAPIPostTestWithBlock:data getFunction:GETBADGENUM_FUNCTION block:^(URLReturnModel *returnModel) {
        
        if (returnModel != Nil && [returnModel getFlag]) {
            badgeModel *a = [[badgeModel alloc]initWithData:[returnModel getData]];
            badgeReturnBlock(a);
        }else{
            badgeModel *a =[[badgeModel alloc]initWithError:[NSNumber numberWithInt:STATIS_NO] info:networkError];
            badgeReturnBlock(a);
        }
    }];
}

//标记未读消息为已读
+(void)setRecordAlreadyRead:(NSString*)userId applyOrInviteId:(NSString*)applyOrInviteId type:(NSString*)type withBlock:(oprationReturnBlock)oprationReturnBlock{
    
    NSString *str = [[NSString alloc]initWithFormat:@"job_user_id=%@&applyOrInviteId=%@&type=%@",userId,applyOrInviteId,type];
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    [self testAPIPostTestWithBlock:data getFunction:SETREAD_FUNCTION block:^(URLReturnModel *returnModel) {
        if (returnModel != Nil && [returnModel getFlag]) {
            oprationResultModel *a = [[oprationResultModel alloc]initWithData:[returnModel getData]];
            oprationReturnBlock(a);
        }else{
            oprationResultModel *a = [[oprationResultModel alloc]initWithError:[NSNumber numberWithInt:STATIS_NO] info:networkError];
            oprationReturnBlock(a);
        }
    }];
}

//删除我的申请
+(void)deleteMyAppliedJob:(NSString*)usrID applyId:(NSString*)applyId withBlock:(oprationReturnBlock)oprationReturnBlock{
    
    NSString *str = [[NSString alloc]initWithFormat:@"apply_id=%@&job_user_id=%@",applyId,usrID];
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    [self testAPIPostTestWithBlock:data getFunction:DELETEAPPLYJOB_FUCTION block:^(URLReturnModel *returnModel) {
        if (returnModel != Nil && [returnModel getFlag]) {
            oprationResultModel *a = [[oprationResultModel alloc]initWithData:[returnModel getData]];
            oprationReturnBlock(a);
        }else{
            oprationResultModel *a = [[oprationResultModel alloc]initWithError:[NSNumber numberWithInt:STATIS_NO] info:networkError];
            oprationReturnBlock(a);
        }
    }];
}

//删除匹配职位
+(void)deleteMatchJob:(NSString*)jobId userId:(NSString*)userId withBlock:(oprationReturnBlock)oprationReturnBlock{
    
    NSString *str = [[NSString alloc]initWithFormat:@"job_id=%@&job_user_id=%@",jobId,userId];
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    [self testAPIPostTestWithBlock:data getFunction:DELETEMATCHJOB_FUNCTION block:^(URLReturnModel *returnModel) {
        if (returnModel != Nil && [returnModel getFlag]) {
            oprationResultModel *a = [[oprationResultModel alloc]initWithData:[returnModel getData]];
            oprationReturnBlock(a);
        }else{
            oprationResultModel *a = [[oprationResultModel alloc]initWithError:[NSNumber numberWithInt:STATIS_NO] info:networkError];
            oprationReturnBlock(a);
        }
    }];
    
}

#pragma base API
//Testget
+(void)testAPIGetTest:(id)target action:(SEL)theAction getInfo:(NSData *)getInfo{
    [self baseAPI:target action:theAction info:getInfo function:@"getTest" isPost:false];
}
//Testpost
+(void)testAPIPostTest:(id)target action:(SEL)theAction postInfo:(NSData *)getInfo{
    [self baseAPI:target action:theAction info:getInfo function:@"postTest" isPost:true];
}

//http://182.92.177.56:3000/getTest
+(void)testAPIGetTestWithBlock:(NSData *)getInfo getFunction:(NSString *)function block:(returnBlock)block{
    @try {
        URLOperationWithBlock *operation = [[URLOperationWithBlock alloc]initWithURL:getInfo serveceFunction:function returnblock:block isPost:FALSE];
        [operation setQueuePriority:NSOperationQueuePriorityHigh];
        [[baseAPP getBaseNSOperationQueue] addOperation:operation];
    }
    @catch (NSException *exception) {
        
    }
}

//http://182.92.177.56:3000/postTest
+(void)testAPIPostTestWithBlock:(NSData *)postInfo getFunction:(NSString *)function block:(returnBlock)block{
    @try {
        URLOperationWithBlock *operation = [[URLOperationWithBlock alloc]initWithURL:postInfo serveceFunction:function returnblock:block isPost:TRUE];
        [operation setQueuePriority:NSOperationQueuePriorityHigh];
        [[baseAPP getBaseNSOperationQueue] addOperation:operation];
    }
    @catch (NSException *exception) {
        
    }
}


//baseAPI
+(void)baseAPI:(id)target action:(SEL)theAction info:(NSData *)info function:(NSString *)function isPost:(BOOL)isPost{
    @try {
        URLOperation *operation = [[URLOperation alloc]initWithURL:info serveceFunction:function target:target action:theAction isPost:isPost];
        [operation setQueuePriority:NSOperationQueuePriorityNormal];
        [[baseAPP getBaseNSOperationQueue] addOperation:operation];
    }
    @catch (NSException *exception) {
        
    }
}
@end
