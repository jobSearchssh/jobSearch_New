//
//  MLFirstVC.m
//  jobSearch
//
//  Created by RAY on 15/1/16.
//  Copyright (c) 2015年 麻辣工作室. All rights reserved.
//

#import "MLFirstVC.h"
#import "MLCell1.h"
#import "NiftySearchView.h"
#import "MLMapView.h"
#import "MLFilterVC.h"
#import "jobDetailVC.h"
#import "MLMessageVC.h"
#import "MLMatchVC.h"
#import "MBProgressHUD.h"
#import "MJRefresh.h"
#import <AMapSearchKit/AMapSearchAPI.h>
#import <MAMapKit/MAMapKit.h>
#import "AJLocationManager.h"

@interface MLFirstVC ()<NiftySearchViewDelegate,UIActionSheetDelegate,UITableViewDataSource,UITableViewDelegate,SWTableViewCellDelegate,UITabBarDelegate,AMapSearchDelegate,finishFilterDelegate,UINavigationControllerDelegate>
{
    NSInteger cellNum;
    NSInteger sectionNum;
    NiftySearchView *searchView;
    MLMapView *mapView;
    NSMutableArray *recordArray;
    BOOL mapDisplaying;
    
    NSDateFormatter *dateFormatter;
    
    BOOL firstLoad;
    BOOL headerRefreshing;
    BOOL footerRefreshing;
    
    AMapSearchAPI *search;
    
    //页数
    int skipTimes;
    
    //查询类型  nearest/newest/keyword/distanceAndType
    NSString *searchType;
    NSString *keyWord;
    CLLocationCoordinate2D locationCoord;
    int distance;
    NSMutableArray *jobTypeArray;
}

@property (weak, nonatomic) IBOutlet UITabBar *tabbar;

@end

@implementation MLFirstVC
@synthesize tableView=_tableView;


static  MLFirstVC *thisVC=nil;

+ (MLFirstVC*)sharedInstance{
    if (thisVC==nil) {
        thisVC=[[MLFirstVC alloc]init];
    }
    return thisVC;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //初始化参数
    distance=20;
    jobTypeArray=[[NSMutableArray alloc]init];
    searchType=@"nearest";
    
    cellNum=0;
    sectionNum=0;
    skipTimes=0;
    firstLoad=YES;
    headerRefreshing=NO;
    footerRefreshing=NO;
    
    searchView = [[NiftySearchView alloc] initWithFrame:CGRectMake(0, -76, [[UIScreen mainScreen] bounds].size.width, 76)];
    searchView.delegate = self;
    [_tableView addSubview:searchView];
    searchView.alpha=0.0f;
    self.navigationController.navigationBar.translucent=NO;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"search"] style:UIBarButtonItemStylePlain target:self action:@selector(search)];
    self.navigationItem.rightBarButtonItem.tintColor=[UIColor whiteColor];
    self.navigationItem.leftBarButtonItem.tintColor=[UIColor whiteColor];
    
    self.title=@"附近的工作";
    
    dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM月dd日"];
    
    mapDisplaying=NO;
    [self tableViewInit];
    
    [self initTabbar];
    
    [self searchCity];
    
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

- (void)viewWillLayoutSubviews{
    
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:54.0/255.0 green:59.0/255.0 blue:81.0/255.0 alpha:1.0]];
    [self.tabbar setSelectedImageTintColor: [UIColor whiteColor]];
    
    //设置导航栏标题颜色及返回按钮颜色
    self.navigationController.navigationBar.barStyle = UIStatusBarStyleDefault;
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    NSMutableDictionary *titleBarAttributes = [NSMutableDictionary dictionaryWithDictionary:[[UINavigationBar appearance] titleTextAttributes]];
    [titleBarAttributes setValue:[UIColor whiteColor] forKey:UITextAttributeTextColor];
    
    [self.navigationController.navigationBar setTitleTextAttributes:titleBarAttributes];
}

- (void)finishFilter:(int)_distance Type:(NSMutableArray *)type{
    jobTypeArray=type;
    distance=_distance;
    firstLoad=YES;
    searchType=@"distanceAndType";
    [self headRefreshData];
}

