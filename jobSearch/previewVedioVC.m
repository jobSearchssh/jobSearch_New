//
//  previewVedioVC.m
//  jobSearch
//
//  Created by 田原 on 15/2/28.
//  Copyright (c) 2015年 麻辣工作室. All rights reserved.
//

#import "previewVedioVC.h"
#import "ALMoviePlayerController.h"
#import "MDRadialProgressView.h"
#import "MDRadialProgressTheme.h"
#import "MDRadialProgressLabel.h"
#import "MLTextUtils.h"

@interface previewVedioVC ()<ALMoviePlayerControllerDelegate>{
    MDRadialProgressView *radialView;
    NSString *vedioURL;
}

@property (nonatomic, strong) ALMoviePlayerController *moviePlayer;
@property (nonatomic) CGRect defaultFrame;

@end

@implementation previewVedioVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSMutableDictionary *titleBarAttributes = [NSMutableDictionary dictionaryWithDictionary:[[UINavigationBar appearance] titleTextAttributes]];
    [titleBarAttributes setValue:[UIColor whiteColor] forKey:UITextAttributeTextColor];
    [self.navigationController.navigationBar setTitleTextAttributes:titleBarAttributes];
    
    NSLog(@"previewVedioVC path = %@",self.vedioPath);
    // Do any additional setup after loading the view from its nib.
    if (self.type.intValue == upload) {
        self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithImage:Nil style:UIBarButtonItemStyleBordered target:self action:@selector(saveVedio)];
        [self.navigationItem.rightBarButtonItem setTitle:@"保存"];
    }


    [[AVAudioSession sharedInstance] setCategory: AVAudioSessionCategoryPlayback error: nil];

    //create a player
    self.moviePlayer = [[ALMoviePlayerController alloc]initWithFrame:self.view.frame];
    self.moviePlayer.view.alpha = 0.f;
    self.moviePlayer.delegate = self; //IMPORTANT!

    //create the controls
    ALMoviePlayerControls *movieControls = [[ALMoviePlayerControls alloc] initWithMoviePlayer:self.moviePlayer style:ALMoviePlayerControlsStyleDefault];
    //[movieControls setAdjustsFullscreenImage:NO];
    [movieControls setBarColor:[UIColor colorWithRed:250/255.0 green:250/255.0 blue:250/255.0 alpha:0.5]];
    [movieControls setTimeRemainingDecrements:YES];
    
    //assign controls
    [self.moviePlayer setControls:movieControls];
    [self.view addSubview:self.moviePlayer.view];
    
    //THEN set contentURL
    if (self.type.intValue == upload) {
        [self.moviePlayer setContentURL:[NSURL fileURLWithPath:self.vedioPath]];
    }
    if (self.type.intValue == preview) {
        [self.moviePlayer setContentURL:[NSURL URLWithString:self.vedioPath]];
    }
    
    
    //delay initial load so statusBarOrientation returns correct value
    double delayInSeconds = 0.3;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [self configureViewForOrientation:[UIApplication sharedApplication].statusBarOrientation];
        [UIView animateWithDuration:0.3 delay:0.0 options:0 animations:^{
            self.moviePlayer.view.alpha = 1.f;
        } completion:^(BOOL finished) {
            self.navigationItem.leftBarButtonItem.enabled = YES;
            self.navigationItem.rightBarButtonItem.enabled = YES;
        }];
    });
    
    //初始化上传图标
    CGRect frame = CGRectMake([UIScreen mainScreen].bounds.size.width/2-50,[UIScreen mainScreen].bounds.size.height/2-120, 100, 100);
    radialView = [[MDRadialProgressView alloc] initWithFrame:frame];
    radialView.theme.completedColor = [UIColor colorWithRed:247/255.0 green:247/255.0 blue:247/255.0 alpha:0.5];
    radialView.theme.incompletedColor = [UIColor colorWithRed:174/255.0 green:197/255.0 blue:80/255.0 alpha:0.5];
    radialView.progressTotal = 100;
    radialView.progressCounter = 0;
    radialView.theme.sliceDividerHidden = YES;
    radialView.theme.centerColor = radialView.theme.completedColor;
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.moviePlayer.controls playPausePressedAction];
}

