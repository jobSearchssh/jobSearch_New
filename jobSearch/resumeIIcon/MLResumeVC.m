//
//  MLResumeVC.m
//  jobSearch
//
//  Created by 田原 on 15/1/25.
//  Copyright (c) 2015年 麻辣工作室. All rights reserved.
//

#import "MLResumeVC.h"
#import "AKPickerView.h"

#define  PIC_WIDTH 60
#define  PIC_HEIGHT 60
#define  INSETS 10


static NSString *scrollindentify = @"scrollviewdown";
static NSString *selectFreecellIdentifier = @"freeselectViewCell";


@interface MLResumeVC ()<AKPickerViewDataSource, AKPickerViewDelegate>{
    NSMutableArray *addedPicArray;
    NSArray *selectfreetimetitleArray;
    NSArray *selectfreetimepicArray;
    bool selectFreeData[21];
    CGFloat freecellwidth;

    QRadioButton *radio_male;
    QRadioButton *radio_female;
    
    NSString *fileTempPath;
    NSMutableArray *typeArray;
    
    const NSArray *jobHopeTypeArray;
}

@property (nonatomic, strong) AKPickerView *pickerView;
@property (nonatomic, strong) NSArray *titles;
@property (weak, nonatomic) IBOutlet UIView *containTopView;
@property (weak, nonatomic) IBOutlet UIView *indicatorcontainview;


@property (nonatomic, strong) MCPagerView *pageIndicator;



//下部分5个view
@property (strong, nonatomic) IBOutlet UIView *view1outlet;
@property (strong, nonatomic) IBOutlet UIView *view2outlet;
@property (strong, nonatomic) IBOutlet UIView *view3outlet;
@property (strong, nonatomic) IBOutlet UIView *view4outlet;
@property (strong, nonatomic) IBOutlet UIView *view5outlet;



//page1
@property (weak, nonatomic) IBOutlet UILabel *sexlabeloutlet;
@property (weak, nonatomic) IBOutlet UITextField *nameoutlet;
@property (weak, nonatomic) IBOutlet UITextField *heightOutlet;
@property (weak, nonatomic) IBOutlet UITextField *iphoneOutlet;
@property (weak, nonatomic) IBOutlet UIButton *birthdayOutlet;
- (IBAction)birthdayAction:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIButton *selectProOutlet;
- (IBAction)selectProAction:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIButton *selectCityOutlet;
- (IBAction)selectCityAction:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIButton *selectDisOutlet;
- (IBAction)selectDisAction:(UIButton *)sender;



//page2
@property (weak, nonatomic) IBOutlet UITextField *schoolOutlet;


//page3
@property (weak, nonatomic) IBOutlet UIScrollView *picscrollview;
- (IBAction)callVideoAction:(UIButton *)sender;
- (BOOL)writeImageToDoc:(UIImage*)image;

//page4
@property (weak, nonatomic) IBOutlet UICollectionView *selectfreetimeOutlet;
@property (weak, nonatomic) IBOutlet UITextField *intentionOutlet;

//page5
@property (weak, nonatomic) IBOutlet UITextField *introductionmeOutlet;
@property (weak, nonatomic) IBOutlet UITextField *workexperienceOutlet;
@property (weak, nonatomic) IBOutlet UITextField *schollNewOutlet;


@end

