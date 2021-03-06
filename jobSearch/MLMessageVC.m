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
#import "MBProgressHUD+Add.h"
#import "MJRefresh.h"
#import "netAPI.h"
#import "jobModel.h"
#import "MLLoginVC.h"
#import "badgeNumber.h"
#import "MLTextUtils.h"
#import "JobMessageCell.h"
#import "SystemMessageCell.h"

@interface MLMessageVC ()<UITableViewDataSource,UITableViewDelegate,SWTableViewCellDelegate,finishHandle,UIAlertViewDelegate,finishLoginDelegate>
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
    BOOL refreshAdded;
    NSInteger nowCellNum;
    
    BOOL tableViewAdded;
    BOOL isJobMessage;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation MLMessageVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    refreshAdded=NO;
    cellNum=0;
    sectionNum=0;
    skipTimes=0;
    firstLoad=YES;
    headerRefreshing=NO;
    footerRefreshing=NO;
    isJobMessage = YES;
    
    dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM月dd日"];
    
    //创建UISegementControl
    UISegmentedControl *segement = [[UISegmentedControl alloc]initWithItems:@[@"职 位 消 息",@"系 统 消 息"]];
    
    segement.selectedSegmentIndex = 0;
    
    segement.tintColor = [UIColor blueColor ];
    
    [segement addTarget:self action:@selector(changeView:) forControlEvents:UIControlEventValueChanged]; //改变的是数值
    
    self.navigationItem.titleView = segement;
    
    [self tableViewInit];
}

- (void)changeView:(UISegmentedControl *)segment
{
    switch (segment.selectedSegmentIndex) {
            
        case 0:
            isJobMessage = YES;
            break;
        case 1:
            isJobMessage = NO;
            break;
            
        default:
            break;
    }
    [self.tableView reloadData];
}

- (void)finishHandle{
    [recordArray removeObjectAtIndex:nowCellNum];
    [self.tableView reloadData];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [[badgeNumber sharedInstance] refreshCount];
}

- (void)finishLogin
{
    firstLoad=YES;
    [self headRefreshData];
}

- (void)headRefreshData
{
    
    NSUserDefaults *myData = [NSUserDefaults standardUserDefaults];
    NSString *currentUserObjectId=[myData objectForKey:@"currentUserObjectId"];
    if ([currentUserObjectId length]>0) {
        
        headerRefreshing=YES;
        skipTimes=0;
    
        if (firstLoad){
            [MBProgressHUD showHUDAddedTo:_tableView animated:YES];
            firstLoad=NO;
        }
    
        [netAPI getMessageList:currentUserObjectId start:1 length:BASE_SPAN withBlock:^(messageListModel *messageListModel) {
            
            badgeNumber *bn=[badgeNumber sharedInstance];
            if ([messageListModel.getCount intValue]>[bn.messageCount intValue]) {
                bn.messageCount=[NSString stringWithFormat:@"%@",messageListModel.getCount];
            }
            [self headHandler:messageListModel];
        }];
        
    }else{
        
        if (!refreshAdded) {
            refreshAdded=YES;
            [_tableView addHeaderWithTarget:self action:@selector(headRefreshData)];
            [_tableView addFooterWithTarget:self action:@selector(footRefreshData)];
        }

        UIAlertView *loginAlert=[[UIAlertView alloc]initWithTitle:NOTLOGIN message:ASKTOLOGIN delegate:self cancelButtonTitle:ALERTVIEW_CANCELBUTTON otherButtonTitles:LOGIN, nil];
        [loginAlert show];
    }
}

