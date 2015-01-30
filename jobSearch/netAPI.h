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

@interface netAPI : NSObject

typedef void (^returnBlock)(URLReturnModel *returnModel);

//http://182.92.177.56:3000/getTest
+(void)testAPIGetTest:(id)target action:(SEL)theAction getInfo:(NSData *)getInfo;

//http://182.92.177.56:3000/postTest
+(void)testAPIPostTest:(id)target action:(SEL)theAction postInfo:(NSData *)postInfo;

//http://182.92.177.56:3000/getTest
+(void)testAPIGetTestWithBlock:(returnBlock)block getFunction:(NSString *)function getInfo:(NSData *)getInfo;

//http://182.92.177.56:3000/postTest
+(void)testAPIPostTestWithBlock:(returnBlock)block getFunction:(NSString *)function postInfo:(NSData *)postInfo;

//用户登录
+(void)usrLogin:(NSString *)name usrPassword:(NSString *)password withBlock:(returnBlock)block;

//用户注册
+(void)usrRegister:(NSString *)name usrPassword:(NSString *)password usrEmail:(NSString *)email usrPhone:(NSString *)phone usrType:(int)type withBlock:(returnBlock)block;

@end
