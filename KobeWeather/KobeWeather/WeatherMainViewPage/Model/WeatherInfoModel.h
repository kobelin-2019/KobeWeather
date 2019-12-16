//
//  WeatherInfoModel.h
//  NEWKobeWeather
//
//  Created by kobelin on 2019/12/13.
//  Copyright © 2019 kobelin. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface WeatherInfoModel : NSObject

@property NSMutableDictionary *weatherInfoDictionary;

//当天天气数据
@property NSDictionary *cityinfo;
@property NSDictionary *weatherdata;
@property NSDictionary *forecastToday;
@property NSString *date;
@property NSString *cityName;
@property NSString *updateTime;
@property NSString *shidu;
@property NSString *temperature;
@property NSString *highest;
@property NSString *lowest;
@property NSString *type;
@property NSString *notice;

//未来15天天气数据
@property NSMutableArray *forecast;

@end

NS_ASSUME_NONNULL_END
