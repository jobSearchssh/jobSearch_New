//
//  MLMessageVC.m
//  jobSearch
//
//  Created by RAY on 15/1/22.
//  Copyright (c) 2015年 麻辣工作室. All rights reserved.
//

#import "MLMessageVC.h"
#import "MLCell2.h"
#import "jobRecmendVC.h"
#import "MBProgressHUD.h"
#import "MJRefresh.h"
#import "netAPI.h"
#import "jobModel.h"

static NSString *userId = @"54d76bd496d9aece6f8b4568";

@interface MLMessageVC ()<UITableViewDataSource,UITableViewDelegate,SWTableViewCellDelegate>
{
    NSInteger cellNum;
    NSDateFormatter *dateFormatter;
    NSInteger sectionNum;
    NSMutableArray *recordArray;
    BOOL firstLoad;
    BOOL headerRefreshing;
    BOOL footerRefreshing;
    //页数
    int skipTimes;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation MLMessageVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    cellNum=0;
    sectionNum=0;
    skipTimes=0;
    firstLoad=YES;
    headerRefreshing=NO;
    footerRefreshing=NO;
    dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM月dd日"];
    
    [self tableViewInit];
}

- (void)headRefreshData{
    
    headerRefreshing=YES;
    skipTimes=0;
    
    if (firstLoad){
        [MBProgressHUD showHUDAddedTo:_tableView animated:YES];
        firstLoad=NO;
    }
    [netAPI getMessageList:userId start:1 length:BASE_SPAN withBlock:^(messageListModel *messageListModel) {
        [self headHandler:messageListModel];
    }];
    
}

- (void)footRefreshData{
    footerRefreshing=YES;
    [netAPI getMessageList:userId start:skipTimes*BASE_SPAN+1 length:BASE_SPAN withBlock:^(messageListModel *messageListModel) {
        [self footHandler:messageListModel];
    }];

}

- (void)headHandler:(messageListModel *)jobListModel{
    [self refreshData:jobListModel];
    [MBProgressHUD hideHUDForView:_tableView animated:YES];
    skipTimes=1;
    if (firstLoad){
        firstLoad=NO;
    }
    headerRefreshing=NO;
    [self.tableView headerEndRefreshing];
}

- (void)footHandler:(messageListModel *)jobListModel{
    [self refreshData:jobListModel];
    
    footerRefreshing=NO;
    skipTimes+=1;
    [self.tableView footerEndRefreshing];
}


- (void)refreshData:(messageListModel *)jobListModel{
    
    if (footerRefreshing) {
        if (![jobListModel.getStatus intValue]==0) {
            NSString *err=jobListModel.getInfo;
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"信息加载失败" message:err delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alert show];
            
        }else{
            
            for (id object in jobListModel.getMessageArray) {
                [recordArray addObject:object];
            }
            
            NSMutableArray *insertIndexPaths = [NSMutableArray arrayWithCapacity:10];
            
            NSInteger n=[recordArray count];
            NSInteger m=[jobListModel.getMessageArray count];
            
            for (NSInteger k=n-m; k<[recordArray count];k++) {
                NSIndexPath *newPath = [NSIndexPath indexPathForRow:k inSection:0];
                [insertIndexPaths addObject:newPath];
            }
            cellNum=[recordArray count];
            [self.tableView insertRowsAtIndexPaths:insertIndexPaths withRowAnimation:UITableViewRowAnimationNone];
        }
    }
    
    else{
        
        if (![jobListModel.getStatus intValue]==0) {
            NSString *err=jobListModel.getInfo;
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"信息加载失败" message:err delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alert show];
        }else{
            
            [recordArray removeAllObjects];
            
            for (id object in jobListModel.getMessageArray) {
                [recordArray addObject:object];
            }
            
            cellNum=[recordArray count];
            [self.tableView reloadData];
        }
    }
}


