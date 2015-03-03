//
//  MLResumeVideoVC.m
//  jobSearch
//
//  Created by 田原 on 15/1/30.
//  Copyright (c) 2015年 麻辣工作室. All rights reserved.
//

#import "MLResumeVideoVC.h"
#import "MDRadialProgressView.h"
#import "MDRadialProgressTheme.h"
#import "MDRadialProgressLabel.h"

@interface MLResumeVideoVC (){
    AVCaptureVideoPreviewLayer *_previewLayer;
    UILongPressGestureRecognizer *_longPressGestureRecognizer;
    PBJStrobeView *_strobeView;
    BOOL _recording;
    ALAssetsLibrary *_assetLibrary;
    __block NSDictionary *_currentVideo;
    BOOL isSave;
    
//    MDRadialProgressView *radialView;
    BOOL startUpload;
    NSString *vedioURL;
    
    BOOL vedioIsWork;
    BOOL vedioCheck;
}

@property (weak, nonatomic) IBOutlet UIView *videoPreViewOutlet;
- (IBAction)changeAction:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIButton *paiOutlet;
@property (weak, nonatomic) IBOutlet UIButton *changeOutlet;

@end

@implementation MLResumeVideoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithImage:Nil style:UIBarButtonItemStyleBordered target:self action:@selector(videoUpload)];
    [self.navigationItem.rightBarButtonItem setTitle:@"预览"];
    [self.navigationItem setTitle:@"录制视频"];
    
    //指示点
    _strobeView = [[PBJStrobeView alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width - 45,25,15,15)];
    [self.videoPreViewOutlet addSubview:_strobeView];
    
    isSave = FALSE;
    _assetLibrary = [[ALAssetsLibrary alloc] init];
    _previewLayer = [[PBJVision sharedInstance] previewLayer];
    CGRect previewBounds = self.videoPreViewOutlet.layer.bounds;
    _previewLayer.bounds = previewBounds;
    _previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    _previewLayer.position = CGPointMake(CGRectGetMidX(previewBounds), CGRectGetMidY(previewBounds));
    [self.videoPreViewOutlet.layer addSublayer:_previewLayer];
    
    //长按开始录制 放开暂停
    _longPressGestureRecognizer = [[UILongPressGestureRecognizer alloc] init];
    _longPressGestureRecognizer.delegate = self;
    _longPressGestureRecognizer.minimumPressDuration = 0.05f;
    _longPressGestureRecognizer.allowableMovement = 10.0f;
    [_longPressGestureRecognizer addTarget:self action:@selector(_handleLongPressGestureRecognizer:)];
    
    [self.paiOutlet addGestureRecognizer:_longPressGestureRecognizer];
    [self.videoPreViewOutlet bringSubviewToFront:self.paiOutlet];
    [self.videoPreViewOutlet bringSubviewToFront:self.changeOutlet];
    [self.videoPreViewOutlet bringSubviewToFront:_strobeView];
    
    vedioIsWork = TRUE;
    vedioCheck = FALSE;
    
//    //初始化上传图标
//    CGRect frame = CGRectMake(0,0, 100, 100);
//    radialView = [[MDRadialProgressView alloc] initWithFrame:frame];
//    radialView.center = CGPointMake(self.view.center.x, self.view.center.y - 150);
//    radialView.theme.completedColor = [UIColor colorWithRed:247/255.0 green:247/255.0 blue:247/255.0 alpha:0.5];
//    radialView.theme.incompletedColor = [UIColor colorWithRed:174/255.0 green:197/255.0 blue:80/255.0 alpha:0.5];
//    radialView.progressTotal = 100;
//    radialView.progressCounter = 0;
//    radialView.theme.sliceDividerHidden = YES;
//    radialView.theme.centerColor = radialView.theme.completedColor;
//    startUpload = false;
}

#pragma mark - UIGestureRecognizer

- (void)_handleLongPressGestureRecognizer:(UIGestureRecognizer *)gestureRecognizer{
    if (!vedioIsWork) {
        return;
    }
    if (!vedioCheck) {
        NSString *mediaType = AVMediaTypeVideo;
        AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];
        if(authStatus == ALAuthorizationStatusRestricted || authStatus == ALAuthorizationStatusDenied){
            vedioIsWork = FALSE;
            UIAlertView *alterTittle = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请开启相机功能" delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:nil];
            alterTittle.tag = 0;
            [alterTittle show];
            [self.paiOutlet removeGestureRecognizer:_longPressGestureRecognizer];
            return;
        }else{
            vedioCheck = TRUE;
        }
    }
    
    switch (gestureRecognizer.state) {
        case UIGestureRecognizerStateBegan:
        {
            if (!_recording)
                [self _startCapture];
            else
                [self _resumeCapture];
            break;
        }
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateCancelled:
        case UIGestureRecognizerStateFailed:
        {
            [self _pauseCapture];
            break;
        }
        default:
            break;
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 0) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}


