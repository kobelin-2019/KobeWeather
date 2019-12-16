//
//  myApp.h
//  NEWKobeWeather
//
//  Created by kobelin on 2019/12/13.
//  Copyright © 2019 kobelin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WeatherMainPageViewController.h"
#import "WeatherMainPageViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface myApp : NSObject

@property NSMutableArray *mySuscriptions;

@property NSMutableDictionary *codeCityMap;

@property NSMutableDictionary *cityCodeMap;

@property CitySelectorViewcontroller *weatherMainPageViewController;

@property CitySelectorViewcontroller *citySelectorViewController;

+ (id)getInstance;

@end

NS_ASSUME_NONNULL_END