- (void)headRefreshData{
    
    headerRefreshing=YES;
    skipTimes=0;
    
    if (firstLoad){
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    }
    [self refreshDataByType:NO];

}

- (void)footRefreshData{
    footerRefreshing=YES;
    
    [self refreshDataByType:YES];
}

- (void)refreshDataByType:(BOOL)_footer{
    
    //上拉加载继续
    if (_footer) {
        //按距离远近排序
        if ([searchType isEqualToString:@"nearest"]) {
            if (abs(locationCoord.latitude-99999.99)<0.001) {
                [self.tableView footerEndRefreshing];
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"定位失败" message:@"请检查是否已打开定位功能" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
                [alert show];
            }else{
                [netAPI getNearByJobs:@"nearest" longtitude:locationCoord.longitude latitude:locationCoord.latitude start:skipTimes*BASE_SPAN+1 length:BASE_SPAN withBlock:^(jobListModel *jobListModel) {
                    [self footHandler:jobListModel];
                }];
            }
        }
        //最新发布的职位
        else if ([searchType isEqualToString:@"newest"]){
            
            [netAPI getNewestJobs:@"newest" start:skipTimes*BASE_SPAN+1  length:BASE_SPAN withBlock:^(jobListModel *jobListModel) {
                [self footHandler:jobListModel];
            }];
            
        }
        //按关键字查询
        else if ([searchType isEqualToString:@"keyword"]){
            if ([keyWord length]<1) {
                [self.tableView footerEndRefreshing];
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"请输入关键字" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
                [alert show];
            }else{
                [netAPI getJobByKeyWord:@"keyword" start:skipTimes*BASE_SPAN+1 length:BASE_SPAN keyWord:keyWord withBlock:^(jobListModel *jobListModel) {
                    [self footHandler:jobListModel];
                }];
            }
        }
        //按距离和类型排序
        else if ([searchType isEqualToString:@"distanceAndType"]){
            if ([jobTypeArray count]==0) {
                if (abs(locationCoord.latitude-99999.99)<0.001) {
                    [self.tableView footerEndRefreshing];
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"定位失败" message:@"请检查是否已打开定位功能" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
                    [alert show];
                }else{
                    [netAPI getJobByDistance:@"distance" longtitude:locationCoord.longitude latitude:locationCoord.latitude start:skipTimes*BASE_SPAN+1 length:BASE_SPAN distance:distance withBlock:^(jobListModel *jobListModel) {
                        [self footHandler:jobListModel];
                    }];
                }
            }else{
                if (abs(locationCoord.latitude-99999.99)<0.001) {
                    [self.tableView footerEndRefreshing];
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"定位失败" message:@"请检查是否已打开定位功能" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
                    [alert show];
                }else{
                    [netAPI getJobByTypeAndDistance:@"distanceAndType" start:skipTimes*BASE_SPAN+1 length:BASE_SPAN longtitude:locationCoord.longitude latitude:locationCoord.latitude distance:distance jobType:jobTypeArray withBlock:^(jobListModel *jobListModel) {
                        [self footHandler:jobListModel];
                    }];
                }
            }
        }
    }
    
    //下拉加载刷新
    else{
        //按距离远近排序
        if ([searchType isEqualToString:@"nearest"]) {
            if (abs(locationCoord.latitude-99999.99)<0.001) {
                [self.tableView headerEndRefreshing];
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                firstLoad=NO;
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"定位失败" message:@"请检查是否已打开定位功能" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
                [alert show];
            }else{
                [netAPI getNearByJobs:@"nearby" longtitude:locationCoord.longitude latitude:locationCoord.latitude start:1 length:BASE_SPAN withBlock:^(jobListModel *jobListModel) {
                    [self headHandler:jobListModel];
                }];
            }
        }
        //最新发布的职位
        else if ([searchType isEqualToString:@"newest"]){
            [netAPI getNewestJobs:@"newest" start:1  length:BASE_SPAN withBlock:^(jobListModel *jobListModel) {
                [self headHandler:jobListModel];
            }];
        }
        //按关键字查询
        else if ([searchType isEqualToString:@"keyword"]){
            if ([keyWord length]<1) {
                firstLoad=NO;
                [self.tableView headerEndRefreshing];
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"请输入关键字" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
                [alert show];
            }else{
                [netAPI getJobByKeyWord:@"keyword" start:1 length:BASE_SPAN keyWord:keyWord withBlock:^(jobListModel *jobListModel) {
                    [self headHandler:jobListModel];
                }];
            }
        }
        //按距离和类型排序
        else if ([searchType isEqualToString:@"distanceAndType"]){
            if ([jobTypeArray count]==0) {
                if (abs(locationCoord.latitude-99999.99)<0.001) {
                    firstLoad=NO;
                    [self.tableView headerEndRefreshing];
                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"定位失败" message:@"请检查是否已打开定位功能" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
                    [alert show];
                }else{
                    if (abs(locationCoord.latitude-99999.99)<0.001) {
                        [self.tableView footerEndRefreshing];
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"定位失败" message:@"请检查是否已打开定位功能" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
                        [alert show];
                    }else{
                        [netAPI getJobByDistance:@"distance" longtitude:locationCoord.longitude latitude:locationCoord.latitude start:1 length:BASE_SPAN distance:distance withBlock:^(jobListModel *jobListModel) {
                            [self headHandler:jobListModel];
                        }];
                    }
                }
            }else{
                if (abs(locationCoord.latitude-99999.99)<0.001) {
                    firstLoad=NO;
                    [self.tableView headerEndRefreshing];
                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"定位失败" message:@"请检查是否已打开定位功能" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
                    [alert show];
                }else{
                    if (abs(locationCoord.latitude-99999.99)<0.001) {
                        [self.tableView footerEndRefreshing];
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"定位失败" message:@"请检查是否已打开定位功能" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
                        [alert show];
                    }else{
                        [netAPI getJobByTypeAndDistance:@"distanceAndType" start:1 length:BASE_SPAN longtitude:locationCoord.longitude latitude:locationCoord.latitude distance:distance jobType:jobTypeArray withBlock:^(jobListModel *jobListModel) {
                            [self headHandler:jobListModel];
                        }];
//                        [netAPI getJobByJobType:@"type" start:1 length:BASE_SPAN jobType:jobTypeArray withBlock:^(jobListModel *jobListModel) {
//                            [self headHandler:jobListModel];
//                        }];
                    }

                }
            }
        }
    }
}

