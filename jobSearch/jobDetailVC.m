//
//  jobDetailVC.m
//  jobSearch
//
//  Created by RAY on 15/1/18.
//  Copyright (c) 2015年 麻辣工作室. All rights reserved.
//

#import "jobDetailVC.h"
#import "MLMapView.h"
#import "MBProgressHUD.h"
#import "MBProgressHUD+Add.h"
#import "PopoverView.h"
#import "freeselectViewCell.h"
#import "netAPI.h"
#import "AsyncImageView.h"
#import <ShareSDK/ShareSDK.h>
#import "MLLoginVC.h"

static NSString *selectFreecellIdentifier = @"freeselectViewCell";

@interface jobDetailVC ()<UICollectionViewDataSource,UICollectionViewDelegate,UIActionSheetDelegate>
{
    NSMutableArray  *addedPicArray;
    NSArray  *selectfreetimepicArray;
    NSArray  *selectfreetimetitleArray;
    CGFloat freecellwidth;
    bool selectFreeData[21];
    
    MLMapView *mapView;
    
}
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *scrollViewBottomConstraint;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *containerViewHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *jobDescribleLabelHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *jobRequireLabelHeightConstraint;
@property (strong, nonatomic) IBOutlet UIView *view1;
@property (weak, nonatomic) IBOutlet UICollectionView *selectfreeCollectionOutlet;

@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet AsyncImageView *entepriseLogoView;
@property (weak, nonatomic) IBOutlet UILabel *jobTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *jobAddressLabel;
@property (weak, nonatomic) IBOutlet UILabel *jobDistanceLabel;
@property (weak, nonatomic) IBOutlet UILabel *jobPublishTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *jobWorkPeriodLabel;
@property (weak, nonatomic) IBOutlet UILabel *jobRecuitNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *jobSalaryLabel;
@property (weak, nonatomic) IBOutlet UILabel *jobDescribeLabel;
@property (weak, nonatomic) IBOutlet UILabel *jobRequireLabel;

@property (strong, nonatomic) NSString *buttonTitle;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *emailLabel;

@end

@implementation jobDetailVC
@synthesize applyButton;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if ([self.origin isEqualToString:@"1"]) {
        self.applyButton.hidden=YES;
        self.phoneLabel.hidden=YES;
        self.scrollViewBottomConstraint.constant=-44;
    }else if ([self.origin isEqualToString:@"2"]){
        self.buttonTitle=@"联系企业";
        self.phoneLabel.hidden=NO;
        [self.applyButton setTitle:self.buttonTitle forState:UIControlStateNormal];
    }
    
    UIBarButtonItem *buttonItem1=[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"export"] style:UIBarButtonItemStylePlain target:self action:@selector(shareJob)];
    buttonItem1.tintColor=[UIColor colorWithRed:174.0/255.0 green:197.0/255.0 blue:80.0/255.0 alpha:1.0];
    UIBarButtonItem *buttonItem2=[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"star"] style:UIBarButtonItemStylePlain target:self action:@selector(saveJob)];
    buttonItem2.tintColor=[UIColor colorWithRed:174.0/255.0 green:197.0/255.0 blue:80.0/255.0 alpha:1.0];
    self.navigationItem.rightBarButtonItems = @[buttonItem1,buttonItem2];
    
    mapView=[[MLMapView alloc]initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, 200)];
    [self.containerView addSubview:mapView];
    
    self.emailLabel.hidden=YES;
    
    [self initData];
    [self timeCollectionViewInit];
    
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex==0) {
        //打电话
        NSString * str=[[NSString alloc] initWithFormat:@"tel:%@",self.contactPhoneNumber];
        UIWebView * callWebview = [[UIWebView alloc] init];
        [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
        [self.view addSubview:callWebview];
        
    }else if (buttonIndex==1){
        //发短信
        NSString *str=[[NSString alloc]initWithFormat:@"sms://%@",self.contactPhoneNumber];
        [[UIApplication sharedApplication]openURL:[NSURL URLWithString:str]];
    }
}