@implementation MLResumeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    //navigator
    
    jobHopeTypeArray = [[NSArray alloc]initWithObjects:@"模特/礼仪",@"促销/导购",@"销售",@"传单派发",@"安保",@"钟点工",@"法律事务",@"服务员",@"婚庆",@"配送/快递",@"化妆",@"护工/保姆",@"演出",@"问卷调查",@"志愿者",@"网络营销",@"导游",@"游戏代练",@"家教",@"软件/网站开发",@"会计",@"平面设计/制作",@"翻译",@"装修",@"影视制作",@"搬家",@"其他", nil];

    [self.navigationItem setTitle:@"新建简历"];
    
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithImage:Nil style:UIBarButtonItemStyleBordered target:self action:@selector(saveResume)];
    [self.navigationItem.rightBarButtonItem setTitle:@"保存"];

    //上部分
    self.pickerView = [[AKPickerView alloc] initWithFrame:self.containTopView.bounds];
    self.pickerView.delegate = self;
    self.pickerView.dataSource = self;
    self.pickerView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.containTopView addSubview:self.pickerView];
    [[self.containTopView window]makeKeyAndVisible];
    
    self.pickerView.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:20];
    self.pickerView.highlightedFont = [UIFont fontWithName:@"HelveticaNeue" size:20];
    self.pickerView.interitemSpacing = 20.0;
    self.pickerView.fisheyeFactor = 0.001;
    self.pickerView.pickerViewStyle = AKPickerViewStyleFlat;
    
    self.titles = @[[self compressImage:[UIImage imageNamed:@"resume_icon1"] size:80],
                    [self compressImage:[UIImage imageNamed:@"resume_icon4"] size:80],
                    [self compressImage:[UIImage imageNamed:@"resume_icon3"] size:80],
                    [self compressImage:[UIImage imageNamed:@"resume_icon5"] size:80]
                    ];
    
    [self.pickerView reloadData];
    //indicator
    self.pageIndicator = [[MCPagerView alloc]initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width/2 - 44, self.pageIndicator.frame.origin.y,100, self.indicatorcontainview.frame.size.height-5)];
    [self.pageIndicator setImage:[self compressImage:[UIImage imageNamed:@"mark1"] size:14]
       highlightedImage:[self compressImage:[UIImage imageNamed:@"mark2"] size:14]
                 forKey:@"a"];
    [self.pageIndicator setPattern:@"aaaa"];
    
    self.pageIndicator.delegate = self;
    [self.indicatorcontainview addSubview:self.pageIndicator];
    
    //下部分
    self.scrollviewOutlet.delegate=self;
    self.pages = 4;
    
    [self createPages:self.pages];
    
    //page1
    radio_male = [[QRadioButton alloc] initWithDelegate:self groupId:@"groupId1"];
    radio_male.frame = CGRectMake(self.nameoutlet.frame.origin.x, self.sexlabeloutlet.frame.origin.y-10, 70, 40);
    [radio_male setTitle:@"男" forState:UIControlStateNormal];
    [radio_male setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [radio_male.titleLabel setFont:[UIFont boldSystemFontOfSize:13.0f]];
    [radio_male setStatus:maleStatus];
    [self.view1outlet addSubview:radio_male];
//    [_radio1 setChecked:YES];
    
    radio_female = [[QRadioButton alloc] initWithDelegate:self groupId:@"groupId1"];
    radio_female.frame = CGRectMake(radio_male.frame.origin.x+radio_male.frame.size.width, self.sexlabeloutlet.frame.origin.y-10, 70, 40);
    [radio_female setTitle:@"女" forState:UIControlStateNormal];
    [radio_female setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [radio_female.titleLabel setFont:[UIFont boldSystemFontOfSize:13.0f]];
    [radio_female setStatus:femaleStatus];
    [self.view1outlet addSubview:radio_female];
    
//    QRadioButton *_radio3 = [[QRadioButton alloc] initWithDelegate:self groupId:@"groupId1"];
//    _radio3.frame = CGRectMake(_radio2.frame.origin.x+_radio2.frame.size.width, self.sexlabeloutlet.frame.origin.y-10, 70, 40);
//    [_radio3 setTitle:@"不限" forState:UIControlStateNormal];
//    [_radio3 setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
//    [_radio3.titleLabel setFont:[UIFont boldSystemFontOfSize:13.0f]];
//    [self.view1outlet addSubview:_radio3];
    
    UIView *lineviewname = [[UIView alloc] initWithFrame:CGRectMake(self.nameoutlet.frame.origin.x, self.nameoutlet.frame.origin.y+self.nameoutlet.frame.size.height+3,[UIScreen mainScreen].bounds.size.width - 125, 1)];
    lineviewname.alpha = 0.5;
    lineviewname.backgroundColor = [UIColor grayColor];
    [self.view1outlet addSubview:lineviewname];
    
    UIView *lineviewiphone = [[UIView alloc] initWithFrame:CGRectMake(self.iphoneOutlet.frame.origin.x, self.iphoneOutlet.frame.origin.y+self.iphoneOutlet.frame.size.height+5,[UIScreen mainScreen].bounds.size.width - 125, 1)];
    lineviewiphone.alpha = 0.5;
    lineviewiphone.backgroundColor = [UIColor grayColor];
    [self.view1outlet addSubview:lineviewiphone];
    
    UIView *lineviewheight= [[UIView alloc] initWithFrame:CGRectMake(self.heightOutlet.frame.origin.x, self.heightOutlet.frame.origin.y+self.heightOutlet.frame.size.height+3,[UIScreen mainScreen].bounds.size.width - 125, 1)];
    lineviewheight.alpha = 0.5;
    lineviewheight.backgroundColor = [UIColor grayColor];
    [self.view1outlet addSubview:lineviewheight];
    
    UIView *lineviewbirthday= [[UIView alloc] initWithFrame:CGRectMake(self.birthdayOutlet.frame.origin.x, self.birthdayOutlet.frame.origin.y+self.birthdayOutlet.frame.size.height+3,[UIScreen mainScreen].bounds.size.width - 125, 1)];
    lineviewbirthday.alpha = 0.5;
    lineviewbirthday.backgroundColor = [UIColor grayColor];
    [self.view1outlet addSubview:lineviewbirthday];
    
    self.nameoutlet.delegate = self;
    self.iphoneOutlet.delegate = self;
    self.heightOutlet.delegate = self;
    //text上移
    [self.nameoutlet addTarget:self action:@selector(textFieldOutletWork:) forControlEvents:UIControlEventEditingDidBegin];
    //text上移
    [self.iphoneOutlet addTarget:self action:@selector(textFieldOutletWork:) forControlEvents:UIControlEventEditingDidBegin];
    //text上移
    [self.heightOutlet addTarget:self action:@selector(textFieldOutletWork:) forControlEvents:UIControlEventEditingDidBegin];
    self.birthdayOutlet.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    
    typeArray = Nil;

    //page2
    UIView *lineviewschool= [[UIView alloc] initWithFrame:CGRectMake(self.schoolOutlet.frame.origin.x, self.schoolOutlet.frame.origin.y+self.schoolOutlet.frame.size.height+3,[UIScreen mainScreen].bounds.size.width - 60, 1)];
    lineviewschool.alpha = 0.5;
    lineviewschool.backgroundColor = [UIColor grayColor];
    [self.view2outlet addSubview:lineviewschool];
    self.schoolOutlet.delegate = self;
    [self.schoolOutlet addTarget:self action:@selector(textFieldOutletWork:) forControlEvents:UIControlEventEditingDidBegin];
    
    
    //page3
    addedPicArray =[[NSMutableArray alloc]init];
    //添加图片
    imageButton *btnPic=[[imageButton alloc]initWithFrame:CGRectMake(INSETS, INSETS, PIC_WIDTH, PIC_HEIGHT)];
    [btnPic setBackgroundImage:[UIImage imageNamed:@"resume_add"] forState:UIControlStateNormal];
    [addedPicArray addObject:btnPic];
    [self.picscrollview addSubview:btnPic];
    [btnPic addTarget:self action:@selector(addPicAction:) forControlEvents:UIControlEventTouchUpInside];
    [self refreshScrollView];
    
    
    
    
    //page4
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
    for (int index = 0; index<21; index++) {
        selectFreeData[index] = FALSE;
    }
    self.selectfreetimeOutlet.delegate = self;
    self.selectfreetimeOutlet.dataSource = self;
    UINib *niblogin = [UINib nibWithNibName:selectFreecellIdentifier bundle:nil];
    [self.selectfreetimeOutlet registerNib:niblogin forCellWithReuseIdentifier:selectFreecellIdentifier];
    [self.intentionOutlet addTarget:self action:@selector(textFieldOutletWork:) forControlEvents:UIControlEventEditingDidBegin];
    self.intentionOutlet.delegate = self;
    UIView *lineviewIntention= [[UIView alloc] initWithFrame:CGRectMake(self.intentionOutlet.frame.origin.x, self.intentionOutlet.frame.origin.y+self.intentionOutlet.frame.size.height+3,[UIScreen mainScreen].bounds.size.width - 120, 1)];
    lineviewIntention.alpha = 0.5;
    lineviewIntention.backgroundColor = [UIColor grayColor];
    [self.view4outlet addSubview:lineviewIntention];
    
    
    //page5
    UIView *lineviewwork= [[UIView alloc] initWithFrame:CGRectMake(self.workexperienceOutlet.frame.origin.x, self.workexperienceOutlet.frame.origin.y+self.workexperienceOutlet.frame.size.height+3,[UIScreen mainScreen].bounds.size.width - 120, 1)];
    lineviewwork.alpha = 0.5;
    lineviewwork.backgroundColor = [UIColor grayColor];
    [self.view5outlet addSubview:lineviewwork];
    
    UIView *lineviewintroduction= [[UIView alloc] initWithFrame:CGRectMake(self.introductionmeOutlet.frame.origin.x, self.introductionmeOutlet.frame.origin.y+self.introductionmeOutlet.frame.size.height+3,[UIScreen mainScreen].bounds.size.width - 120, 1)];
    lineviewintroduction.alpha = 0.5;
    lineviewintroduction.backgroundColor = [UIColor grayColor];
    [self.view5outlet addSubview:lineviewintroduction];
    
    UIView *lineviewschoolnew= [[UIView alloc] initWithFrame:CGRectMake(self.schollNewOutlet.frame.origin.x, self.schollNewOutlet.frame.origin.y+self.schollNewOutlet.frame.size.height+3,[UIScreen mainScreen].bounds.size.width - 120, 1)];
    lineviewschoolnew.alpha = 0.5;
    lineviewschoolnew.backgroundColor = [UIColor grayColor];
    [self.view5outlet addSubview:lineviewschoolnew];
    
    self.introductionmeOutlet.delegate = self;
    self.workexperienceOutlet.delegate = self;
    self.schollNewOutlet.delegate = self;
    
    [self.introductionmeOutlet addTarget:self action:@selector(textFieldOutletWork:) forControlEvents:UIControlEventEditingDidBegin];
    [self.workexperienceOutlet addTarget:self action:@selector(textFieldOutletWork:) forControlEvents:UIControlEventEditingDidBegin];
    [self.schollNewOutlet addTarget:self action:@selector(textFieldOutletWork:) forControlEvents:UIControlEventEditingDidBegin];
    
    [self.scrollviewOutlet setTarget:self selector:@selector(tapRegisnFirstRespond)];
    
    //初始化信息
    if (self.usermodel != Nil) {
        //name
        if ([self.usermodel getuserName] != Nil) {
            self.nameoutlet.text = [self.usermodel getuserName];
        }
        
        //gender
        if ([self.usermodel getuserGender] != Nil) {
            if ([self.usermodel getuserGender].intValue == 0) {
                [radio_male setChecked:TRUE];
            }
            if ([self.usermodel getuserGender].intValue == 1) {
                [radio_female setChecked:TRUE];
            }
        }
        //身高
        if ([self.usermodel getuserHeight] != Nil) {
            self.heightOutlet.text = [NSString stringWithFormat:@"%@",[self.usermodel getuserHeight]];
        }
        //生日
        if ([self.usermodel getuserBirthday] != Nil) {
            NSString *birthdayTemp = [DateUtil birthdayStringFromDate:[self.usermodel getuserBirthday]];
            [self.birthdayOutlet setTitle:birthdayTemp forState:UIControlStateNormal];
        }
        //电话
        if ([self.usermodel getuserPhone] != Nil) {
            [self.iphoneOutlet setText:[self.usermodel getuserPhone]];
        }
        //地区
        if ([self.usermodel getuserProvince] != Nil) {
            [self.selectProOutlet setTitle:[self.usermodel getuserProvince] forState:UIControlStateNormal];
        }
        if ([self.usermodel getuserCity] != Nil) {
            [self.selectCityOutlet setTitle:[self.usermodel getuserCity] forState:UIControlStateNormal];
        }
        if ([self.usermodel getuserDistrict] != Nil) {
            [self.selectDisOutlet setTitle:[self.usermodel getuserDistrict] forState:UIControlStateNormal];
        }
        //求职意向
        if ([self.usermodel getuserHopeJobType] != Nil) {
            NSMutableString *usrintentionTemp = [[NSMutableString alloc]init];
            NSMutableArray *usrintentionTempArray = [self.usermodel getuserHopeJobType];
            for (NSNumber *index in usrintentionTempArray ) {
                if (index.intValue>=0 && index.intValue<jobHopeTypeArray.count) {
                    [usrintentionTemp appendFormat:@"%@,",[jobHopeTypeArray objectAtIndex:index.intValue]];
                }
            }
            [self.intentionOutlet setText:usrintentionTemp];
        }
        
        //空闲时间
        if ([self.usermodel getuserFreeTime] != Nil) {
            for (NSNumber *freetimetemp in [self.usermodel getuserFreeTime]) {
                if (freetimetemp.intValue>=0 && freetimetemp.intValue<21) {
                    selectFreeData[freetimetemp.intValue] = TRUE;
                }
            }
            [self.selectfreetimeOutlet reloadData];
        }
        //学校
        if ([self.usermodel getuserSchool] != Nil) {
            [self.schollNewOutlet setText:[self.usermodel getuserSchool]];
        }
        //自我介绍
        if ([self.usermodel getuserIntroduction] != Nil) {
            [self.introductionmeOutlet setText:[self.usermodel getuserIntroduction]];
        }
        //工作经验
        if ([self.usermodel getuserExperience] != Nil) {
            [self.workexperienceOutlet setText:[self.usermodel getuserExperience]];
        }
    }else{
        self.usermodel = [[userModel alloc]init];
    }
}

- (BOOL)validateMobile:(NSString *)mobileNum{
    /**
     * 手机号码
     * 移动：134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     * 联通：130,131,132,152,155,156,185,186
     * 电信：133,1349,153,180,189
     */
    NSString * MOBILE = @"^1(3[0-9]|5[0-35-9]|8[025-9])\\d{8}$";
    /**
     10         * 中国移动：China Mobile
     11         * 134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     12         */
    NSString * CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[278])\\d)\\d{7}$";
    /**
     15         * 中国联通：China Unicom
     16         * 130,131,132,152,155,156,185,186
     17         */
    NSString * CU = @"^1(3[0-2]|5[256]|8[56])\\d{8}$";
    /**
     20         * 中国电信：China Telecom
     21         * 133,1349,153,180,189
     22         */
    NSString * CT = @"^1((33|53|8[09])[0-9]|349)\\d{7}$";
    /**
     25         * 大陆地区固话及小灵通
     26         * 区号：010,020,021,022,023,024,025,027,028,029
     27         * 号码：七位或八位
     28         */
    // NSString * PHS = @"^0(10|2[0-5789]|\\d{3})\\d{7,8}$";
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    
    if (([regextestmobile evaluateWithObject:mobileNum] == YES)
        || ([regextestcm evaluateWithObject:mobileNum] == YES)
        || ([regextestct evaluateWithObject:mobileNum] == YES)
        || ([regextestcu evaluateWithObject:mobileNum] == YES)){
        return YES;
    }
    else{
        return NO;
    }
}