#pragma mark - view lifecycle

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self _resetCapture];
    [[PBJVision sharedInstance] startPreview];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [[PBJVision sharedInstance] stopPreview];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//提交视频
-(void)videoUpload{
    
    _longPressGestureRecognizer.enabled = NO;
    _longPressGestureRecognizer.enabled = YES;
    isSave = TRUE;
    [self _endCapture];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/



#pragma mark - private start/stop helper methods

- (void)_startCapture
{
    [UIApplication sharedApplication].idleTimerDisabled = YES;
    [[PBJVision sharedInstance] startVideoCapture];
}

- (void)_pauseCapture
{
    [[PBJVision sharedInstance] pauseVideoCapture];
}

- (void)_resumeCapture
{
    [[PBJVision sharedInstance] resumeVideoCapture];
}

- (void)_endCapture
{
    [UIApplication sharedApplication].idleTimerDisabled = NO;
    [[PBJVision sharedInstance] endVideoCapture];
}

- (void)_resetCapture
{
    [_strobeView stop];
    _longPressGestureRecognizer.enabled = YES;
    
    PBJVision *vision = [PBJVision sharedInstance];
    vision.delegate = self;
    [vision setCameraMode:PBJCameraModeVideo];
    [vision setCameraDevice:PBJCameraDeviceBack];
    [vision setCameraOrientation:PBJCameraOrientationPortrait];
    [vision setFocusMode:PBJFocusModeAutoFocus];
}

#pragma mark - PBJVisionDelegate

- (void)visionSessionWillStart:(PBJVision *)vision
{
}

- (void)visionSessionDidStart:(PBJVision *)vision
{
}

- (void)visionSessionDidStop:(PBJVision *)vision
{
}

- (void)visionPreviewDidStart:(PBJVision *)vision
{
    _longPressGestureRecognizer.enabled = YES;
}

- (void)visionPreviewWillStop:(PBJVision *)vision
{
    _longPressGestureRecognizer.enabled = NO;
}

- (void)visionModeWillChange:(PBJVision *)vision
{
}

- (void)visionModeDidChange:(PBJVision *)vision
{
}

- (void)vision:(PBJVision *)vision cleanApertureDidChange:(CGRect)cleanAperture
{
}

- (void)visionWillStartFocus:(PBJVision *)vision
{
}

- (void)visionDidStopFocus:(PBJVision *)vision
{
}

// video capture

- (void)visionDidStartVideoCapture:(PBJVision *)vision
{
    [_strobeView start];
    _recording = YES;
}

- (void)visionDidPauseVideoCapture:(PBJVision *)vision
{
    [_strobeView stop];
}

- (void)visionDidResumeVideoCapture:(PBJVision *)vision
{
    [_strobeView start];
}

- (void)vision:(PBJVision *)vision capturedVideo:(NSDictionary *)videoDict error:(NSError *)error
{
    _recording = NO;
    
    _currentVideo = videoDict;
//    if (startUpload) {
//        UIAlertView *alterTittle = [[UIAlertView alloc] initWithTitle:@"提示" message:@"正在上传，请稍后" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil];
//        [alterTittle show];
//        return;
//    }
    
    if (isSave) {
        NSString *videoPath = [_currentVideo  objectForKey:PBJVisionVideoPathKey];
        previewVedioVC *vc = [[previewVedioVC alloc]init];
        vc.vedioPath = videoPath;
        vc.type = [NSNumber numberWithInt:upload];
        vc.setVideoURLDelegate = self;
        vc.title = @"我的视频介绍";
        [self.navigationController pushViewController:vc animated:YES];
//        if (error) {
//            UIAlertView *alterTittle = [[UIAlertView alloc] initWithTitle:@"提示" message:[NSString stringWithFormat:@"%@",error] delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil];
//            [alterTittle show];
//            return;
//        }
//        
//        if ([(AppDelegate *)[[UIApplication sharedApplication] delegate] getCurrentConnectType] == NotReachable) {
//            UIAlertView *alterTittle = [[UIAlertView alloc] initWithTitle:@"提示" message:@"当前无网络" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil];
//            [alterTittle show];
//            return;
//        }
//        
//        if ([(AppDelegate *)[[UIApplication sharedApplication] delegate] getCurrentConnectType] == ReachableViaWWAN) {
//            UIAlertView *alterTittle = [[UIAlertView alloc] initWithTitle:@"提示" message:@"当前使用手机网络，是否上传" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
//            [alterTittle show];
//            return;
//        }
//        
//        if ([(AppDelegate *)[[UIApplication sharedApplication] delegate] getCurrentConnectType] == ReachableViaWiFi) {
//            [self puloadVedio];
//        }
    }else{
        NSString *videoPath = [_currentVideo  objectForKey:PBJVisionVideoPathKey];
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSError *error;
        if (![fileManager fileExistsAtPath:videoPath]) {
            if (![fileManager removeItemAtPath:videoPath error:&error]) {
                NSLog(@"%@",error);
            }else{
                NSLog(@"删除临时文件成功");
            }
        }
    }
}

//-(void)puloadVedio{
//    startUpload = TRUE;
//    NSString *videoPath = [_currentVideo  objectForKey:PBJVisionVideoPathKey];
//    NSLog(@"videoPath = %@",videoPath);
//    @try {
//        [radialView removeFromSuperview];
//    }
//    @catch (NSException *exception) {
//        
//    }
//    [self.view addSubview:radialView];
//    [BmobFile filesUploadBatchWithPaths:@[videoPath]
//                          progressBlock:^(int index, float progress) {
//                              //index 上传数组的下标，progress当前文件的进度
//                              NSLog(@"index %d progress %f",index,progress);
//                              dispatch_async(dispatch_get_main_queue(), ^{
//                                  [radialView setProgressCounter:progress*100];
//                              });
//                          } resultBlock:^(NSArray *array, BOOL isSuccessful, NSError *error) {
//
//                              [radialView removeFromSuperview];
//                              
//                              if (isSuccessful) {
//                                  dispatch_async(dispatch_get_main_queue(), ^{
//                                      [MBProgressHUD showError:@"上传成功" toView:self.view];
//                                      startUpload = false;
//                                  });
//                                  
//                                  //array 文件数组，isSuccessful 成功或者失败,error 错误信息
//                                  BmobObject *obj = [[BmobObject alloc] initWithClassName:@"moveScoreFile"];
//                                  for (int i = 0 ; i < array.count ;i ++) {
//                                      BmobFile *file = array [i];
//                                      NSString *key = [NSString stringWithFormat:@"userFile%d",i];
//                                      vedioURL = [file url];
//                                      [obj setObject:file  forKey:key];
//                                  }
////                                  [obj saveInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
////                                      
////                                  }];
//                                  //s删除临时文件
//                                  NSString *videoPath = [_currentVideo  objectForKey:PBJVisionVideoPathKey];
//                                  NSFileManager *fileManager = [NSFileManager defaultManager];
//                                  NSError *error;
//                                  if ([fileManager fileExistsAtPath:videoPath]) {
//                                      if (![fileManager removeItemAtPath:videoPath error:&error]) {
//                                          NSLog(@"%@",error);
//                                      }else{
//                                          NSLog(@"删除临时文件成功");
//                                      }
//                                  }
//                                  //回调
//                                  if (self.setVideoURLDelegate != Nil && vedioURL != Nil) {
//                                      [self.setVideoURLDelegate getVideoURLDelegate:vedioURL];
//                                  }
//                                  isSave = false;
//                              }else{
//                                  [MBProgressHUD showError:@"上传失败" toView:self.view];
//                              }
//                          }];
//}

#pragma mark - UIAlertViewDelegate

//- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
//{
//    if (buttonIndex == 0) {
//        
//    }
//    
//    if (buttonIndex == 1) {
////        [self puloadVedio];
//    }
//}

- (void) getVideoURLDelegate:(NSString *)getVideoURL{
    NSLog(@"vvvvvv");
    if (self.setVideoURLDelegate != Nil && getVideoURL != Nil) {
        [self.setVideoURLDelegate getVideoURLDelegate:getVideoURL];
    }
}



- (IBAction)changeAction:(UIButton *)sender {
    PBJVision *vision = [PBJVision sharedInstance];
    if (vision.cameraDevice == PBJCameraDeviceBack) {
        [vision setCameraDevice:PBJCameraDeviceFront];
    } else {
        [vision setCameraDevice:PBJCameraDeviceBack];
    }
}
@end