- (IBAction)applyTheJob:(id)sender {
    
    if ([self.origin isEqualToString:@"2"]) {
 
        if (self.contactPhoneNumber) {
            UIActionSheet *actionSheet=[[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"打电话给企业",@"发短信给企业", nil];
            [actionSheet showInView:self.view];
            
        }else{
            [MBProgressHUD showError:@"该企业暂未提供联系方式" toView:self.view];
        }
        
    }else{
    
        NSUserDefaults *myData = [NSUserDefaults standardUserDefaults];
        NSString *currentUserObjectId=[myData objectForKey:@"currentUserObjectId"];
        if ([currentUserObjectId length]>0) {

        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [netAPI applyTheJob:currentUserObjectId jobID:self.jobModel.getjobID withBlock:^(jobApplyModel *oprationResultModel) {
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            if (![oprationResultModel.getStatus intValue]==0) {
                NSString *err=oprationResultModel.getInfo;
                [MBProgressHUD showError:err toView:self.view];
            }
            else
            {
                [MBProgressHUD showSuccess:@"申请成功" toView:self.view];
            }
        }];
        }else{
            UIAlertView *loginAlert=[[UIAlertView alloc]initWithTitle:@"未登录" message:@"是否现在登录？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"登录", nil];
            [loginAlert show];
        }
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (buttonIndex==1) {
        MLLoginVC *loginVC=[[MLLoginVC alloc]init];
        [self.navigationController pushViewController:loginVC animated:YES];
    }
}


- (void)viewDidAppear:(BOOL)animated{
    
}

- (void)timeCollectionViewInit{
    selectfreetimepicArray = [[NSMutableArray alloc]init];
    selectfreetimetitleArray = [[NSMutableArray alloc]init];
    freecellwidth = ([UIScreen mainScreen].bounds.size.width - 120)/7;
    
    selectfreetimetitleArray = @[[UIImage imageNamed:@"resume_7"],
                                 [UIImage imageNamed:@"resume_1"],
                                 [UIImage imageNamed:@"resume_2"],
                                 [UIImage imageNamed:@"resume_3"],
                                 [UIImage imageNamed:@"resume_4"],
                                 [UIImage imageNamed:@"resume_5"],
                                 [UIImage imageNamed:@"resume_6"],
                                 
                                 ];
    
    selectfreetimepicArray = @[[UIImage imageNamed:@"resume_am1"],
                               [UIImage imageNamed:@"resume_am2"],
                               [UIImage imageNamed:@"resume_pm1"],
                               [UIImage imageNamed:@"resume_pm2"],
                               [UIImage imageNamed:@"resume_night1"],
                               [UIImage imageNamed:@"resume_night2"]
                               ];
    
    for (int index = 0; index<21; index++) {
        selectFreeData[index] = FALSE;
    }
   
    for (NSNumber *t in self.jobModel.getjobWorkTime) {
        if ([t intValue]>0) {
            int n=[t intValue];
            if (n<21&&n>=0) {
                selectFreeData[n]=TRUE;
            }
            
        }
    }

    self.selectfreeCollectionOutlet.delegate = self;
    self.selectfreeCollectionOutlet.dataSource = self;
    UINib *niblogin = [UINib nibWithNibName:selectFreecellIdentifier bundle:nil];
    [self.selectfreeCollectionOutlet registerNib:niblogin forCellWithReuseIdentifier:selectFreecellIdentifier];
}


- (void)updateConstraints{
    
    //工作描述label
    CGRect rect1 =[self.jobDescribeLabel.text boundingRectWithSize:CGSizeMake([[UIScreen mainScreen] bounds].size.width-16, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13]}  context:nil];
    self.jobDescribleLabelHeightConstraint.constant=rect1.size.height;

    //任职要求label
    CGRect rect2 =[self.jobRequireLabel.text boundingRectWithSize:CGSizeMake([[UIScreen mainScreen] bounds].size.width-16, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13]}  context:nil];
    self.jobRequireLabelHeightConstraint.constant=rect2.size.height;

    self.containerViewHeightConstraint.constant=430+rect1.size.height+rect2.size.height;
}

- (void)initData{
    if (self.jobModel) {
        
        
        NSString *imageUrl;
        
        if ([self.jobModel.getjobEnterpriseImageURL length]>4) {
            if ([[self.jobModel.getjobEnterpriseImageURL substringToIndex:4] isEqualToString:@"http"])
                imageUrl=self.jobModel.getjobEnterpriseImageURL;
        }else if ([self.jobModel.getjobEnterpriseLogoURL length]>4) {
            if ([[self.jobModel.getjobEnterpriseLogoURL substringToIndex:4] isEqualToString:@"http"])
                imageUrl=self.jobModel.getjobEnterpriseLogoURL;
        }
        
        if ([imageUrl length]>4) {
            self.entepriseLogoView.contentMode = UIViewContentModeScaleAspectFill;
            self.entepriseLogoView.clipsToBounds = YES;
            [[AsyncImageLoader sharedLoader] cancelLoadingImagesForTarget:self.entepriseLogoView];
            self.entepriseLogoView.imageURL=[NSURL URLWithString:imageUrl];
        }else{
            self.entepriseLogoView.image=[UIImage imageNamed:@"placeholder"];
        }

        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"MM月dd日"];

        self.jobTitleLabel.text=self.jobModel.getjobTitle;
        self.jobAddressLabel.text=[NSString stringWithFormat:@"%@%@%@",self.jobModel.getjobWorkPlaceCity,self.jobModel.getjobWorkPlaceDistrict,self.jobModel.getjobWorkAddressDetail];
        
        self.jobDistanceLabel.text=[NSString stringWithFormat:@"%.1f千米",[jobModel getDistance:self.jobModel.getjobWorkPlaceGeoPoint]];
        
        self.jobPublishTimeLabel.text=[dateFormatter stringFromDate:self.jobModel.getcreated_at];
        self.jobWorkPeriodLabel.text=[NSString stringWithFormat:@"%@—%@",[dateFormatter stringFromDate:self.jobModel.getjobBeginTime],[dateFormatter stringFromDate:self.jobModel.getjobEndTime]];
        
        self.jobRecuitNumLabel.text=[NSString stringWithFormat:@"招募数量：%d/%d人",[self.jobModel.getjobHasAccepted intValue],[self.jobModel.getjobRecruitNum intValue]];
        
        NSString *settlement;
        NSString *str=[NSString stringWithFormat:@"%@",self.jobModel.getjobSettlementWay];

        if ([str isEqualToString:@"0"])
            settlement=@"日";
        else if ([str isEqualToString:@"1"])
            settlement=@"月";
        else if ([str isEqualToString:@"2"])
            settlement=@"项目";
        
        self.jobSalaryLabel.text=[NSString stringWithFormat:@"%@元/%@",self.jobModel.getjobSalaryRange,settlement];

        self.jobDescribeLabel.text=[NSString stringWithFormat:@"【工作描述】%@",self.jobModel.getjobIntroduction];
        
        NSString *gender;
        NSString *genStr=[NSString stringWithFormat:@"%@",_jobModel.getjobGenderReq];
        if ([genStr isEqualToString:@"0"]) {
            gender=@"【性别要求】不限";
        }else if ([genStr isEqualToString:@"1"]){
            gender=@"【性别要求】男";
        }else if ([genStr isEqualToString:@"2"]){
            gender=@"【性别要求】女";
        }
        
        NSString *degree;
        
        if ([_jobModel.getjobDegreeReq intValue]==1){
            degree=@"【学历要求】初中";
        }else if ([_jobModel.getjobDegreeReq intValue]==2){
            degree=@"【学历要求】高中";
        }else if ([_jobModel.getjobDegreeReq intValue]==3){
            degree=@"【学历要求】大专";
        }else if ([_jobModel.getjobDegreeReq intValue]==4){
            degree=@"【学历要求】本科";
        }else if ([_jobModel.getjobDegreeReq intValue]==5){
            degree=@"【学历要求】硕士";
        }else if ([_jobModel.getjobDegreeReq intValue]==6){
            degree=@"【学历要求】博士及以上";
        }

        NSString *age=[NSString stringWithFormat:@"【年龄要求】%@—%@岁",self.jobModel.getjobAgeStartReq,self.jobModel.getjobAgeEndReq];
        NSString *height=[NSString stringWithFormat:@"【身高要求】%@—%@cm",self.jobModel.getjobHeightStartReq,self.jobModel.getjobHeightEndReq];
        
        NSString *textString=[[NSString alloc]init];
        if (age) {
            textString=[textString stringByAppendingString:[NSString stringWithFormat:@"%@\n",age]];
        }
        if (degree) {
            textString=[textString stringByAppendingString:[NSString stringWithFormat:@"%@\n",degree]];
        }
        if (height) {
            textString=[textString stringByAppendingString:[NSString stringWithFormat:@"%@\n",height]];
        }
        if (gender) {
            textString=[textString stringByAppendingString:[NSString stringWithFormat:@"%@\n",gender]];
        }
        self.jobRequireLabel.text=textString;
        
        if (self.contactPhoneNumber&&[self.origin isEqualToString:@"2"]) {
            self.phoneLabel.text=[NSString stringWithFormat:@"【联系电话】%@",self.contactPhoneNumber];
        }else{
            self.phoneLabel.hidden=YES;
        }
        
        [self updateConstraints];
        
        [mapView addAnnotation:self.jobModel.getjobWorkPlaceGeoPoint Title:self.jobModel.getjobTitle tag:0 SetToCenter:YES];
    }
}

