//
//  AreaPickerMenu.h
//  AreaPicker
//
//  Created by songshuo on 16/3/24.
//  Copyright © 2016年 xxx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZWSPagingView.h"
#import "ZWSSectionBar.h"

@protocol AreaPickerMenuDelegate <NSObject>

- (void)areaPcikerMenuSelected:(NSString *)province City:(NSString *)city District:(NSString *)district;

@end

@interface AreaPickerMenu : UIView

@property (nonatomic,assign) id<AreaPickerMenuDelegate> delegate;

@end
