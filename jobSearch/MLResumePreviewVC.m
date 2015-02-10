//
//  MLResumePreviewVC.m
//  jobSearch
//
//  Created by 田原 on 15/1/26.
//  Copyright (c) 2015年 麻辣工作室. All rights reserved.
//

#import "MLResumePreviewVC.h"
#import "MLResumeVC.h"

static NSString *selectFreecellIdentifier = @"freeselectViewCell";

@interface MLResumePreviewVC (){
    //collection内容
    NSArray *selectfreetimetitleArray;
    NSArray *selectfreetimepicArray;
    bool selectFreeData[21];
    CGFloat freecellwidth;
}
@property (weak, nonatomic) IBOutlet UIScrollView *mainScrollviewOutlet;
//第一项
@property (weak, nonatomic) IBOutlet UIView *coverflowOutlet;
//第二项
@property (strong, nonatomic) IBOutlet UIView *usrinfo1Outlet;
//第三项
@property (strong, nonatomic) IBOutlet UIView *usrinfo2Outlet;
@property (weak, nonatomic) IBOutlet UILabel *usrNameOutlet;
@property (weak, nonatomic) IBOutlet UIImageView *sexOutlet;
@property (weak, nonatomic) IBOutlet UILabel *ageOutlet;
@property (weak, nonatomic) IBOutlet UILabel *locationOutlet;
@property (weak, nonatomic) IBOutlet UILabel *intentionOutlet;
@property (weak, nonatomic) IBOutlet UILabel *phoneOutlet;

//第四项
@property (strong, nonatomic) IBOutlet UIView *collectionViewOutlet;
@property (weak, nonatomic) IBOutlet UICollectionView *selectfreeCollectionOutlet;
//第五项
@property (strong, nonatomic) IBOutlet UIView *usrinfo3Outet;
@property (weak, nonatomic) IBOutlet UILabel *workexperienceOutlet;
@property (weak, nonatomic) IBOutlet UILabel *userIntroductionOutlet;



@end

@implementation MLResumePreviewVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.mainScrollviewOutlet.delegate=self;
    [self.navigationItem setTitle:@"简历预览"];
    
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithImage:Nil style:UIBarButtonItemStyleBordered target:self action:@selector(editResume)];
    [self.navigationItem.rightBarButtonItem setTitle:@"编辑"];
    
    [self.coverflowOutlet setFrame:CGRectMake(0,0,[UIScreen mainScreen].bounds.size.width,[UIScreen mainScreen].bounds.size.width*0.6)];
    [self.mainScrollviewOutlet addSubview:self.coverflowOutlet];
    
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    //获取简历 ok
    [netAPI getUserDetail:@"54d76bd496d9aece6f8b4569" withBlock:^(userModel *userModel) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        if ([userModel getStatus].intValue == STATIS_OK) {
            [self initfromNet:userModel];
        }else{
            UIAlertView *alterTittle = [[UIAlertView alloc] initWithTitle:@"提示" message:@"数据获取错误" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil];
            [alterTittle show];
        }
    }];
}