-(void)saveResume{
    if (self.nameoutlet.text != Nil) {
        [self.usermodel setuserName:self.nameoutlet.text];
    }
    
    if (self.heightOutlet.text != Nil) {
        NSNumber *temp = Nil;
        @try {
            temp = [NSNumber numberWithInt:self.heightOutlet.text.intValue];
        }
        @catch (NSException *exception) {
            temp = Nil;
        }
        if (temp != Nil) {
            [self.usermodel setuserHeight:temp];
        }
    }
    
    if (self.iphoneOutlet.text != Nil) {
        if ([self validateMobile:self.iphoneOutlet.text]) {
            [self.usermodel setuserPhone:self.iphoneOutlet.text];
        }else{
            UIAlertView *alterTittle = [[UIAlertView alloc] initWithTitle:@"提示" message:@"电话号码错误" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil];
            [alterTittle show];
            return;
        }
    }
    
    if (typeArray != Nil) {
        NSMutableArray *temp = [[NSMutableArray alloc]init];
        for (NSString *value in typeArray) {
            NSNumber *number = Nil;
            @try {
                number = [NSNumber numberWithInt:value.intValue];
            }
            @catch (NSException *exception) {
                number = Nil;
            }
            if (number != Nil) {
                [temp addObject:number];
            }
        }
        [self.usermodel setuserHopeJobType:temp];
    }
    NSMutableArray *tempFreeTime = [[NSMutableArray alloc]init];
    for (int index = 0; index<21 ; index++) {
        
        if (selectFreeData[index] == TRUE) {
            [tempFreeTime addObject:[NSNumber numberWithInt:index]];
        }
    }
    [self.usermodel setuserFreeTime:tempFreeTime];
    
    if (self.schollNewOutlet.text != Nil) {
        [self.usermodel setuserSchool:self.schollNewOutlet.text];
    }else{
        [self.usermodel setuserSchool:@""];
    }
    
    if (self.introductionmeOutlet.text != Nil) {
        [self.usermodel setuserIntroduction:self.introductionmeOutlet.text];
    }else{
        [self.usermodel setuserIntroduction:@""];
    }
    
    if (self.workexperienceOutlet.text) {
        [self.usermodel setuserExperience:self.workexperienceOutlet.text];
    }else{
        [self.usermodel setuserExperience:@""];
    }
    [netAPI editUserDetail:self.usermodel withBlock:^(userReturnModel *userReturnModel) {
        if ([userReturnModel getStatus].intValue == STATIS_OK) {
            UIAlertView *alterTittle = [[UIAlertView alloc] initWithTitle:@"提示" message:@"更新成功" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil];
            [alterTittle show];
        }else{
            UIAlertView *alterTittle = [[UIAlertView alloc] initWithTitle:@"提示" message:[NSString stringWithFormat:@"更新失败:%@",[userReturnModel getInfo]] delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil];
            [alterTittle show];
        }
    }];
}