- (void)shareJob{
    
    //构造分享内容
    id<ISSContent> publishContent = [ShareSDK content:@"我在兼职精灵找到工作啦！你要不要来尝试？猛戳链接http://www.baidu.com"
                                       defaultContent:nil
                                                image:[ShareSDK jpegImageWithImage:[self imageFromView:self.containerView] quality:1.0f]
                                                title:@"兼职精灵"
                                                  url:@"http://www.baidu.com"
                                          description:@"兼职精灵，您的兼职助手"
                                            mediaType:SSPublishContentMediaTypeNews];
    //创建弹出菜单容器
    id<ISSContainer> container = [ShareSDK container];
    
    //弹出分享菜单
    [ShareSDK showShareActionSheet:container
                         shareList:nil
                           content:publishContent
                     statusBarTips:YES
                       authOptions:nil
                      shareOptions:nil
                            result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                                
                                if (state == SSResponseStateSuccess)
                                {
                                    [MBProgressHUD showSuccess:@"分享成功" toView:self.view];
                                }
                                else if (state == SSResponseStateFail)
                                {
                                    [MBProgressHUD showError:@"分享失败" toView:self.view];
                                }
                            }];
}
//截屏
- (UIImage *)imageFromView: (UIView *) theView
{
    UIGraphicsBeginImageContext(theView.frame.size);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    [theView.layer renderInContext:context];
    
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    
    CGRect myImageRect = CGRectMake(0.0, 200.0, theView.frame.size.width, theView.frame.size.height-200);

    CGImageRef imageRef = theImage.CGImage;
    
    CGImageRef subImageRef = CGImageCreateWithImageInRect(imageRef, myImageRect);
    
    CGSize size;
    
    size.width = theView.frame.size.width;
    
    size.height = theView.frame.size.height-200;
    
    UIGraphicsBeginImageContext(size);
    
    CGContextDrawImage(context, myImageRect, subImageRef);
    
    UIImage* smallImage = [UIImage imageWithCGImage:subImageRef];
    
    UIGraphicsEndImageContext();
    
    return smallImage;

}

