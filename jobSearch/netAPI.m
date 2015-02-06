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
//opration
#define SAVEJOB_FUNCTION @"user/createSaveList"
#define DELETEJOB_FUNCTION @"user/createDeleteList"
#define APPLYJOB_FUNCTION @"user/createJobApply"

@implementation netAPI
+(void)test{
//    //ok
//    [netAPI getNearByJobs:@"54ceddc6910d78bb68004293" longtitude:116.46 latitude:49.92 start:1 length:2 withBlock:^(nearByJobListModel *nearByJobListModel) {
//        NSMutableArray *a = [nearByJobListModel getnearByJobListArray];
//        for (jobModel *job in a) {
//            NSLog(@"getNearByJobs jobid = %@",[job getjobBeginTime]);
//        }
//    }];
//    //ok
//    [netAPI getJobByDistance:@"54ceddc6910d78bb68004293" longtitude:116.46 latitude:49.92 start:1 length:2 distance:2 withBlock:^(jobListModel *jobListModel) {
//        NSMutableArray *a = [jobListModel getJobArray];
//        for (jobModel *job in a) {
//            NSLog(@"getNearByJobs jobid = %@",[job getjobBeginTime]);
//        }
//    }];
    
    
    //
    NSMutableArray *type1Array = [NSMutableArray arrayWithObjects:[NSNumber numberWithInt:1],[NSNumber numberWithInt:2], nil];
    [netAPI getJobByJobType:@"54ceddc6910d78bb68004293" start:1 length:2 jobType:type1Array withBlock:^(jobListModel *jobListModel) {
        NSMutableArray *a = [jobListModel getJobArray];
        for (jobModel *job in a) {
            NSLog(@"getNearByJobs jobid = %@",[job getjobID]);
        }
    }];
    
    //
//    NSMutableArray *type2Array = [NSMutableArray arrayWithObjects:[NSNumber numberWithInt:1], nil];
//    [netAPI getJobByTypeAndDistance:@"54ceddc6910d78bb68004293" start:1 length:2 longtitude:116.46 latitude:49.92 distance:2 jobType:type2Array withBlock:^(jobListModel *jobListModel) {
//        NSMutableArray *a = [jobListModel getJobArray];
//        for (jobModel *job in a) {
//            NSLog(@"getNearByJobs jobid = %@",[job getjobID]);
//        }
//    }];
    
    
//    [netAPI getNewestJobs:@"54cdee5b3ed1ccf5358b458a" withBlock:^(newestJobListModel *newestJobListModel) {
//        NSMutableArray *a = [newestJobListModel getnewestJobListArray];
//        for (newestJobModel *job in a) {
//            NSLog(@"getNewestJobs title = %@",[job getjobTitle]);
//        }
//    }];
//    [netAPI getApplyJobs:@"54cdee5b3ed1ccf5358b458a" withBlock:^(applyJobListModel *applyJobListModel) {
//        NSMutableArray *a = [applyJobListModel getapplyJobListArray];
//        for (applyJobModel *job in a) {
//            NSLog(@"getApplyJobs title = %@",[job getjobTitle]);
//        }
//    }];
//    [netAPI usrRegister:@"18610782216" usrPassword:@"123456" withBlock:^(registerModel *registerModel) {
//        NSLog(@"register info= %@",[registerModel getInfo]);
//        NSLog(@"register id= %@",[registerModel getUsrID]);
//    }];
//    [netAPI saveTheJob:@"54cdfe873ed1ccf5358b45d3" jobID:@"54cdee5b3ed1ccf5358b458a" withBlock:^(oprationResultModel *oprationResultModel) {
//        NSLog(@"saveTheJob info= %@",[oprationResultModel getInfo]);
//        NSLog(@"saveTheJob id= %@",[oprationResultModel getOprationID]);
//    }];
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
    NSMutableString *getType = [[NSMutableString alloc]initWithFormat:@"\""];
    for (int index = 0; index < [typeArray count] ; index++ ) {
        NSNumber *number = [typeArray objectAtIndex:index];
        [getType appendFormat:@"%d",number.intValue];
        if (index != ([typeArray count] -1)) {
            [getType appendFormat:@","];
        }
    }
    [getType appendFormat:@"\""];
    
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
    NSMutableString *getType = [[NSMutableString alloc]initWithFormat:@"\""];
    for (int index = 0; index < [typeArray count] ; index++ ) {
        NSNumber *number = [typeArray objectAtIndex:index];
        [getType appendFormat:@"%d",number.intValue];
        if (index != ([typeArray count] -1)) {
            [getType appendFormat:@","];
        }
    }
    [getType appendFormat:@"\""];
    
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
        [operation setQueuePriority:NSOperationQueuePriorityHigh];
        [[baseAPP getBaseNSOperationQueue] addOperation:operation];
    }
    @catch (NSException *exception) {
        
    }
}
@end
