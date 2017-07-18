//
//  YXYSlideTitleGroup.h
//  SlideBtnGroups
//
//  Created by 杨肖宇 on 2017/7/13.
//  Copyright © 2017年 杨肖宇. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol YXYSlideTitleGroupDelegate <NSObject>

/**
   点击title的回调方法

 @param btn 当前点击的btn
 @param index 当前点击btn的序号
 */
- (void)YXYSlideTitleGroupBtnClicked:(UIButton *)btn didSelectItemAtIndex:(NSUInteger)index;

@end


@interface YXYSlideTitleGroup : UIScrollView<UIScrollViewDelegate>

@property (nonatomic, strong) UIColor * normalColor;//default is black
@property (nonatomic, strong) UIColor * selectedColor;//default is red

@property (nonatomic, strong) NSArray * titlesArr;

@property (nonatomic, strong) UIFont * normalFont;//default is 14
@property (nonatomic, strong) UIFont * selectedFont;//default is 16

@property (nonatomic, assign) BOOL scrollBarHidden;//是否隐藏底部的选择指示条，默认NO

@property (nonatomic, weak) id<YXYSlideTitleGroupDelegate> YXYDelegate;

@end
