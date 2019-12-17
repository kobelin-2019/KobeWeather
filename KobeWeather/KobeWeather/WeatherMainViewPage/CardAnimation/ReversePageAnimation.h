//
//  ReversePageAnimation.h
//  NEWKobeWeather
//
//  Created by kobelin on 2019/12/16.
//  Copyright © 2019 kobelin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
/*
 卡片翻转动画类
 */
@interface ReversePageAnimation : NSObject

//提供天气卡片的翻转动画
+ (void)transitformShowView:(UIView *)view hiddenView:(UIView *)toView;

@end

NS_ASSUME_NONNULL_END
