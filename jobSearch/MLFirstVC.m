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

@interface MLFirstVC ()<NiftySearchViewDelegate,UIActionSheetDelegate,UITableViewDataSource,UITableViewDelegate,SWTableViewCellDelegate,UITabBarDelegate,AMapSearchDelegate>
{
    NSInteger cellNum;
    NiftySearchView *searchView;
    MLMapView *mapView;
    NSMutableArray *recordArray;
    BOOL mapDisplaying;
    
    NSDateFormatter *dateFormatter;
    
    BOOL firstLoad;
    
    BOOL headerRefreshing;
    BOOL footerRefreshing;
    
    AMapSearchAPI *search;
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
 
    cellNum=0;
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
    [dateFormatter setDateFormat:@"yyyy年MM月dd日"];
    
    [self tableViewInit];
    
    mapDisplaying=NO;
    
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

- (void)refreshData{
    if (!headerRefreshing)
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [netAPI getNearByJobs:116.46 latitude:49.92 withBlock:^(nearByJobListModel *nearByJobListModel) {
        if (!headerRefreshing)
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        else
            headerRefreshing=NO;
        
        [self.tableView headerEndRefreshing];
        
        if (![nearByJobListModel.getStatus intValue]==0) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"信息加载失败" message:@"网络有点不给力哦，请稍后再试~" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alert show];
        }else{
            
            [recordArray removeAllObjects];
            
            for (id object in nearByJobListModel.getnearByJobListArray) {
                [recordArray addObject:object];
            }
            
            cellNum=[recordArray count];
            [self.tableView reloadData];
        }
    }];
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
    [self.navigationController pushViewController:filterVC animated:YES];
}

//*********************ActionSheet********************//
- (void)sort{
    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                  initWithTitle:@"请选择排序类型"
                                  delegate:self
                                  cancelButtonTitle:@"取消"
                                  destructiveButtonTitle:nil
                                  otherButtonTitles:@"智能排序", @"距离最近", @"最新发布",nil];

    [actionSheet showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        
    }else if (buttonIndex == 1) {
        
    }else if(buttonIndex == 2) {
        
    }else if(buttonIndex == 3) {
        
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
    [_tableView addHeaderWithTarget:self action:@selector(headerRereshing)];
    [_tableView addFooterWithTarget:self action:@selector(footerRereshing)];
    [self refreshData];
}

- (void)headerRereshing{
    headerRefreshing=YES;
    //skipTimes=0;
    [self refreshData];
}

- (void)footerRereshing{
    footerRefreshing=YES;
    [self refreshData];
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
    
    
    nearByJobModel *jobObject=[recordArray objectAtIndex:[indexPath row]];
    
    cell.jobTitleLabel.text=jobObject.getjobTitle;
    cell.jobAddressLabel.text=[NSString stringWithFormat:@"%@%@",jobObject.getjobWorkPlaceCity,jobObject.getjobWorkPlaceDistrict];
    cell.jobTimeLabel.text=[NSString stringWithFormat:@"%@—%@",[dateFormatter stringFromDate:jobObject.getjobBeginTime],[dateFormatter stringFromDate:jobObject.getjobEndTime]];
    cell.jobDistance.text=@"1.2km";
    cell.jobNumberRemainLabel.text=[NSString stringWithFormat:@"还剩%@人",jobObject.getjobRecruitNum];
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
    //获得用户位置信息
    [[AJLocationManager shareLocation] getLocationCoordinate:^(CLLocationCoordinate2D locationCorrrdinate) {
        
        NSLog(@"%f  %f",locationCorrrdinate.latitude,locationCorrrdinate.longitude);
//        NSUserDefaults *mySettingData = [NSUserDefaults standardUserDefaults];
//        [mySettingData setObject:NSStringFromCGPoint(CGPointMake(locationCorrrdinate.longitude, locationCorrrdinate.latitude)) forKey:@"currentCoordinate"];
//        
//        [MAMapServices sharedServices].apiKey =@"269c3b70b59f61d9885ca37fbd74f582";
//        
//        search=[[AMapSearchAPI alloc] initWithSearchKey: @"41f0145aa2a77c39924ee9aa0664701f" Delegate:self];
//        search.delegate=self;
//        AMapReGeocodeSearchRequest *regeoRequest = [[AMapReGeocodeSearchRequest alloc] init];
//        regeoRequest.searchType = AMapSearchType_ReGeocode;
//        regeoRequest.location = [AMapGeoPoint locationWithLatitude:locationCorrrdinate.latitude longitude:locationCorrrdinate.longitude];
//        regeoRequest.radius = 10000;
//        regeoRequest.requireExtension = YES;
//        
//        [search AMapReGoecodeSearch: regeoRequest];
        
    }];
}

- (void)onReGeocodeSearchDone:(AMapReGeocodeSearchRequest *)request response:(AMapReGeocodeSearchResponse *)response
{
//    if (response) {
//        
//        if ([response.regeocode.addressComponent.city length]>0) {
//            if (![response.regeocode.addressComponent.city isEqualToString:currentCity]) {
//                
//                currentCity=response.regeocode.addressComponent.city;
//                currentCityCode=response.regeocode.addressComponent.citycode;
//                
//                
//                NSString *str=[NSString stringWithFormat:@"亲爱的用户，定位到您再%@，是否切换城市？",currentCity];
//                changeCityAlert = [[UIAlertView alloc] initWithTitle:@"切换城市" message:str delegate:nil cancelButtonTitle:@"切换" otherButtonTitles:@"取消",nil];
//                changeCityAlert.delegate=self;
//                [changeCityAlert show];
//            }
//        }else{
//            if (![response.regeocode.addressComponent.province isEqualToString:currentCity]) {
//                
//                currentCity=response.regeocode.addressComponent.province;
//                currentCityCode=response.regeocode.addressComponent.citycode;
//                
//                NSString *str=[NSString stringWithFormat:@"亲爱的用户，定位到您再%@，是否切换城市？",currentCity];
//                changeCityAlert = [[UIAlertView alloc] initWithTitle:@"切换城市" message:str delegate:nil cancelButtonTitle:@"切换" otherButtonTitles:@"取消",nil];
//                changeCityAlert.delegate=self;
//                [changeCityAlert show];
//            }
//        }
//    }
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