- (void)saveJob{
    
    NSUserDefaults *myData = [NSUserDefaults standardUserDefaults];
    NSString *currentUserObjectId=[myData objectForKey:@"currentUserObjectId"];
    if ([currentUserObjectId length]>0) {
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [netAPI saveTheJob:currentUserObjectId jobID:self.jobModel.getjobID withBlock:^(oprationResultModel *oprationResultModel) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        if (![oprationResultModel.getStatus intValue]==0) {
            NSString *err=oprationResultModel.getInfo;

            [MBProgressHUD showError:err toView:self.view];
        }
        else{
            [MBProgressHUD showSuccess:@"收藏成功" toView:self.view];
        }
    }];
    }else{
        UIAlertView *loginAlert=[[UIAlertView alloc]initWithTitle:@"未登录" message:@"是否现在登录？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"登录", nil];
        [loginAlert show];
    }
}

- (IBAction)showWorkTime:(id)sender {
    [self.view1 setFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width-40,[[UIScreen mainScreen] bounds].size.width/2)];
    [PopoverView showPopoverAtPoint:CGPointMake(0, 135) inView:self.view withTitle:@"工作时间" withContentView:self.view1 delegate:nil];
}

#pragma mark - Collection View Data Source
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 28;
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(freecellwidth, freecellwidth);
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(2, 2, 2, 2);
}

-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row>=0 && indexPath.row<7) {
        return NO;
    }
    return YES;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    selectFreeData[indexPath.row-7] = selectFreeData[indexPath.row-7]?false:true;
    [collectionView reloadData];
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    freeselectViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:selectFreecellIdentifier forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[freeselectViewCell alloc]init];
    }
    //[[cell imageView]setFrame:CGRectMake(0, 0, freecellwidth, freecellwidth)];
    if (indexPath.row>=0 && indexPath.row<7) {
        cell.imageView.image = [selectfreetimetitleArray objectAtIndex:indexPath.row];
    }
    
    
    if (indexPath.row>=7 && indexPath.row<14) {
        if (selectFreeData[indexPath.row-7]) {
            cell.imageView.image = [selectfreetimepicArray objectAtIndex:1];
        }else{
            cell.imageView.image = [selectfreetimepicArray objectAtIndex:0];
        }
        
    }
    if (indexPath.row>=14 && indexPath.row<21) {
        if (selectFreeData[indexPath.row-7]) {
            cell.imageView.image = [selectfreetimepicArray objectAtIndex:3];
        }else{
            cell.imageView.image = [selectfreetimepicArray objectAtIndex:2];
        }
    }
    if (indexPath.row>=21 && indexPath.row<28) {
        if (selectFreeData[indexPath.row-7]) {
            cell.imageView.image = [selectfreetimepicArray objectAtIndex:5];
        }else{
            cell.imageView.image = [selectfreetimepicArray objectAtIndex:4];
        }
    }
    return cell;
};


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
