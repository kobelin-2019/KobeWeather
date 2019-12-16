//
//  WeatherMainPageViewController.h
//  KobeWeatherReport
//
//  Created by kobelin on 2019/12/9.
//  Copyright © 2019 kobelin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CitySelectorViewController.h"
#import "SingleCityForecastView.h"
#import "myApp.h"
#import "WeatherInfoGetter.h"
#import "WeatherInfoModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface WeatherMainPageViewController : UIViewController

@property UIButton *cityNanageBtn;
@property WeatherInfoGetter *weatherInfoGetter;
@property SingleCityForecastView *scrollView;
@property NSMutableArray *cardViews;
@property UIButton *refreshBtn;
@property NSMutableArray *reverseCardViews;
@property NSMutableArray *cardColor;
@property WeatherInfoModel *weatherInfoModel;
@property NSMutableArray *suscriptions;

@end

NS_ASSUME_NONNULL_END
