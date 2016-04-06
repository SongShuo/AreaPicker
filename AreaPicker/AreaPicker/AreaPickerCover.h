//
//  AreaPickerCover.h
//  AreaPicker
//
//  Created by songshuo on 16/3/22.
//  Copyright © 2016年 xxx. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AreaPickerCoverDelegate <NSObject>

- (void)getAreaInformationProvince:(NSString *)province City:(NSString *)city District:(NSString *)district;

@end

@interface AreaPickerCover : UIView

@property (nonatomic,assign) id<AreaPickerCoverDelegate> delegate;

- (void)show ;
- (void)dismiss;

@end
