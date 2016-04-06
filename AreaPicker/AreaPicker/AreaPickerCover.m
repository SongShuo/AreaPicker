//
//  AreaPickerCover.m
//  AreaPicker
//
//  Created by songshuo on 16/3/22.
//  Copyright © 2016年 xxx. All rights reserved.
//

#import "AreaPickerCover.h"
#import "AreaPickerMenu.h"

#define kCoverProportion 0.10625
#define kStatusBarHeight 20.f
#define kNavigationBarHeight 44.f
#define kNaviagtionBarBtn  22.f

@interface AreaPickerCover ()
<
AreaPickerMenuDelegate
>

@property (nonatomic, strong) UIControl *overlayView;
@property (nonatomic, strong) UIView *cover;
@property (nonatomic, strong) AreaPickerMenu *menu;

//navigation bar
@property (nonatomic, strong) UIView *navigationView;
@property (nonatomic, strong) UIButton *leftBtn;
@property (nonatomic, strong) UIButton *rightBtn;
@property (nonatomic, strong) UILabel *titleLabel;


@end

@implementation AreaPickerCover

#pragma mark - Overide

- (instancetype)init{
    self = [super init];
    if (self) {
        self.frame = [UIScreen mainScreen].bounds;
        [self addSubview:self.cover];
        [self addSubview:self.navigationView];
        [self.navigationView addSubview:self.leftBtn];
//        [self.navigationView addSubview:self.rightBtn];
        [self.navigationView addSubview:self.titleLabel];
        [self addSubview:self.menu];
    }
    return self;
}


#pragma mark - Methods

- (void)show {
    if(!self.overlayView.superview){
        NSEnumerator *frontToBackWindows = [UIApplication.sharedApplication.windows reverseObjectEnumerator];
        UIScreen *mainScreen = UIScreen.mainScreen;
        
        for (UIWindow *window in frontToBackWindows)
            if (window.screen == mainScreen && window.windowLevel == UIWindowLevelNormal) {
                [window addSubview:self.overlayView];
                
                break;
            }
    } else {
        [self.overlayView.superview bringSubviewToFront:self.overlayView];
    }
    
    if(!self.superview){
        self.frame = [[UIScreen mainScreen] bounds];
        [self.overlayView addSubview:self];
    }
    
    [self setNeedsDisplay];
}

- (void)dismiss {
    [UIView animateWithDuration:0.5f animations:^{
        _overlayView.frame = CGRectMake(CGRectGetMaxX([UIScreen mainScreen].bounds),
                                        CGRectGetMinY([UIScreen mainScreen].bounds),
                                        CGRectGetWidth([UIScreen mainScreen].bounds),
                                        CGRectGetHeight([UIScreen mainScreen].bounds));
    } completion:^(BOOL finished) {
        [_overlayView removeFromSuperview];
        _overlayView = nil;
        UIViewController *rootController = [[UIApplication sharedApplication] keyWindow].rootViewController;
        if ([rootController respondsToSelector:@selector(setNeedsStatusBarAppearanceUpdate)]) {
            [rootController setNeedsStatusBarAppearanceUpdate];
        }
    }];
    
}


#pragma mark - Properties

- (UIView *)cover{
    if (!_cover) {
        _cover = [[UIView alloc] init];
        _cover.frame = CGRectMake(0.f, 0.f, self.frame.size.width*kCoverProportion, self.frame.size.height);
        _cover.backgroundColor = [UIColor blackColor];
        _cover.alpha = 0.7f;
    }
    return _cover;
}

- (UIView *)navigationView{
    if (!_navigationView) {
        _navigationView = [UIView new];
        _navigationView.frame = CGRectMake(self.frame.size.width*kCoverProportion, 0.f, self.frame.size.width*(1-kCoverProportion), 20.f+44.f);
        _navigationView.backgroundColor = [UIColor whiteColor];
    }
    return _navigationView;
}

- (UIButton *)leftBtn{
    if (!_leftBtn) {
        _leftBtn = [UIButton new];
        _leftBtn.frame = CGRectMake(10.f, (kNavigationBarHeight - kNaviagtionBarBtn)/2.f +kStatusBarHeight , kNaviagtionBarBtn, kNaviagtionBarBtn);
        _leftBtn.titleLabel.font = [UIFont systemFontOfSize:12.0f];
        [_leftBtn setImage:[UIImage imageNamed:@"Picture.bundle/back_bt.png"] forState:UIControlStateNormal];
        [_leftBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [_leftBtn addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    }
    return _leftBtn;
}

- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
        _titleLabel.frame = CGRectMake((_navigationView.frame.size.width -100.f)/2.f, (kNavigationBarHeight - kNaviagtionBarBtn)/2.f +kStatusBarHeight, 100.f, kNaviagtionBarBtn);
        _titleLabel.text = @"配送至";
        _titleLabel.font = [UIFont fontWithName:@"Helvetica" size:18.f];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}

- (AreaPickerMenu *)menu{
    if (!_menu) {
        _menu = [[AreaPickerMenu alloc] initWithFrame: CGRectMake(CGRectGetMaxX(_cover.frame), CGRectGetMaxY(_navigationView.frame)+1, CGRectGetWidth(_navigationView.frame), self.frame.size.height - CGRectGetHeight(_navigationView.frame)-1)];
        _menu.backgroundColor = [UIColor whiteColor];
        _menu.delegate = self;
    }
    return _menu;
}

- (UIControl *)overlayView {
    if(!_overlayView) {
        _overlayView = [[UIControl alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _overlayView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _overlayView.userInteractionEnabled = YES;
        
    }
    return _overlayView;
}

//- (UIButton *)rightBtn {
//    if (!_rightBtn) {
//        _rightBtn = [UIButton new];
//        _rightBtn.frame = CGRectMake(_navigationView.frame.size.width -kNaviagtionBarBtn -15 , (kNavigationBarHeight - kNaviagtionBarBtn)/2 +kStatusBarHeight, kNaviagtionBarBtn, kNaviagtionBarBtn);
//        _rightBtn.titleLabel.font = [UIFont systemFontOfSize:12];
//        _rightBtn.backgroundColor = [UIColor blueColor];
//        [_rightBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
//        [_rightBtn addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
//    }
//    return _rightBtn;
//}

#pragma mark - AreaPickerMenuDelegate 

- (void)areaPcikerMenuSelected:(NSString *)province City:(NSString *)city District:(NSString *)district{
    [self dismiss];
    if (_delegate && [_delegate respondsToSelector:@selector(getAreaInformationProvince:City:District:)]) {
        [_delegate getAreaInformationProvince:province City:city District:district];
    }
}



@end
