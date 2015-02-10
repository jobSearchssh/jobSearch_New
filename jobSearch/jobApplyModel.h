//
//  jobApplyModel.h
//  jobSearch
//
//  Created by 田原 on 15/2/9.
//  Copyright (c) 2015年 麻辣工作室. All rights reserved.
//

#import "baseModel.h"

@interface jobApplyModel : baseModel{
    NSString *apply_id;
    NSString *recieve_id;
}
-(jobApplyModel *)initWithData:(NSData *)mainData;
-(jobApplyModel *)initWithError:(NSNumber *)getStatus info:(NSString *)error;
-(NSString *)getapply_id;
-(NSString *)getrecieve_id;

@end