-(void)initfromNet:(userModel *)userModel{
    
    
    //第一项
    NSMutableArray *sourceImages = [[NSMutableArray alloc]init];
    [sourceImages addObject:[UIImage imageNamed:@"0.jpg"]];
    [sourceImages addObject:[UIImage imageNamed:@"1.jpg"]];
    [sourceImages addObject:[UIImage imageNamed:@"2.jpg"]];
    //背景黑
    CGRect coverflowFrame = CGRectMake(0,0,[UIScreen mainScreen].bounds.size.width,self.coverflowOutlet.frame.size.height -20);
    //添加coverflow
    coverFlowView *cfView = [coverFlowView coverFlowViewWithFrame:coverflowFrame andImages:sourceImages sideImageCount:2 sideImageScale:0.55 middleImageScale:0.7];
    [cfView setDuration:0.3];
    [self.coverflowOutlet addSubview:cfView];
    
    
    //第二项
    //    [self.usrinfo1Outlet setFrame:CGRectMake(0,self.coverflowOutlet.frame.size.height,[UIScreen mainScreen].bounds.size.width,110)];
    //    [self.mainScrollviewOutlet addSubview:self.usrinfo1Outlet];
    //第三项
    //用户名字
    NSString *usrname = [userModel getuserName];
    [self.usrNameOutlet setNumberOfLines:0];
    [self.usrNameOutlet setLineBreakMode:NSLineBreakByWordWrapping];
    CGSize usrnameSize = [usrname sizeWithFont:[self.usrNameOutlet font] constrainedToSize:CGSizeMake(0,0) lineBreakMode:NSLineBreakByWordWrapping];
    
    [self.usrNameOutlet setFrame:CGRectMake(self.usrNameOutlet.frame.origin.x,
                                            self.usrNameOutlet.frame.origin.y,
                                            usrnameSize.width,
                                            usrnameSize.height)];
    [self.usrNameOutlet setText:usrname];
    
    [self.sexOutlet setFrame:CGRectMake(
                                        300,
                                        self.sexOutlet.frame.origin.y,
                                        self.sexOutlet.frame.size.width,
                                        self.sexOutlet.frame.size.height)];
    //性别
    if ([userModel getuserGender].intValue == 0) {
        self.sexOutlet.image = [UIImage imageNamed:@"resume_male"];
    }else if ([userModel getuserGender].intValue == 1){
        self.sexOutlet.image = [UIImage imageNamed:@"resume_female"];
    }else{
        self.sexOutlet.image = Nil;
    }
    
    //年龄
    if ([userModel getuserBirthday] != Nil) {
        @try {
            NSString *ageString = [NSString stringWithFormat:@"%ld岁",(long)[DateUtil ageWithDateOfBirth:[userModel getuserBirthday]]];
            self.ageOutlet.text = ageString;
        }
        @catch (NSException *exception) {
            self.ageOutlet.text = @"未知年龄";
        }
    }else{
        self.ageOutlet.text = @"未知年龄";
    }
    //电话
    self.phoneOutlet.text = [userModel getuserPhone];
    //位置
    NSString *usrLoaction = [NSString stringWithFormat:@"%@%@%@",[userModel getuserProvince],[userModel getuserCity],[userModel getuserDistrict]];
    [self.locationOutlet setNumberOfLines:0];
    [self.locationOutlet setLineBreakMode:NSLineBreakByWordWrapping];
    CGSize locationOutletlabelsize = [usrLoaction sizeWithFont:[self.locationOutlet font] constrainedToSize:CGSizeMake(self.locationOutlet.frame.size.width,2000) lineBreakMode:NSLineBreakByWordWrapping];
    [self.locationOutlet setFrame:CGRectMake(self.locationOutlet.frame.origin.x,
                                             self.locationOutlet.frame.origin.y, locationOutletlabelsize.width, locationOutletlabelsize.height)];
    [self.locationOutlet setText:usrLoaction];
    
    NSString *usrintention = @"咨询经理、设计师、客服、文员、其他、临时工";
    [self.intentionOutlet setNumberOfLines:0];
    [self.intentionOutlet setLineBreakMode:NSLineBreakByWordWrapping];
    CGSize intentionOutletlabelsize = [usrLoaction sizeWithFont:[self.intentionOutlet font] constrainedToSize:CGSizeMake(self.intentionOutlet.frame.size.width,2000) lineBreakMode:NSLineBreakByWordWrapping];
    [self.intentionOutlet setFrame:CGRectMake(self.intentionOutlet.frame.origin.x,
                                              self.intentionOutlet.frame.origin.y,
                                              intentionOutletlabelsize.width,
                                              intentionOutletlabelsize.height)];
    [self.intentionOutlet setText:usrintention];
    
    [self.usrinfo2Outlet setFrame:CGRectMake(0,self.coverflowOutlet.frame.origin.y+self.coverflowOutlet.frame.size.height,[UIScreen mainScreen].bounds.size.width,self.intentionOutlet.frame.origin.y+self.intentionOutlet.frame.size.height+20)];
    [self.mainScrollviewOutlet addSubview:self.usrinfo2Outlet];
    
    //第四项
    selectfreetimepicArray = [[NSMutableArray alloc]init];
    selectfreetimetitleArray = [[NSMutableArray alloc]init];
    freecellwidth = ([UIScreen mainScreen].bounds.size.width - 110)/7;
    selectfreetimetitleArray = @[[UIImage imageNamed:@"resume_7"],
                                 [UIImage imageNamed:@"resume_1"],
                                 [UIImage imageNamed:@"resume_2"],
                                 [UIImage imageNamed:@"resume_3"],
                                 [UIImage imageNamed:@"resume_4"],
                                 [UIImage imageNamed:@"resume_5"],
                                 [UIImage imageNamed:@"resume_6"]
                                 ];
    selectfreetimepicArray = @[[UIImage imageNamed:@"resume_am1"],
                               [UIImage imageNamed:@"resume_am2"],
                               [UIImage imageNamed:@"resume_pm1"],
                               [UIImage imageNamed:@"resume_pm2"],
                               [UIImage imageNamed:@"resume_night1"],
                               [UIImage imageNamed:@"resume_night2"]
                               ];
    
    NSArray *freeTime = [userModel getuserFreeTime];
    for (int index = 0; index < 21; index++) {
        selectFreeData[index] = false;
    }
    for (NSNumber *free in freeTime) {
        if (free.intValue >=0 && free.intValue < 21) {
            selectFreeData[free.intValue] = true;
        }
    }
    self.selectfreeCollectionOutlet.delegate = self;
    self.selectfreeCollectionOutlet.dataSource = self;
    UINib *niblogin = [UINib nibWithNibName:selectFreecellIdentifier bundle:nil];
    [self.selectfreeCollectionOutlet registerNib:niblogin forCellWithReuseIdentifier:selectFreecellIdentifier];
    [self.collectionViewOutlet setFrame:CGRectMake(0,self.usrinfo2Outlet.frame.origin.y+self.usrinfo2Outlet.frame.size.height,[UIScreen mainScreen].bounds.size.width,60+freecellwidth*4+50)];
    [self.mainScrollviewOutlet addSubview:self.collectionViewOutlet];
    [self.selectfreeCollectionOutlet reloadData];
    
    //第五项
    
    NSString *intro = [userModel getuserIntroduction];
    
    NSString  *testintroFormat = [intro stringByReplacingOccurrencesOfString:@"\\n" withString:@" \r\n" ];
    [self.userIntroductionOutlet setNumberOfLines:0];
    [self.userIntroductionOutlet setLineBreakMode:NSLineBreakByWordWrapping];
    CGSize testintrolabelsize = [testintroFormat sizeWithFont:[self.userIntroductionOutlet font] constrainedToSize:CGSizeMake(self.userIntroductionOutlet.frame.size.width,2000) lineBreakMode:NSLineBreakByWordWrapping];
    [self.userIntroductionOutlet setFrame:CGRectMake(self.userIntroductionOutlet.frame.origin.x,
                                                     self.userIntroductionOutlet.frame.origin.y, testintrolabelsize.width,
                                                       testintrolabelsize.height)];
    [self.userIntroductionOutlet setText:testintroFormat];
    
    
    NSString *workexperience = [userModel getuserExperience];
    NSString  *workexperienceFormat = [workexperience stringByReplacingOccurrencesOfString:@"\\n" withString:@" \r\n" ];
    [self.workexperienceOutlet setNumberOfLines:0];
    [self.workexperienceOutlet setLineBreakMode:NSLineBreakByWordWrapping];
    CGSize testworkexperiencelabelsize = [workexperienceFormat sizeWithFont:[self.workexperienceOutlet font] constrainedToSize:CGSizeMake(self.workexperienceOutlet.frame.size.width,2000) lineBreakMode:NSLineBreakByWordWrapping];
    [self.workexperienceOutlet setFrame:CGRectMake(self.workexperienceOutlet.frame.origin.x,
                                                   self.workexperienceOutlet.frame.origin.y, testworkexperiencelabelsize.width, testworkexperiencelabelsize.height)];
    [self.workexperienceOutlet setText:workexperienceFormat];
    
    [self.usrinfo3Outet setFrame:CGRectMake(0,
                                            self.collectionViewOutlet.frame.origin.y+self.collectionViewOutlet.frame.size.height,
                                            [UIScreen mainScreen].bounds.size.width,
                                            testintrolabelsize.height + testworkexperiencelabelsize.height+100)];
    NSLog(@"%f  %f",testintrolabelsize.height,testworkexperiencelabelsize.height);
    [self.mainScrollviewOutlet addSubview:self.usrinfo3Outet];
    
    
    //设置最终长度
    [self.mainScrollviewOutlet setContentSize:CGSizeMake(0,self.usrinfo3Outet.frame.origin.y+self.usrinfo3Outet.frame.size.height)];
    
}

- (void)viewWillLayoutSubviews{
    //设置导航栏标题颜色及返回按钮颜色
    self.navigationController.navigationBar.barStyle = UIStatusBarStyleDefault;
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    NSMutableDictionary *titleBarAttributes = [NSMutableDictionary dictionaryWithDictionary:[[UINavigationBar appearance] titleTextAttributes]];
    [titleBarAttributes setValue:[UIColor whiteColor] forKey:UITextAttributeTextColor];
    
    [self.navigationController.navigationBar setTitleTextAttributes:titleBarAttributes];
}

- (void)editResume{
    MLResumeVC *resumeVC=[[MLResumeVC alloc]init];
    [self.navigationController pushViewController:resumeVC animated:YES];
}

-(UIImage *)compressImage:(UIImage *)imgSrc size:(int)width
{
    CGSize size = {width, width};
    UIGraphicsBeginImageContext(size);
    CGRect rect = {{0,0}, size};
    [imgSrc drawInRect:rect];
    UIImage *compressedImg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return compressedImg;
}

//coolection
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
    return UIEdgeInsetsMake(5, 5, 5, 5);
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
