//
//  ViewController.m
//  SlideBtnGroups
//
//  Created by 杨肖宇 on 2017/7/13.
//  Copyright © 2017年 杨肖宇. All rights reserved.
//

#import "ViewController.h"
#import "YXYSlideTitleGroup.h"

@interface ViewController ()<YXYSlideTitleGroupDelegate>

@property (weak, nonatomic) IBOutlet YXYSlideTitleGroup *titleScr;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.titleScr.titlesArr = @[@"我就去", @"大些", @"多dsadas撒多", @"动物城", @"无权限", @"的财富", @"dasdw", @"大当家", @"dqwdhqn", @"体育新闻"];
    self.titleScr.YXYDelegate = self;
    self.titleScr.normalFont = [UIFont systemFontOfSize:13];
    self.titleScr.selectedFont = [UIFont systemFontOfSize:15];
    self.titleScr.selectedColor = [UIColor purpleColor];
    self.titleScr.normalColor = [UIColor grayColor];
    self.titleScr.scrollBarHidden = YES;
}

#pragma mark--YXYSlideTitleGroupDelegate
- (void)YXYSlideTitleGroupBtnClicked:(UIButton *)btn didSelectItemAtIndex:(NSUInteger)index{
    NSLog(@"%@", btn.titleLabel.text);
    NSLog(@"%lu", index);
}



@end
