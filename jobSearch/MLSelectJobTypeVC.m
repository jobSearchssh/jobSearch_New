//
//  MLSelectJobTypeVC.m
//  jobSearch
//
//  Created by RAY on 15/2/4.
//  Copyright (c) 2015年 麻辣工作室. All rights reserved.
//

#import "MLSelectJobTypeVC.h"
#import "MLCell4.h"

@interface MLSelectJobTypeVC ()
{
    const NSArray *typeArray;
}
@end

@implementation MLSelectJobTypeVC



- (void)viewDidLoad {
    [super viewDidLoad];
    
    typeArray=[[NSArray alloc]initWithObjects:@"模特/礼仪 ",@"促销/导购",@"销售",@"传单派发",@"安保",@"钟点工",@"法律事务",@"服务员",@"婚庆",@"配送/快递",@"化妆",@"护工/保姆",@"演出",@"问卷调查",@"志愿者",@"网络营销",@"导游",@"游戏代练",@"家教",@"软件/网站开发",@"会计",@"平面设计/制作",@"翻译",@"装修",@"影视制作",@"搬家",@"其他", nil];
    self.selectedTypeArray=[[NSMutableArray alloc]init];
    self.selectedTypeName=[[NSMutableArray alloc]init];
    UIBarButtonItem *finishItem = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(finishSelecting)];

    self.navigationItem.rightBarButtonItem = finishItem;
}

- (void)finishSelecting{
    [self.navigationController popViewControllerAnimated:YES];
    [self.selectDelegate finishSelect:self.selectedTypeArray SelectName:self.selectedTypeName];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [typeArray count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    BOOL nibsRegistered = NO;
    
    static NSString *Cellidentifier=@"MLCell4";
    if (!nibsRegistered) {
        UINib *nib = [UINib nibWithNibName:@"MLCell4" bundle:nil];
        [tableView registerNib:nib forCellReuseIdentifier:Cellidentifier];
        nibsRegistered = YES;
    }
    
    MLCell4 *cell = [tableView dequeueReusableCellWithIdentifier:Cellidentifier forIndexPath:indexPath];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    cell.titleLabel.text=[typeArray objectAtIndex:[indexPath row]];
    
    if ([self.selectedTypeArray containsObject:[NSString stringWithFormat:@"%ld",(long)[indexPath row]]]) {
        cell.selectedImageView.hidden=NO;
        cell.selecting=YES;
    }else
    {
        cell.selectedImageView.hidden=YES;
        cell.selecting=NO;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    MLCell4 *cell=(MLCell4 *)[tableView cellForRowAtIndexPath:indexPath];
    
    if (cell.selecting) {
        cell.selecting=NO;
        cell.selectedImageView.hidden=YES;
        for (NSString* str in self.selectedTypeArray){
            if ([str isEqualToString:[NSString stringWithFormat:@"%ld",(long)[indexPath row]]]) {
                NSInteger n=[typeArray indexOfObject:str];
                [self.selectedTypeArray removeObject:str];
                [self.selectedTypeName removeObjectAtIndex:n];
                break;
            }
        }
    }else{
        cell.selecting=YES;
        cell.selectedImageView.hidden=NO;
        [self.selectedTypeArray addObject:[NSString stringWithFormat:@"%ld",(long)[indexPath row]]];
        [self.selectedTypeName addObject:[typeArray objectAtIndex:[indexPath row]]];
    }
    [self deselect];
}

- (void)deselect
{
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}


@end
