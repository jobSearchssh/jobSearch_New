//
//  AppDelegate.m
//  jobSearch
//
//  Created by RAY on 15/1/15.
//  Copyright (c) 2015年 麻辣工作室. All rights reserved.
//

#import "AppDelegate.h"
#import "MLFirstVC.h"
#import "MobClick.h"
#import "UMFeedback.h"
#import "Reachability.h"
#import "MLLoginBusiness.h"
#import "SMS_SDK/SMS_SDK.h"
#import <BmobSDK/Bmob.h>
#import <ShareSDK/ShareSDK.h>
#import "WXApi.h"
#import "WeiboSDK.h"
#import "badgeNumber.h"
#import "MLIntroduceVC.h"

@interface AppDelegate (){
    int currentConnectType;
}

@property (strong, nonatomic) Reachability *internetReachability;
@property (nonatomic) BOOL isReachable;
@property (nonatomic) BOOL beenReachable;

@end

@implementation AppDelegate

+ (NSInteger)OSVersion
{
    static NSUInteger _deviceSystemMajorVersion = -1;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _deviceSystemMajorVersion = [[[[[UIDevice currentDevice] systemVersion] componentsSeparatedByString:@"."] objectAtIndex:0] intValue];
    });
    return _deviceSystemMajorVersion;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    
    if((![[NSUserDefaults standardUserDefaults] objectForKey:@"launchFirstTime"])||![[[NSUserDefaults standardUserDefaults] objectForKey:@"launchFirstTime"] isEqualToString:[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"]]){
        
        //self.window.rootViewController = [[UINavigationController alloc] initWithRootViewController:[MLFirstVC sharedInstance]];
        //MLIntroduceVC *introVC=[[MLIntroduceVC alloc] init];
        //[self.window addSubview:introVC.view];
        //[self.window bringSubviewToFront:introVC.view];
        self.window.rootViewController = [[MLIntroduceVC alloc] init];
    }
    else{
        self.window.rootViewController = [[UINavigationController alloc] initWithRootViewController:[MLFirstVC sharedInstance]];
    }

    [self.window makeKeyAndVisible];
    
    //友盟
    [MobClick startWithAppkey:@"54c10ddbfd98c5b7c2000836" reportPolicy:BATCH  channelId:nil];
    [MobClick checkUpdate:@"兼职精灵有新版本啦" cancelButtonTitle:@"无情的忽略" otherButtonTitles:@"欣然前往下载"];
    [UMFeedback setAppkey:@"54c10ddbfd98c5b7c2000836"];
    
    
    //Bmob后台服务
    [Bmob registerWithAppKey:@"feda8b57c5da4a0364a3406906f77e2d"];
    
    //短信验证模块
    [SMS_SDK registerApp:@"57cd980818a9" withSecret:@"3bf26f5a30d5c3317f17887c4ee4986d"];

    //shareSDK 社会化分享
    [ShareSDK registerApp:@"1c4bbb89bd910c8432630a80804cdc7a"];
    
    //新浪微博分享
    [ShareSDK connectSinaWeiboWithAppKey:@"2652267694"
                               appSecret:@"a85484d25a129269b314f75070ab9238"
                             redirectUri:@"http://www.baidu.com"];
    //微信分享
    [ShareSDK connectWeChatWithAppId:@"wx4649b5a8f915a066"
                           appSecret:@"1698c5fe244127dba389b99849f0f8e5"
                           wechatCls:[WXApi class]];
    
    
    //网络连接监测
    self.isReachable=YES;
    self.beenReachable=YES;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:) name:kReachabilityChangedNotification object:nil];
    self.internetReachability = [Reachability reachabilityWithHostName:@"www.bmob.cn"] ;
    //开始监听，会启动一个run loop
    [self.internetReachability startNotifier];  
    
    //刷新badge
    [[badgeNumber sharedInstance] refreshCount];
    
    //新建图片文件夹
    [fileUtil createPicFolder];
    
    return YES;
}

#pragma mark - 网络通信检查
-(void)reachabilityChanged:(NSNotification *)note
{
    Reachability *curReach = [note object];
    NSParameterAssert([curReach isKindOfClass:[Reachability class]]);
    
    //对连接改变做出响应处理动作
    NetworkStatus status = [curReach currentReachabilityStatus];
    //如果没有连接到网络就弹出提醒实况
    
    if(status == NotReachable)
    {
        currentConnectType = NotReachable;
        if (self.isReachable) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"网络连接异常" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alert show];
            self.isReachable = NO;
        }
        return;
    }
    if (status==ReachableViaWiFi) {
        currentConnectType = ReachableViaWiFi;
        if (!self.isReachable) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"网络连接信息" message:@"网络连接恢复" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alert show];
            self.isReachable = YES;
        }
    }
    if (status==ReachableViaWWAN) {
        currentConnectType = ReachableViaWWAN;
        if (!self.isReachable) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"网络连接信息" message:@"网络连接恢复" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alert show];
            self.isReachable = YES;
        }
    }
}

-(int)getCurrentConnectType{
    return currentConnectType;
}


- (BOOL)application:(UIApplication *)application
      handleOpenURL:(NSURL *)url
{
    return [ShareSDK handleOpenURL:url
                        wxDelegate:self];
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
    return [ShareSDK handleOpenURL:url
                 sourceApplication:sourceApplication
                        annotation:annotation
                        wxDelegate:self];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)initSideMenu{

}

@end
