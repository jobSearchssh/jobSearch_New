//
//  netAPI.m
//  wowilling
//
//  Created by 田原 on 14-3-7.
//  Copyright (c) 2014年 田原. All rights reserved.
//

#import "netAPI.h"

@implementation netAPI


+(void)usrLogin:(NSString *)name usrPassword:(NSString *)password withBlock:(returnBlock)block{
    NSString *str = [[NSString alloc]initWithFormat:@"userName=%@&userPassword=%@",name,password];
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    [self testAPIPostTestWithBlock:block getFunction:@"user" postInfo:data];
}

+(void)usrRegister:(NSString *)name usrPassword:(NSString *)password usrEmail:(NSString *)email usrPhone:(NSString *)phone usrType:(int)type withBlock:(returnBlock)block{
    NSString *str = [[NSString alloc]initWithFormat:@"userName=%@&userPassword=%@&userPhone=%@&userEmail=%@&userType=%d",name,password,phone,email,type];
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    [self testAPIPostTestWithBlock:block getFunction:@"user/register" postInfo:data];
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
+(void)testAPIGetTestWithBlock:(returnBlock)block getFunction:(NSString *)function getInfo:(NSData *)getInfo{
    @try {
        URLOperationWithBlock *operation = [[URLOperationWithBlock alloc]initWithURL:getInfo serveceFunction:function returnblock:block isPost:FALSE];
        [operation setQueuePriority:NSOperationQueuePriorityHigh];
        [[baseAPP getBaseNSOperationQueue] addOperation:operation];
    }
    @catch (NSException *exception) {
        
    }
}

//http://182.92.177.56:3000/postTest
+(void)testAPIPostTestWithBlock:(returnBlock)block getFunction:(NSString *)function postInfo:(NSData *)postInfo{
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
