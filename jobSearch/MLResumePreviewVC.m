//
//  MLResumePreviewVC.m
//  jobSearch
//
//  Created by 田原 on 15/1/26.
//  Copyright (c) 2015年 麻辣工作室. All rights reserved.
//

#import "MLResumePreviewVC.h"
#import "MLResumeVC.h"
#import "MLLoginVC.h"


static NSString *selectFreecellIdentifier = @"freeselectViewCell";

@interface MLResumePreviewVC (){
    //collection内容
    NSArray *selectfreetimetitleArray;
    NSArray *selectfreetimepicArray;
    bool selectFreeData[21];
    CGFloat freecellwidth;
    
    const NSArray *jobHopeTypeArray;
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
@property (weak, nonatomic) IBOutlet UILabel *userHeightOutlet;

//第四项
@property (strong, nonatomic) IBOutlet UIView *collectionViewOutlet;
@property (weak, nonatomic) IBOutlet UICollectionView *selectfreeCollectionOutlet;
//第五项
@property (strong, nonatomic) IBOutlet UIView *usrinfo3Outet;
@property (weak, nonatomic) IBOutlet UILabel *workexperienceOutlet;
@property (weak, nonatomic) IBOutlet UILabel *userIntroductionOutlet;
@property (weak, nonatomic) IBOutlet UILabel *usrschoolOutlet;

@property (weak, nonatomic) IBOutlet AsyncImageView *userLogoView;


@end

@implementation MLResumePreviewVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    jobHopeTypeArray = [[NSArray alloc]initWithObjects:@"全部",@"模特/礼仪",@"促销/导购",@"销售",@"传单派发",@"安保",@"钟点工",@"法律事务",@"服务员",@"婚庆",@"配送/快递",@"化妆",@"护工/保姆",@"演出",@"问卷调查",@"志愿者",@"网络营销",@"导游",@"游戏代练",@"家教",@"软件/网站开发",@"会计",@"平面设计/制作",@"翻译",@"装修",@"影视制作",@"搬家",@"其他", nil];
    
    self.mainScrollviewOutlet.delegate=self;
    
    [self.coverflowOutlet setFrame:CGRectMake(0,0,[UIScreen mainScreen].bounds.size.width,[UIScreen mainScreen].bounds.size.width*0.6)];
    [self.coverflowOutlet setRestorationIdentifier:@"coverflowOutlet"];
    [self.mainScrollviewOutlet addSubview:self.coverflowOutlet];
    
    if (self.type.intValue == type_preview) {
        self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithImage:Nil style:UIBarButtonItemStyleBordered target:self action:@selector(editResume)];
        [self.navigationItem.rightBarButtonItem setTitle:@"编辑"];
    }
    if (self.type.intValue == type_preview_edit) {
        self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc]initWithImage:Nil style:UIBarButtonItemStyleBordered target:self action:@selector(returnResume)];
        [self.navigationItem.leftBarButtonItem setTitle:@"返回"];
        
        self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithImage:Nil style:UIBarButtonItemStyleBordered target:self action:@selector(saveResume)];
        [self.navigationItem.rightBarButtonItem setTitle:@"保存"];
    }
}

-(void)returnResume{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

-(void)returnAndSave{
    [self returnResume];
    [self.saveDelegate finishSave];
}

-(void)saveResume{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [netAPI editUserDetail:self.mainUserModel withBlock:^(userReturnModel *userReturnModel) {
        
        [MBProgressHUD hideAllHUDsForView:self.view animated:NO];
        
        if ([userReturnModel getStatus].intValue == STATIS_OK) {
            [MBProgressHUD showSuccess:REMUMEUPDATESUCCESS toView:self.view];
            
            if ([[self.mainUserModel getImageFileURL] count]>0) {
                RESideMenu *sideMenu=[RESideMenu sharedInstance];
                NSString *logoUrl=[[self.mainUserModel getImageFileURL] objectAtIndex:0];
                [sideMenu setUserImageUrl:logoUrl];
                
                NSUserDefaults *mySettingData = [NSUserDefaults standardUserDefaults];
                [mySettingData setObject:logoUrl forKey:@"currentUserlogoUrl"];
                [mySettingData synchronize];
            }
            
            [self performSelector:@selector(returnAndSave) withObject:nil afterDelay:1.0f];
            
        }else{
            [MBProgressHUD showError:[userReturnModel getInfo] toView:self.view];
        }
    }];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    switch (self.type.intValue) {
        case type_preview:
            [self callPreView];
            break;
        case type_preview_edit:
            [self callPreViewEdit];
            break;
        default:
            break;
    }
}

-(void)callPreView{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    //获取简历 ok
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSUserDefaults *myData = [NSUserDefaults standardUserDefaults];
    NSString *currentUserObjectId=[myData objectForKey:@"currentUserObjectId"];
    if ([currentUserObjectId length]>0) {
        
        [netAPI getUserDetail:currentUserObjectId withBlock:^(userModel *userModel) {
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            if ([userModel getStatus].intValue == STATIS_OK) {
                [self initfromNet:userModel];
            }else{
                UIAlertView *alterTittle = [[UIAlertView alloc] initWithTitle:ALERTVIEW_TITLE message:userModel.getInfo delegate:self cancelButtonTitle:ALERTVIEW_CANCELBUTTON otherButtonTitles:FILLRESUMENOW,nil];
                alterTittle.tag=101;
                [alterTittle show];
            }
        }];
    }else{
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        UIAlertView *loginAlert=[[UIAlertView alloc]initWithTitle:NOTLOGIN message:ASKTOLOGIN delegate:self cancelButtonTitle:ALERTVIEW_CANCELBUTTON otherButtonTitles:LOGIN, nil];
        [loginAlert show];
    }
}

-(void)callPreViewEdit{
    //NSLog(@"callPreViewEdit");
    //NSLog(@"aaa = %@",self.mainUserModel);
    [self initfromNet:self.mainUserModel];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag==101) {
        if (buttonIndex==1)
            [self editResume];
    }else{
        if (buttonIndex==1) {
            MLLoginVC *loginVC=[[MLLoginVC alloc]init];
            [self.navigationController pushViewController:loginVC animated:YES];
        }
    }
}

