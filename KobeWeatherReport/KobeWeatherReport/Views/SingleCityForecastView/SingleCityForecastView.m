//
//  SingleCityForecast.m
//  KobeWeatherReport
//
//  Created by kobelin on 2019/12/9.
//  Copyright © 2019 kobelin. All rights reserved.
//

#import "SingleCityForecastView.h"


@implementation ReachableScrollView
- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
{
    return YES;
}

@end

@interface SingleCityForecastView ()

@end

@implementation SingleCityForecastView 

- (ReachableScrollView *)scrollView
{
    if (!_scrollView)
    {
        _scrollView = [[ReachableScrollView alloc] initWithFrame:self.bounds];
        _scrollView.clipsToBounds = NO;
        _scrollView.pagingEnabled = YES;
    }
    return _scrollView;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self setupView];
    }
    return self;
}

- (void)setupView
{
    [self addSubview:self.scrollView];
}

- (void)setActualWidth:(CGFloat)actualWidth
{
    if (actualWidth == 0)
    {
        return;
    }
    CGRect frame = self.scrollView.frame;
    frame.size.width = actualWidth;
    self.scrollView.frame = frame;
    self.scrollView.center = self.center;
}

- (void)setActualHeight:(CGFloat)actualHeight
{
    if (actualHeight == 0)
    {
        return;
    }
    CGRect frame = self.scrollView.frame;
    frame.size.height = actualHeight;
    self.scrollView.frame = frame;
    self.scrollView.center = self.center;
}

- (void)setContentSize:(CGSize)contentSize
{
    self.scrollView.contentSize = contentSize;
}
@end
