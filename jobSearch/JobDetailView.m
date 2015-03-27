//
//  JobDetailView.m
//  jobSearch
//
//  Created by Leione on 15/3/24.
//  Copyright (c) 2015年 麻辣工作室. All rights reserved.
//

#import "JobDetailView.h"
#import "JobNormalCell.h"
#import "JobDetailCell.h"
#import "ButtonForJob.h"

@interface JobDetailView ()
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)NSArray *objArray;
@end
@implementation JobDetailView

- (MLMapView *)mapView
{
    if (_mapView) {
        return _mapView;
    }
    _mapView=[[MLMapView alloc]initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, 150)];
    return _mapView;
}
- (NSArray *)objArray
{
    if (_objArray) {
        return _objArray;
    }
    _objArray = [NSArray arrayWithObjects:@"工作描述",@"年龄要求",@"学历要求",@"身高要求", nil];
    return _objArray;
}

- (ButtonForJob *)buttonView
{
    if (_buttonView) {
        return _buttonView;
    }
    _buttonView = [[ButtonForJob alloc]initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height - 50, [UIScreen mainScreen].bounds.size.width, 50)];
    return _buttonView;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        _tableView = [[UITableView alloc]initWithFrame:frame style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
//        _tableView.bounces = NO;
        [self addSubview:_tableView];
        
        self.tableView.tableHeaderView = self.mapView;
        
        [self addSubview:self.buttonView];
        
        [self.tableView registerClass:[JobNormalCell class] forCellReuseIdentifier:@"normalCell"];
        [self.tableView registerClass:[JobDetailCell class] forCellReuseIdentifier:@"MLCell1"];
    }
    return self;
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section == 0) {
        
        static NSString *Cellidentifier=@"MLCell1";
        UINib *nib = [UINib nibWithNibName:@"JobDetailCell" bundle:nil];
        [tableView registerNib:nib forCellReuseIdentifier:Cellidentifier];
        
        JobDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:Cellidentifier forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.jobmodel = _jobmodel;
        
        return cell;
        
    }else{
        
        if (indexPath.row == 4) {
            
//            static NSString *Cellidentifier=@"button1";
//            UINib *nib = [UINib nibWithNibName:@"jobDetailButtonCell" bundle:nil];
//            [tableView registerNib:nib forCellReuseIdentifier:Cellidentifier];
//            jobDetailButtonCell *cell = [tableView dequeueReusableCellWithIdentifier:@"button1" forIndexPath:indexPath];
//            cell.selectionStyle = UITableViewCellSelectionStyleNone;
//            
//            [cell.sendButton addTarget:self action:@selector(sendResume:) forControlEvents:UIControlEventTouchUpInside];
//            [cell.callButton addTarget:self action:@selector(callPhone:) forControlEvents:UIControlEventTouchUpInside];
//            
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"placeHolder"];
            if (!cell) {
                cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"placeHolder"];
            }
            cell.backgroundColor = [UIColor clearColor];
//            tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
            return cell;
        }
        
        UINib *nib = [UINib nibWithNibName:@"JobNormalCell" bundle:nil];
        [tableView registerNib:nib forCellReuseIdentifier:@"normalCell"];
        
        JobNormalCell *cell = [tableView dequeueReusableCellWithIdentifier:@"normalCell" forIndexPath:indexPath];
        
        cell.objTitle.text = self.objArray[indexPath.row];
        
        switch (indexPath.row) {
            case 0:
                cell.desLabel.text = _jobmodel.getjobIntroduction;
                
                break;
            case 1:
                cell.desLabel.text = [NSString stringWithFormat:@"%@到%@岁",_jobmodel.getjobAgeStartReq,_jobmodel.getjobAgeEndReq];
                break;
            case 2:
                cell.desLabel.text = [NSString stringWithFormat:@"%@",_jobmodel.getjobDegreeReq];
                break;
            case 3:
                cell.desLabel.text = [NSString stringWithFormat:@"%@到%@CM",_jobmodel.getjobHeightStartReq,_jobmodel.getjobHeightEndReq];
                break;
                
            default:
                break;
        }
        
        
        
        
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    
    return nil;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 120;
    }
    return 50;
}




@end
