//
//  WeatherInfoGetter.h
//  NEWKobeWeather
//
//  Created by kobelin on 2019/12/13.
//  Copyright © 2019 kobelin. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface WeatherInfoGetter : NSObject

-(NSString *)getWeatherInfo:(NSString *)cityName;//传入城市名，返回Json格式的数据

@end

NS_ASSUME_NONNULL_END
