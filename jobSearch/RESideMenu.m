//
//  RESideMenu.m
// RESideMenu
//
// Copyright (c) 2013 Roman Efimov (https://github.com/romaonthego)
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.
//

#import "RESideMenu.h"
#import "AccelerationAnimation.h"
#import "Evaluate.h"

const int INTERSTITIAL_STEPS = 99;

@interface RESideMenu ()
{
    BOOL _appIsHidingStatusBar;
    BOOL _isInSubMenu;
}
@property (assign, readwrite, nonatomic) NSInteger initialX;
@property (assign, readwrite, nonatomic) CGSize originalSize;
@property (strong, readonly, nonatomic) REBackgroundView *backgroundView;
@property (strong, readonly, nonatomic) UIImageView *screenshotView;
@property (strong, readonly, nonatomic) UITableView *tableView;

// Array containing menu (which are array of items)
@property (strong, readwrite, nonatomic) NSMutableArray *menuStack;
@property (strong, readwrite, nonatomic) RESideMenuItem *backMenu;

@end

@implementation RESideMenu
static  RESideMenu *thisMenu=nil;

- (id)init
{
    self = [super init];
    if (!self)
        return nil;
    
    self.verticalOffset = 100;
    self.horizontalOffset = 50;
    CGFloat scrennHeight = [UIScreen mainScreen].bounds.size.height;
    if(scrennHeight < 481){
        self.itemHeight = 40;
    }else{
        self.itemHeight = 50;
    }
    
    
    self.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:18];
    self.textColor = [UIColor whiteColor];
    self.highlightedTextColor = [UIColor lightGrayColor];
    self.hideStatusBarArea = YES;
    
    self.menuStack = [NSMutableArray array];
    return self;
}

- (id)initWithItems:(NSArray *)items
{
    self = [self init];
    if (!self)
        return nil;
    
    _items = items;
    [_menuStack addObject:items];
    _backMenu = [[RESideMenuItem alloc] initWithTitle:@"<" setFlag:DEFAULTCELL action:nil];
    
    return self;
}



+ (RESideMenu*)initInstanceWithItems:(NSArray *)items{
    if (thisMenu==nil) {
        thisMenu=[[RESideMenu alloc]initWithItems:items];
    }
    return thisMenu;
}

+ (RESideMenu*)sharedInstance{
    return thisMenu;
}

- (void)setTableItem:(NSInteger)row Title:(NSString*)title Subtitle:(NSString*)subtitle ImageUrl:(NSString*)imageurl{
 
    if (row==0) {
        if ([_items count]>0) {
            RESideMenuItem*usrItem=[_items objectAtIndex:0];
            
            [usrItem setTitle:title Subtitle:subtitle Url:imageurl];
            
            NSIndexPath *indexPath=[NSIndexPath indexPathForRow:0 inSection:0];
            usrTableViewCell *usrcell=(usrTableViewCell *)[_tableView cellForRowAtIndexPath:indexPath];
            [usrcell setUsrAvatarWithURL:imageurl];
            [usrcell setusrName:title];
            [usrcell setusrAction:subtitle];
        }
    }
}

- (void)setUserImageUrl:(NSString*)imageurl{

    if ([_items count]>0) {
            
        RESideMenuItem*usrItem=[_items objectAtIndex:0];
        usrItem.imageUrl=imageurl;
    }

}

-(void)setBadgeView:(NSInteger)index badgeText:(NSString*)badgeText{
    
    RESideMenuItem*usrItem=[_items objectAtIndex:index];
    
    usrItem.badgeText=badgeText;
    
    NSIndexPath *indexPath=[NSIndexPath indexPathForRow:index inSection:0];
    sideNormalTableViewCell *cell=(sideNormalTableViewCell *)[_tableView cellForRowAtIndexPath:indexPath];
    [cell setBadgeString:badgeText];
    
}

- (void) showItems:(NSArray *)items
{
    // Animate to deappear
    __typeof (&*self) __weak weakSelf = self;
    weakSelf.tableView.transform = CGAffineTransformScale(_tableView.transform, 0.9, 0.9);
    [UIView animateWithDuration:0.5 animations:^{
        weakSelf.tableView.transform = CGAffineTransformIdentity;
    }];
    [UIView animateWithDuration:0.6 animations:^{
        weakSelf.tableView.alpha = 0;
    }];
    
    // Set items and reload
    _items = items;
    [self.tableView reloadData];
    
    // Animate to reappear once reloaded
    weakSelf.tableView.transform = CGAffineTransformScale(_tableView.transform, 1, 1);
    [UIView animateWithDuration:0.5 animations:^{
        weakSelf.tableView.transform = CGAffineTransformIdentity;
    }];
    [UIView animateWithDuration:0.6 animations:^{
        weakSelf.tableView.alpha = 1;
    }];
    
}

