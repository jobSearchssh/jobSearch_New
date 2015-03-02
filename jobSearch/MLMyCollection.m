//
//  MLMyCollection.m
//  jobSearch
//
//  Created by RAY on 15/1/27.
//  Copyright (c) 2015年 麻辣工作室. All rights reserved.
//

#import "MLMyCollection.h"
#import "MLCell1.h"
#import "jobDetailVC.h"
#import "MBProgressHUD.h"
#import "MBProgressHUD+Add.h"
#import "MJRefresh.h"
#import "MLLoginVC.h"


@interface MLMyCollection ()<UITableViewDataSource,UITableViewDelegate,SWTableViewCellDelegate,finishLoginDelegate>
{
    NSInteger cellNum;
    NSDateFormatter *dateFormatter;
    NSInteger sectionNum;
    NSMutableArray *recordArray;
    BOOL firstLoad;
    BOOL headerRefreshing;
    BOOL footerRefreshing;
    BOOL refreshAdded;
    //页数
    int skipTimes;
    
    BOOL NotFirstRefresh;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation MLMyCollection

static  MLMyCollection *thisVC=nil;

+ (MLMyCollection*)sharedInstance{
    if (thisVC==nil) {
        thisVC=[[MLMyCollection alloc]init];
    }
    return thisVC;
}

- (void)viewWillLayoutSubviews{
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    refreshAdded=NO;
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

- (void)finishLogin{
    firstLoad=YES;
    [self headRefreshData];
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

- (void)headRefreshData{
    NSUserDefaults *myData = [NSUserDefaults standardUserDefaults];
    NSString *currentUserObjectId=[myData objectForKey:@"currentUserObjectId"];
    if ([currentUserObjectId length]>0) {
    
        headerRefreshing=YES;
        skipTimes=0;
    
        if (firstLoad){
            [MBProgressHUD showHUDAddedTo:_tableView animated:YES];
        }

        [netAPI getSaveJobList:currentUserObjectId start:1 length:BASE_SPAN withBlock:^(jobListModel *jobListModel) {
            [self headHandler:jobListModel];
        }];
    }
    else{
        
        if (!refreshAdded) {
            refreshAdded=YES;
            [_tableView addHeaderWithTarget:self action:@selector(headRefreshData)];
            [_tableView addFooterWithTarget:self action:@selector(footRefreshData)];
        }
        
        UIAlertView *loginAlert=[[UIAlertView alloc]initWithTitle:@"未登录" message:@"是否现在登录？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"登录", nil];
        [loginAlert show];
    }
}

- (void)footRefreshData{
    NSUserDefaults *myData = [NSUserDefaults standardUserDefaults];
    NSString *currentUserObjectId=[myData objectForKey:@"currentUserObjectId"];
    
    if ([currentUserObjectId length]>0) {
    
        footerRefreshing=YES;
    
        [netAPI getSaveJobList:currentUserObjectId start:skipTimes*BASE_SPAN+1 length:BASE_SPAN withBlock:^(jobListModel *jobListModel) {
            [self footHandler:jobListModel];
        }];
    }
    else{
        UIAlertView *loginAlert=[[UIAlertView alloc]initWithTitle:@"未登录" message:@"是否现在登录？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"登录", nil];
        [loginAlert show];

    }
}

- (void)headHandler:(jobListModel *)jobListModel{
    
    if (!refreshAdded) {
        refreshAdded=YES;
        [_tableView addHeaderWithTarget:self action:@selector(headRefreshData)];
        [_tableView addFooterWithTarget:self action:@selector(footRefreshData)];
    }
    
    [self refreshData:jobListModel];
    
    skipTimes=1;
    if (firstLoad){
        [MBProgressHUD hideHUDForView:_tableView animated:YES];
        firstLoad=NO;
    }
    headerRefreshing=NO;
    [self.tableView headerEndRefreshing];
}

- (void)footHandler:(jobListModel *)jobListModel{
    [self refreshData:jobListModel];
    
    footerRefreshing=NO;
    skipTimes+=1;
    [self.tableView footerEndRefreshing];
}


- (void)refreshData:(jobListModel *)jobListModel{
    
    if (footerRefreshing) {
        if (![jobListModel.getStatus intValue]==0) {
            NSString *err=jobListModel.getInfo;

            [MBProgressHUD showError:err toView:self.view];
            
        }else{
            
            if ([jobListModel.getJobArray count]==0) {
                [MBProgressHUD showError:@"没有更多数据啦" toView:self.view];
            }else{
                for (id object in jobListModel.getJobArray) {
                    [recordArray addObject:object];
                }
                
                NSMutableArray *insertIndexPaths = [NSMutableArray arrayWithCapacity:10];
                
                NSInteger n=[recordArray count];
                NSInteger m=[jobListModel.getJobArray count];
                
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
            
            if ([jobListModel.getJobArray count]==0) {
                [MBProgressHUD showError:@"您没有收藏记录哦" toView:self.view];
            }else{
                [recordArray removeAllObjects];
                
                for (id object in jobListModel.getJobArray) {
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
    recordArray=[[NSMutableArray alloc]init];
    
    [_tableView setDelegate:self];
    [_tableView setDataSource:self];
    _tableView.scrollEnabled=YES;
    _tableView.tableFooterView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
    
    [self headRefreshData];
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    BOOL nibsRegistered = NO;
    
    static NSString *Cellidentifier=@"MLCell1";
    if (!nibsRegistered) {
        UINib *nib = [UINib nibWithNibName:@"MLCell1" bundle:nil];
        [tableView registerNib:nib forCellReuseIdentifier:Cellidentifier];
        nibsRegistered = YES;
    }
    
    MLCell1 *cell = [tableView dequeueReusableCellWithIdentifier:Cellidentifier forIndexPath:indexPath];
    [cell setRightUtilityButtons:[self rightButtons] WithButtonWidth:58.0f];
    cell.delegate = self;
    
    jobModel *jobObject=[recordArray objectAtIndex:[indexPath row]];
    
    cell.jobTitleLabel.text=jobObject.getjobTitle;
    cell.jobAddressLabel.text=[NSString stringWithFormat:@"%@%@",jobObject.getjobWorkPlaceCity,jobObject.getjobWorkPlaceDistrict];
    cell.jobTimeLabel.text=[NSString stringWithFormat:@"%@—%@",[dateFormatter stringFromDate:jobObject.getjobBeginTime],[dateFormatter stringFromDate:jobObject.getjobEndTime]];
    cell.jobDistance.text=[NSString stringWithFormat:@"%.1fKM",[jobModel getDistance:jobObject.getjobWorkPlaceGeoPoint]];
    int num=[jobObject.getjobRecruitNum intValue]-[jobObject.getjobHasAccepted intValue];
    cell.jobNumberRemainLabel.text=[NSString stringWithFormat:@"还剩%d人",num];
    
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
    
    if ([imageUrl length]>4) {
        cell.portraitView.contentMode = UIViewContentModeScaleAspectFill;
        cell.portraitView.clipsToBounds = YES;
        [[AsyncImageLoader sharedLoader] cancelLoadingImagesForTarget:cell.portraitView];
        cell.portraitView.imageURL=[NSURL URLWithString:imageUrl];
    }else{
        cell.portraitView.image=[UIImage imageNamed:@"placeholder"];
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
    return cellNum;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

//改变行高
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    jobDetailVC *detailVC=[[jobDetailVC alloc]init];
    if ([recordArray objectAtIndex:[indexPath row]]) {
        detailVC.jobModel=[recordArray objectAtIndex:[indexPath row]];
    }
    
    detailVC.origin=@"0";
    
    detailVC.hidesBottomBarWhenPushed=YES;
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] init];
    backItem.title = @"";
    backItem.tintColor=[UIColor colorWithRed:23.0/255.0 green:87.0/255.0 blue:50.0/255.0 alpha:1.0];
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
            [MBProgressHUD showHUDAddedTo:_tableView animated:YES];
            
            NSIndexPath *cellIndexPath = [_tableView indexPathForCell:cell];
            
            NSInteger row=[cellIndexPath row];
            
            jobModel *jm=[recordArray objectAtIndex:row];
            
            NSUserDefaults *myData = [NSUserDefaults standardUserDefaults];
            NSString *currentUserObjectId=[myData objectForKey:@"currentUserObjectId"];
            if ([currentUserObjectId length]>0) {
            
            [netAPI deleteTheJob:currentUserObjectId jobID:jm.getjobID withBlock:^(oprationResultModel *oprationResultModel) {
                
                [MBProgressHUD hideAllHUDsForView:_tableView animated:YES];
                
                if ([oprationResultModel.getStatus intValue]==0) {
                    [recordArray removeObjectAtIndex:row];
                    cellNum=[recordArray count];
                    [_tableView deleteRowsAtIndexPaths:@[cellIndexPath] withRowAnimation:UITableViewRowAnimationLeft];
                }else{
                    NSString *err=oprationResultModel.getInfo;
                    [MBProgressHUD showError:err toView:self.view];
                }
            }];
            }
            else{
                UIAlertView *loginAlert=[[UIAlertView alloc]initWithTitle:@"未登录" message:@"是否现在登录？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"登录", nil];
                [loginAlert show];
            }
            
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
