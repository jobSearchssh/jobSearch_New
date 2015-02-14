//
//  MLMyApplication.m
//  jobSearch
//
//  Created by RAY on 15/1/27.
//  Copyright (c) 2015年 麻辣工作室. All rights reserved.
//

#import "MLMyApplication.h"
#import "MLCell1.h"
#import "jobDetailVC.h"
#import "MBProgressHUD.h"
#import "MBProgressHUD+Add.h"
#import "MJRefresh.h"

static NSString *userId = @"54d76bd496d9aece6f8b4568";

@interface MLMyApplication ()<UITableViewDataSource,UITableViewDelegate,SWTableViewCellDelegate>
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
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic)BOOL inBackground;;

@end

@implementation MLMyApplication

static  MLMyApplication *thisVC=nil;

+ (MLMyApplication*)sharedInstance{
    thisVC.inBackground=YES;
    if (thisVC==nil) {
        thisVC=[[MLMyApplication alloc]init];
        thisVC.inBackground=NO;
    }
    return thisVC;
}

- (void)viewWillLayoutSubviews{
    self.title=@"我的申请";
    //设置导航栏标题颜色及返回按钮颜色
    self.navigationController.navigationBar.barStyle = UIStatusBarStyleDefault;
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    NSMutableDictionary *titleBarAttributes = [NSMutableDictionary dictionaryWithDictionary:[[UINavigationBar appearance] titleTextAttributes]];
    [titleBarAttributes setValue:[UIColor whiteColor] forKey:UITextAttributeTextColor];
    
    [self.navigationController.navigationBar setTitleTextAttributes:titleBarAttributes];
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
    self.inBackground=NO;
    dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM月dd日"];

    [self tableViewInit];
}

- (void)viewDidAppear:(BOOL)animated{
    //[self refreshInBackground];
}

- (void)headRefreshData{
    
    headerRefreshing=YES;
    skipTimes=0;
    
    if (firstLoad){
        [MBProgressHUD showHUDAddedTo:_tableView animated:YES];
        firstLoad=NO;
    }
    [netAPI getApplyJobs:userId start:1 length:BASE_SPAN withBlock:^(jobAppliedListModel *jobListModel) {
        [self headHandler:jobListModel];
    }];
}

- (void)footRefreshData{
    footerRefreshing=YES;
    
    [netAPI getApplyJobs:userId start:skipTimes*BASE_SPAN+1 length:BASE_SPAN withBlock:^(jobAppliedListModel *jobListModel) {
        [self footHandler:jobListModel];
    }];
}

- (void)headHandler:(jobAppliedListModel *)jobListModel{
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

- (void)footHandler:(jobAppliedListModel *)jobListModel{
    [self refreshData:jobListModel];
    
    footerRefreshing=NO;
    skipTimes+=1;
    [self.tableView footerEndRefreshing];
}


- (void)refreshData:(jobAppliedListModel *)jobListModel{
    
    if (footerRefreshing) {
        if (![jobListModel.getStatus intValue]==0) {
            NSString *err=jobListModel.getInfo;
            [MBProgressHUD showError:err toView:self.view];
            
        }else{
            
            for (id object in jobListModel.getjobAppliedArray) {
                [recordArray addObject:object];
            }
            
            NSMutableArray *insertIndexPaths = [NSMutableArray arrayWithCapacity:10];
            
            NSInteger n=[recordArray count];
            NSInteger m=[jobListModel.getjobAppliedArray count];
            
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
            if (self.inBackground) {
                self.inBackground=NO;
            }else{
                NSString *err=jobListModel.getInfo;
                [MBProgressHUD showError:err toView:self.view];
            }
        }else{
            self.inBackground=NO;

            [recordArray removeAllObjects];
            
            for (id object in jobListModel.getjobAppliedArray) {
                [recordArray addObject:object];
            }
            
            cellNum=[recordArray count];
            [self.tableView reloadData];
        }
    }
}

- (void)refreshInBackground{
    if (self.inBackground) {
        headerRefreshing=YES;
        skipTimes=0;
        [netAPI getApplyJobs:userId start:1 length:BASE_SPAN withBlock:^(jobAppliedListModel *jobListModel) {
            [self headHandler:jobListModel];
        }];
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
    
    jobAppliedModel *jobObject=[recordArray objectAtIndex:[indexPath row]];
    
    cell.jobTitleLabel.text=jobObject.getjobTitle;
    cell.jobAddressLabel.text=[NSString stringWithFormat:@"%@%@",jobObject.getjobWorkPlaceCity,jobObject.getjobWorkPlaceDistrict];
    cell.jobTimeLabel.text=[NSString stringWithFormat:@"%@—%@",[dateFormatter stringFromDate:jobObject.getjobBeginTime],[dateFormatter stringFromDate:jobObject.getjobEndTime]];
    cell.jobDistance.text=[NSString stringWithFormat:@"%.1fKM",[jobModel getDistance:jobObject.getjobWorkPlaceGeoPoint]];
    
    NSString *status;
    if ([jobObject.getjobApplyStatus intValue]==0) {
        status=@"未处理";
    }else if ([jobObject.getjobApplyStatus intValue]==1){
        status=@"已拒绝";
    }else if ([jobObject.getjobApplyStatus intValue]==2){
        status=@"已接受";
    }
    if (status) {
        cell.jobNumberRemainLabel.text=status;
    }
    
    NSString *settlement;
    NSString *str=[NSString stringWithFormat:@"%@",jobObject.getjobSettlementWay];
    
    if ([str isEqualToString:@"0"])
        settlement=@"日";
    else if ([str isEqualToString:@"1"])
        settlement=@"月";
    else if ([str isEqualToString:@"2"])
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
    
    jobAppliedModel *appliedModel=[recordArray objectAtIndex:[indexPath row]];
    
    if ([recordArray objectAtIndex:[indexPath row]]) {
        detailVC.jobModel=(jobModel*)appliedModel;
    }
    
    if ([appliedModel.getjobApplyStatus intValue]==2) {
        detailVC.origin=@"2";
        if (appliedModel.getjobPhone) {
            detailVC.contactPhoneNumber=appliedModel.getjobPhone;
        }
    }else{
        detailVC.origin=@"1";
    }
    
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
