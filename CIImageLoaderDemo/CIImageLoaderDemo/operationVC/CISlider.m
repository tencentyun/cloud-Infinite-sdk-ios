//
//  CISlider.m
//  CIImageLoaderDemo
//
//  Created by garenwang on 2020/8/13.
//  Copyright © 2020 garenwang. All rights reserved.
//

#import "CISlider.h"

#define MAS_SHORTHAND
#define MAS_SHORTHAND_GLOBALS
#import <Masonry.h>
@interface CISlider ()
@property(nonatomic,strong)UISlider * slider;
@property(nonatomic,strong)UILabel * title;

@property(nonatomic,strong)UILabel * topTitle;
@end

@implementation CISlider

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self createSubView];
    }
    return self;
}

-(void)createSubView{

    self.slider = [UISlider new];
    [self addSubview:self.slider];

    [self.slider addTarget:self  action:@selector(changeValue:) forControlEvents:UIControlEventValueChanged];
    [self addObserver:self forKeyPath:@"slider.value" options:NSKeyValueObservingOptionNew context:nil];
    self.title = [UILabel new];
    self.title.text = @"0";
    self.title.textColor = [UIColor blackColor];
    self.title.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.title];
    
    
    self.topTitle = [UILabel new];
    self.topTitle.text = @"";
    self.topTitle.textColor = [UIColor blackColor];
    self.topTitle.font = [UIFont systemFontOfSize:15];
    self.topTitle.textAlignment = NSTextAlignmentLeft;
    [self addSubview:self.topTitle];
    
}

-(void)changeValue:(UISlider *)slider{
    if (self.slider.maximumValue >1) {
        self.title.text = [NSString stringWithFormat:@"%.0f",slider.value];
    }else{
        self.title.text = [NSString stringWithFormat:@"%.2f",slider.value];
    }
    
}

- (void)layoutSubviews{
    [super layoutSubviews];
    self.topTitle.numberOfLines = 0;
    [self.topTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(16);
        make.right.equalTo(-16);
        make.top.equalTo(4);
    }];
    
    [self.slider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(16);
        make.width.equalTo(self.width).offset(-120);
        make.top.equalTo(self.topTitle.bottom).offset(12);
        make.height.equalTo(20);
    }];
    
    [self.title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.slider.right).offset(4);
        make.width.equalTo(80);
        make.top.equalTo(self.slider.top);
        make.height.equalTo(20);
    }];
}

- (void)setEnabled:(BOOL)enabled{
    [self.slider setEnabled:enabled];
}

- (float)maximumValue{
    return self.slider.maximumValue;
}

- (void)setMaximumValue:(float)maximumValue{
    self.slider.maximumValue = maximumValue;
}

- (float)value{
    return self.slider.value;
}

- (void)setValue:(float)value{
    [self.slider setValue:value];
}

-(float)minimumValue{
    return self.slider.minimumValue;
}
- (void)setMinimumValue:(float)minimumValue{
    [self.slider setMinimumValue:minimumValue];
}

- (void)addTarget:(nullable id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents{
    [self.slider addTarget:target action:action forControlEvents:controlEvents];
}

- (void)dealloc
{
    [self removeObserver:self forKeyPath:@"slider.value"];
}
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    CGFloat newValue = [change[NSKeyValueChangeNewKey] doubleValue];
    self.title.text = [NSString stringWithFormat:@"%.2f",newValue * self.slider.maximumValue];
}

- (void)setTitleString:(NSString *)titleString{
    self.topTitle.text = titleString;
//    self.top
//    [self.topTitle sizeToFit];
}

@end
