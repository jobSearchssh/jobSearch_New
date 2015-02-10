//
//  MLLoginBusiness.m
//  jobSearch
//
//  Created by RAY on 15/1/26.
//  Copyright (c) 2015年 麻辣工作室. All rights reserved.
//

#import "MLLoginBusiness.h"
#import "netAPI.h"
#import "registerModel.h"
#import "loginModel.h"

@implementation MLLoginBusiness

- (void)registerInBackground:(NSString*)username Password:(NSString*)pwd{
    
    [netAPI usrRegister:username usrPassword:pwd withBlock:^(registerModel *registerModel) {
        
        if ([registerModel.getStatus intValue]==0) {
            
            [self saveUserInfoLocallyWithUserName:username userObjectId:registerModel.getUsrID];
            
            [self registerIsSucceed:YES feedback:@"注册成功"];
            
        }else{
            NSString *error=registerModel.getInfo;
            
//            if ([registerModel.getInfo isEqualToString:@"CREATE_ERROR"])
//                error=@"数据创建失败";
//            else if ([registerModel.getInfo isEqualToString:@"USER_EXISTED"])
//                error=@"该手机号已经被注册";
//            else if ([registerModel.getInfo isEqualToString:@"INVALID_INPUT"])
//                error=@"该手机号已经被注册";
            [self registerIsSucceed:NO feedback:error];
        }
    }];
    
}

-(void)registerIsSucceed:(BOOL)result feedback:(NSString*)feedback{
    
    [self.registerResultDelegate registerResult:result Feedback:feedback];
}

-(void)loginInBackground:(NSString*) username Password:(NSString*)pwd{
    
    [netAPI usrLogin:username usrPassword:pwd withBlock:^(loginModel *loginModel) {
        if ([loginModel.getStatus intValue]==0) {
            [self saveUserInfoLocallyWithUserName:username userObjectId:loginModel.getUsrID];
            [self loginIsSucceed:YES feedback:@"登录成功"];
            
        }else{
            
             NSString *error=loginModel.getInfo;
//            if ([loginModel.getInfo isEqualToString:@"QUERY_ERROR"])
//                error=@"登录名或密码有误";
//            else if ([loginModel.getInfo isEqualToString:@"INVALID_INPUT"])
//                error=@"您的输入有误";
            
            [self loginIsSucceed:NO feedback:error];
        }
    }];
}

-(void)loginIsSucceed:(BOOL)result feedback:(NSString*)feedback
{

    [self.loginResultDelegate loginResult:result Feedback:feedback];

}

- (void)saveUserInfoLocallyWithUserName:(NSString*)userName userObjectId:(NSString*)userObjectId{

    
    NSUserDefaults *mySettingData = [NSUserDefaults standardUserDefaults];
    [mySettingData setObject:userName forKey:@"currentUserName"];
    [mySettingData setObject:userObjectId forKey:@"currentUserObjectId"];
    [mySettingData synchronize];

}

+ (void)logout{
    NSUserDefaults *mySettingData = [NSUserDefaults standardUserDefaults];
    if ([mySettingData objectForKey:@"currentUserObjectId"]) {
        [mySettingData setObject:nil forKey:@"currentUserName"];
        [mySettingData setObject:nil forKey:@"currentUserObjectId"];
        [mySettingData synchronize];
    }
}

@end
