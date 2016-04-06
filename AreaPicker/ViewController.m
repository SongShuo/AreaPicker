//
//  ViewController.m
//  AreaPicker
//
//  Created by songshuo on 16/3/21.
//  Copyright © 2016年 xxx. All rights reserved.
//

#import "ViewController.h"
#import "AreaPickerCover.h"

@interface ViewController ()
<
AreaPickerCoverDelegate
>
@property (strong, nonatomic) UIButton *menu;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.menu];
    self.title = @"Home Controller";
}

- (UIButton *)menu{
    if (!_menu) {
        _menu = [UIButton new];
        _menu.backgroundColor = [UIColor orangeColor];
        _menu.frame = CGRectMake(CGRectGetWidth(self.view.frame) - 40, 65, 40, 30);
        [_menu addTarget:self action:@selector(menuClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _menu;
}

- (void)menuClick{
    AreaPickerCover *view = [[AreaPickerCover alloc] init];
    view.delegate = self;
    [view show];
}

#pragma mark AreaPickerCoverDelegate

- (void)getAreaInformationProvince:(NSString *)province City:(NSString *)city District:(NSString *)district{
    NSLog(@"province = %@, city = %@, district = %@",province,city,district);
}

@end
