//
//  MLMatchVC.m
//  jobSearch
//
//  Created by RAY on 15/1/23.
//  Copyright (c) 2015年 麻辣工作室. All rights reserved.
//

#import "MLMatchVC.h"
#import "RSCircaPageControl.h"
#import "PiPeiView.h"
#import "MBProgressHUD.h"
#import "netAPI.h"
#import "MLLoginVC.h"

//static NSString *userId = @"54d76bd496d9aece6f8b4568";

@interface RSView : UIView

@property (nonatomic, weak) UIScrollView *scrollView;

@end

@implementation RSView

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    UIView *child = nil;
    if ((child = [super hitTest:point withEvent:event]) == self) {
        return self.scrollView;
    }
    return child;
}

@end


@interface MLMatchVC ()<UIScrollViewDelegate,childViewDelegate,finishLoginDelegate>
{
    int kScrollViewHeight;
    int kScrollViewContentHeight;
    int kScrollViewTagBase;
    
    NSMutableArray *recordArray;
    NSMutableArray *childViewArray;
}

@property (nonatomic, strong) RSView *clipView;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) RSCircaPageControl *pageControl;

@end

@implementation MLMatchVC


static int pageNumber=5;
static  MLMatchVC *thisVC=nil;

+ (MLMatchVC*)sharedInstance{
    if (thisVC==nil) {
        thisVC=[[MLMatchVC alloc]init];
    }
    return thisVC;
}

//- (void)viewWillLayoutSubviews{
//    self.title=@"精灵管家";
//    //设置导航栏标题颜色及返回按钮颜色
//    self.navigationController.navigationBar.barStyle = UIStatusBarStyleDefault;
//    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
//    NSMutableDictionary *titleBarAttributes = [NSMutableDictionary dictionaryWithDictionary:[[UINavigationBar appearance] titleTextAttributes]];
//    [titleBarAttributes setValue:[UIColor whiteColor] forKey:UITextAttributeTextColor];
//    
//    [self.navigationController.navigationBar setTitleTextAttributes:titleBarAttributes];
//}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"精灵管家";
    
    kScrollViewHeight = [[UIScreen mainScreen]bounds].size.height;
    kScrollViewContentHeight=kScrollViewHeight;
    kScrollViewTagBase=kScrollViewHeight;

    
    recordArray=[[NSMutableArray alloc]init];
    childViewArray=[[NSMutableArray alloc]init];
    self.clipView = [[RSView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    self.clipView.clipsToBounds = YES;
    [self.view addSubview:self.clipView];
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, self.clipView.bounds.size.width, kScrollViewHeight)];
    self.scrollView.delegate = self;
    self.scrollView.clipsToBounds = NO;
    self.scrollView.pagingEnabled = YES;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [self.view addSubview:self.scrollView];
    self.clipView.scrollView = self.scrollView;
    
    self.pageControl = [[RSCircaPageControl alloc] initWithNumberOfPages:pageNumber];
    CGRect frame = self.pageControl.frame;
    frame.origin.x = self.view.bounds.size.width - frame.size.width - 10;
    frame.origin.y = roundf((self.view.bounds.size.height - frame.size.height) / 2.);
    self.pageControl.frame = frame;
    self.pageControl.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
    [self.pageControl setCurrentPage:0 usingScroller:NO];
    [self.view addSubview:self.pageControl];
    
    [self initData];
}

- (void)refreshScrollView{
    
    for (id view in [self.scrollView subviews]) {
        [view removeFromSuperview];
    }
    
    CGFloat currentY = 0;
    
    for (int i = 0; i < [recordArray count]; i++) {
        
        PiPeiView* childView=[[PiPeiView alloc]init];
        childView.childViewDelegate=self;
        [self addChildViewController:childView];
        
        [childView.view setFrame:CGRectMake(0, currentY, self.scrollView.bounds.size.width, kScrollViewHeight-44)];
        
        childView.view.tag = kScrollViewTagBase + i;
        
        childView.view.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        
        jobModel *_jobModel=[recordArray objectAtIndex:i];
        
        if (_jobModel) {
        
            childView.jobModel=_jobModel;
            childView.index=i;
            [childView initData];
        }
        [childViewArray addObject:childView.view];
        [self.scrollView addSubview:childView.view];
        currentY += kScrollViewHeight;
    }
    
    self.scrollView.contentSize = CGSizeMake(self.scrollView.contentSize.width, currentY);

}

- (void)initData{
    
    NSUserDefaults *myData = [NSUserDefaults standardUserDefaults];
    NSString *currentUserObjectId=[myData objectForKey:@"currentUserObjectId"];
    if ([currentUserObjectId length]>0) {
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [netAPI queryJingLingMatch:currentUserObjectId start:1 length:pageNumber withBlock:^(jobListModel *jobListModel) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        if ([jobListModel.getStatus intValue]!=0) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"信息加载失败" message:jobListModel.getInfo delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alert show];
        }
        else{
            if ([jobListModel.getJobArray count]<1) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"暂时没有适合你的职位哦~" message:jobListModel.getInfo delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
                [alert show];

            }else{
                
                for (jobModel *jobModel in jobListModel.getJobArray) {
                    [recordArray addObject:jobModel];
                }
                
                [self refreshScrollView];
            }
        }
    }];
    }
    else{
        UIAlertView *loginAlert=[[UIAlertView alloc]initWithTitle:@"未登录" message:@"是否现在登录？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"登录", nil];
        [loginAlert show];
    }
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (buttonIndex==1) {
        MLLoginVC *loginVC=[[MLLoginVC alloc]init];
        loginVC.loginDelegate=self;
        [self.navigationController pushViewController:loginVC animated:YES];
    }
}

- (void)finishLogin{
    [self initData];
}

- (void)deleteJob:(int)index{
    
    if (index>=0&&index<[recordArray count]) {
        
        [[childViewArray objectAtIndex:index] removeFromSuperview];
        
        for (int i=index+1;i<[recordArray count];i++ ) {
            UIView *currentView=[childViewArray objectAtIndex:i];
            
            [UIView animateWithDuration:0.3 animations:^{
                [currentView setCenter:CGPointMake(currentView.center.x, currentView.center.y-kScrollViewHeight)];
            }];
        }
        self.scrollView.contentSize = CGSizeMake(self.scrollView.contentSize.width, self.scrollView.contentSize.height-kScrollViewHeight);
        
        //删除匹配的职位
        NSUserDefaults *myData = [NSUserDefaults standardUserDefaults];
        NSString *currentUserObjectId=[myData objectForKey:@"currentUserObjectId"];

        jobModel *_jobModel=[recordArray objectAtIndex:index];
        
        if (_jobModel.getjobID&&[currentUserObjectId length]>0) {
            [netAPI deleteMatchJob:_jobModel.getjobID userId:currentUserObjectId withBlock:^(oprationResultModel *oprationResultModel) {
                if ([oprationResultModel.getStatus intValue]==0) {
                    NSLog(@"删除成功");
                }
            }];
        }
    }
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView != self.scrollView) {
        float percentage = scrollView.contentOffset.y / (scrollView.contentSize.height - scrollView.bounds.size.height);
        [self.pageControl updateScrollerAtPercentage:percentage animated:YES];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (scrollView == self.scrollView) {
        int index = (int)(scrollView.contentOffset.y / kScrollViewHeight);
        
        [self.pageControl setCurrentPage:index usingScroller:NO];
        
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
