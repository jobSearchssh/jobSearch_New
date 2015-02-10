//
//  userModel.m
//  jobSearch
//
//  Created by 田原 on 15/2/7.
//  Copyright (c) 2015年 麻辣工作室. All rights reserved.
//

#import "userModel.h"

@implementation userModel

-(userModel *)initWithData:(NSData *)mainData{
    self = [super init];
    if (self) {
        NSString *receiveStr = [[NSString alloc]initWithData:mainData encoding:NSUTF8StringEncoding];
//        NSLog(@"%@",receiveStr);
        NSError *error;
        NSData* aData = [receiveStr dataUsingEncoding: NSASCIIStringEncoding];
        NSDictionary *aDicMain = Nil;
        BOOL flag = TRUE;
        @try {
            aDicMain = [NSJSONSerialization JSONObjectWithData:aData options:NSJSONReadingMutableLeaves error:&error];
        }
        @catch (NSException *exception) {
            aDicMain = Nil;
            flag = false;
        }
        if (flag) {
            @try {
                status = [aDicMain objectForKey:@"status"];
                info = [aDicMain objectForKey:@"info"];
            }@catch (NSException *exception) {
                flag = false;
            }
        }
        if (flag && status.intValue == STATIS_OK) {
            do{
                NSDictionary *dictionary = nil;
                @try {
                    dictionary = [aDicMain objectForKey:@"datas"];
                }
                @catch (NSException *exception) {
                    NSLog(@"datas 解析不成功");
                    dictionary = Nil;
                    flag = false;
                }
                if (dictionary == Nil) {
                    NSLog(@"datas 为空");
                    flag = false;
                    break;
                }
                
                @try {
                    job_user_id = [dictionary objectForKey:@"job_user_id"];
                    userName = [dictionary objectForKey:@"userName"];
                    userProvince = [dictionary objectForKey:@"userProvince"];
                    userDistrict = [dictionary objectForKey:@"userDistrict"];
                    userCity = [dictionary objectForKey:@"userCity"];
                    userAddressDetail = [dictionary objectForKey:@"userAddressDetail"];
                    userSchool = [dictionary objectForKey:@"userSchool"];
                    userIntroduction = [dictionary objectForKey:@"userIntroduction"];
                    userExperience = [dictionary objectForKey:@"userExperience"];
                    userPhone = [dictionary objectForKey:@"userPhone"];
                    userEmail = [dictionary objectForKey:@"userEmail"];
                    userVideoURL = [dictionary objectForKey:@"userVideoURL"];
                    beiyong1 = [dictionary objectForKey:@"beiyong1"];
                    beiyong2 = [dictionary objectForKey:@"beiyong2"];
                    beiyong3 = [dictionary objectForKey:@"beiyong3"];
                    beiyong4 = [dictionary objectForKey:@"beiyong4"];
                    userGender = [dictionary objectForKey:@"userGender"];
                    NSString *tempstring = [dictionary objectForKey:@"userBirthday"];
                    @try {
                        if (tempstring !=Nil) {
                            userBirthday = [DateUtil BirthdateFromString:tempstring];
                        }
                    }
                    @catch (NSException *exception) {
                        
                    }
                    userDegree = [dictionary objectForKey:@"userDegree"];
                    userHopeJobType = [dictionary objectForKey:@"userHopeJobType"];
                    userFreeTime = [dictionary objectForKey:@"userFreeTime"];
                    userHopeSettlement = [dictionary objectForKey:@"userHopeSettlement"];
                    userInfoComplete = [dictionary objectForKey:@"userInfoComplete"];
                    NSArray *temparray = [dictionary objectForKey:@"userLocationGeo"];
                    if (temparray != Nil && [temparray count] == 2) {
                        NSNumber *lon = [temparray objectAtIndex:0];
                        NSNumber *lat = [temparray objectAtIndex:1];
                        userLocationGeo = [[geoModel alloc]initWith:[lon doubleValue] lat:[lat doubleValue]];
                    }
                }
                @catch (NSException *exception) {
                    NSLog(@"datas 解析错误");
                    flag = false;
                    break;
                }
            }while (FALSE);
        }else{
            NSLog(@"status 不成功");
            return self;
        }
        if (!flag) {
            status = [NSNumber numberWithInt:STATIS_NO];
            info = @"解析错误,请重新尝试";
        }
    }
    return self;
}
-(userModel *)initWithError:(NSNumber *)getStatus info:(NSString *)error{
    self = [super init];
    if (self) {
        status = getStatus;
        info = error;
    }
    return self;
}