- (void)configureViewForOrientation:(UIInterfaceOrientation)orientation {
    CGFloat videoWidth = 0;
    CGFloat videoHeight = 0;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        videoWidth = 700.f;
        videoHeight = 535.f;
    } else {
        videoWidth = self.view.frame.size.width;
        videoHeight = 260.f;
    }
    
    //calulate the frame on every rotation, so when we're returning from fullscreen mode we'll know where to position the movie plauyer
    self.defaultFrame = CGRectMake(0,0, self.view.frame.size.width, self.view.frame.size.height);
    
    //only manage the movie player frame when it's not in fullscreen. when in fullscreen, the frame is automatically managed
    if (self.moviePlayer.isFullscreen)
        return;
    
    //you MUST use [ALMoviePlayerController setFrame:] to adjust frame, NOT [ALMoviePlayerController.view setFrame:]
    [self.moviePlayer setFrame:self.defaultFrame];
}

//IMPORTANT!
- (void)moviePlayerWillMoveFromWindow {
    //movie player must be readded to this view upon exiting fullscreen mode.
    if (![self.view.subviews containsObject:self.moviePlayer.view])
        [self.view addSubview:self.moviePlayer.view];
    
    //you MUST use [ALMoviePlayerController setFrame:] to adjust frame, NOT [ALMoviePlayerController.view setFrame:]
    [self.moviePlayer setFrame:self.defaultFrame];
}

- (void)movieTimedOut {
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:VEDIOTIMEOUT message:nil
                                                delegate:nil cancelButtonTitle:ALERTVIEW_OKBUTTON otherButtonTitles:nil, nil];
    [alert show];
}

- (BOOL)shouldAutorotate {
    return YES;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    return YES;
}

-(void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    [super willAnimateRotationToInterfaceOrientation:toInterfaceOrientation duration:duration];
    [self configureViewForOrientation:toInterfaceOrientation];
}


-(void)saveVedio{
    if ([(AppDelegate *)[[UIApplication sharedApplication] delegate] getCurrentConnectType] == NotReachable) {
        UIAlertView *alterTittle = [[UIAlertView alloc] initWithTitle:ALERTVIEW_TITLE message:NONET delegate:nil cancelButtonTitle:ALERTVIEW_KNOWN otherButtonTitles:nil];
        [alterTittle show];
        return;
    }
    
    if ([(AppDelegate *)[[UIApplication sharedApplication] delegate] getCurrentConnectType] == ReachableViaWWAN) {
        UIAlertView *alterTittle = [[UIAlertView alloc] initWithTitle:ALERTVIEW_TITLE message:NOTVIAWIFI delegate:self cancelButtonTitle:ALERTVIEW_CANCELBUTTON otherButtonTitles:ALERTVIEW_OKBUTTON, nil];
        [alterTittle show];
        return;
    }
    
    if ([(AppDelegate *)[[UIApplication sharedApplication] delegate] getCurrentConnectType] == ReachableViaWiFi) {
        [self puloadVedio];
    }
    
}

-(void)puloadVedio{
    
    NSString *videoPath = self.vedioPath;
    NSLog(@"videoPath = %@",videoPath);
    @try {
        [radialView removeFromSuperview];
    }
    @catch (NSException *exception) {
        
    }
    [self.view addSubview:radialView];
    [BmobFile filesUploadBatchWithPaths:@[videoPath]
                          progressBlock:^(int index, float progress) {
                              //index 上传数组的下标，progress当前文件的进度
                              NSLog(@"index %d progress %f",index,progress);
                              dispatch_async(dispatch_get_main_queue(), ^{
                                  [radialView setProgressCounter:progress*100];
                              });
                          } resultBlock:^(NSArray *array, BOOL isSuccessful, NSError *error) {
                              
                              [radialView removeFromSuperview];
                              
                              if (isSuccessful) {
                                  dispatch_async(dispatch_get_main_queue(), ^{
                                      [MBProgressHUD showError:UPLOADSUCCESS toView:self.view];
                                  });
                                  
                                  //array 文件数组，isSuccessful 成功或者失败,error 错误信息
                                  BmobObject *obj = [[BmobObject alloc] initWithClassName:@"moveScoreFile"];
                                  for (int i = 0 ; i < array.count ;i ++) {
                                      BmobFile *file = array [i];
                                      NSString *key = [NSString stringWithFormat:@"userFile%d",i];
                                      vedioURL = [file url];
                                      [obj setObject:file  forKey:key];
                                  }
                                  //回调
                                  if (self.setVideoURLDelegate != Nil && vedioURL != Nil) {
                                      [self.setVideoURLDelegate getVideoURLDelegate:vedioURL];
                                  }
                              }else{
                                  [MBProgressHUD showError:UPLOADFAIL toView:self.view];
                              }
                          }];
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        
    }
    
    if (buttonIndex == 1) {
        [self puloadVedio];
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
