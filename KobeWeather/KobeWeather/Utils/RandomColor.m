//
//  randomColor.m
//  KobeWeather
//
//  Created by kobelin on 2019/12/17.
//  Copyright © 2019 kobelin. All rights reserved.
//

#import "RandomColor.h"
#import "UIKit/UIKit.h"

@implementation RandomColor

//产生随机颜色的工具类方法
+ (UIColor *)randomColor
{
    CGFloat randomR = drand48();
    CGFloat randomG = drand48();
    CGFloat randomB = drand48();
    return [UIColor colorWithRed:randomR green:randomG blue:randomB alpha:1];
}

@end
