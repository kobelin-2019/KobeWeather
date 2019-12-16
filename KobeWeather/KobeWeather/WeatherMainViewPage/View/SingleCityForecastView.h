//
//  SingleCityForecast.h
//  KobeWeatherReport
//
//  Created by kobelin on 2019/12/9.
//  Copyright © 2019 kobelin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface  ReachableScrollView : UIScrollView

@end


@interface SingleCityForecastView : UIView

@property (nonatomic, assign) CGFloat actualWidth;

@property (nonatomic, assign) CGFloat actualHeight;

@property (nonatomic, strong) ReachableScrollView *scrollView;

@end


