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


@interface MLMatchVC ()<UIScrollViewDelegate>
{
    int kScrollViewHeight;
    int kScrollViewContentHeight;
    int kScrollViewTagBase;

}

@property (nonatomic, strong) RSView *clipView;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) RSCircaPageControl *pageControl;

@end

@implementation MLMatchVC



static  MLMatchVC *thisVC=nil;

+ (MLMatchVC*)sharedInstance{
    if (thisVC==nil) {
        thisVC=[[MLMatchVC alloc]init];
    }
    return thisVC;
}

- (void)viewWillLayoutSubviews{
    self.title=@"精灵匹配";
    //设置导航栏标题颜色及返回按钮颜色
    self.navigationController.navigationBar.barStyle = UIStatusBarStyleDefault;
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    NSMutableDictionary *titleBarAttributes = [NSMutableDictionary dictionaryWithDictionary:[[UINavigationBar appearance] titleTextAttributes]];
    [titleBarAttributes setValue:[UIColor whiteColor] forKey:UITextAttributeTextColor];
    
    [self.navigationController.navigationBar setTitleTextAttributes:titleBarAttributes];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    kScrollViewHeight = [[UIScreen mainScreen]bounds].size.height;
    kScrollViewContentHeight=kScrollViewHeight;
    kScrollViewTagBase=kScrollViewHeight;
    
    self.clipView = [[RSView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    self.clipView.clipsToBounds = YES;
    [self.view addSubview:self.clipView];
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.clipView.bounds.size.width, kScrollViewHeight)];
    self.scrollView.delegate = self;
    self.scrollView.clipsToBounds = NO;
    self.scrollView.pagingEnabled = YES;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [self.view addSubview:self.scrollView];
    self.clipView.scrollView = self.scrollView;
    
    self.pageControl = [[RSCircaPageControl alloc] initWithNumberOfPages:5];
    CGRect frame = self.pageControl.frame;
    frame.origin.x = self.view.bounds.size.width - frame.size.width - 10;
    frame.origin.y = roundf((self.view.bounds.size.height - frame.size.height) / 2.);
    self.pageControl.frame = frame;
    self.pageControl.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
    [self.pageControl setCurrentPage:0 usingScroller:NO];
    [self.view addSubview:self.pageControl];
    
    CGFloat currentY = 0;
    
    
    for (int i = 0; i < 5; i++) {
        
        PiPeiView* childView=[[PiPeiView alloc]init];
        [self addChildViewController:childView];
        
        [childView.view setFrame:CGRectMake(0, currentY, self.scrollView.bounds.size.width, kScrollViewHeight-44)];
        //childView.label.text=[NSString stringWithFormat:@"第%d页",i];
        
        childView.view.tag = kScrollViewTagBase + i;
        
        childView.view.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        
        [self.scrollView addSubview:childView.view];
        
        currentY += kScrollViewHeight;
    }
    
    self.scrollView.contentSize = CGSizeMake(self.scrollView.contentSize.width, currentY);

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
        
        //UIView *sv=(UIView*)[self.scrollView viewWithTag:kScrollViewTagBase + index];
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