- (UIImage *)scaleToSize:(UIImage *)img size:(CGSize)size{
    // 创建一个bitmap的context
    // 并把它设置成为当前正在使用的context
    UIGraphicsBeginImageContext(size);
    // 绘制改变大小的图片
    [img drawInRect:CGRectMake(0, 0, size.width, size.height)];
    // 从当前context中创建一个改变大小后的图片
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    // 返回新的改变大小后的图片
    return scaledImage;
}

-(void)initfromNet:(userModel *)userModel{
    
    if (self.type.intValue == type_preview) {
        self.mainUserModel = userModel;
    }
    
    for (UIView *view in self.mainScrollviewOutlet.subviews) {
        if ([view.restorationIdentifier isEqualToString:@"coverflowOutlet"]) {
            continue;
        }
        [view removeFromSuperview];
    }
    
    //第一项
    NSMutableArray *sourceImages = [[NSMutableArray alloc]init];
    NSMutableArray *sourceImagesURL = [userModel getImageFileURL];
    CGSize size = CGSizeMake(225, 225);
    UIImage *temp = [self scaleToSize:[UIImage imageNamed:@"placeholder"] size:size];
    
    
//    for (NSString *url in sourceImagesURL) {
//        [sourceImages addObject:temp];
//    }
    
    for (int i=0; i<[sourceImagesURL count]; i++) {
        [sourceImages addObject:temp];
    }
    
    //背景黑
    CGRect coverflowFrame = CGRectMake(0,0,[UIScreen mainScreen].bounds.size.width,self.coverflowOutlet.frame.size.height -20);
    //添加coverflow
    coverFlowView *cfView = [coverFlowView coverFlowViewWithFrame:coverflowFrame andImages:sourceImages andURLs:sourceImagesURL sideImageCount:2 sideImageScale:0.55 middleImageScale:0.7];
    [cfView setDuration:0.3];
    for (UIView *view in self.coverflowOutlet.subviews) {
        [view removeFromSuperview];
    }
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
    //头像
    if ([[userModel getImageFileURL] count]>0) {
        
        NSString *tempUrl=[[userModel getImageFileURL] objectAtIndex:0];
        
        if ([tempUrl length]>4) {
            self.userLogoView.contentMode = UIViewContentModeScaleAspectFill;
            self.userLogoView.clipsToBounds = YES;
            [[AsyncImageLoader sharedLoader] cancelLoadingImagesForTarget:self.userLogoView];
            self.userLogoView.imageURL=[NSURL URLWithString:tempUrl];
        }else{
            self.userLogoView.image=[UIImage imageNamed:@"placeholder"];
        }
    }
    
    //性别
    if ([userModel getuserGender].intValue == 0) {
        self.sexOutlet.image = [UIImage imageNamed:@"resume_male"];
    }else if ([userModel getuserGender].intValue == 1){
        self.sexOutlet.image = [UIImage imageNamed:@"resume_female"];
    }else{
        self.sexOutlet.image = Nil;
    }
    
    //身高
    if ([userModel getuserHeight] != Nil) {
        self.userHeightOutlet.text = [NSString stringWithFormat:@"%@cm",[userModel getuserHeight]];
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
    NSString *usrLoaction = Nil;
    if ([userModel getuserProvince]== Nil && [userModel getuserCity] == Nil && [userModel getuserDistrict] == Nil) {
        usrLoaction = @"未填写地区";
    }else{
        usrLoaction = [NSString stringWithFormat:@"%@%@%@",[userModel getuserProvince],[userModel getuserCity],[userModel getuserDistrict]];
    }
    

    [self.locationOutlet setNumberOfLines:0];
    [self.locationOutlet setLineBreakMode:NSLineBreakByWordWrapping];
    CGSize locationOutletlabelsize = [usrLoaction sizeWithFont:[self.locationOutlet font] constrainedToSize:CGSizeMake([UIScreen mainScreen].bounds.size.width - 143,2000) lineBreakMode:NSLineBreakByWordWrapping];
    [self.locationOutlet setFrame:CGRectMake(self.locationOutlet.frame.origin.x,
                                             self.locationOutlet.frame.origin.y,
                                             self.locationOutlet.frame.size.width,
                                             locationOutletlabelsize.height)];
    [self.locationOutlet setText:usrLoaction];
    
    NSMutableString *usrintentionTemp = [[NSMutableString alloc]init];
    NSMutableArray *usrintentionTempArray = [userModel getuserHopeJobType];
    for (NSNumber *index in usrintentionTempArray ) {
        if (index.intValue>=0 && index.intValue<jobHopeTypeArray.count) {
            [usrintentionTemp appendFormat:@"%@,",[jobHopeTypeArray objectAtIndex:(index.intValue+1)]];
        }
    }
    
    NSString *usrintention = usrintentionTemp;
    [self.intentionOutlet setNumberOfLines:0];
    [self.intentionOutlet setLineBreakMode:NSLineBreakByWordWrapping];
    CGSize intentionOutletlabelsize = [usrintention sizeWithFont:[self.intentionOutlet font] constrainedToSize:CGSizeMake([UIScreen mainScreen].bounds.size.width - 112,2000) lineBreakMode:NSLineBreakByWordWrapping];
    [self.intentionOutlet setFrame:CGRectMake(self.intentionOutlet.frame.origin.x,
                                              self.intentionOutlet.frame.origin.y,
                                              self.intentionOutlet.frame.size.width,
                                              intentionOutletlabelsize.height)];
    [self.intentionOutlet setText:usrintention];
    
    [self.usrinfo2Outlet setFrame:CGRectMake(0,self.coverflowOutlet.frame.origin.y+self.coverflowOutlet.frame.size.height,[UIScreen mainScreen].bounds.size.width,self.intentionOutlet.frame.origin.y+self.intentionOutlet.frame.size.height)];
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
    
    if ([userModel getuserSchool] != nil) {
        [self.usrschoolOutlet setText:[userModel getuserSchool]];
    }else{
        [self.usrschoolOutlet setText:@""];
    }
    
    NSString *intro = [userModel getuserIntroduction];
    NSString  *testintroFormat = [intro stringByReplacingOccurrencesOfString:@"\n" withString:@"\r\n" ];
    [self.userIntroductionOutlet setNumberOfLines:0];
    [self.userIntroductionOutlet setLineBreakMode:NSLineBreakByWordWrapping];
    CGSize testintrolabelsize = [testintroFormat sizeWithFont:[self.userIntroductionOutlet font] constrainedToSize:CGSizeMake([UIScreen mainScreen].bounds.size.width - 120,2000) lineBreakMode:NSLineBreakByWordWrapping];
    [self.userIntroductionOutlet setFrame:CGRectMake(self.userIntroductionOutlet.frame.origin.x,
                                                     self.userIntroductionOutlet.frame.origin.y, testintrolabelsize.width,
                                                       testintrolabelsize.height)];
    [self.userIntroductionOutlet setText:testintroFormat];
    
    
    NSString *workexperience = [userModel getuserExperience];
    NSString  *workexperienceFormat = [workexperience stringByReplacingOccurrencesOfString:@"\n" withString:@"\r\n" ];
    [self.workexperienceOutlet setNumberOfLines:0];
    [self.workexperienceOutlet setLineBreakMode:NSLineBreakByWordWrapping];
    CGSize testworkexperiencelabelsize = [workexperienceFormat sizeWithFont:[self.workexperienceOutlet font] constrainedToSize:CGSizeMake([UIScreen mainScreen].bounds.size.width - 120,2000) lineBreakMode:NSLineBreakByWordWrapping];
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

- (void)editResume{
    
    NSUserDefaults *myData = [NSUserDefaults standardUserDefaults];
    NSString *currentUserObjectId=[myData objectForKey:@"currentUserObjectId"];
    if ([currentUserObjectId length]>0) {

        MLResumeVC *resumeVC=[[MLResumeVC alloc]init];
        resumeVC.usermodel = self.mainUserModel;
        [self.navigationController pushViewController:resumeVC animated:YES];
        
    }
    else{
        UIAlertView *loginAlert=[[UIAlertView alloc]initWithTitle:NOTLOGIN message:ASKTOLOGIN delegate:self cancelButtonTitle:ALERTVIEW_CANCELBUTTON otherButtonTitles:LOGIN, nil];
        [loginAlert show];
    }
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
    return NO;
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

- (IBAction)previewVedio:(id)sender {
    if ([[self.mainUserModel getuserVideoURL] length]>4) {
        previewVedioVC *vc = [[previewVedioVC alloc]init];
        vc.vedioPath = [self.mainUserModel getuserVideoURL];
        vc.type = [NSNumber numberWithInt:preview];
        vc.title = VEDIOVCTITLE;
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        [MBProgressHUD showSuccess:NOVEDIO toView:self.view];
    }
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
