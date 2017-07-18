//
//  YXYSlideTitleGroup.m
//  SlideBtnGroups
//
//  Created by 杨肖宇 on 2017/7/13.
//  Copyright © 2017年 杨肖宇. All rights reserved.
//

#import "YXYSlideTitleGroup.h"

#define ScreenSpace  5   //距离屏幕的距离
#define ItemSpace  8     //每个按钮之间的距离

static NSUInteger ButtonTag = 1000;

@implementation YXYSlideTitleGroup{
   
    NSMutableArray * _btnsArr;
    NSMutableArray * _titleWidthArr;
    UIView * _scrollBar;//滚动条
    
    CGFloat _btnHeight;
    NSUInteger _lastBtnTag;
    UIButton * _selectedBtn;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super initWithCoder:aDecoder]) {
        [self setup];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}

- (void)setup{
    
    self.delegate = self;
    self.showsHorizontalScrollIndicator = NO;
    self.showsVerticalScrollIndicator = NO;
    self.panGestureRecognizer.delaysTouchesBegan = YES;//解决button区域无法滑动scrollview的问题
    
    _scrollBar = [[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height - 2, 10, 2)];
    [self addSubview:_scrollBar];
    
    //获取文字的size大小
    CGSize size = [@"宇哥" sizeWithAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:16]}];
    _btnHeight = size.height;
    
    _normalColor = [UIColor blackColor];
    _selectedColor = [UIColor redColor];
    _normalFont = [UIFont systemFontOfSize:14];
    _selectedFont = [UIFont systemFontOfSize:16];
    
    _lastBtnTag = ButtonTag;
    _titleWidthArr = [NSMutableArray new];
    _btnsArr = [NSMutableArray new];
}

/**
 创建滚动条
 */
- (void)createScrollBar{
    
    _scrollBar.frame = CGRectMake(ScreenSpace, _btnHeight + 5, [_titleWidthArr[0] floatValue], 2);
    _scrollBar.backgroundColor = self.selectedColor;
}

- (void)configScrollView{
    
    if (_titleWidthArr) [_titleWidthArr removeAllObjects];
    if (_btnsArr) [_btnsArr removeAllObjects];
    for (UIView * view in self.subviews) {
        if ([view isKindOfClass:[UIButton class]]) {
            [view removeFromSuperview];
        }
    }
    //获取文字的size大小
    CGSize size = [@"宇哥" sizeWithAttributes:@{NSFontAttributeName: self.selectedFont}];
    _btnHeight = size.height;

    for (int i = 0; i < self.titlesArr.count; i++) {
        
        __block CGFloat x = ScreenSpace;
        [_titleWidthArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            x += [obj floatValue];
            x += ItemSpace;
        }];
        
        CGFloat width = [self.titlesArr[i] sizeWithAttributes:@{NSFontAttributeName: self.selectedFont}].width;
        [_titleWidthArr addObject:[NSNumber numberWithFloat:width]];
        
        UIButton * btn = [[UIButton alloc] initWithFrame:CGRectMake(x , 0, width, _btnHeight)];
        [btn setTitle:self.titlesArr[i] forState:UIControlStateNormal];
       
        if (i == 0) {
            btn.titleLabel.font = self.selectedFont;
            _selectedBtn = btn;
            btn.selected = YES;
            
        }else{
            btn.titleLabel.font = self.normalFont;
        }
        
        [btn setTitleColor:self.normalColor forState:UIControlStateNormal];
        [btn setTitleColor:self.selectedColor forState:UIControlStateSelected];

        btn.tag = ButtonTag + i;
        btn.titleLabel.textAlignment = NSTextAlignmentCenter;
        [btn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
        [_btnsArr addObject:btn];
    }
    
    __block CGFloat width = ScreenSpace;
    [_titleWidthArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        width += [obj floatValue];
        width += ItemSpace;
    }];
    
    self.contentSize = CGSizeMake(width, self.frame.size.height);
    
    [self createScrollBar];
}

- (void)btnClicked:(UIButton *)btn{
    
    _selectedBtn = btn;
    
    UIButton * lastBtn = (UIButton *)[self viewWithTag:_lastBtnTag];
    lastBtn.selected = NO;
    lastBtn.titleLabel.font = self.normalFont;
    
    [UIView animateWithDuration:0.25 animations:^{
        
        btn.selected = YES;
        btn.titleLabel.font = self.selectedFont;
        
        _scrollBar.frame = CGRectMake(0, _btnHeight + 5, [_titleWidthArr[btn.tag - ButtonTag] floatValue], 2);
        CGPoint center = _scrollBar.center;
        center.x = btn.center.x;
        _scrollBar.center = center;
    }];
    
    NSUInteger tag = btn.tag - ButtonTag;
    if ((_btnsArr.count - tag) > 1) {
        CGRect rect = ((UIButton *)_btnsArr[tag + 1]).frame;
        [self scrollRectToVisible:rect animated:YES];
    }
    
    if (tag < (_lastBtnTag - ButtonTag) && tag > 0) {
        CGRect rect = ((UIButton *)_btnsArr[tag - 1]).frame;
        [self scrollRectToVisible:rect animated:YES];
    }
    
    _lastBtnTag = btn.tag;
    
    if (self.YXYDelegate && [self.YXYDelegate respondsToSelector:@selector(YXYSlideTitleGroupBtnClicked: didSelectItemAtIndex:)]) {
        [self.YXYDelegate YXYSlideTitleGroupBtnClicked:btn didSelectItemAtIndex:(btn.tag - ButtonTag)];
    }
}

#pragma mark--Setter

- (void)setTitlesArr:(NSArray *)titlesArr{
    
    _titlesArr = titlesArr;

    [self configScrollView];
}

- (void)setNormalFont:(UIFont *)normalFont{
   
    _normalFont = normalFont;
    for (UIView * subView in self.subviews) {
        if ([subView isKindOfClass:[UIButton class]]) {
            UIButton * btn = (UIButton *)subView;
            if (_selectedBtn != btn) {
                btn.titleLabel.font = _normalFont;
            }
        }
    }
}

- (void)setSelectedFont:(UIFont *)selectedFont{
    _selectedFont = selectedFont;
    _selectedBtn.titleLabel.font = _selectedFont;

    [self configScrollView];
}

- (void)setNormalColor:(UIColor *)normalColor{
    
    _normalColor = normalColor;
    
    for (UIView * subView in self.subviews) {
        if ([subView isKindOfClass:[UIButton class]]) {
            UIButton * btn = (UIButton *)subView;
            [btn setTitleColor:_normalColor forState:UIControlStateNormal];
        }
    }
}

- (void)setSelectedColor:(UIColor *)selectedColor{
   
    _selectedColor = selectedColor;
    
    for (UIView * subView in self.subviews) {
        if ([subView isKindOfClass:[UIButton class]]) {
            UIButton * btn = (UIButton *)subView;
            [btn setTitleColor:_selectedColor forState:UIControlStateSelected];
        }
    }

    _scrollBar.backgroundColor = _selectedColor;

}

- (void)setScrollBarHidden:(BOOL)scrollBarHidden{
    _scrollBarHidden = scrollBarHidden;
    _scrollBar.hidden = _scrollBarHidden;
}

#pragma mark--UIScrollViewDelegate



@end
