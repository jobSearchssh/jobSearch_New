//
//  applyJobListModel.h
//  jobSearch
//
//  Created by 田原 on 15/2/1.
//  Copyright (c) 2015年 麻辣工作室. All rights reserved.
//

#import "baseModel.h"
#import "applyJobModel.h"

@interface applyJobListModel : baseModel{
    NSMutableArray *applyJobList;
}
-(applyJobListModel *)initWithData:(NSData *)mainData;
-(applyJobListModel *)initWithError:(NSNumber *)getStatus info:(NSString *)error;
-(NSMutableArray *)getapplyJobListArray;

@end
