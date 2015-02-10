//
//  netAPI.m
//  wowilling
//
//  Created by 田原 on 14-3-7.
//  Copyright (c) 2014年 田原. All rights reserved.
//

#import "netAPI.h"
//login&register
#define LOGIN_FUNCTION @"user/userLogin"
#define REGISTER_FUNCTION @"user/userRegister"
//list
#define SAVEJOBLIST_FUNCTION @"userService/queryUserSaveList"
#define NEARBYJOBLIST_FUNCTION @"userService/queryNearestJobs"
#define NEWESTJOBLIST_FUNCTION @"userService/queryNewestJobs"
#define APPLYJOBLIST_FUNCTION @"userService/queryUserApplys"
#define DISTANCEJOBLIST_FUNCTION @"userService/queryJobsByDistance"
#define TYPEJOBLIST_FUNCTION @"userService/queryJobsByJobType"
#define TYPEANDDISJOBLIST_FUNCTION @"userService/queryJobsByDistanceAndJobType"
#define KEYWORDJOBLIST_FUNCTION @"userService/queryJobsByCondition"
#define messageList_FUNCTION @"userService/messageList"
//opration
#define SAVEJOB_FUNCTION @"user/createSaveList"
#define DELETEJOB_FUNCTION @"user/createDeleteList"
#define APPLYJOB_FUNCTION @"user/createJobApply"
#define editUserDetail_FUNCTION @"user/editUserDetail"
#define getUserDetail_FUNCTION @"user/getUserDetail"
#define acceptedInvite_FUNCTION @"userService/acceptedInvite"
#define refusedInvite_FUNCTION @"userService/refusedInvite"

