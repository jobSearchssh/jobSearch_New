//
//  MLFeedBackVC.m
//  jobSearch
//
//  Created by RAY on 15/2/5.
//  Copyright (c) 2015年 麻辣工作室. All rights reserved.
//

#import "MLFeedBackVC.h"
#import "CWStarRateView.h"
#import "UMFeedback.h"
#import "MBProgressHUD.h"
#import "MBProgressHUD+Add.h"
#import "MLTextUtils.h"


@interface MLFeedBackVC ()<CWStarRateViewDelegate,UMFeedbackDataDelegate,UITextViewDelegate>
{
    float value;
    CGRect rect1;
}

@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (strong, nonatomic) CWStarRateView *starRateView1;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraint;
@property (strong, nonatomic) UMFeedback *feedback;
@end

@implementation MLFeedBackVC

static  MLFeedBackVC *thisVC=nil;
+ (MLFeedBackVC*)sharedInstance{
    if (thisVC==nil) {
        thisVC=[[MLFeedBackVC alloc]init];
    }
    return thisVC;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.starRateView1 = [[CWStarRateView alloc] initWithFrame:CGRectMake(20, 40, [[UIScreen mainScreen] bounds].size.width-40, 40) numberOfStars:5];
    self.starRateView1.scorePercent = 1.0;
    self.starRateView1.allowIncompleteStar = NO;
    self.starRateView1.hasAnimation = YES;
    self.starRateView1.delegate=self;
    [self.view insertSubview:self.starRateView1 belowSubview:self.containerView];
    value=5.0f;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillhide:) name:UIKeyboardWillHideNotification object:nil];
    
    self.feedback = [UMFeedback sharedInstance];
    self.feedback.delegate = self;
    
    //键盘上方的按钮
    UIToolbar * topView = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 30)];
    [topView setBarStyle:UIBarStyleDefault];
    
    UIBarButtonItem * btnSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    UIBarButtonItem * doneButton = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(dismissKeyBoard)];
    NSArray * buttonsArray = [NSArray arrayWithObjects:btnSpace, doneButton, nil];
    
    [topView setItems:buttonsArray];
    [self.textView setInputAccessoryView:topView];

}

- (IBAction)sendFeedBack:(id)sender {
    
    if ([self.textView.text length]==0) {
        [MBProgressHUD showError:FEEDBACK_ALERT toView:self.view];
    }
    else{
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        NSString *feedBackString=[NSString stringWithFormat:@"评分：%.1f  评价：%@",value,self.textView.text];
        NSDictionary *postContent = @{@"content":feedBackString};
        [self.feedback post:postContent];
    }
}

- (void)postFinishedWithError:(NSError *)error {
    
    [MBProgressHUD hideAllHUDsForView:self.view animated:NO];
    
    if (error != nil) {
        [MBProgressHUD showError:FEEDBACK_FAIL toView:self.view];
    } else {
        [MBProgressHUD showSuccess:FEEDBACK_SUCCESS toView:self.view];
    }
}

- (void)starRateView:(CWStarRateView *)starRateView scroePercentDidChange:(CGFloat)newScorePercent{
    value=starRateView.scorePercent*5;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.textView resignFirstResponder];
}

- (void)keyboardWillShow:(NSNotification *)notification{
    
    [UIView animateWithDuration:0.3 animations:^{
        self.constraint.constant=-30;
    }];
}

- (void)keyboardWillhide:(NSNotification *)notification{
    
    [UIView animateWithDuration:0.3 animations:^{
        self.constraint.constant=80;
    }];
}

- (void)dismissKeyBoard{
    [self.textView resignFirstResponder];
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