- (void)show
{
    if (_isShowing)
        return;
    
    _isShowing = YES;
    
    // keep track of whether or not it was already hidden
    _appIsHidingStatusBar=[[UIApplication sharedApplication] isStatusBarHidden];
    
    if(!_appIsHidingStatusBar)
        [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
    
    [self performSelector:@selector(showAfterDelay) withObject:nil afterDelay:0.1];
}

- (void)hide
{
    if (_isShowing)
        [self restoreFromRect:_screenshotView.frame];
}

- (void)setRootViewController:(UIViewController *)viewController
{
    if (_isShowing)
        [self hide];
    
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    window.rootViewController = viewController;
    _screenshotView.image = [window re_snapshotWithStatusBar:!self.hideStatusBarArea];
    [window bringSubviewToFront:_backgroundView];
    [window bringSubviewToFront:_tableView];
    [window bringSubviewToFront:_screenshotView];
}

- (void)addAnimation:(NSString *)path view:(UIView *)view startValue:(double)startValue endValue:(double)endValue
{
    AccelerationAnimation *animation = [AccelerationAnimation animationWithKeyPath:path
                                                                        startValue:startValue
                                                                          endValue:endValue
                                                                  evaluationObject:[[ExponentialDecayEvaluator alloc] initWithCoefficient:6.0]
                                                                 interstitialSteps:INTERSTITIAL_STEPS];
    animation.removedOnCompletion = NO;
    [view.layer addAnimation:animation forKey:path];
}

//- (void)animate

- (void)showAfterDelay
{
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    
    // Take a snapshot
    //
    _screenshotView = [[UIImageView alloc] initWithFrame:CGRectNull];
    _screenshotView.image = [window re_snapshotWithStatusBar:!self.hideStatusBarArea];
    _screenshotView.frame = CGRectMake(0, 0, _screenshotView.image.size.width, _screenshotView.image.size.height);
    _screenshotView.userInteractionEnabled = YES;
    _screenshotView.layer.anchorPoint = CGPointMake(0, 0);
    
    _originalSize = _screenshotView.frame.size;
    
    // Add views
    //
    _backgroundView = [[REBackgroundView alloc] initWithFrame:window.bounds];
    _backgroundView.backgroundImage = _backgroundImage;
    [window addSubview:_backgroundView];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, window.frame.size.width, window.frame.size.height)];
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.backgroundView = nil;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, window.frame.size.width, self.verticalOffset/2)];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.alpha = 0;
    [window addSubview:_tableView];
    
    [window addSubview:_screenshotView];
    
    [self minimizeFromRect:CGRectMake(0, 0, _originalSize.width, _originalSize.height)];
    
    UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureRecognized:)];
    [_screenshotView addGestureRecognizer:panGestureRecognizer];
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureRecognized:)];
    [_screenshotView addGestureRecognizer:tapGestureRecognizer];
}

- (void)minimizeFromRect:(CGRect)rect
{
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    CGFloat m = 0.5;
    CGFloat newWidth = _originalSize.width * m;
    CGFloat newHeight = _originalSize.height * m;
    
    [CATransaction begin];
    [CATransaction setValue:[NSNumber numberWithFloat:0.6] forKey:kCATransactionAnimationDuration];
    [self addAnimation:@"position.x" view:_screenshotView startValue:rect.origin.x endValue:window.frame.size.width - 80.0];
    [self addAnimation:@"position.y" view:_screenshotView startValue:rect.origin.y endValue:(window.frame.size.height - newHeight) / 2.0];
    [self addAnimation:@"bounds.size.width" view:_screenshotView startValue:rect.size.width endValue:newWidth];
    [self addAnimation:@"bounds.size.height" view:_screenshotView startValue:rect.size.height endValue:newHeight];
    
    _screenshotView.layer.position = CGPointMake(window.frame.size.width - 80.0, (window.frame.size.height - newHeight) / 2.0);
    _screenshotView.layer.bounds = CGRectMake(window.frame.size.width - 80.0, (window.frame.size.height - newHeight) / 2.0, newWidth, newHeight);
    [CATransaction commit];
    
    if (_tableView.alpha == 0) {
        __typeof (&*self) __weak weakSelf = self;
        weakSelf.tableView.transform = CGAffineTransformScale(_tableView.transform, 0.9, 0.9);
        [UIView animateWithDuration:0.5 animations:^{
            weakSelf.tableView.transform = CGAffineTransformIdentity;
        }];
        
        [UIView animateWithDuration:0.6 animations:^{
            weakSelf.tableView.alpha = 1;
        }];
    }
}

