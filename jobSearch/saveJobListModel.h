//
//  jobsModel.h
//  jobSearch
//
//  Created by 田原 on 15/2/1.
//  Copyright (c) 2015年 麻辣工作室. All rights reserved.
//

#import "baseModel.h"
#import "saveJobModel.h"

@interface saveJobListModel : baseModel{
    NSMutableArray *savejobsArray;
}

-(saveJobListModel *)initWithData:(NSData *)mainData;
-(saveJobListModel *)initWithError:(NSNumber *)getStatus info:(NSString *)error;
-(NSMutableArray *)getsaveJobsArray;
@end
