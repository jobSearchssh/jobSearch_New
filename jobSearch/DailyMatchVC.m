//
//  DailyMatchVC.m
//  jobSearch
//
//  Created by RAY on 15/1/17.
//  Copyright (c) 2015年 麻辣工作室. All rights reserved.
//

#import "DailyMatchVC.h"
#import "ZLSwipeableView.h"
#import "UIColor+FlatColors.h"
#import "CardView.h"

@interface DailyMatchVC ()<ZLSwipeableViewDataSource,ZLSwipeableViewDelegate>
{
    UIImageView *likeImgView;
}
@property (nonatomic, weak) IBOutlet ZLSwipeableView *swipeableView;
@property (nonatomic, strong) NSArray *colors;
@property (nonatomic) NSUInteger colorIndex;

@end

@implementation DailyMatchVC

static  DailyMatchVC *thisVC=nil;
+ (DailyMatchVC*)sharedInstance{
    if (thisVC==nil) {
        thisVC=[[DailyMatchVC alloc]init];
    }
    return thisVC;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.swipeableView.delegate = self;
    
    self.colorIndex = 0;
    self.colors = @[
                    @"Turquoise",
                    @"Green Sea",
                    @"Emerald",
                    @"Nephritis",
                    @"Peter River",
                    @"Belize Hole",
                    @"Amethyst",
                    @"Wisteria",
                    @"Wet Asphalt",
                    @"Midnight Blue",
                    @"Sun Flower",
                    @"Orange",
                    @"Carrot",
                    @"Pumpkin",
                    @"Alizarin",
                    @"Pomegranate",
                    @"Clouds",
                    @"Silver",
                    @"Concrete",
                    @"Asbestos"
                    ];
}

- (void)viewDidLayoutSubviews {
    // Required Data Source
    self.swipeableView.dataSource = self;
    
    likeImgView=[[UIImageView alloc]initWithFrame:CGRectMake(self.swipeableView.frame.size.width/2-25,self.swipeableView.frame.size.height/2-25, 50, 50)];
    likeImgView.image=[UIImage imageNamed:@"accept"];
    likeImgView.alpha=0.0f;
    [self.swipeableView addSubview:likeImgView];
}

- (IBAction)dontlikeClick:(id)sender {
    [self.swipeableView swipeTopViewToLeft];
}

- (IBAction)likeClick:(id)sender {
    [self.swipeableView swipeTopViewToRight];
}

- (void)updateLikeImageView:(CGPoint)transition Status:(int)status{
    
    //准备开始滑动
    if (status==0) {
        likeImgView.alpha=0.0f;
    }
    //正在滑动
    else if (status==1){
        if (transition.x>0) {
            likeImgView.image=[UIImage imageNamed:@"accept"];
            likeImgView.alpha=((float)transition.x/100);
        }else if (transition.x<0){
            likeImgView.image=[UIImage imageNamed:@"refuse"];
            likeImgView.alpha=-((float)transition.x/100);
        }
        
        float scale=[self updateScale:transition];
        likeImgView.frame=CGRectMake(likeImgView.center.x-25*scale, likeImgView.center.y-25*scale, 50*scale, 50*scale);
    }
    //结束滑动
    else if (status==2){
        likeImgView.alpha=0.0f;
        likeImgView.frame=CGRectMake(self.swipeableView.frame.size.width/2-25,self.swipeableView.frame.size.height/2-25, 50, 50);
        likeImgView.image=nil;
    }
}

- (float)updateScale:(CGPoint)transition{
    float scale;
    
    scale=(float)abs(transition.x)/100+1.0f;
    if (scale>2.0f) {
        scale=2.0f;
    }
    return scale;
}

- (UIView *)nextViewForSwipeableView:(ZLSwipeableView *)swipeableView {
    if (self.colorIndex < self.colors.count) {
        
        CardView *view = [[CardView alloc] initWithFrame:swipeableView.bounds];
        view.backgroundColor = [self colorForName:self.colors[self.colorIndex]];
        self.colorIndex++;
        
        UITextView *textView =
        [[UITextView alloc] initWithFrame:view.bounds];
        textView.text = @"This UITextView was created programmatically.";
        textView.backgroundColor = [UIColor clearColor];
        textView.font = [UIFont systemFontOfSize:24];
        textView.editable = NO;
        textView.selectable = NO;
        [view addSubview:textView];
        
        return view;
    }
    return nil;
}

- (UIColor *)colorForName:(NSString *)name {
    NSString *sanitizedName =
    [name stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSString *selectorString =
    [NSString stringWithFormat:@"flat%@Color", sanitizedName];
    Class colorClass = [UIColor class];
    return [colorClass performSelector:NSSelectorFromString(selectorString)];
}

- (void)swipeableView:(ZLSwipeableView *)swipeableView
         didSwipeLeft:(UIView *)view {
    NSLog(@"did swipe left");
}

- (void)swipeableView:(ZLSwipeableView *)swipeableView
        didSwipeRight:(UIView *)view {
    NSLog(@"did swipe right");
}

- (void)swipeableView:(ZLSwipeableView *)swipeableView
       didCancelSwipe:(UIView *)view {
    NSLog(@"did cancel swipe");
}

- (void)swipeableView:(ZLSwipeableView *)swipeableView
  didStartSwipingView:(UIView *)view
           atLocation:(CGPoint)location {
    NSLog(@"did start swiping at location: x %f, y %f", location.x, location.y);
    [self updateLikeImageView:location Status:0];
}

- (void)swipeableView:(ZLSwipeableView *)swipeableView
          swipingView:(UIView *)view
           atLocation:(CGPoint)location
          translation:(CGPoint)translation {
    NSLog(@"swiping at location: x %f, y %f, translation: x %f, y %f",
          location.x, location.y, translation.x, translation.y);
    [self updateLikeImageView:translation Status:1];
}

- (void)swipeableView:(ZLSwipeableView *)swipeableView
    didEndSwipingView:(UIView *)view
           atLocation:(CGPoint)location {
    NSLog(@"did end swiping at location: x %f, y %f", location.x, location.y);
    [self updateLikeImageView:location Status:2];
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