- (void)restoreFromRect:(CGRect)rect
{
    _screenshotView.userInteractionEnabled = NO;
    while (_screenshotView.gestureRecognizers.count) {
        [_screenshotView removeGestureRecognizer:[_screenshotView.gestureRecognizers objectAtIndex:0]];
    }
    
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    [CATransaction begin];
    [CATransaction setValue:[NSNumber numberWithFloat:0.4] forKey:kCATransactionAnimationDuration];
    [self addAnimation:@"position.x" view:_screenshotView startValue:rect.origin.x endValue:0];
    [self addAnimation:@"position.y" view:_screenshotView startValue:rect.origin.y endValue:0];
    [self addAnimation:@"bounds.size.width" view:_screenshotView startValue:rect.size.width endValue:window.frame.size.width];
    [self addAnimation:@"bounds.size.height" view:_screenshotView startValue:rect.size.height endValue:window.frame.size.height];
    
    _screenshotView.layer.position = CGPointMake(0, 0);
    _screenshotView.layer.bounds = CGRectMake(0, 0, window.frame.size.width, window.frame.size.height);
    [CATransaction commit];
    [self performSelector:@selector(restoreView) withObject:nil afterDelay:0.4];
    
    __typeof (&*self) __weak weakSelf = self;
    [UIView animateWithDuration:0.2 animations:^{
        weakSelf.tableView.alpha = 0;
        weakSelf.tableView.transform = CGAffineTransformScale(_tableView.transform, 0.7, 0.7);
    }];
    
    // restore the status bar to its original state.
    [[UIApplication sharedApplication] setStatusBarHidden:_appIsHidingStatusBar withAnimation:UIStatusBarAnimationFade];
    _isShowing = NO;
}

- (void)restoreView
{
    __typeof (&*self) __weak weakSelf = self;
    [UIView animateWithDuration:0.2 animations:^{
        weakSelf.screenshotView.alpha = 0;
    } completion:^(BOOL finished) {
        [weakSelf.screenshotView removeFromSuperview];
    }];
    [_backgroundView removeFromSuperview];
    [_tableView removeFromSuperview];
}

#pragma mark -
#pragma mark Gestures

- (void)panGestureRecognized:(UIPanGestureRecognizer *)sender
{
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    
    CGPoint translation = [sender translationInView:window];
	if (sender.state == UIGestureRecognizerStateBegan) {
		_initialX = _screenshotView.frame.origin.x;
	}
	
    if (sender.state == UIGestureRecognizerStateChanged) {
        CGFloat x = translation.x + _initialX;
        CGFloat m = 1 - ((x / window.frame.size.width) * 210/window.frame.size.width);
        CGFloat y = (window.frame.size.height - _originalSize.height * m) / 2.0;
        
        _tableView.alpha = (x + 80.0) / window.frame.size.width;
        
        if (x < 0 || y < 0) {
            _screenshotView.frame = CGRectMake(0, 0, _originalSize.width, _originalSize.height);
        } else {
            _screenshotView.frame = CGRectMake(x, y, _originalSize.width * m, _originalSize.height * m);
        }
    }
    
    if (sender.state == UIGestureRecognizerStateEnded) {
        if ([sender velocityInView:window].x < 0) {
            [self restoreFromRect:_screenshotView.frame];
        } else {
            [self minimizeFromRect:_screenshotView.frame];
        }
    }
}

