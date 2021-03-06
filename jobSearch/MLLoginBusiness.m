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
#import "badgeNumber.h"

@implementation MLLoginBusiness

- (void)registerInBackground:(NSString*)username Password:(NSString*)pwd{
    
    [netAPI usrRegister:username usrPassword:pwd withBlock:^(registerModel *registerModel) {
        
        if ([registerModel.getStatus intValue]==0) {
            
            [self saveUserInfoLocallyWithUserName:username userObjectId:registerModel.getUsrID logoUrl:nil];
            
            [self registerIsSucceed:YES feedback:REGISTERSUCCESS];
            
        }else{
            NSString *error=registerModel.getInfo;
            
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
            
            [self saveUserInfoLocallyWithUserName:username userObjectId:loginModel.getUsrID logoUrl:loginModel.getusrLogoUrl];
            [self loginIsSucceed:YES feedback:LOGINSUCCESS logoUrl:loginModel.getusrLogoUrl];
            
            //刷新消息条目
            [[badgeNumber sharedInstance] refreshCount];
            
        }else{
            
            NSString *error=loginModel.getInfo;
            
            [self loginIsSucceed:NO feedback:error logoUrl:nil];
        }
    }];
}

- (void)resetPasswordInBackground:(NSString*)username Password:(NSString*)pwd{
    
    [netAPI usrResetPassword:username usrPassword:pwd withBlock:^(oprationResultModel *oprationResultModel) {
        if ([oprationResultModel.getStatus intValue]==0) {
            [self.resetResultDelegate resetPassword:YES Feedback:PASSWORDEDITSUCCESS];
        }else{
            [self.resetResultDelegate resetPassword:NO Feedback:oprationResultModel.getInfo];
        }
    }];
    
}

-(void)loginIsSucceed:(BOOL)result feedback:(NSString*)feedback logoUrl:(NSString*)logoUrl
{

    [self.loginResultDelegate loginResult:result Feedback:feedback logoUrl:logoUrl];

}

- (void)saveUserInfoLocallyWithUserName:(NSString*)userName userObjectId:(NSString*)userObjectId logoUrl:(NSString*)logoUrl{

    NSUserDefaults *mySettingData = [NSUserDefaults standardUserDefaults];
    [mySettingData setObject:userName forKey:@"currentUserName"];
    [mySettingData setObject:userObjectId forKey:@"currentUserObjectId"];
    [mySettingData setObject:logoUrl forKey:@"currentUserlogoUrl"];
    [mySettingData synchronize];

}

+ (void)logout{
    NSUserDefaults *mySettingData = [NSUserDefaults standardUserDefaults];
    if ([mySettingData objectForKey:@"currentUserObjectId"]) {
        
        [mySettingData setObject:nil forKey:@"currentUserName"];
        [mySettingData setObject:nil forKey:@"currentUserObjectId"];
        [mySettingData setObject:nil forKey:@"currentUserlogoUrl"];
        [mySettingData setObject:nil forKey:@"badgeInviteNum"];
        [mySettingData setObject:nil forKey:@"badgeApplyNum"];
        [mySettingData synchronize];
        
        badgeNumber *bn=[badgeNumber sharedInstance];
        bn.messageCount=@"0";
        bn.applyCount=@"0";
    }
}

//重置密码


@end