-(NSString *)getjob_user_id{
    return job_user_id;
}

-(void)setjob_user_id:(NSString *)value{
    job_user_id = value;
}

-(NSString *)getuserName{
    return userName;
}
-(void)setuserName:(NSString *)value{
    userName = value;
}

-(NSDate *)getuserBirthday{
    return userBirthday;
}
-(void)setuserBirthday:(NSDate *)value{
    userBirthday = value;
}

-(NSString *)getuserProvince{
    return userProvince;
}
-(void)setuserProvince:(NSString *)value{
    userProvince = value;
}

-(NSString *)getuserDistrict{
    return userDistrict;
}
-(void)setuserDistrict:(NSString *)value{
    userDistrict = value;
}

-(NSString *)getuserCity{
    return userCity;
}
-(void)setuserCity:(NSString *)value{
    userCity = value;
}

-(NSString *)getuserAddressDetail{
    return userAddressDetail;
}
-(void)setuserAddressDetail:(NSString *)value{
    userAddressDetail = value;
}

-(NSString *)getuserSchool{
    return userSchool;
}
-(void)setuserSchool:(NSString *)value{
    userSchool = value;
}

-(NSString *)getuserIntroduction{
    return userIntroduction;
}
-(void)setuserIntroduction:(NSString *)value{
    userIntroduction = value;
}

-(NSString *)getuserExperience{
    return userExperience;
}
-(void)setuserExperience:(NSString *)value{
    userExperience = value;
}

-(NSString *)getuserPhone{
    return userPhone;
}
-(void)setuserPhone:(NSString *)value{
    userPhone = value;
}

-(NSString *)getuserEmail{
    return userEmail;
}
-(void)setuserEmail:(NSString *)value{
    userEmail = value;
}

-(NSString *)getuserVideoURL{
    return userVideoURL;
}
-(void)setuserVideoURL:(NSString *)value{
    userVideoURL = value;
}

-(NSString *)getbeiyong1{
    return beiyong1;
}
-(void)setbeiyong1:(NSString *)value{
    beiyong1 = value;
}

-(NSString *)getbeiyong2{
    return beiyong2;
}
-(void)setbeiyong2:(NSString *)value{
    beiyong2 = value;
}

-(NSString *)getbeiyong3{
    return beiyong3;
}
-(void)setbeiyong3:(NSString *)value{
    beiyong3 = value;
}

-(NSNumber *)getuserGender{
    return userGender;
}
-(void)setuserGender:(NSNumber *)value{
    userGender = value;
}

-(NSNumber *)getuserDegree{
    return userDegree;
}
-(void)setuserDegree:(NSNumber *)value{
    userDegree = value;
}

-(NSArray *)getuserHopeJobType{
    return userHopeJobType;
}
-(void)setuserHopeJobType:(NSArray *)value{
    userHopeJobType = value;
}

-(NSArray *)getuserFreeTime{
    return userFreeTime;
}
-(void)setuserFreeTime:(NSArray *)value{
    userFreeTime = value;
}
-(NSArray *)getuserHopeSettlement{
    return userHopeSettlement;
}
-(void)setuserHopeSettlement:(NSArray *)value{
    userHopeSettlement = value;
}

-(geoModel *)getuserLocationGeo{
    return userLocationGeo;
}
-(void)setuserLocationGeo:(geoModel *)value{
    userLocationGeo = value;
}

-(NSString *)getImageFileURL{
    return ImageFileURL;
}
-(void)setImageFileURL:(NSString *)value{
    ImageFileURL = value;
}


