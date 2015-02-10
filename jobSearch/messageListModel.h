//
//  messageListModel.h
//  jobSearch
//
//  Created by 田原 on 15/2/9.
//  Copyright (c) 2015年 麻辣工作室. All rights reserved.
//

#import "baseModel.h"
#import "messageModel.h"

@interface messageListModel : baseModel{
    NSMutableArray *messageArray;
}

-(messageListModel *)initWithData:(NSData *)mainData;
-(messageListModel *)initWithError:(NSNumber *)getStatus info:(NSString *)error;
-(NSMutableArray *)getMessageArray;

@end