@implementation netAPI
+(void)test{
    //20150208test
//    //ok
//    [netAPI usrRegister:@"18610782215" usrPassword:@"123456" withBlock:^(registerModel *registerModel) {
//        NSLog(@"register info= %@",[registerModel getInfo]);
//        NSLog(@"register id= %@",[registerModel getUsrID]);
//    }];
//    //login ok
//    [netAPI usrLogin:@"18610782216" usrPassword:@"123456" withBlock:^(loginModel *loginModel) {
//        NSLog(@"usrLogin info= %@",[loginModel getInfo]);
//        NSLog(@"usrLogin id = %@",[loginModel getUsrID]);
//    }];
    
//    [netAPI getSaveJobList:@"54d76bd496d9aece6f8b4569" start:1 length:2 withBlock:^(jobListModel *jobListModel) {
//        NSLog(@"getSaveJobList info = %@",[jobListModel getInfo]);
//        NSArray *array = [jobListModel getJobArray];
//        for (jobModel *job in array) {
//            NSLog(@"getSaveJobList id = %@",[job getjobID]);
//        }
//    }];
    
//    [netAPI getNewestJobs:@"54d76bd496d9aece6f8b4569" start:1 length:10 withBlock:^(jobListModel *jobListModel) {
//        NSMutableArray *a = [jobListModel getJobArray];
//        for (jobModel *job in a) {
//            NSLog(@"getNewestJobs title = %@",[job getjobTitle]);
//        }
//    }];
    
    
    
//    //ok
//    [netAPI getNearByJobs:@"54d76bd496d9aece6f8b4569" longtitude:123.45 latitude:45.67 start:1 length:2 withBlock:^(jobListModel *jobListModel) {
//        NSLog(@"getNearByJobs info = %@",[jobListModel getInfo]);
//        NSMutableArray *a = [jobListModel getJobArray];
//        for (jobModel *job in a) {
//            NSLog(@"getNearByJobs jobid = %@",[job getjobID]);
//        }
//    }];
    
    
//    //ok
//    [netAPI getJobByDistance:@"54d76bd496d9aece6f8b4569" longtitude:116.46 latitude:49.92 start:1 length:2 distance:2 withBlock:^(jobListModel *jobListModel) {
//        NSMutableArray *a = [jobListModel getJobArray];
//        for (jobModel *job in a) {
//            NSLog(@"getNearByJobs jobid = %@",[job getjobBeginTime]);
//        }
//    }];
    
    
    
//    NSMutableArray *type1Array = [NSMutableArray arrayWithObjects:[NSNumber numberWithInt:1],[NSNumber numberWithInt:2], nil];
//    [netAPI getJobByJobType:@"54d76bd496d9aece6f8b4569" start:1 length:2 jobType:type1Array withBlock:^(jobListModel *jobListModel) {
//        NSMutableArray *a = [jobListModel getJobArray];
//        for (jobModel *job in a) {
//            NSLog(@"getJobByJobType jobid = %@",[job getjobID]);
//        }
//    }];
    
    //
//    NSMutableArray *type2Array = [NSMutableArray arrayWithObjects:[NSNumber numberWithInt:1], nil];
//    [netAPI getJobByTypeAndDistance:@"54d76bd496d9aece6f8b4569" start:1 length:2 longtitude:116.46 latitude:49.92 distance:2 jobType:type2Array withBlock:^(jobListModel *jobListModel) {
//        NSLog(@"getJobByTypeAndDistance info = %@",[jobListModel getInfo]);
//        NSMutableArray *a = [jobListModel getJobArray];
//        for (jobModel *job in a) {
//            NSLog(@"getJobByTypeAndDistance jobid = %@",[job getjobID]);
//        }
//    }];
    

//    [netAPI getApplyJobs:@"54d76bd496d9aece6f8b4569" start:1 length:2 withBlock:^(jobListModel *jobListModel) {
//        NSLog(@"getApplyJobs info = %@",[jobListModel getInfo]);
//        NSMutableArray *a = [jobListModel getJobArray];
//        for (jobModel *job in a) {
//            NSLog(@"getApplyJobs title = %@",[job getjobTitle]);
//        }
//    }];


//    [netAPI saveTheJob:@"54d76bd496d9aece6f8b4569" jobID:@"54d76bd496d9aece6f8b4570" withBlock:^(oprationResultModel *oprationResultModel) {
//        NSLog(@"saveTheJob info= %@",[oprationResultModel getInfo]);
//        NSLog(@"saveTheJob id= %@",[oprationResultModel getOprationID]);
//    }];
    
//    //修改创建简历 ok
//    userModel *usermodel = [[userModel alloc]init];
//    [usermodel setjob_user_id:@"54d76bd496d9aece6f8b4569"];
//    [usermodel setuserName:@"田原"];
//    [usermodel setuserBirthday:[NSDate date]];
//    [usermodel setuserProvince:@"重庆"];
//    [usermodel setuserCity:@"重庆"];
//    [usermodel setuserDistrict:@"沙坪坝"];
//    [usermodel setuserAddressDetail:@"三峡广场"];
//    [usermodel setuserSchool:@"北邮"];
//    [usermodel setuserDegree:[NSNumber numberWithInt:5]];
//    [usermodel setuserHopeJobType:[NSArray arrayWithObjects:[NSNumber numberWithInt:1], nil]];
//    [usermodel setuserFreeTime:[NSArray arrayWithObjects:[NSNumber numberWithInt:4],[NSNumber numberWithInt:5],[NSNumber numberWithInt:6], nil]];
//    [usermodel setuserHopeSettlement:[NSArray arrayWithObjects:[NSNumber numberWithInt:7],[NSNumber numberWithInt:8],[NSNumber numberWithInt:9], nil]];
//    [usermodel setuserIntroduction:@"哈哈哈"];
//    [usermodel setuserExperience:@"hehehe"];
//    [usermodel setuserPhone:@"18610782215"];
//    [usermodel setuserEmail:@"12@123.com"];
//    [usermodel setuserVideoURL:@"www.www.ww"];
//    [usermodel setImageFileURL:@"www.aaa.aa"];
//    [usermodel setuserLocationGeo:[[geoModel alloc]initWith:111.11 lat:22.22]];
//    NSLog(@"%@",[usermodel getBaseString]);
//    [netAPI editUserDetail:usermodel withBlock:^(userReturnModel *userReturnModel) {
//        NSLog(@"editUserDetail info = %@",[userReturnModel getInfo]);
//    }];
    
//    //获取简历 ok
//    [netAPI getUserDetail:@"54d76bd496d9aece6f8b4569" withBlock:^(userModel *userModel) {
//        NSLog(@"usergeo lon = %f lat = %f",[[userModel getuserLocationGeo]getLon],[[userModel getuserLocationGeo] getLat]);
//    }];
    
//    //精灵 ok
//    [netAPI queryJingLingMatch:@"54d76bd496d9aece6f8b4569" start:1 length:2 withBlock:^(jobListModel *jobListModel) {
//        NSLog(@"getApplyJobs info = %@",[jobListModel getInfo]);
//        NSMutableArray *a = [jobListModel getJobArray];
//        for (jobModel *job in a) {
//            NSLog(@"getApplyJobs title = %@",[job getjobTitle]);
//        }
//    }];
    
//    //接受邀请 ok
//    [netAPI acceptedInvite:@"54d76bd596d9aece6f8b4583" withBlock:^(oprationResultModel *oprationResultModel) {
//        NSLog(@"acceptedInvite info= %@",[oprationResultModel getInfo]);
//        NSLog(@"acceptedInvite id= %@",[oprationResultModel getOprationID]);
//    }];
    
//    //拒绝邀请
//    [netAPI refusedInvite:@"54d76bd596d9aece6f8b4583" withBlock:^(oprationResultModel *oprationResultModel) {
//        NSLog(@"refusedInvite info= %@",[oprationResultModel getInfo]);
//        NSLog(@"refusedInvite id= %@",[oprationResultModel getOprationID]);
//    }];
    
    //消息
    [netAPI getMessageList:@"54d76bd496d9aece6f8b4568" start:1 length:2 withBlock:^(messageListModel *messageListModel) {
        NSLog(@"getMessageList info = %@",[messageListModel getInfo]);
        NSMutableArray *a = [messageListModel getMessageArray];
        for (messageModel *job in a) {
            NSLog(@"getMessageList title = %@",[job getjobTitle]);
            NSLog(@"getMessageList invite_id = %@",[job getinvite_id]);
        }
    }];
}

