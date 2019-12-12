//
//  myApp.h
//  KobeWeatherReport
//
//  Created by kobelin on 2019/12/9.
//  Copyright © 2019 kobelin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EditSuscriptionsViewController.h"
#import "SingleCityForecastViewController.h"
NS_ASSUME_NONNULL_BEGIN

@interface myApp : NSObject
@property NSMutableArray * mySuscriptions;
@property NSMutableDictionary * codeCityMap;
@property NSMutableDictionary * cityCodeMap;
@property EditSuscriptionsViewController *editSuscriptionsViewController;
@property SingleCityForecastViewController* mainVC;
+ (id)getInstance;
@end

NS_ASSUME_NONNULL_END
