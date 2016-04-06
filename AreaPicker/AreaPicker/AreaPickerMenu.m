//
//  AreaPickerMenu.m
//  AreaPicker
//
//  Created by songshuo on 16/3/24.
//  Copyright © 2016年 xxx. All rights reserved.
//

#import "AreaPickerMenu.h"
#import "AreaPickerMenuCell.h"

@interface AreaPickerMenu ()
<
UITableViewDelegate,
UITableViewDataSource,
ZWSPagingViewDataSource,
ZWSPagingViewDelegate,
ZWSSectionBarDelegate
>

@property (nonatomic, strong) ZWSPagingView *pagingView;
@property (nonatomic, strong) ZWSSectionBar *sectionBar;
@property (nonatomic, strong) NSMutableArray *menuTitles;
@property (nonatomic, strong) NSDictionary *areaDic;
@property (nonatomic, strong) NSArray *province;
@property (nonatomic, strong) NSArray *city;
@property (nonatomic, strong) NSArray *district;

@property (nonatomic, assign) NSString *selectedProvince;
@property (nonatomic, assign) NSString *selectedCity;
@property (nonatomic, assign) NSString *selectedDistrict;


@end

@implementation AreaPickerMenu


- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self initViews];
        
        _menuTitles = [NSMutableArray arrayWithArray:@[@"请选择"]];
        [self loadFirstArea];
    }
    return self;
}

- (void)layoutSubviews{
    [self refreshViews];
}

- (void)initViews{
    if (!_sectionBar) {
        _sectionBar = [[ZWSSectionBar alloc] init];
        _sectionBar.barDelegate = self;
        _sectionBar.menuInsets   = UIEdgeInsetsMake(0, 10, 0, 10);
        _sectionBar.highlightedTextColor = [UIColor redColor];
        _sectionBar.textColor = [UIColor darkGrayColor];
        _sectionBar.selectedTextFont = [UIFont systemFontOfSize:13];
    }
    
    if (!_pagingView) {
        _pagingView = [[ZWSPagingView alloc] init];
        _pagingView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        _pagingView.pagingDataSource = self;
        _pagingView.pagingDelegate = self;
    }
}

- (void)refreshViews
{
    _sectionBar.frame = CGRectMake(self.bounds.origin.x, self.bounds.origin.y, self.bounds.size.width, 44.0f);
    [self addSubview:_sectionBar];
    
    _pagingView.frame = CGRectMake(self.bounds.origin.x, self.sectionBar.frame.size.height, self.bounds.size.width, self.bounds.size.height - self.sectionBar.frame.size.height);
    [self insertSubview:_pagingView belowSubview:_sectionBar];
    
    [_pagingView reloadPages];
    _sectionBar.titles = self.menuTitles;
}


#pragma mark - Override Methods

- (UIView *)contentViewForPage:(ZWSPage *)page atIndex:(NSInteger)index
{
    UITableView *tableView = [[UITableView alloc] initWithFrame:page.bounds];
    [tableView registerClass:[AreaPickerMenuCell class] forCellReuseIdentifier:@"AreaPickerMenuCellIdntifier"];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.tag = index+10000;
    return tableView;
}

#pragma mark - ZWSPagingViewDataSource

- (NSUInteger)numberOfPagesInPagingView:(ZWSPagingView *)pagingView {
    return [[self menuTitles] count];
}

- (ZWSPage *)pagingView:(ZWSPagingView *)pagingView pageForIndex:(NSUInteger)index {
    ZWSPage *page = [pagingView dequeueReusablePage];
    if (!page) {
        page = [ZWSPage new];
    }
    
    return page;
}

#pragma mark - ZWSPagingViewDelegate

- (void)pagingView:(ZWSPagingView *)pagingView didRemovePage:(ZWSPage *)page {
    if (pagingView.centerPage != page) {
        return;
    }
}

- (void)pagingView:(ZWSPagingView *)pagingView willMoveToPage:(ZWSPage *)page {
    page.contentView = [self contentViewForPage:(ZWSPage *)page atIndex:[pagingView indexOfPage:page]];
}

- (void)pagingView:(ZWSPagingView *)pagingView didMoveToPage:(ZWSPage *)page {
}

- (void)pagingViewLayoutChanged:(ZWSPagingView *)pagingView {
    [self transform3DEffects:pagingView];
    [_sectionBar moveToMenuAtFloatIndex:pagingView.floatIndex animated:YES];
}

#pragma mark - ZWSSectionBarDelegate

- (void)sectionBar:(ZWSSectionBar *)sectionBar didSelectAtInedx:(NSUInteger)index
{
    if (index == 0 && _menuTitles.count > 2) {
        [_menuTitles removeObjectAtIndex:1];
    }
    [_pagingView moveToPageAtFloatIndex:index animated:YES];
}

- (void)didCreateItemView:(UIView *)itemView
{
    
}

#pragma mark - UITableView Datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger index = tableView.tag - 10000;
    switch (index) {
        case 0:
            //province
            return _province.count;
        case 1:
            //city
            return _city.count;
        case 2:
            //district
            return _district.count;
        default:
            return 0;
    }
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger index = tableView.tag - 10000;
    static NSString *identifier = @"AreaPickerMenuCellIdntifier";
    AreaPickerMenuCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[AreaPickerMenuCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    switch (index) {
        case 0:
            //province
            [cell setArea:_province[indexPath.row]];
            break;
        case 1:
            //city
            [cell setArea:_city[indexPath.row]];
            break;
        case 2:
            //district
            [cell setArea:_district[indexPath.row]];
            break;
    }
    
    return cell;
}