//用户登录
+(void)usrLogin:(NSString *)name usrPassword:(NSString *)password withBlock:(loginReturnBlock)loginBlock{
    NSString *str = [[NSString alloc]initWithFormat:@"userPhone=%@&userPassword=%@",name,password];
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    [self testAPIPostTestWithBlock:data getFunction:LOGIN_FUNCTION block:^(URLReturnModel *returnModel) {
        if (returnModel != Nil && [returnModel getFlag]) {
            loginModel *a = [[loginModel alloc]initWithData:[returnModel getData]];
            loginBlock(a);
        }else{
            loginModel *a = [[loginModel alloc]initWithError:[NSNumber numberWithInt:STATIS_NO] info:[[returnModel getError] localizedDescription] usrID:[NSString stringWithFormat:@"-1"]];
            loginBlock(a);
        }
        
    }];
}

//用户注册
+(void)usrRegister:(NSString *)name usrPassword:(NSString *)password withBlock:(registerReturnBlock)registerBlock{
    NSString *str = [[NSString alloc]initWithFormat:@"userPhone=%@&userPassword=%@",name,password];
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    [self testAPIPostTestWithBlock:data getFunction:REGISTER_FUNCTION block:^(URLReturnModel *returnModel) {
        if (returnModel != Nil && [returnModel getFlag]) {
            registerModel *a = [[registerModel alloc]initWithData:[returnModel getData]];
            registerBlock(a);
        }else{
            registerModel *a = [[registerModel alloc]initWithError:[NSNumber numberWithInt:STATIS_NO] info:[[returnModel getError] localizedDescription] usrID:[NSString stringWithFormat:@"-1"]];
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
            jobListModel *a = [[jobListModel alloc]initWithError:[NSNumber numberWithInt:STATIS_NO] info:[[returnModel getError] localizedDescription]];
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
            jobListModel *a = [[jobListModel alloc]initWithError:[NSNumber numberWithInt:STATIS_NO] info:[[returnModel getError] localizedDescription]];
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
            jobListModel *a = [[jobListModel alloc]initWithError:[NSNumber numberWithInt:STATIS_NO] info:[[returnModel getError] localizedDescription]];
            newestJobListBlock(a);
        }
    }];
}

//精灵匹配
//用户id，回调block
+(void)queryJingLingMatch:(NSString *)usrID start:(int)start length:(int)length withBlock:(jobListReturnBlock)newestJobListBlock{
    NSString *str = [[NSString alloc]initWithFormat:@"_id=%@&start=%d&length=%d",usrID,start,length];
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    [self testAPIPostTestWithBlock:data getFunction:NEWESTJOBLIST_FUNCTION block:^(URLReturnModel *returnModel) {
        if (returnModel != Nil && [returnModel getFlag]) {
            jobListModel *a = [[jobListModel alloc]initWithData:[returnModel getData]];
            newestJobListBlock(a);
        }else{
            jobListModel *a = [[jobListModel alloc]initWithError:[NSNumber numberWithInt:STATIS_NO] info:[[returnModel getError] localizedDescription]];
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
            jobListModel *a = [[jobListModel alloc]initWithError:[NSNumber numberWithInt:STATIS_NO] info:[[returnModel getError] localizedDescription]];
            bykeyBlock(a);
        }
    }];
}

