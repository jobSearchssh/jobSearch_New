//
//  newestJobListModel.h
//  jobSearch
//
//  Created by 田原 on 15/2/1.
//  Copyright (c) 2015年 麻辣工作室. All rights reserved.
//

#import "baseModel.h"
#import "newestJobModel.h"

@interface newestJobListModel : baseModel{
    NSMutableArray *newestJobList;
}
-(newestJobListModel *)initWithData:(NSData *)mainData;
-(newestJobListModel *)initWithError:(NSNumber *)getStatus info:(NSString *)error;
-(NSMutableArray *)getnewestJobListArray;

@end
