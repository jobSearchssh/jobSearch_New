//
//  MLMatchVC.m
//  jobSearch
//
//  Created by RAY on 15/1/23.
//  Copyright (c) 2015年 麻辣工作室. All rights reserved.
//

#import "MLMatchVC.h"
#import "MLCell3.h"


@interface MLMatchVC ()<UITableViewDataSource,UITableViewDelegate>
{
    int cellNum;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;

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
    
    [self tableViewInit];
}

- (void)tableViewInit{
    cellNum=10;
    [_tableView setDelegate:self];
    [_tableView setDataSource:self];
    _tableView.scrollEnabled=YES;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BOOL nibsRegistered = NO;
    
    static NSString *Cellidentifier=@"MLCell3";
    if (!nibsRegistered) {
        UINib *nib = [UINib nibWithNibName:@"MLCell3" bundle:nil];
        [tableView registerNib:nib forCellReuseIdentifier:Cellidentifier];
        nibsRegistered = YES;
    }
    
    MLCell3 *cell=[tableView dequeueReusableCellWithIdentifier:Cellidentifier forIndexPath:indexPath];
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return cellNum;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

//改变行高
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 300;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (void)deselect
{
    [_tableView deselectRowAtIndexPath:[_tableView indexPathForSelectedRow] animated:YES];
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