//*********************tableView********************//
- (void)tableViewInit{
    recordArray=[[NSMutableArray alloc]init];
    
    [_tableView setDelegate:self];
    [_tableView setDataSource:self];
    _tableView.scrollEnabled=YES;
    [_tableView addHeaderWithTarget:self action:@selector(headRefreshData)];
    [_tableView addFooterWithTarget:self action:@selector(footRefreshData)];
    _tableView.tableFooterView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
    
    [self headRefreshData];}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    BOOL nibsRegistered = NO;
    
    static NSString *Cellidentifier=@"MLCell2";
    if (!nibsRegistered) {
        UINib *nib = [UINib nibWithNibName:@"MLCell2" bundle:nil];
        [tableView registerNib:nib forCellReuseIdentifier:Cellidentifier];
        nibsRegistered = YES;
    }
    
    MLCell2 *cell = [tableView dequeueReusableCellWithIdentifier:Cellidentifier forIndexPath:indexPath];
    [cell setRightUtilityButtons:[self rightButtons] WithButtonWidth:58.0f];
    cell.delegate = self;
    
    return cell;
}

- (NSArray *)rightButtons
{
    NSMutableArray *rightUtilityButtons = [NSMutableArray new];
    [rightUtilityButtons sw_addUtilityButtonWithColor:
     [UIColor colorWithRed:174.0/255.0 green:197.0/255.0 blue:80.0/255.0 alpha:1.0]
                                                 icon:[UIImage imageNamed:@"trash"]];
    
    return rightUtilityButtons;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [recordArray count];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

//改变行高
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    jobRecmendVC *detailVC=[[jobRecmendVC alloc]init];
    
    if ([recordArray objectAtIndex:[indexPath row]]) {
        detailVC.jobModel=[recordArray objectAtIndex:[indexPath row]];
    }
    
    detailVC.hidesBottomBarWhenPushed=YES;
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] init];
    backItem.title = @"";
    backItem.tintColor=[UIColor whiteColor];
    self.navigationItem.backBarButtonItem = backItem;
    
    [self.navigationController pushViewController:detailVC animated:YES];
    
    [self performSelector:@selector(deselect) withObject:nil afterDelay:0.5f];
}

- (void)deselect
{
    [_tableView deselectRowAtIndexPath:[_tableView indexPathForSelectedRow] animated:YES];
}

//*********************swipeableTableViewCell********************//
- (void)swipeableTableViewCell:(SWTableViewCell *)cell scrollingToState:(SWCellState)state
{
    switch (state) {
        case 0:
            NSLog(@"utility buttons closed");
            break;
        case 1:
            NSLog(@"left utility buttons open");
            break;
        case 2:
            NSLog(@"right utility buttons open");
            break;
        default:
            break;
    }
}

- (void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerLeftUtilityButtonWithIndex:(NSInteger)index
{
    switch (index) {
        case 0:
            NSLog(@"left button 0 was pressed");
            break;
        case 1:
            NSLog(@"left button 1 was pressed");
            break;
        case 2:
            NSLog(@"left button 2 was pressed");
            break;
        case 3:
            NSLog(@"left btton 3 was pressed");
        default:
            break;
    }
}

- (void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index
{
    switch (index) {
        case 0:
        {
            NSIndexPath *cellIndexPath = [_tableView indexPathForCell:cell];
            
            [recordArray removeObjectAtIndex:[cellIndexPath row]];
            cellNum=[recordArray count];
            [_tableView deleteRowsAtIndexPaths:@[cellIndexPath] withRowAnimation:UITableViewRowAnimationLeft];
            
            break;
        }
        case 1:
        {
            
            break;
        }
        default:
            break;
    }
}

- (BOOL)swipeableTableViewCellShouldHideUtilityButtonsOnSwipe:(SWTableViewCell *)cell
{
    // allow just one cell's utility button to be open at once
    return YES;
}

- (BOOL)swipeableTableViewCell:(SWTableViewCell *)cell canSwipeToState:(SWCellState)state
{
    switch (state) {
        case 1:
            // set to NO to disable all left utility buttons appearing
            return YES;
            break;
        case 2:
            // set to NO to disable all right utility buttons appearing
            return YES;
            break;
        default:
            break;
    }
    
    return YES;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