//点击空白取消textfield响应
-(void)tapRegisnFirstRespond{
    if ([self.nameoutlet isFirstResponder]) {
        [self.nameoutlet resignFirstResponder];
    }
    if ([self.iphoneOutlet isFirstResponder]) {
        [self.iphoneOutlet resignFirstResponder];
    }
    if ([self.heightOutlet isFirstResponder]) {
        [self.heightOutlet resignFirstResponder];
    }
    if ([self.schollNewOutlet isFirstResponder]) {
        [self.schollNewOutlet resignFirstResponder];
    }
    if ([self.intentionOutlet isFirstResponder]) {
        [self.intentionOutlet resignFirstResponder];
    }
    if ([self.introductionmeOutlet isFirstResponder]) {
        [self.introductionmeOutlet resignFirstResponder];
    }
    if ([self.workexperienceOutlet isFirstResponder]) {
        [self.workexperienceOutlet resignFirstResponder];
    }
}

//响应回车
- (BOOL)textFieldShouldReturn:(UITextField *)theTextField {
    [theTextField resignFirstResponder];
    CGPoint offset = CGPointMake([self.pickerView selectedItem]*[UIScreen mainScreen].bounds.size.width,0);
    [self.scrollviewOutlet setContentOffset:offset animated:YES];
    return YES;
}