-(NSString *)getBaseString{
    NSMutableString *baseString = [[NSMutableString alloc]initWithFormat:@"job_user_id=%@",job_user_id];
    if (userName != Nil) {
        [baseString appendFormat:@"&userName=%@",userName];
    }
    if (userGender != Nil) {
        [baseString appendFormat:@"&userGender=%d",userGender.intValue];
    }
    if (userBirthday != Nil) {
        [baseString appendFormat:@"&userBirthday=%@",[DateUtil startTimeStringFromDate:userBirthday]];
    }
    if (userProvince != Nil) {
        [baseString appendFormat:@"&userProvince=%@",userProvince];
    }
    if (userCity != Nil) {
        [baseString appendFormat:@"&userCity=%@",userCity];
    }
    if (userDistrict != Nil) {
        [baseString appendFormat:@"&userDistrict=%@",userDistrict];
    }
    if (userAddressDetail != Nil) {
        [baseString appendFormat:@"&userAddressDetail=%@",userAddressDetail];
    }
    if (userSchool != Nil) {
        [baseString appendFormat:@"&userSchool=%@",userSchool];
    }
    if (userDegree != Nil) {
        [baseString appendFormat:@"&userDegree=%d",userDegree.intValue];
    }
    if (userIntroduction != Nil) {
        [baseString appendFormat:@"&userIntroduction=%@",userIntroduction];
    }
    if (userExperience != Nil) {
        [baseString appendFormat:@"&userExperience=%@",userExperience];
    }
    if (userPhone != Nil) {
        [baseString appendFormat:@"&userPhone=%@",userPhone];
    }
    if (userEmail != Nil) {
        [baseString appendFormat:@"&userEmail=%@",userEmail];
    }
    if (userInfoComplete != Nil) {
        [baseString appendFormat:@"&userInfoComplete=%d",userInfoComplete.intValue];
    }
    if (userVideoURL != Nil) {
        [baseString appendFormat:@"&userVideoURL=%@",userVideoURL];
    }
    if (beiyong4 != Nil) {
        [baseString appendFormat:@"&beiyong4=%d",beiyong4.intValue];
    }
    if (beiyong1 != Nil) {
        [baseString appendFormat:@"&beiyong1=%@",beiyong1];
    }
    if (beiyong2 != Nil) {
        [baseString appendFormat:@"&beiyong2=%@",beiyong2];
    }
    if (beiyong3 != Nil) {
        [baseString appendFormat:@"&beiyong3=%@",beiyong3];
    }
    if (ImageFileURL != Nil) {
        [baseString appendFormat:@"&ImageFileURL=%@",ImageFileURL];
    }
    if (userLocationGeo !=Nil) {
        NSString *geoPoint = [NSString stringWithFormat:@"%f,%f",[userLocationGeo getLon],[userLocationGeo getLat]];
        [baseString appendFormat:@"&userLocationGeo=%@",geoPoint];
    }
    
    if (userHopeJobType !=Nil) {
        NSMutableString *getType = [[NSMutableString alloc]initWithFormat:@""];
        for (int index = 0; index < [userHopeJobType count] ; index++ ) {
            NSNumber *number = [userHopeJobType objectAtIndex:index];
            [getType appendFormat:@"%d",number.intValue];
            if (index != ([userHopeJobType count] -1)) {
                [getType appendFormat:@","];
            }
        }
//        [getType appendFormat:@"\""];
        [baseString appendFormat:@"&userHopeJobType=%@",getType];
    }
    
    if (userFreeTime !=Nil) {
        NSMutableString *temp = [[NSMutableString alloc]initWithFormat:@""];
        for (int index = 0; index < [userFreeTime count] ; index++ ) {
            NSNumber *number = [userFreeTime objectAtIndex:index];
            [temp appendFormat:@"%d",number.intValue];
            if (index != ([userFreeTime count] -1)) {
                [temp appendFormat:@","];
            }
        }
//        [temp appendFormat:@"\""];
        [baseString appendFormat:@"&userFreeTime=%@",temp];
    }
    
    if (userHopeSettlement !=Nil) {
        NSMutableString *temp = [[NSMutableString alloc]initWithFormat:@""];
        for (int index = 0; index < [userHopeSettlement count] ; index++ ) {
            NSNumber *number = [userHopeSettlement objectAtIndex:index];
            [temp appendFormat:@"%d",number.intValue];
            if (index != ([userHopeSettlement count] -1)) {
                [temp appendFormat:@","];
            }
        }
//        [temp appendFormat:@"\""];
        [baseString appendFormat:@"&userHopeSettlement=%@",temp];
    }
    
    
    return baseString;
}

@end