- (void)footRefreshData
{
    NSUserDefaults *myData = [NSUserDefaults standardUserDefaults];
    NSString *currentUserObjectId=[myData objectForKey:@"currentUserObjectId"];
    
    if ([currentUserObjectId length]>0) {
        
        footerRefreshing=YES;
        
        [netAPI getMessageList:currentUserObjectId start:skipTimes*BASE_SPAN+1 length:BASE_SPAN withBlock:^(messageListModel *messageListModel) {
        [self footHandler:messageListModel];
    }];
    }else{
        UIAlertView *loginAlert=[[UIAlertView alloc]initWithTitle:NOTLOGIN message:ASKTOLOGIN delegate:self cancelButtonTitle:ALERTVIEW_CANCELBUTTON otherButtonTitles:LOGIN, nil];
        [loginAlert show];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    [self.tableView headerEndRefreshing];
    [self.tableView footerEndRefreshing];
    if (buttonIndex==1) {
        MLLoginVC *loginVC=[[MLLoginVC alloc]init];
        loginVC.loginDelegate=self;
        [self.navigationController pushViewController:loginVC animated:YES];
    }
}

- (void)headHandler:(messageListModel *)jobListModel{
    
    if (!refreshAdded) {
        refreshAdded=YES;
        [_tableView addHeaderWithTarget:self action:@selector(headRefreshData)];
        [_tableView addFooterWithTarget:self action:@selector(footRefreshData)];
    }
    
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
            
            [MBProgressHUD showError:jobListModel.getInfo toView:self.view];
            
        }else{
            if ([jobListModel.getMessageArray count]==0){
                [MBProgressHUD showError:NOMOREDATA toView:self.view];
            }else{
                for (messageModel *object in jobListModel.getMessageArray) {
                    
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
    }
    
    else{
        
        if (![jobListModel.getStatus intValue]==0) {
            NSString *err=jobListModel.getInfo;
            [MBProgressHUD showError:err toView:self.view];
        }else{
            
            if ([jobListModel.getMessageArray count]==0){
                [MBProgressHUD showError:NONEWMESSAGE toView:self.view];
            }else{
                [recordArray removeAllObjects];
                
                for (messageModel *object in jobListModel.getMessageArray) {
                    
                    [recordArray addObject:object];
                }
                
                cellNum=[recordArray count];
                [self.tableView reloadData];

            }
        }
    }
}

//*********************tableView********************//
- (void)tableViewInit{
    if (!recordArray) {
        recordArray=[[NSMutableArray alloc]init];
    }
    
    [_tableView setDelegate:self];
    [_tableView setDataSource:self];
    _tableView.scrollEnabled=YES;
    _tableView.tableFooterView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
    
    [self headRefreshData];
}

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
    
    if ([recordArray objectAtIndex:[indexPath row]]) {
        jobModel *jobObject=[recordArray objectAtIndex:[indexPath row]];
        cell.titleLabel.text=jobObject.getjobTitle;
        cell.jobAddressLabel.text=[NSString stringWithFormat:@"%@%@",jobObject.getjobWorkPlaceCity,jobObject.getjobWorkPlaceDistrict];
        
        NSString *settlement;
        NSString *str=[NSString stringWithFormat:@"%@",jobObject.getjobSettlementWay];
        
        if ([str isEqualToString:@"0"])
            settlement=@"日";
        else if ([str isEqualToString:@"1"])
            settlement=@"周";
        else if ([str isEqualToString:@"2"])
            settlement=@"月";
        else if ([str isEqualToString:@"3"])
            settlement=@"项目";

        
        cell.jobPriceLabel.text=[NSString stringWithFormat:@"%@元/%@",jobObject.getjobSalaryRange,settlement];

        NSString *imageUrl;
        
        if ([jobObject.getjobEnterpriseImageURL length]>4) {
            if ([[jobObject.getjobEnterpriseImageURL substringToIndex:4] isEqualToString:@"http"])
                imageUrl=jobObject.getjobEnterpriseImageURL;
        }else if ([jobObject.getjobEnterpriseLogoURL length]>4) {
            if ([[jobObject.getjobEnterpriseLogoURL substringToIndex:4] isEqualToString:@"http"])
                imageUrl=jobObject.getjobEnterpriseLogoURL;
        }
        
        [cell.portraitView setImage:[UIImage imageNamed:@"placeholder"]];
        if ([imageUrl length]>4) {
            cell.portraitView.contentMode = UIViewContentModeScaleAspectFill;
            cell.portraitView.clipsToBounds = YES;
            [[AsyncImageLoader sharedLoader] cancelLoadingImagesForTarget:cell.portraitView];
            cell.portraitView.imageURL=[NSURL URLWithString:imageUrl];
        }
    }
    
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
    nowCellNum=[indexPath row];
    
    jobRecmendVC *detailVC=[[jobRecmendVC alloc]init];
    detailVC.handleDelegate=self;
    
    if ([recordArray objectAtIndex:[indexPath row]]) {
        detailVC.jobModel=[recordArray objectAtIndex:nowCellNum];
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
            
            
            messageModel *object=[recordArray objectAtIndex:[cellIndexPath row]];
            
            if (object.getinvite_id) {
                [netAPI refusedInvite:object.getinvite_id withBlock:^(oprationResultModel *oprationResultModel) {
                }];
            }
            
            [recordArray removeObjectAtIndex:[cellIndexPath row]];
            cellNum=[recordArray count];
            [_tableView deleteRowsAtIndexPaths:@[cellIndexPath] withRowAnimation:UITableViewRowAnimationLeft];
            
            badgeNumber *bn=[badgeNumber sharedInstance];
            [bn minusMessageCount];
            
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
    return YES;
}

- (BOOL)swipeableTableViewCell:(SWTableViewCell *)cell canSwipeToState:(SWCellState)state
{
    switch (state) {
        case 1:
            
            return YES;
            break;
        case 2:
            
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