- (void)finishSelect:(NSMutableArray *)type SelectName:(NSMutableArray *)nameArray{
    if ([self.intentionOutlet isFirstResponder]) {
        [self.intentionOutlet resignFirstResponder];
    }
    if([type count]>0){
        typeArray=type;
        
        NSString *typeString=[[NSString alloc]init];
        for (NSString *str in nameArray ) {
            typeString=[typeString stringByAppendingString:[NSString stringWithFormat:@"%@,",str]];
        }
        self.intentionOutlet.text=[NSString stringWithFormat:@"%@",typeString];
    }else{
        self.intentionOutlet.text=@"全部";
        [typeArray removeAllObjects];
    }
}

//编辑上移
-(void)textFieldOutletWork:(UITextField *)sender{
    if ([[sender restorationIdentifier] isEqualToString:@"userintention"]) {
        [sender resignFirstResponder];
        MLSelectJobTypeVC *selectVC=[[MLSelectJobTypeVC alloc]init];
        selectVC.selectDelegate=self;
        [self.navigationController pushViewController:selectVC animated:YES];
    }else{
        CGFloat yDiff = sender.frame.origin.y-sender.frame.size.height-10;
        if (yDiff<10) {
            return;
        }
        CGPoint offset = CGPointMake([self.pickerView selectedItem]*[UIScreen mainScreen].bounds.size.width,yDiff);
        [self.scrollviewOutlet setContentOffset:offset animated:YES];
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

#pragma mark - AKPickerViewDataSource

- (NSUInteger)numberOfItemsInPickerView:(AKPickerView *)pickerView
{
    return [self.titles count];
}

/*
 * AKPickerView now support images!
 *
 * Please comment '-pickerView:titleForItem:' entirely
 * and uncomment '-pickerView:imageForItem:' to see how it works.
 *
 */

//- (NSString *)pickerView:(AKPickerView *)pickerView titleForItem:(NSInteger)item
//{
//	return self.titles[item];
//}


- (UIImage *)pickerView:(AKPickerView *)pickerView imageForItem:(NSInteger)item
{
    return self.titles[item];
}


#pragma mark - AKPickerViewDelegate

- (void)pickerView:(AKPickerView *)pickerView didSelectItem:(NSInteger)item
{
    self.pageIndicator.page = item;
    CGPoint offset = CGPointMake(self.scrollviewOutlet.frame.size.width * item, self.scrollviewOutlet.contentOffset.y);
    [self.scrollviewOutlet setContentOffset:offset animated:YES];
    [pickerView reloadData];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    // Too noisy...
    // NSLog(@"%f", scrollView.contentOffset.x);
}


/*
 * Label Customization
 *
 * You can customize labels by their any properties (except font,)
 * and margin around text.
 * These methods are optional, and ignored when using images.
 *
 */

/*
 - (void)pickerView:(AKPickerView *)pickerView configureLabel:(UILabel *const)label forItem:(NSInteger)item
 {
	label.textColor = [UIColor lightGrayColor];
	label.highlightedTextColor = [UIColor whiteColor];
	label.backgroundColor = [UIColor colorWithHue:(float)item/(float)self.titles.count
 saturation:1.0
 brightness:1.0
 alpha:1.0];
 }
 */

/*
 - (CGSize)pickerView:(AKPickerView *)pickerView marginForItem:(NSInteger)item
 {
	return CGSizeMake(40, 20);
 }
 */

#pragma mark - UIScrollViewDelegate

/*
 * AKPickerViewDelegate inherits UIScrollViewDelegate.
 * You can use UIScrollViewDelegate methods
 * by simply setting pickerView's delegate.
 *
 */


- (void)createPages:(NSInteger)pages {
    
    [self.view1outlet setFrame:CGRectMake([UIScreen mainScreen].bounds.size.width* 0, 0,[UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    
    [self.view4outlet setFrame:CGRectMake([UIScreen mainScreen].bounds.size.width* 1, 0,[UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    
    [self.view3outlet setFrame:CGRectMake([UIScreen mainScreen].bounds.size.width* 2, 0,[UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    
    [self.view5outlet setFrame:CGRectMake([UIScreen mainScreen].bounds.size.width* 3, 0,[UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    
//    [self.view5outlet setFrame:CGRectMake([UIScreen mainScreen].bounds.size.width* 4, 0,[UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    
    [self.scrollviewOutlet addSubview:self.view1outlet];
//    [self.scrollviewOutlet addSubview:self.view2outlet];
    [self.scrollviewOutlet addSubview:self.view4outlet];
    [self.scrollviewOutlet addSubview:self.view3outlet];
    [self.scrollviewOutlet addSubview:self.view5outlet];
    
    CGFloat scrennHeight = [UIScreen mainScreen].bounds.size.height;
    
    if(scrennHeight < 481){
        [self.scrollviewOutlet setContentSize:CGSizeMake(CGRectGetWidth([UIScreen mainScreen].bounds) * pages, CGRectGetHeight([UIScreen mainScreen].bounds))];
    }else{
        [self.scrollviewOutlet setContentSize:CGSizeMake(CGRectGetWidth([UIScreen mainScreen].bounds) * pages, 0)];
    }
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if ([[scrollView restorationIdentifier] isEqualToString:scrollindentify]) {
        NSInteger page = floorf(self.scrollviewOutlet.contentOffset.x / self.scrollviewOutlet.frame.size.width);
        CGPoint offset = CGPointMake(self.scrollviewOutlet.frame.size.width * page, self.scrollviewOutlet.contentOffset.y);
        [self.scrollviewOutlet setContentOffset:offset animated:YES];
        self.pageIndicator.page = page;
        [self.pickerView selectItem:page animated:YES];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if ([[scrollView restorationIdentifier] isEqualToString:scrollindentify]) {
        if (!decelerate) {
            NSInteger page = floorf(self.scrollviewOutlet.contentOffset.x / self.scrollviewOutlet.frame.size.width);
            CGPoint offset = CGPointMake(self.scrollviewOutlet.frame.size.width * page, self.scrollviewOutlet.contentOffset.y);
            [self.scrollviewOutlet setContentOffset:offset animated:YES];
            self.pageIndicator.page = page;
            [self.pickerView selectItem:page animated:YES];
            //[self.pickerView reloadData];
        }
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

- (IBAction)continueAction:(id)sender {
    NSInteger currentpage = [self.pickerView selectedItem];
    if (currentpage == self.pages-1) {
        return;
    }
    NSInteger nextpage = currentpage+1;
    CGPoint offset = CGPointMake(self.scrollviewOutlet.frame.size.width * nextpage, self.scrollviewOutlet.contentOffset.y);
    [self.scrollviewOutlet setContentOffset:offset animated:YES];
    self.pageIndicator.page = nextpage;
    [self.pickerView selectItem:nextpage animated:YES];

}


//page1
#pragma mark - QRadioButtonDelegate

- (void)didSelectedRadioButton:(QRadioButton *)radio groupId:(NSString *)groupId {
//    NSLog(@"did selected radio:%@ groupId:%@ status:%d", radio.titleLabel.text, groupId,[radio getStatus]);
    if ([radio getStatus] == maleStatus) {
        [self.usermodel setuserGender:[NSNumber numberWithInt:maleStatus]];
    }
    if ([radio getStatus] == femaleStatus) {
        [self.usermodel setuserGender:[NSNumber numberWithInt:femaleStatus]];
    }
}

- (IBAction)birthdayAction:(UIButton *)sender {
    
}

//page3
//设置新的url
- (void) getVideoURLDelegate:(NSObject *)videoURL{
    NSString *URLTemp = (NSString *)videoURL;
    if (URLTemp != Nil) {
        [self.usermodel setuserVideoURL:URLTemp];
    }
    NSLog(@"获得videourl = %@",[self.usermodel getuserVideoURL]);
}

- (IBAction)addPicAction:(UIButton *)sender {
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                  initWithTitle:Nil
                                  delegate:self
                                  cancelButtonTitle:@"取消"
                                  destructiveButtonTitle:Nil
                                  otherButtonTitles:@"选择本地图片",@"拍照",nil];
    actionSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
    actionSheet.tag = 0;
    [actionSheet showInView:self.view];
}

//action
//tag == 0 为选择图片按钮
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet.tag == 0) {
        if (buttonIndex == 0) {
            UIImagePickerController *imagePickerController =[[UIImagePickerController alloc]init];
            imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            imagePickerController.delegate = self;
            imagePickerController.allowsEditing = TRUE;
            [self presentViewController:imagePickerController animated:YES completion:^{}];
            return;
        }
        if (buttonIndex == 1) {
            UIImagePickerController *imagePickerController =[[UIImagePickerController alloc]init];
            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
            {
                imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
                imagePickerController.delegate = self;
                imagePickerController.allowsEditing = TRUE;
                [self presentViewController:imagePickerController animated:YES completion:^{}];
            }else{
                UIAlertView *alterTittle = [[UIAlertView alloc] initWithTitle:@"提示" message:@"无法使用照相功能" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil];
                [alterTittle show];
            }
            return;
        }
    }
}

//action响应事件
- (void)actionSheetCancel:(UIActionSheet *)actionSheet{
    
}
-(void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex{
    
}
-(void)actionSheet:(UIActionSheet *)actionSheet willDismissWithButtonIndex:(NSInteger)buttonIndex{
    
}

-(BOOL)writeImageToDoc:(UIImage*)image{
    BOOL result;
    @synchronized(self) {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
        fileTempPath = [[paths objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@UserDetailTemp.png",[baseAPP getUsrID]]];
        result = [UIImagePNGRepresentation(image)writeToFile:fileTempPath atomically:YES];
    }
    return result;
}

//图片获取
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo{

    UIImage *temp = image;
    if (image.size.height > PIC_HEIGHT || image.size.width>PIC_WIDTH) {
        float a = image.size.height>image.size.width?image.size.height:image.size.width;
        temp = [self scaleImage:image toScale:320/a];
    }
    picker = Nil;
    [self dismissModalViewControllerAnimated:YES];
    if (![self writeImageToDoc:image]) {
        UIAlertView *alterTittle = [[UIAlertView alloc] initWithTitle:@"提示" message:@"写入文件夹错误,请重试" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil];
        [alterTittle show];
    }else{
        //添加图片
        imageButton *btnPic=[[imageButton alloc]initWithFrame:CGRectMake(-PIC_WIDTH, INSETS, PIC_WIDTH, PIC_HEIGHT)];
        btnPic.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        btnPic.titleLabel.font = [UIFont systemFontOfSize:13];
        UIImage *darkTemp = [temp rt_darkenWithLevel:0.5f];
        [btnPic setBackgroundImage:darkTemp forState:UIControlStateNormal];
        [btnPic setFrame:CGRectMake(-PIC_WIDTH, INSETS, PIC_WIDTH, PIC_HEIGHT)];
        [addedPicArray addObject:btnPic];
        [btnPic setRestorationIdentifier:[NSString stringWithFormat:@"%lu",(unsigned long)addedPicArray.count-1]];
        [btnPic addTarget:self action:@selector(deletePicAction:) forControlEvents:UIControlEventTouchUpInside];
        [btnPic setStatus:uplaoding];
        [self.picscrollview addSubview:btnPic];
        
        for (imageButton *btn in addedPicArray) {
            CABasicAnimation *positionAnim=[CABasicAnimation animationWithKeyPath:@"position"];
            [positionAnim setFromValue:[NSValue valueWithCGPoint:CGPointMake(btn.center.x, btn.center.y)]];
            [positionAnim setToValue:[NSValue valueWithCGPoint:CGPointMake(btn.center.x+INSETS+PIC_WIDTH, btn.center.y)]];
            [positionAnim setDelegate:self];
            [positionAnim setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
            [positionAnim setDuration:0.25f];
            [btn.layer addAnimation:positionAnim forKey:nil];
            
            [btn setCenter:CGPointMake(btn.center.x+INSETS+PIC_WIDTH, btn.center.y)];
        }
        [self refreshScrollView];
        
        
        //上传图片
        [BmobFile filesUploadBatchWithPaths:@[fileTempPath]
                              progressBlock:^(int index, float progress) {
                                  dispatch_async(dispatch_get_main_queue(), ^{
                                      [btnPic setTitle:[NSString stringWithFormat:@"上传:%ld％",(long)(progress*100)] forState:UIControlStateNormal];
                                  });
                              } resultBlock:^(NSArray *array, BOOL isSuccessful, NSError *error) {
                                  
                                  if (isSuccessful) {
                                      NSString *imageTemp = Nil;
                                      for (int i = 0 ; i < array.count ;i ++) {
                                          BmobFile *file = array [i];
                                          imageTemp = [file url];
                                          if (imageTemp != Nil) {
                                              
                                              dispatch_async(dispatch_get_main_queue(), ^{
                                                  if ([self.usermodel getImageFileURL] == Nil) {
                                                      [self.usermodel setImageFileURL:[[NSMutableArray alloc]init]];
                                                  }
                                                  [[self.usermodel getImageFileURL] addObject:imageTemp];
                                                  [btnPic setStatus:uploadOK];
                                                  
                                                  [btnPic setTitle:@"" forState:UIControlStateNormal];
                                                  [btnPic setBackgroundImage:temp forState:UIControlStateNormal];
                                                  [MBProgressHUD showError:@"上传成功" toView:self.view];
                                              });
                                          }else{
                                              dispatch_async(dispatch_get_main_queue(), ^{
                                                  [btnPic setTitle:@"失败" forState:UIControlStateNormal];
                                                  [btnPic setBackgroundImage:temp forState:UIControlStateNormal];
                                                  [btnPic setStatus:uploaderror];
                                                  [MBProgressHUD showError:@"上传失败" toView:self.view];
                                              });
                                          }
                                      }
                                      
                                  }else{
                                      dispatch_async(dispatch_get_main_queue(), ^{
                                          [btnPic setTitle:@"失败" forState:UIControlStateNormal];
                                          [btnPic setBackgroundImage:temp forState:UIControlStateNormal];
                                          [btnPic setStatus:uploaderror];
                                          [MBProgressHUD showError:@"上传失败" toView:self.view];
                                      });
                                  }
                              }];
    }
}

-(UIImage *)scaleImage:(UIImage *)image toScale:(float)scaleSize{
    
    UIGraphicsBeginImageContext(CGSizeMake(image.size.width * scaleSize, image.size.height * scaleSize));
    [image drawInRect:CGRectMake(0, 0, image.size.width * scaleSize, image.size.height * scaleSize)];
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return scaledImage;
}
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    picker = Nil;
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)deletePicAction_uploadOKandfromNet:(imageButton *)sender{
    NSInteger btnindex = [sender restorationIdentifier].integerValue;
    imageButton *btn = [addedPicArray objectAtIndex:btnindex];
    [btn removeFromSuperview];
    for (imageButton *tempbtn in addedPicArray) {
        if ([tempbtn restorationIdentifier].intValue > btnindex) {
            [tempbtn setRestorationIdentifier:[NSString stringWithFormat:@"%d",[tempbtn restorationIdentifier].intValue-1]];
            continue;
        }
        if ([tempbtn restorationIdentifier].intValue == btnindex) {
            continue;
        }
        if ([tempbtn restorationIdentifier].intValue < btnindex) {
            CABasicAnimation *positionAnim=[CABasicAnimation animationWithKeyPath:@"position"];
            [positionAnim setFromValue:[NSValue valueWithCGPoint:CGPointMake(tempbtn.center.x, tempbtn.center.y)]];
            [positionAnim setToValue:[NSValue valueWithCGPoint:CGPointMake(tempbtn.center.x-INSETS-PIC_WIDTH, tempbtn.center.y)]];
            [positionAnim setDelegate:self];
            [positionAnim setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
            [positionAnim setDuration:0.25f];
            [tempbtn.layer addAnimation:positionAnim forKey:nil];
            [tempbtn setCenter:CGPointMake(tempbtn.center.x-INSETS-PIC_WIDTH, tempbtn.center.y)];
        }
    }
    [addedPicArray removeObjectAtIndex:btnindex];
    [self refreshScrollView];
}

-(void)deletePicAction_uplaoding{
    
}

-(void)deletePicAction_uploaderror{
    
}


-(IBAction)deletePicAction:(imageButton *)sender{
    switch ([sender getStatus]) {
        case uploadOK:
            [self deletePicAction_uploadOKandfromNet:sender];
            break;
        case uplaoding:
            [self deletePicAction_uplaoding];
            break;
        case uploaderror:
            [self deletePicAction_uploaderror];
            break;
        case fromNet:
            [self deletePicAction_uploadOKandfromNet:sender];
            break;
        default:
            break;
    }
}
- (void)refreshScrollView
{
    CGFloat width=(PIC_WIDTH+INSETS*2)+(addedPicArray.count-1)*(PIC_WIDTH+INSETS);
    CGSize contentSize=CGSizeMake(width, PIC_HEIGHT+INSETS*2);
    [self.picscrollview setContentSize:contentSize];
    [self.picscrollview setContentOffset:CGPointMake(width<self.picscrollview.frame.size.width?0:width-self.picscrollview.frame.size.width, 0) animated:YES];
}
- (IBAction)callVideoAction:(UIButton *)sender {
    MLResumeVideoVC *vc = [[MLResumeVideoVC alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}

//page4
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
}
- (IBAction)selectProAction:(UIButton *)sender {
}
- (IBAction)selectCityAction:(UIButton *)sender {
}
- (IBAction)selectDisAction:(UIButton *)sender {
}
@end
