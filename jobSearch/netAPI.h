//
//  netAPI.h
//  wowilling
//
//  Created by 田原 on 14-3-7.
//  Copyright (c) 2014年 田原. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "URLOperation.h"
#import "URLOperationWithBlock.h"
#import "baseAPP.h"
#import "URLReturnModel.h"
#import "loginModel.h"
#import "registerModel.h"
#import "saveJobListModel.h"
#import "nearByJobListModel.h"
#import "newestJobListModel.h"
#import "applyJobListModel.h"
#import "oprationResultModel.h"

@interface netAPI : NSObject

typedef void (^returnBlock)(URLReturnModel *returnModel);
typedef void (^loginReturnBlock)(loginModel *loginModel);
typedef void (^registerReturnBlock)(registerModel *registerModel);
typedef void (^saveJobListReturnBlock)(saveJobListModel *saveJobListModel);
typedef void (^nearByJobReturnBlock)(nearByJobListModel *nearByJobListModel);
typedef void (^newestJobReturnBlock)(newestJobListModel *newestJobListModel);
typedef void (^applyJobReturnBlock)(applyJobListModel *applyJobListModel);
typedef void (^oprationReturnBlock)(oprationResultModel *oprationResultModel);

#define STATIS_OK 0
#define STATIS_NO 1

//http://182.92.177.56:3000/getTest
+(void)testAPIGetTest:(id)target action:(SEL)theAction getInfo:(NSData *)getInfo;

//http://182.92.177.56:3000/postTest
+(void)testAPIPostTest:(id)target action:(SEL)theAction postInfo:(NSData *)postInfo;

//http://182.92.177.56:3000/getTest
+(void)testAPIGetTestWithBlock:(NSData *)getInfo getFunction:(NSString *)function block:(returnBlock)block;
//http://182.92.177.56:3000/postTest
+(void)testAPIPostTestWithBlock:(NSData *)postInfo getFunction:(NSString *)function block:(returnBlock)block;


//用户登录
//用户名，密码，回调block
+(void)usrLogin:(NSString *)name usrPassword:(NSString *)password withBlock:(loginReturnBlock)loginBlock;

//用户注册
//用户名，密码，回调block
+(void)usrRegister:(NSString *)name usrPassword:(NSString *)password withBlock:(registerReturnBlock)registerBlock;

//保存的job列表
//用户id，回调block
+(void)getSaveJobList:(NSString *)usrID withBlock:(saveJobListReturnBlock)saveJobListBlock;

//附近的兼职信息
//longtitude，latitude，回调block
+(void)getNearByJobs:(double)longtitude latitude:(double)latitude withBlock:(nearByJobReturnBlock)nearByBlock;

//最新的兼职信息
//用户id，回调block
+(void)getNewestJobs:(NSString *)usrID withBlock:(newestJobReturnBlock)newestJobListBlock;

//申请的兼职信息
//用户id，回调block
+(void)getApplyJobs:(NSString *)usrID withBlock:(applyJobReturnBlock)applyJobListBlock;

//保存该job到用户save列表
//用户id，jobid，回调block
+(void)saveTheJob:(NSString *)usrID jobID:(NSString *)jobID withBlock:(oprationReturnBlock)oprationReturnBlock;

//从save列表删除该job
//用户id，jobid，回调block
+(void)deleteTheJob:(NSString *)usrID jobID:(NSString *)jobID withBlock:(oprationReturnBlock)oprationReturnBlock;

//申请该兼职
//用户id，jobid，回调block
+(void)applyTheJob:(NSString *)usrID jobID:(NSString *)jobID withBlock:(oprationReturnBlock)oprationReturnBlock;

+(void)test;

@end
