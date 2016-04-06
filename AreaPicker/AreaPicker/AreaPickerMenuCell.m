//
//  AreaPickerMenuCell.m
//  AreaPicker
//
//  Created by songshuo on 16/3/28.
//  Copyright © 2016年 xxx. All rights reserved.
//

#import "AreaPickerMenuCell.h"

@interface AreaPickerMenuCell (){
    NSString *_area;
}

@property (nonatomic,strong) UILabel *arealabel;
@property (nonatomic,strong) UIButton *markView;

@end

@implementation AreaPickerMenuCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.arealabel];
        [self.contentView addSubview:self.markView];
    }
    return self;
}

- (UILabel *)arealabel{
    if (!_arealabel) {
        _arealabel = [UILabel new];
        _arealabel.frame = CGRectMake(10.f, 0.f, 30.f, self.frame.size.height);
        _arealabel.textColor = [UIColor darkGrayColor];
        _arealabel.font = [UIFont systemFontOfSize:13];
    }
    return _arealabel;
}

- (UIButton *)markView{
    if (!_markView) {
        _markView = [UIButton new];
        _markView.frame = CGRectMake(0, (self.frame.size.height -7.5f)/2, 10.f, 7.5f);
        [_markView setImage:[UIImage imageNamed:@"Picture.bundle/contact_picker_selected.png"] forState:UIControlStateHighlighted];
        [_markView setImage:[UIImage imageNamed:@"Picture.bundle/contact_picker.png"] forState:UIControlStateNormal];
    }
    return _markView;
}

- (void)setArea:(NSString *)area{
    _area = area;
    _arealabel.text = area;
    
    CGRect rect = [area boundingRectWithSize:CGSizeMake(200.f, 0)
                                  options:NSStringDrawingUsesLineFragmentOrigin
                               attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13]}
                                  context:nil];
    
    int width = rect.size.width+5;
    _arealabel.frame = CGRectMake(_arealabel.frame.origin.x, _arealabel.frame.origin.y, width, _arealabel.frame.size.height);
    _markView.frame = CGRectMake(20.f+width, _markView.frame.origin.y,  20.f, 15.f);
    [self setNeedsFocusUpdate];
}


- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated{
    [super setHighlighted:highlighted animated:animated];
    if (highlighted) {
        _markView.highlighted = YES;
    }else{
        _markView.highlighted = NO;
    }
}


@end