- (void)headHandler:(jobListModel *)jobListModel{
    [self refreshData:jobListModel];
    
    skipTimes=1;
    if (firstLoad){
        [MBProgressHUD hideHUDForView:self.view animated:YES];
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
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"信息加载失败" message:@"数据请求失败，请稍后再试" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alert show];
            
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
    
    else{
        
        if (![jobListModel.getStatus intValue]==0) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"信息加载失败" message:@"网络有点不给力哦，请稍后再试~" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alert show];
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

- (void)initTabbar{
    
    [[self.tabbar.items objectAtIndex:0] setFinishedSelectedImage:[[UIImage imageNamed:@"location"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] withFinishedUnselectedImage:[[UIImage imageNamed:@"location"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [[self.tabbar.items objectAtIndex:0] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                        [UIColor whiteColor], UITextAttributeTextColor,
                                        nil] forState:UIControlStateNormal];
    
    
    [[self.tabbar.items objectAtIndex:1] setFinishedSelectedImage:[[UIImage imageNamed:@"catagory"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] withFinishedUnselectedImage:[[UIImage imageNamed:@"catagory"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [[self.tabbar.items objectAtIndex:1] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                                 [UIColor whiteColor], UITextAttributeTextColor,
                                                                 nil] forState:UIControlStateNormal];
    [[self.tabbar.items objectAtIndex:2] setFinishedSelectedImage:[[UIImage imageNamed:@"letter"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] withFinishedUnselectedImage:[[UIImage imageNamed:@"letter"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [[self.tabbar.items objectAtIndex:2] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                                 [UIColor whiteColor], UITextAttributeTextColor,
                                                                 nil] forState:UIControlStateNormal];
    [[self.tabbar.items objectAtIndex:3] setFinishedSelectedImage:[[UIImage imageNamed:@"target"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] withFinishedUnselectedImage:[[UIImage imageNamed:@"target"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [[self.tabbar.items objectAtIndex:3] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                                 [UIColor whiteColor], UITextAttributeTextColor,
                                                                 nil] forState:UIControlStateNormal];
    [[self.tabbar.items objectAtIndex:4] setFinishedSelectedImage:[[UIImage imageNamed:@"calendar"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] withFinishedUnselectedImage:[[UIImage imageNamed:@"calendar"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [[self.tabbar.items objectAtIndex:4] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                                 [UIColor whiteColor], UITextAttributeTextColor,
                                                                 nil] forState:UIControlStateNormal];
    self.tabbar.delegate=self;
}

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item{
    if (item.tag==0) {
        [self showMap];
    }else if (item.tag==1){
        [self sort];
    }else if (item.tag==2){
        [self showMessage];
    }else if (item.tag==3){
        [self filter];
    }else if (item.tag==4){
        [self showMatchInfo];
    }
}

- (void)showMatchInfo{
    MLMatchVC *matchVC=[MLMatchVC sharedInstance];
    matchVC.title=@"精灵匹配";
    [self.navigationController pushViewController:matchVC animated:YES];
}

- (void)showMap{
    if (!mapDisplaying) {
        if (!mapView) {
            mapView=[[MLMapView alloc]initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height-113)];
            mapView.alpha=0.0f;
            [self.view addSubview:mapView];
        }
        mapDisplaying=YES;
        [UIView animateWithDuration:0.4 animations:^{
            mapView.alpha=1.0f;
        }];
    }else {
        [UIView animateWithDuration:0.4 animations:^{
            mapView.alpha=0.0f;
        }];
        mapDisplaying=NO;
    }
}
- (void)showMessage{
    MLMessageVC *messageVC=[[MLMessageVC alloc]init];
    messageVC.title=@"消息";
    [self.navigationController pushViewController:messageVC animated:YES];
    
}

- (void)filter{
    MLFilterVC *filterVC=[[MLFilterVC alloc]init];
    filterVC.filterDelegate=self;
    [self.navigationController pushViewController:filterVC animated:YES];
}

//*********************ActionSheet********************//
- (void)sort{
    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                  initWithTitle:@"请选择排序类型"
                                  delegate:self
                                  cancelButtonTitle:@"取消"
                                  destructiveButtonTitle:nil
                                  otherButtonTitles: @"距离最近", @"最新发布",nil];

    [actionSheet showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        searchType=@"nearest";
        firstLoad=YES;
        [self headRefreshData];
    }else if (buttonIndex == 1) {
        searchType=@"newest";
        firstLoad=YES;
        [self headRefreshData];
    }
}

//*********************searchView********************//
- (void)search{
    [UIView animateWithDuration:0.4 animations:^{
        searchView.alpha=1.0f;
    }];
    if ([searchView.startTextField.text isEqualToString:NSLocalizedString(@"Current Location", nil)]) {
        searchView.startTextField.textColor = [UIColor blueColor];
    } else {
        searchView.startTextField.textColor = [UIColor blackColor];
    }
    if ([searchView.finishTextField.text isEqualToString:NSLocalizedString(@"Current Location", nil)]) {
        searchView.finishTextField.textColor = [UIColor blueColor];
    } else {
        searchView.finishTextField.textColor = [UIColor blackColor];
    }
    
    CGRect searchBarFrame = searchView.frame;
    searchBarFrame.origin.y = 0;
    [UIView animateWithDuration:0.4 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         searchView.frame = searchBarFrame;
                     }
                     completion:^(BOOL completion) {
                         [searchView.startTextField becomeFirstResponder];
                     }];
}

#pragma mark -
#pragma mark NiftySearchView Delegate Methods

- (void)startBookmarkButtonClicked:(UITextField *)textField
{
    NSLog(@"startBookmarkButtonClicked");
}
- (void)finishBookmarkButtonClicked:(UITextField *)textField
{
    NSLog(@"finishBookmarkButtonClicked");
}

- (void)niftySearchViewResigend
{
    NSLog(@"resignSearchView");
    [self hideSearchBar:self];
    
    [UIView animateWithDuration:0.4 animations:^{
        searchView.alpha=0.0f;
    }];
}

- (void)routeButtonClicked:(UITextField *)startTextField finishTextField:(UITextField *)finishTextField
{
    NSLog(@"routeButtonClicked");
}

- (IBAction)hideSearchBar:(id)sender
{
    [searchView.startTextField resignFirstResponder];
    [searchView.finishTextField resignFirstResponder];
    CGRect searchBarFrame = searchView.frame;
    searchBarFrame.origin.y = -76;
    [UIView animateWithDuration:0.4 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         searchView.frame = searchBarFrame;
                     }
                     completion:^(BOOL completion){
                         
                     }];
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
    
    //[cell setRightUtilityButtons:[self rightButtons] WithButtonWidth:58.0f];
    //cell.delegate = self;
    
    
    jobModel *jobObject=[recordArray objectAtIndex:[indexPath row]];
    
    cell.jobTitleLabel.text=jobObject.getjobTitle;
    cell.jobAddressLabel.text=[NSString stringWithFormat:@"%@%@",jobObject.getjobWorkPlaceCity,jobObject.getjobWorkPlaceDistrict];
    cell.jobTimeLabel.text=[NSString stringWithFormat:@"%@—%@",[dateFormatter stringFromDate:jobObject.getjobBeginTime],[dateFormatter stringFromDate:jobObject.getjobEndTime]];
    cell.jobDistance.text=[NSString stringWithFormat:@"%.1fKM",[jobModel getDistance:jobObject.getjobWorkPlaceGeoPoint]];
    int num=[jobObject.getjobRecruitNum intValue]-[jobObject.getjobHasAccepted intValue];
    cell.jobNumberRemainLabel.text=[NSString stringWithFormat:@"还剩%d人",num];
    cell.jobPriceLabel.text=[NSString stringWithFormat:@"%@元/天",jobObject.getjobSalaryRange];
    
    return cell;
}

- (NSArray *)rightButtons
{
    NSMutableArray *rightUtilityButtons = [NSMutableArray new];
    [rightUtilityButtons sw_addUtilityButtonWithColor:
     [UIColor colorWithRed:0.78f green:0.78f blue:0.8f alpha:1.0]
                                                title:@"More"];
    [rightUtilityButtons sw_addUtilityButtonWithColor:
     [UIColor colorWithRed:1.0f green:0.231f blue:0.188 alpha:1.0f]
                                                title:@"Delete"];
    
    return rightUtilityButtons;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return cellNum;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (cellNum==0)
        return 0;
    else
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
    
    detailVC.buttonTitle=@"一键申请";
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
            NSLog(@"More button was pressed");
            UIAlertView *alertTest = [[UIAlertView alloc] initWithTitle:@"Hello" message:@"More more more" delegate:nil cancelButtonTitle:@"cancel" otherButtonTitles: nil];
            [alertTest show];
            
            [cell hideUtilityButtonsAnimated:YES];
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

- (void)searchCity
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSUserDefaults *mySettingData = [NSUserDefaults standardUserDefaults];
    
    //获得用户位置信息
    [[AJLocationManager shareLocation] getLocationCoordinate:^(CLLocationCoordinate2D locationCorrrdinate) {
        locationCoord=locationCorrrdinate;
        
        [mySettingData setObject:NSStringFromCGPoint(CGPointMake(locationCorrrdinate.longitude, locationCorrrdinate.latitude)) forKey:@"currentCoordinate"];
        [mySettingData synchronize];
        
        [self headRefreshData];
        
    } error:^(NSError *error) {
        
        if ([mySettingData objectForKey:@"currentCoordinate"]) {

            CGPoint p=CGPointFromString([mySettingData objectForKey:@"currentCoordinate"]);
            locationCoord=CLLocationCoordinate2DMake(p.y, p.x);

        }else{
            locationCoord=CLLocationCoordinate2DMake(38.92, 116.46);
        }
        [self headRefreshData];
    }];
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