//申请的兼职信息
+(void)getApplyJobs:(NSString *)usrID start:(int)start length:(int)length withBlock:(jobListReturnBlock)applyJobListBlock{
    NSString *str = [[NSString alloc]initWithFormat:@"_id=%@&start=%d&length=%d",usrID,start,length];
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    [self testAPIPostTestWithBlock:data getFunction:APPLYJOBLIST_FUNCTION block:^(URLReturnModel *returnModel) {
        if (returnModel != Nil && [returnModel getFlag]) {
            jobListModel *a = [[jobListModel alloc]initWithData:[returnModel getData]];
            applyJobListBlock(a);
        }else{
            jobListModel *a = [[jobListModel alloc]initWithError:[NSNumber numberWithInt:STATIS_NO] info:[[returnModel getError] localizedDescription]];
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
            messageListModel *a = [[messageListModel alloc]initWithError:[NSNumber numberWithInt:STATIS_NO] info:[[returnModel getError] localizedDescription]];
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
            oprationResultModel *a = [[oprationResultModel alloc]initWithError:[NSNumber numberWithInt:STATIS_NO] info:[[returnModel getError] localizedDescription]];
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
            jobListModel *a = [[jobListModel alloc]initWithError:[NSNumber numberWithInt:STATIS_NO] info:[[returnModel getError] localizedDescription]];
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
//    [getType appendFormat:@"\""];
    
    NSString *str = [[NSString alloc]initWithFormat:
                     @"_id=%@&start=%d&length=%d&jobType=%@",usrID,start,length,getType];
    NSLog(@"%@",str);
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    [self testAPIPostTestWithBlock:data getFunction:TYPEJOBLIST_FUNCTION block:^(URLReturnModel *returnModel) {
        if (returnModel != Nil && [returnModel getFlag]) {
            jobListModel *a = [[jobListModel alloc]initWithData:[returnModel getData]];
            byTypeBlock(a);
        }else{
            jobListModel *a = [[jobListModel alloc]initWithError:[NSNumber numberWithInt:STATIS_NO] info:[[returnModel getError] localizedDescription]];
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
            jobListModel *a = [[jobListModel alloc]initWithError:[NSNumber numberWithInt:STATIS_NO] info:[[returnModel getError] localizedDescription]];
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
            userReturnModel *a = [[userReturnModel alloc]initWithError:[NSNumber numberWithInt:STATIS_NO] info:[[returnModel getError] localizedDescription] usrID:[NSString stringWithFormat:@"-1"]];
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
            userModel *a = [[userModel alloc]initWithError:[NSNumber numberWithInt:STATIS_NO] info:[[returnModel getError] localizedDescription]];
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
            oprationResultModel *a = [[oprationResultModel alloc]initWithError:[NSNumber numberWithInt:STATIS_NO] info:[[returnModel getError] localizedDescription]];
            oprationReturnBlock(a);
        }
    }];
}

//申请该兼职
//用户id，jobid，回调block
+(void)applyTheJob:(NSString *)usrID jobID:(NSString *)jobID withBlock:(oprationReturnBlock)oprationReturnBlock{
    NSString *str = [[NSString alloc]initWithFormat:@"job_id=%@&job_user_id=%@",jobID,usrID];
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    [self testAPIPostTestWithBlock:data getFunction:APPLYJOB_FUNCTION block:^(URLReturnModel *returnModel) {
        if (returnModel != Nil && [returnModel getFlag]) {
            oprationResultModel *a = [[oprationResultModel alloc]initWithData:[returnModel getData]];
            oprationReturnBlock(a);
        }else{
            oprationResultModel *a = [[oprationResultModel alloc]initWithError:[NSNumber numberWithInt:STATIS_NO] info:[[returnModel getError] localizedDescription]];
            oprationReturnBlock(a);
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
            oprationResultModel *a = [[oprationResultModel alloc]initWithError:[NSNumber numberWithInt:STATIS_NO] info:[[returnModel getError] localizedDescription]];
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
            oprationResultModel *a = [[oprationResultModel alloc]initWithError:[NSNumber numberWithInt:STATIS_NO] info:[[returnModel getError] localizedDescription]];
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
