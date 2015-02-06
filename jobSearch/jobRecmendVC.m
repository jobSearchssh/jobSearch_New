//
//  jobRecmendVC.m
//  jobSearch
//
//  Created by RAY on 15/1/22.
//  Copyright (c) 2015年 麻辣工作室. All rights reserved.
//

#import "jobRecmendVC.h"
#import "MLMapView.h"
#import "PopoverView.h"
#import "freeselectViewCell.h"

static NSString *selectFreecellIdentifier = @"freeselectViewCell";

@interface jobRecmendVC ()<UICollectionViewDataSource,UICollectionViewDelegate>{
    NSMutableArray  *addedPicArray;
    NSArray  *selectfreetimepicArray;
    NSArray  *selectfreetimetitleArray;
    CGFloat freecellwidth;
    bool selectFreeData[21];
    MLMapView *mapView;
}
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *containerViewHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *jobDescribleLabelHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *jobRequireLabelHeightConstraint;
@property (strong, nonatomic) IBOutlet UIView *view1;
@property (weak, nonatomic) IBOutlet UICollectionView *selectfreeCollectionOutlet;

@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UIImageView *entepriseLogoView;
@property (weak, nonatomic) IBOutlet UILabel *jobTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *jobAddressLabel;
@property (weak, nonatomic) IBOutlet UILabel *jobDistanceLabel;
@property (weak, nonatomic) IBOutlet UILabel *jobPublishTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *jobWorkPeriodLabel;
@property (weak, nonatomic) IBOutlet UILabel *jobRecuitNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *jobSalaryLabel;
@property (weak, nonatomic) IBOutlet UILabel *jobDescribeLabel;
@property (weak, nonatomic) IBOutlet UILabel *jobRequireLabel;
@end

@implementation jobRecmendVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    mapView=[[MLMapView alloc]initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, 200)];
    [self.containerView addSubview:mapView];
    [self timeCollectionViewInit];

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
    selectFreeData[3] = YES;
    selectFreeData[5] = YES;
    selectFreeData[7] = YES;
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
    CGRect rect2 =[self.jobDescribeLabel.text boundingRectWithSize:CGSizeMake([[UIScreen mainScreen] bounds].size.width-16, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13]}  context:nil];
    self.jobRequireLabelHeightConstraint.constant=rect2.size.height;
    
    self.containerViewHeightConstraint.constant=457+rect1.size.height+rect2.size.height;
}

- (void)initData{
    if (self.jobModel) {
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy年MM月dd日"];
        
        self.jobTitleLabel.text=self.jobModel.getjobTitle;
        self.jobAddressLabel.text=[NSString stringWithFormat:@"%@%@",self.jobModel.getjobWorkPlaceCity,self.jobModel.getjobWorkPlaceDistrict];
        self.jobPublishTimeLabel.text=[dateFormatter stringFromDate:self.jobModel.getcreated_at];
        self.jobWorkPeriodLabel.text=[NSString stringWithFormat:@"%@—%@",[dateFormatter stringFromDate:self.jobModel.getjobBeginTime],[dateFormatter stringFromDate:self.jobModel.getjobEndTime]];
        self.jobRecuitNumLabel.text=[NSString stringWithFormat:@"还剩%@人",self.jobModel.getjobRecruitNum];
        self.jobSalaryLabel.text=[NSString stringWithFormat:@"%@元/天",self.jobModel.getjobSalaryRange];
        self.jobDescribeLabel.text=[NSString stringWithFormat:@"工作描述：%@",self.jobModel.getjobIntroduction];
        //NSString *gender=[NSString stringWithFormat:@"性别要求：%@",self.jobModel.getjobGender];
        NSString *degree=[NSString stringWithFormat:@"学历要求：%@",self.jobModel.getjobDegreeReq];
        NSString *age=[NSString stringWithFormat:@"年龄要求：%@——%@",self.jobModel.getjobAgeStartReq,self.jobModel.getjobAgeEndReq];
        NSString *height=[NSString stringWithFormat:@"年龄要求：%@——%@",self.jobModel.getjobHeightStartReq,self.jobModel.getjobHeightEndReq];
        NSString *other=@"";
        self.jobRequireLabel.text=[NSString stringWithFormat:@"%@\n%@\n%@\n%@",degree,age,height,other];
        
        [self updateConstraints];
        
        [mapView addAnnotation:self.jobModel.getjobWorkPlaceGeoPoint];
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