- (void)tapGestureRecognized:(UITapGestureRecognizer *)sender
{
    [self restoreFromRect:_screenshotView.frame];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _items.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RESideMenuItem *item = [_items objectAtIndex:indexPath.row];
    if ([item getCellFlag] == USRCELL) {
        return 100;
    }
    if ([item getCellFlag] == LOGINCELL) {
        return 65;
    }
    return self.itemHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    BOOL nibsRegistered = NO;
    
    NSString *normalcellIdentifier = @"sideNormalCell";
    NSString *loginCellIdentifier = @"loginCell";
    NSString *usrCellIdentifier = @"usrCell";
    
    if (!nibsRegistered) {
        UINib *niblogin = [UINib nibWithNibName:@"loginTableViewCell" bundle:nil];
        [tableView registerNib:niblogin forCellReuseIdentifier:loginCellIdentifier];
        UINib *nibusr = [UINib nibWithNibName:@"usrTableViewCell" bundle:nil];
        [tableView registerNib:nibusr forCellReuseIdentifier:usrCellIdentifier];
        UINib *nibnormal = [UINib nibWithNibName:@"sideNormalTableViewCell" bundle:nil];
        [tableView registerNib:nibnormal forCellReuseIdentifier:normalcellIdentifier];
        nibsRegistered = YES;
    }
    

    
    RESideMenuItem *item = [_items objectAtIndex:indexPath.row];
    usrTableViewCell *usrcell = nil;
    sideNormalTableViewCell *normalcell = nil;
    loginTableViewCell *logincell = nil;
    
    
    if ([item getCellFlag] == USRCELL) {
        
        usrcell = [tableView dequeueReusableCellWithIdentifier:usrCellIdentifier];
        if (usrcell == nil) {
            usrcell = [[usrTableViewCell alloc]init];
            usrcell.backgroundColor = [UIColor clearColor];
            usrcell.selectedBackgroundView = [[UIView alloc] init];
            usrcell.usrActionOutlet.font = self.font;
            usrcell.usrActionOutlet.textColor = self.textColor;
            usrcell.usrNameOutlet.font = self.font;
            usrcell.usrNameOutlet.textColor = self.textColor;
        }
        if (item.imageUrl) {
            [usrcell setUsrAvatarWithURL:item.imageUrl];
        }else{
            [usrcell setUsrAvatar:[UIImage imageNamed:@"tourists"]];
        }
        
        [usrcell setusrName:item.title];
        [usrcell setusrAction:item.subtitle];
        usrcell.selectionStyle = UITableViewCellSelectionStyleNone;
        return usrcell;
    }
    
    if ([item getCellFlag] == NORMALCELL || [item getCellFlag] == DEFAULTCELL) {
        
        normalcell = [tableView dequeueReusableCellWithIdentifier:normalcellIdentifier];
        if (normalcell == nil) {
            normalcell = [[sideNormalTableViewCell alloc]init];
        }
        
        [normalcell setImage:item.image];
        [normalcell setAction:item.title];
        normalcell.item = item;
        [normalcell notifyDatasetChange];
        //if ([item.badgeText intValue]>0) {
        [normalcell setBadgeString:item.badgeText];
        //}
        
        normalcell.selectionStyle = UITableViewCellSelectionStyleNone;
        return normalcell;
    }
    
    if ([item getCellFlag] == LOGINCELL) {
        
        logincell = [tableView dequeueReusableCellWithIdentifier:loginCellIdentifier];
        if (logincell == nil) {
            logincell = [[loginTableViewCell alloc] init];
        }
        logincell.item = item;
        logincell.menu = self;
        logincell.selectionStyle = UITableViewCellSelectionStyleNone;
        return logincell;
    }
    return nil;
}

#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    RESideMenuItem *item = [_items objectAtIndex:indexPath.row];
    
    if (indexPath.row >0 && indexPath.row <8) {
        for (RESideMenuItem *getiItema in _items) {
            [getiItema setIsClick:false];
        }
        [item setIsClick:true];
    }else{
        for (RESideMenuItem *getiItema in _items) {
            [getiItema setIsClick:false];
        }
    }
    [tableView reloadData];
    
    // Case back on subMenu
    if(_isInSubMenu &&
       indexPath.row==0 &&
       indexPath.section == 0){
        
        [_menuStack removeLastObject];
        if(_menuStack.count==1){
            _isInSubMenu = NO;
        }
        [self showItems:_menuStack.lastObject];
        
        return;
    }
        
    // Case menu with subMenu
    if(item.subItems){
        _isInSubMenu = YES;
        
        // Concat back menu to submenus and show
        NSMutableArray * array = [NSMutableArray arrayWithObject:_backMenu];
        [array addObjectsFromArray:item.subItems];
        [self showItems:array];
        
        // Push new menu on stack
        [_menuStack addObject:array];
    }
    
    if (item.action)
        item.action(self, item);
}
@end
