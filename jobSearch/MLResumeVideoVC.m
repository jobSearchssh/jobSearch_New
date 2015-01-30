//
//  MLResumeVideoVC.m
//  jobSearch
//
//  Created by 田原 on 15/1/30.
//  Copyright (c) 2015年 麻辣工作室. All rights reserved.
//

#import "MLResumeVideoVC.h"

@interface MLResumeVideoVC (){
    AVCaptureVideoPreviewLayer *_previewLayer;
    UILongPressGestureRecognizer *_longPressGestureRecognizer;
    PBJStrobeView *_strobeView;
    BOOL _recording;
    ALAssetsLibrary *_assetLibrary;
    __block NSDictionary *_currentVideo;
    BOOL isSave;
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
    [self.navigationItem.rightBarButtonItem setTitle:@"提交"];
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
}

#pragma mark - UIGestureRecognizer

- (void)_handleLongPressGestureRecognizer:(UIGestureRecognizer *)gestureRecognizer
{
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
    
    if (error) {
        NSLog(@"%@", error);
        return;
    }
    
    _currentVideo = videoDict;
    
    NSString *videoPath = [_currentVideo  objectForKey:PBJVisionVideoPathKey];
    if (isSave) {
        [_assetLibrary writeVideoAtPathToSavedPhotosAlbum:[NSURL URLWithString:videoPath] completionBlock:^(NSURL *assetURL, NSError *error1) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"保存成功!" message:nil
                                                           delegate:self
                                                  cancelButtonTitle:nil
                                                  otherButtonTitles:@"OK", nil];
            [alert show];
        }];
    }else{
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSError *error;
        if (![fileManager fileExistsAtPath:videoPath]) {
            if (![fileManager createDirectoryAtPath:videoPath withIntermediateDirectories:YES attributes:Nil error:&error]) {
                NSLog(@"%@",error);
            }else{
                NSLog(@"删除临时文件成功");
            }
        }
    }
    isSave = FALSE;
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [self _resetCapture];
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
