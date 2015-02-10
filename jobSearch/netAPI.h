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
#import "jobListModel.h"
#import "oprationResultModel.h"
#import "userReturnModel.h"
#import "userModel.h"
#import "messageListModel.h"
#import "jobApplyModel.h"

@interface netAPI : NSObject

typedef void (^returnBlock)(URLReturnModel *returnModel);
typedef void (^loginReturnBlock)(loginModel *loginModel);
typedef void (^registerReturnBlock)(registerModel *registerModel);
typedef void (^jobListReturnBlock)(jobListModel *jobListModel);
typedef void (^jobApplyReturnBlock)(jobApplyModel *jobApplyModel);
typedef void (^oprationReturnBlock)(oprationResultModel *oprationResultModel);
typedef void (^userReturnBlock)(userReturnModel *userReturnModel);
typedef void (^userBlock)(userModel *userModel);
typedef void (^messageListReturnBlock)(messageListModel *messageListModel);

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
+(void)getSaveJobList:(NSString *)usrID start:(int)start length:(int)length withBlock:(jobListReturnBlock)saveJobListBlock;

//附近的兼职信息
//lon:经度坐标;lat:纬度坐标;start:起始位置;length:获取长度;_id:用户唯一标示;回调block;
+(void)getNearByJobs:(NSString *)usrID longtitude:(double)longtitude latitude:(double)latitude start:(int)start length:(int)length withBlock:(jobListReturnBlock)nearByBlock;

//根据距离
//lon:经度坐标;lat:纬度坐标;start:起始位置;length:获取长度;distance:距离长度(km);_id:用户唯一标示;回调block;
+(void)getJobByDistance:(NSString *)usrID longtitude:(double)longtitude latitude:(double)latitude start:(int)start length:(int)length distance:(int)distance withBlock:(jobListReturnBlock)distanceBlock;

//根据工作类型
//start:起始位置;length:获取长度;typeArray:如[1,2,3]m,不为空，nsnumber类型;回调block;
+(void)getJobByJobType:(NSString *)usrID start:(int)start length:(int)length jobType:(NSMutableArray *)typeArray withBlock:(jobListReturnBlock)byTypeBlock;

//根据工作类型与距离
//lon:经度坐标;lat:纬度坐标;distance:距离长度(km);start:起始位置;length:获取长度;typeArray:如[1,2,3]m,不为空，nsnumber类型;回调block;
+(void)getJobByTypeAndDistance:(NSString *)usrID start:(int)start length:(int)length longtitude:(double)longtitude latitude:(double)latitude distance:(int)distance jobType:(NSMutableArray *)typeArray withBlock:(jobListReturnBlock)byTypeAndDisBlock;

//根据关键字
+(void)getJobByKeyWord:(NSString *)usrID start:(int)start length:(int)length keyWord:(NSString *)keyWord withBlock:(jobListReturnBlock)bykeyBlock;

//最新的兼职信息
//用户id，回调block
+(void)getNewestJobs:(NSString *)usrID start:(int)start length:(int)length withBlock:(jobListReturnBlock)newestJobListBlock;

//精灵匹配
//用户id，回调block
+(void)queryJingLingMatch:(NSString *)usrID start:(int)start length:(int)length withBlock:(jobListReturnBlock)newestJobListBlock;

//申请的兼职信息
//用户id，回调block
+(void)getApplyJobs:(NSString *)usrID start:(int)start length:(int)length withBlock:(jobListReturnBlock)applyJobListBlock;

//保存该job到用户save列表
//用户id，jobid，回调block
+(void)saveTheJob:(NSString *)usrID jobID:(NSString *)jobID withBlock:(oprationReturnBlock)oprationReturnBlock;

//从save列表删除该job
//用户id，jobid，回调block
+(void)deleteTheJob:(NSString *)usrID jobID:(NSString *)jobID withBlock:(oprationReturnBlock)oprationReturnBlock;

//申请该兼职
//用户id，jobid，回调block
+(void)applyTheJob:(NSString *)usrID jobID:(NSString *)jobID withBlock:(jobApplyReturnBlock)applyReturnBlock;

//编辑用户简历
+(void)editUserDetail:(userModel *)usr withBlock:(userReturnBlock)userReturnBlock;

//获取用户简历
+(void)getUserDetail:(NSString *)usrid withBlock:(userBlock)userBlock;

//接受企业邀请
+(void)acceptedInvite:(NSString *)invite_id withBlock:(oprationReturnBlock)oprationReturnBlock;

//拒绝企业邀请
+(void)refusedInvite:(NSString *)invite_id withBlock:(oprationReturnBlock)oprationReturnBlock;

//用户消息列表
+(void)getMessageList:(NSString *)usrID start:(int)start length:(int)length withBlock:(messageListReturnBlock)messageListBlock;

+(void)test;

@end
