//
//  JsonDecoder.m
//  NEWKobeWeather
//
//  Created by kobelin on 2019/12/13.
//  Copyright © 2019 kobelin. All rights reserved.
//

#import "JsonDecoder.h"
#import "WeatherInfoModel.h"
#import "WeatherInfoGetter.h"
#import "myApp.h"
@implementation JsonDecoder

- (WeatherInfoModel *)decodeJson: (NSString *)cityName
{
    myApp *app = [myApp getInstance];
    WeatherInfoGetter *weatherInfoGetter = [[WeatherInfoGetter alloc]init];
    NSString *jsonString = [weatherInfoGetter getWeatherInfo:cityName];
    NSLog(@"IIIIIIIIIIIIII%@",jsonString);
    NSData * wdata = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
      NSError * error = [[NSError alloc] init];
      NSDictionary * res = [NSJSONSerialization JSONObjectWithData:wdata options:0 error:&error];
    
    NSMutableDictionary *weatherInfoDictionary = [[NSMutableDictionary alloc] initWithDictionary:res];
    
    NSLog(@"*************%@",res);

    WeatherInfoModel *returnModel = [[WeatherInfoModel alloc] init];
    //NSLog(@"23333%@",weatherInfoDictionary);
    NSDictionary *cityinfo = weatherInfoDictionary[@"cityInfo"];
    NSDictionary *weatherdata = weatherInfoDictionary[@"data"];
    
    NSArray *forecast = weatherdata[@"forecast"];
    
    NSDictionary *forecastToday = forecast[0];
    NSLog(@"ffffffffff%@",forecastToday);
    //NSLog(@"forestcastTaday:%@",forecastToday);
    NSString *date = weatherInfoDictionary[@"date"];
    NSString *thecityName = cityinfo[@"city"];
    NSString *updateTime = cityinfo[@"updateTime"];
    NSString *shidu = weatherdata[@"shidu"];
    NSString *temperature = weatherdata[@"wendu"];
    NSString *highest = forecastToday[@"high"];
    NSString *lowest = forecastToday[@"low"];
    NSString *type = forecastToday[@"type"];
    NSString *notice = forecastToday[@"notice"];
    NSLog(@"%@",notice);
    
    //将获取到的数据转化为WeatherInfoModel返回
    returnModel.forecast = forecast;
    returnModel.date = date;
    returnModel.cityName = thecityName;
    returnModel.updateTime = updateTime;
    returnModel.shidu = shidu;
    returnModel.temperature = temperature;
    returnModel.forecastToday = forecastToday;
    returnModel.highest = highest;
    returnModel.lowest = lowest;
    returnModel.type = type;
    returnModel.notice = notice;
    
    return returnModel;
}

@end
