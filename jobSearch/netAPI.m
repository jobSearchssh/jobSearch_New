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
//opration
#define SAVEJOB_FUNCTION @"user/createSaveList"
#define DELETEJOB_FUNCTION @"user/createDeleteList"
#define APPLYJOB_FUNCTION @"user/createJobApply"

@implementation netAPI
+(void)test{
    [netAPI getNearByJobs:116.46 latitude:49.92 withBlock:^(nearByJobListModel *nearByJobListModel) {
        NSMutableArray *a = [nearByJobListModel getnearByJobListArray];
        for (nearByJobModel *job in a) {
            NSLog(@"%@",[job getjobID]);
        }
    }];
    [netAPI getNewestJobs:@"54cdee5b3ed1ccf5358b458a" withBlock:^(newestJobListModel *newestJobListModel) {
        NSMutableArray *a = [newestJobListModel getnewestJobListArray];
        for (newestJobModel *job in a) {
            NSLog(@"%@",[job getjobTitle]);
        }
    }];
    [netAPI getApplyJobs:@"54cdee5b3ed1ccf5358b458a" withBlock:^(applyJobListModel *applyJobListModel) {
        NSMutableArray *a = [applyJobListModel getapplyJobListArray];
        for (applyJobModel *job in a) {
            NSLog(@"%@",[job getjobTitle]);
        }
    }];
    [netAPI usrRegister:@"18610782216" usrPassword:@"123456" withBlock:^(registerModel *registerModel) {
        NSLog(@"register status= %@",[registerModel getInfo]);
        NSLog(@"register id= %@",[registerModel getUsrID]);
    }];
    [netAPI saveTheJob:@"54cdfe873ed1ccf5358b45d3" jobID:@"54cdee5b3ed1ccf5358b458a" withBlock:^(oprationResultModel *oprationResultModel) {
        NSLog(@"register status= %@",[oprationResultModel getInfo]);
        NSLog(@"register id= %@",[oprationResultModel getOprationID]);
    }];
}

//用户登录
+(void)usrLogin:(NSString *)name usrPassword:(NSString *)password withBlock:(loginReturnBlock)loginBlock{
    NSString *str = [[NSString alloc]initWithFormat:@"userPhone=%@&userPassword=%@",name,password];
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    [self testAPIPostTestWithBlock:data getFunction:LOGIN_FUNCTION block:^(URLReturnModel *returnModel) {
        if ([returnModel getFlag]) {
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
        if ([returnModel getFlag]) {
            registerModel *a = [[registerModel alloc]initWithData:[returnModel getData]];
            registerBlock(a);
        }else{
            registerModel *a = [[registerModel alloc]initWithError:[NSNumber numberWithInt:STATIS_NO] info:[[returnModel getError] localizedDescription] usrID:[NSString stringWithFormat:@"-1"]];
            registerBlock(a);
        }
    }];
}

//保存的job列表
+(void)getSaveJobList:(NSString *)usrID withBlock:(saveJobListReturnBlock)saveJobListBlock{
    NSString *str = [[NSString alloc]initWithFormat:@"_id=%@",usrID];
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    [self testAPIPostTestWithBlock:data getFunction:SAVEJOBLIST_FUNCTION block:^(URLReturnModel *returnModel) {
        if ([returnModel getFlag]) {
            saveJobListModel *a = [[saveJobListModel alloc]initWithData:[returnModel getData]];
            saveJobListBlock(a);
        }else{
            saveJobListModel *a = [[saveJobListModel alloc]initWithError:[NSNumber numberWithInt:STATIS_NO] info:[[returnModel getError] localizedDescription]];
            saveJobListBlock(a);
        }
    }];
}

//附近的兼职信息
+(void)getNearByJobs:(double)longtitude latitude:(double)latitude withBlock:(nearByJobReturnBlock)nearByBlock{
    NSString *str = [[NSString alloc]initWithFormat:@"lon=%f&lat=%f",longtitude,latitude];
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    [self testAPIPostTestWithBlock:data getFunction:NEARBYJOBLIST_FUNCTION block:^(URLReturnModel *returnModel) {
        if ([returnModel getFlag]) {
            nearByJobListModel *a = [[nearByJobListModel alloc]initWithData:[returnModel getData]];
            nearByBlock(a);
        }else{
            nearByJobListModel *a = [[nearByJobListModel alloc]initWithError:[NSNumber numberWithInt:STATIS_NO] info:[[returnModel getError] localizedDescription]];
            nearByBlock(a);
        }
    }];
}

//最新的兼职信息
+(void)getNewestJobs:(NSString *)usrID withBlock:(newestJobReturnBlock)newestJobListBlock{
    NSString *str = [[NSString alloc]initWithFormat:@"_id=%@",usrID];
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    [self testAPIPostTestWithBlock:data getFunction:NEWESTJOBLIST_FUNCTION block:^(URLReturnModel *returnModel) {
        if ([returnModel getFlag]) {
            newestJobListModel *a = [[newestJobListModel alloc]initWithData:[returnModel getData]];
            newestJobListBlock(a);
        }else{
            newestJobListModel *a = [[newestJobListModel alloc]initWithError:[NSNumber numberWithInt:STATIS_NO] info:[[returnModel getError] localizedDescription]];
            newestJobListBlock(a);
        }
    }];
}

//申请的兼职信息
+(void)getApplyJobs:(NSString *)usrID withBlock:(applyJobReturnBlock)applyJobListBlock{
    NSString *str = [[NSString alloc]initWithFormat:@"_id=%@",usrID];
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    [self testAPIPostTestWithBlock:data getFunction:APPLYJOBLIST_FUNCTION block:^(URLReturnModel *returnModel) {
        if ([returnModel getFlag]) {
            applyJobListModel *a = [[applyJobListModel alloc]initWithData:[returnModel getData]];
            applyJobListBlock(a);
        }else{
            applyJobListModel *a = [[applyJobListModel alloc]initWithError:[NSNumber numberWithInt:STATIS_NO] info:[[returnModel getError] localizedDescription]];
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
        if ([returnModel getFlag]) {
            oprationResultModel *a = [[oprationResultModel alloc]initWithData:[returnModel getData]];
            oprationReturnBlock(a);
        }else{
            oprationResultModel *a = [[oprationResultModel alloc]initWithError:[NSNumber numberWithInt:STATIS_NO] info:[[returnModel getError] localizedDescription]];
            oprationReturnBlock(a);
        }
    }];
}

//从save列表删除该job
//用户id，jobid，回调block
+(void)deleteTheJob:(NSString *)usrID jobID:(NSString *)jobID withBlock:(oprationReturnBlock)oprationReturnBlock{
    NSString *str = [[NSString alloc]initWithFormat:@"job_id=%@&job_user_id=%@",jobID,usrID];
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    [self testAPIPostTestWithBlock:data getFunction:DELETEJOB_FUNCTION block:^(URLReturnModel *returnModel) {
        if ([returnModel getFlag]) {
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
        if ([returnModel getFlag]) {
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
