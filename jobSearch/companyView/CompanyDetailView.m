//
//  CompanyDetailView.m
//  jobSearch
//
//  Created by Leione on 15/3/24.
//  Copyright (c) 2015年 麻辣工作室. All rights reserved.
//

#import "CompanyDetailView.h"
#import "UIImage+ImageEffects.h"
#import "CompanyIntroCell.h"


@interface CompanyDetailView ()

@property (nonatomic,strong)UITableView *tableView;

@end

@implementation CompanyDetailView

- (UIImageView *)backImageView
{
    if (_backImageView) {
        return _backImageView;
    }
    _backImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320,180)];
                    
//    _backImageView.frame = CGRectMake(0, 0, 320,180);
    
    _backImageView.backgroundColor = [UIColor whiteColor];
    
    [_backImageView addSubview:self.photoImageView];
    return _backImageView;
                                                                
}

- (UIImageView *)photoImageView
{
    if (_photoImageView) {
        return _photoImageView;
    }
    _photoImageView = [[UIImageView alloc]initWithFrame:CGRectMake(20, 20, 140, 140)];
    _photoImageView.backgroundColor = [UIColor whiteColor];
    return _photoImageView;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        _tableView = [[UITableView alloc]initWithFrame:frame style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        
//        [_tableView addSubview:self.backImageView];
        _tableView.tableHeaderView = self.backImageView;
        
//        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"companyCell"];
        [_tableView registerNib:[UINib nibWithNibName:@"CompanyIntroCell" bundle:nil] forCellReuseIdentifier:@"companyCell"];
        [self addSubview:_tableView];
        
    }
    
    return self;
}
#pragma mark - Table view data source


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    CompanyIntroCell *cell = [tableView dequeueReusableCellWithIdentifier:@"companyCell" forIndexPath:indexPath];
    
    
    
    
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 10;
}


@end
