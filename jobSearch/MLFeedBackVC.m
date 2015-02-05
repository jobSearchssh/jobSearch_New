//
//  MLFeedBackVC.m
//  jobSearch
//
//  Created by RAY on 15/2/5.
//  Copyright (c) 2015年 麻辣工作室. All rights reserved.
//

#import "MLFeedBackVC.h"
#import "CWStarRateView.h"

@interface MLFeedBackVC ()<CWStarRateViewDelegate>
{
    float value;
    CGRect rect1;
}
@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (strong, nonatomic) CWStarRateView *starRateView1;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraint;
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
    
    self.starRateView1 = [[CWStarRateView alloc] initWithFrame:CGRectMake(20, 60, [[UIScreen mainScreen] bounds].size.width-40, 40) numberOfStars:5];
    self.starRateView1.scorePercent = 1.0;
    self.starRateView1.allowIncompleteStar = NO;
    self.starRateView1.hasAnimation = YES;
    self.starRateView1.delegate=self;
    [self.containerView addSubview:self.starRateView1];
    value=5.0f;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillhide:) name:UIKeyboardWillHideNotification object:nil];

}

- (void)starRateView:(CWStarRateView *)starRateView scroePercentDidChange:(CGFloat)newScorePercent{

    value=starRateView.scorePercent*5;
    
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.textView resignFirstResponder];
}

- (void)keyboardWillShow:(NSNotification *)notification{
    
//    CGRect rect2;
//    if ([[UIScreen mainScreen] bounds].size.height==480) {
//        rect2=CGRectMake(rect1.origin.x, rect1.origin.y-300, rect1.size.width, rect1.size.height);
//    }else{
//        rect2=CGRectMake(rect1.origin.x, rect1.origin.y-200, rect1.size.width, rect1.size.height);
//    }
//    
    [UIView animateWithDuration:0.3 animations:^{
        
        self.constraint.constant=10;
    }];
}

- (void)keyboardWillhide:(NSNotification *)notification{
    
    [UIView animateWithDuration:0.3 animations:^{
        self.constraint.constant=80;
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
