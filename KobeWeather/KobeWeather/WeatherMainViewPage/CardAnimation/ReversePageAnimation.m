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

+ (void)transitformShowView:(UIView *)view hiddenView:(UIView *)toView
{
    NSInteger indexView = [view.superview.subviews indexOfObject:view];
    NSInteger indexToView = [toView.superview.subviews indexOfObject:toView];
    [UIView beginAnimations:@"tranTwoViewAnimation" context:nil];
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:view.superview cache:YES];
    [view.superview exchangeSubviewAtIndex:indexView withSubviewAtIndex:indexToView];
    [UIView commitAnimations];
}

@end