#pragma mark - UITableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger index = tableView.tag - 10000;
    if (index == 0) {
        
        if (_menuTitles.count > 1) {
            [_menuTitles removeObjectAtIndex:0];
        }
        [_menuTitles insertObject:_province[indexPath.row] atIndex:0];
        [_pagingView reloadPages];
        _sectionBar.titles = self.menuTitles;
        [self loadSecondArea:indexPath];
        [_pagingView moveToPageAtFloatIndex:index+1 animated:YES];
    }else if (index == 1){
        if (_menuTitles.count > 2) {
            [_menuTitles removeObjectAtIndex:1];
        }
        [_menuTitles insertObject:_city[indexPath.row] atIndex:1];
        [_pagingView reloadPages];
        _sectionBar.titles = self.menuTitles;
        [self loadThirdArea:indexPath];
        [_pagingView moveToPageAtFloatIndex:index+1 animated:YES];
        
    }else if (index == 2){
        _selectedDistrict = _district[indexPath.row];
        if (_delegate && [_delegate respondsToSelector:@selector(areaPcikerMenuSelected:City:District:)]) {
            [_delegate areaPcikerMenuSelected:_selectedProvince City:_selectedCity District:_selectedDistrict];
        }
    }
    
}

#pragma mark - Private Methods

- (void)transform3DEffects:(ZWSPagingView *)pagingView
{
    CGFloat ratio = .0, scale;
    for (ZWSPage *page in pagingView.visiblePages) {
        ratio = [pagingView widthInSight:page] / CGRectGetWidth(page.frame);
        scale = .9 + ratio * .1;
        
        CATransform3D t = CATransform3DMakeScale(scale, scale, scale);
        
        page.layer.transform = t;
    }
}


- (void)loadFirstArea{
    NSBundle *bundle = [NSBundle mainBundle];
    NSString *plistPath = [bundle pathForResource:@"area" ofType:@"plist"];
    _areaDic = [[NSDictionary alloc] initWithContentsOfFile:plistPath];
    
    NSArray *components = [_areaDic allKeys];
    NSArray *sortedArray = [components sortedArrayUsingComparator: ^(id obj1, id obj2) {
        
        if ([obj1 integerValue] > [obj2 integerValue]) {
            return (NSComparisonResult)NSOrderedDescending;
        }
        
        if ([obj1 integerValue] < [obj2 integerValue]) {
            return (NSComparisonResult)NSOrderedAscending;
        }
        return (NSComparisonResult)NSOrderedSame;
    }];
    
    NSMutableArray *provinceTmp = [[NSMutableArray alloc] init];
    for (int i=0; i<[sortedArray count]; i++) {
        NSString *index = [sortedArray objectAtIndex:i];
        NSArray *tmp = [[_areaDic objectForKey: index] allKeys];
        [provinceTmp addObject: [tmp objectAtIndex:0]];
    }
    
    _province = [[NSArray alloc] initWithArray: provinceTmp];
    
}


- (void)loadSecondArea:(NSIndexPath *) indexPath{
    _selectedProvince = _province[indexPath.row];
    NSDictionary *tmp = [NSDictionary dictionaryWithDictionary: [_areaDic objectForKey: [NSString stringWithFormat:@"%lu", (unsigned long)indexPath.row]]];
    NSDictionary *dic = [NSDictionary dictionaryWithDictionary: [tmp objectForKey: _selectedProvince]];
    NSArray *cityArray = [dic allKeys];
    NSArray *sortedArray = [cityArray sortedArrayUsingComparator: ^(id obj1, id obj2) {
        
        if ([obj1 integerValue] > [obj2 integerValue]) {
            return (NSComparisonResult)NSOrderedDescending;
        }
        
        if ([obj1 integerValue] < [obj2 integerValue]) {
            return (NSComparisonResult)NSOrderedAscending;
        }
        return (NSComparisonResult)NSOrderedSame;
    }];
    
    NSMutableArray *array = [[NSMutableArray alloc] init];
    for (int i=0; i<[sortedArray count]; i++) {
        NSString *index = [sortedArray objectAtIndex:i];
        NSArray *temp = [[dic objectForKey: index] allKeys];
        [array addObject: [temp objectAtIndex:0]];
    }
    
    _city = [[NSArray alloc] initWithArray: array];
}


- (void)loadThirdArea:(NSIndexPath *) indexPath{
    _selectedCity = _city[indexPath.row];
    NSString *provinceIndex = [NSString stringWithFormat: @"%lu", (unsigned long)[_province indexOfObject: _selectedProvince]];
    NSDictionary *tmp = [NSDictionary dictionaryWithDictionary: [_areaDic objectForKey: provinceIndex]];
    NSDictionary *dic = [NSDictionary dictionaryWithDictionary: [tmp objectForKey: _selectedProvince]];
    NSArray *dicKeyArray = [dic allKeys];
    NSArray *sortedArray = [dicKeyArray sortedArrayUsingComparator: ^(id obj1, id obj2) {
        
        if ([obj1 integerValue] > [obj2 integerValue]) {
            return (NSComparisonResult)NSOrderedDescending;
        }
        
        if ([obj1 integerValue] < [obj2 integerValue]) {
            return (NSComparisonResult)NSOrderedAscending;
        }
        return (NSComparisonResult)NSOrderedSame;
    }];
    
    NSDictionary *cityDic = [NSDictionary dictionaryWithDictionary: [dic objectForKey: [sortedArray objectAtIndex: indexPath.row]]];
    NSArray *cityKeyArray = [cityDic allKeys];
    
    _district = [[NSArray alloc] initWithArray: [cityDic objectForKey: [cityKeyArray objectAtIndex:0]]];

}


@end
