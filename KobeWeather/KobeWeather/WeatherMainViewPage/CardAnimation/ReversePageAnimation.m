//
//  ReversePageAnimation.m
//  NEWKobeWeather
//
//  Created by kobelin on 2019/12/16.
//  Copyright © 2019 kobelin. All rights reserved.
//

#import "ReversePageAnimation.h"
#import <UIKit/UIKit.h>
@implementation ReversePageAnimation

//提供天气卡片的翻转动画
+ (void)transitformShowView:(UIView *)view hiddenView:(UIView *)toView
{
    [UIView transitionFromView:view toView:toView duration:0.4 options:UIViewAnimationOptionTransitionFlipFromLeft completion:nil];
}


@end
