//
//  WeatherInfoModel.m
//  NEWKobeWeather
//
//  Created by kobelin on 2019/12/13.
//  Copyright © 2019 kobelin. All rights reserved.
//

#import "WeatherInfoModel.h"

@implementation WeatherInfoModel

- (id)init
{
    self = [super init];
    if(self)
    {
        _cityinfo = [[NSDictionary alloc] init];
        _cityName = [[NSString alloc] init];
        _date = [[NSString alloc]init];
        _forecast = [[NSDictionary alloc] init];
        _forecastToday = [[NSDictionary alloc]init];
        _highest = [[NSString alloc]init];
        _lowest = [[NSString alloc]init];
        _notice = [[NSString alloc]init];
        _shidu = [[NSString alloc]init];
        _temperature = [[NSString alloc]init];;
        _type = [[NSString alloc]init];;
        _updateTime = [[NSString alloc]init];;
        _weatherdata = [[NSDictionary alloc]init];
        _weatherInfoDictionary = [[NSMutableDictionary alloc] init];
    }
    return self;
}

@end
