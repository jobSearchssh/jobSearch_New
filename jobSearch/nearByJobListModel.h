//
//  nearByJobListModel.h
//  jobSearch
//
//  Created by 田原 on 15/2/1.
//  Copyright (c) 2015年 麻辣工作室. All rights reserved.
//

#import "baseModel.h"
#import "nearByJobModel.h"

@interface nearByJobListModel : baseModel{
    NSMutableArray *nearByJobList;
}
-(nearByJobListModel *)initWithData:(NSData *)mainData;
-(nearByJobListModel *)initWithError:(NSNumber *)getStatus info:(NSString *)error;
-(NSMutableArray *)getnearByJobListArray;
@end
