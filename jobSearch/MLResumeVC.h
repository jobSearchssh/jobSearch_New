//
//  MLResumeVC.h
//  jobSearch
//
//  Created by 田原 on 15/1/25.
//  Copyright (c) 2015年 麻辣工作室. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QRadioButton.h"
#import "MCPagerView.h"
#import "freeselectViewCell.h"
#import "MLResumeVideoVC.h"
#import "fixedScrollView.h"
#import "userModel.h"
#import "netAPI.h"
#import "imageButton.h"
#import <BmobSDK/Bmob.h>
#import "UIImage+RTTint.h"
#import "MLSelectJobTypeVC.h"
#import "MLResumePreviewVC.h"
#import "MLNavigation.h"
#import "previewVedioVC.h"
#import "geturlProtocol.h"

@interface MLResumeVC : UIViewController<UIScrollViewDelegate,QRadioButtonDelegate,MCPagerViewDelegate,UICollectionViewDataSource,UICollectionViewDelegate,UITextFieldDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,getVideoURLDelegate,finishSelectDelegate,UIAlertViewDelegate>

-(UIImage *)compressImage:(UIImage *)imgSrc size:(int)width;

@property (nonatomic)NSInteger pages;
@property (weak, nonatomic) IBOutlet fixedScrollView *scrollviewOutlet;
@property (strong, nonatomic) userModel *usermodel;
@end
