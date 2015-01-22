//
//  MLProfileVC.m
//  jobSearch
//
//  Created by RAY on 15/1/19.
//  Copyright (c) 2015年 麻辣工作室. All rights reserved.
//

#import "MLProfileVC.h"

@interface MLProfileVC ()
@property (strong, nonatomic) IBOutlet UIView *view1;
@property (strong, nonatomic) IBOutlet UIView *view2;
@property (strong, nonatomic) IBOutlet UIView *view3;

@end

@implementation MLProfileVC

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.title=@"创建我的简历";
    
    self.scrollView.delegate=self;
    self.pages = 3;
    KVNMaskedPageControl *pageControl = [[KVNMaskedPageControl alloc] init];
    [pageControl setNumberOfPages:self.pages];

    [pageControl setCenter:CGPointMake(CGRectGetMidX([UIScreen mainScreen].bounds), 200)];

    [pageControl setDataSource:self];
    [pageControl setHidesForSinglePage:YES];
    
    [self.view addSubview:pageControl];
    
    self.pageControl = pageControl;
    
    [self createPages:self.pages];
    
    [self.pageControl addTarget:self action:@selector(changePage:) forControlEvents:UIControlEventValueChanged];

}

- (IBAction)click:(id)sender {
    //跳转至下一页面
    [self.scrollView setContentOffset:CGPointMake(CGRectGetWidth([UIScreen mainScreen].bounds)* 1, 0) animated:YES];
}

- (void)createPages:(NSInteger)pages {
    
    [self.view1 setFrame:CGRectMake(CGRectGetWidth([UIScreen mainScreen].bounds)* 0, 0, CGRectGetWidth([UIScreen mainScreen].bounds), CGRectGetHeight([UIScreen mainScreen].bounds))];
    
    [self.view2 setFrame:CGRectMake(CGRectGetWidth([UIScreen mainScreen].bounds)* 1, 0, CGRectGetWidth([UIScreen mainScreen].bounds), CGRectGetHeight([UIScreen mainScreen].bounds))];
    
    [self.view3 setFrame:CGRectMake(CGRectGetWidth([UIScreen mainScreen].bounds)* 2, 0, CGRectGetWidth([UIScreen mainScreen].bounds), CGRectGetHeight([UIScreen mainScreen].bounds))];
    
    [self.scrollView addSubview:self.view1];
    [self.scrollView addSubview:self.view2];
    [self.scrollView addSubview:self.view3];

    [self.scrollView setContentSize:CGSizeMake(CGRectGetWidth([UIScreen mainScreen].bounds) * pages, CGRectGetHeight([UIScreen mainScreen].bounds))];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self.pageControl maskEventWithOffset:scrollView.contentOffset.x frame:scrollView.frame];
    
//    CGFloat pageWidth = self.scrollView.frame.size.width;
//    if (self.scrollView.contentOffset.x>(self.pages-1)*pageWidth+pageWidth/4) {
//        [self touchStart];
//    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    CGFloat pageWidth = self.scrollView.frame.size.width;
    NSInteger page =  floor((self.scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    [self.pageControl setCurrentPage:page];
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    CGFloat pageWidth = self.scrollView.frame.size.width;
    NSInteger page =  floor((self.scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    
    [self.pageControl setCurrentPage:page];
}

#pragma mark - IBActions
- (void)changePage:(KVNMaskedPageControl *)sender {
    self.pageControl.currentPage = sender.currentPage;
    
    CGRect frame = self.scrollView.frame;
    frame.origin.x = frame.size.width * self.pageControl.currentPage;
    frame.origin.y = 0;
    [self.scrollView scrollRectToVisible:frame animated:YES];
}

#pragma mark - KVNMaskedPageControlDataSource
- (UIColor *)pageControl:(KVNMaskedPageControl *)control pageIndicatorTintColorForIndex:(NSInteger)index {
    return [UIColor colorWithWhite:1.0 alpha:0.6];
}

- (UIColor *)pageControl:(KVNMaskedPageControl *)control currentPageIndicatorTintColorForIndex:(NSInteger)index {
    return [UIColor colorWithRed:0.98 green:0.30 blue:0.37 alpha:1.0];
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
