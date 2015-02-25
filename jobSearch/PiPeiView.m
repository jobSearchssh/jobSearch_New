//
//  PiPeiView.m
//  jobSearch
//
//  Created by RAY on 15/1/29.
//  Copyright (c) 2015年 麻辣工作室. All rights reserved.
//

#import "PiPeiView.h"
#import "PopoverView.h"
#import "freeselectViewCell.h"
#import "AsyncImageView.h"
#import "MBProgressHUD.h"
#import "MBProgressHUD+Add.h"
#import "netAPI.h"
#import "MLLoginVC.h"

static NSString *selectFreecellIdentifier = @"freeselectViewCell";
//static NSString *userId = @"54d76bd496d9aece6f8b4568";

@interface PiPeiView ()<PopoverViewDelegate,UICollectionViewDataSource,UICollectionViewDelegate>

{
    NSMutableArray  *addedPicArray;
    NSArray  *selectfreetimepicArray;
    NSArray  *selectfreetimetitleArray;
    CGFloat freecellwidth;
    bool selectFreeData[21];
}

@property (weak, nonatomic) IBOutlet UICollectionView *selectfreeCollectionOutlet;
@property (weak, nonatomic) IBOutlet AsyncImageView *entepriseLogoView;
@property (weak, nonatomic) IBOutlet UILabel *jobTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *jobAddressLabel;
@property (weak, nonatomic) IBOutlet UILabel *jobDistanceLabel;
@property (weak, nonatomic) IBOutlet UILabel *jobPublishTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *jobWorkPeriodLabel;
@property (weak, nonatomic) IBOutlet UILabel *jobRecuitNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *jobSalaryLabel;
@property (weak, nonatomic) IBOutlet UILabel *jobSettlementWay;
@property (weak, nonatomic) IBOutlet UITextView *jobDescribleLabel;
@property (weak, nonatomic) IBOutlet UILabel *jobRequireLabel;
@property (strong, nonatomic) IBOutlet UIView *view1;

@end

@implementation PiPeiView
@synthesize jobModel= _jobModel;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.jobDescribleLabel.editable=NO;
}

- (IBAction)showWorkTime:(id)sender {
    [self.view1 setFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width-40, 160)];
    [PopoverView showPopoverAtPoint:CGPointMake(88, 135) inView:self.view withTitle:@"工作时间" withContentView:self.view1 delegate:self];
}

- (IBAction)delete:(id)sender {
    [self.childViewDelegate deleteJob:self.index];
}

- (IBAction)apply:(id)sender {
    
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

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (buttonIndex==1) {
        MLLoginVC *loginVC=[[MLLoginVC alloc]init];
        [self.navigationController pushViewController:loginVC animated:YES];
    }
}

- (void)timeViewInit{
    
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
    
    if ([self.jobModel.getjobWorkTime count]>0) {
        
        for (NSNumber *t in self.jobModel.getjobWorkTime) {
            if ([t intValue]>0) {
                int n=[t intValue];
                if (n<21&&n>=0) {
                    selectFreeData[n]=TRUE;
                }
                
            }
        }

    }
    
    self.selectfreeCollectionOutlet.delegate = self;
    self.selectfreeCollectionOutlet.dataSource = self;
    UINib *niblogin = [UINib nibWithNibName:selectFreecellIdentifier bundle:nil];
    [self.selectfreeCollectionOutlet registerNib:niblogin forCellWithReuseIdentifier:selectFreecellIdentifier];
    
}

- (void)initData{
    
    if (_jobModel) {

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
    
        self.jobTitleLabel.text=_jobModel.getjobTitle;
        self.jobAddressLabel.text=[NSString stringWithFormat:@"%@%@%@",_jobModel.getjobWorkPlaceCity,_jobModel.getjobWorkPlaceDistrict,_jobModel.getjobWorkAddressDetail];
    
        self.jobDistanceLabel.text=[NSString stringWithFormat:@"%.1f千米",[jobModel getDistance:_jobModel.getjobWorkPlaceGeoPoint]];
    
        self.jobPublishTimeLabel.text=[dateFormatter stringFromDate:_jobModel.getcreated_at];
        self.jobWorkPeriodLabel.text=[NSString stringWithFormat:@"%@—%@",[dateFormatter stringFromDate:_jobModel.getjobBeginTime],[dateFormatter stringFromDate:_jobModel.getjobEndTime]];
    
        self.jobRecuitNumLabel.text=[NSString stringWithFormat:@"招募数量：%d/%d人",[_jobModel.getjobHasAccepted intValue],[_jobModel.getjobRecruitNum intValue]];
    
        NSString *settlement;
        NSString *str=[NSString stringWithFormat:@"%@",_jobModel.getjobSettlementWay];
    
        if ([str isEqualToString:@"0"])
            settlement=@"日结";
        else if ([str isEqualToString:@"1"])
            settlement=@"月结";
        else if ([str isEqualToString:@"2"])
            settlement=@"项目结";
    
        self.jobSalaryLabel.text=[NSString stringWithFormat:@"%@元",_jobModel.getjobSalaryRange];
        self.jobSettlementWay.text=settlement;
    
        self.jobDescribleLabel.text=[NSString stringWithFormat:@"工作描述：%@",_jobModel.getjobIntroduction];
    
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
        
        NSString *age;
        if (_jobModel.getjobAgeStartReq) {
            age=[NSString stringWithFormat:@"年龄要求：%@—%@岁",_jobModel.getjobAgeStartReq,_jobModel.getjobAgeEndReq];
        }
        NSString *height;
        if (_jobModel.getjobHeightStartReq||_jobModel.getjobHeightEndReq) {
            height=[NSString stringWithFormat:@"身高要求：%@—%@cm",_jobModel.getjobHeightStartReq,_jobModel.getjobHeightEndReq];
        }
        
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
        
        [self timeViewInit];
        
    }
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
