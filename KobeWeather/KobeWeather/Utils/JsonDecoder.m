//
//  JsonDecoder.m
//  NEWKobeWeather
//
//  Created by kobelin on 2019/12/13.
//  Copyright © 2019 kobelin. All rights reserved.
//

#import "JsonDecoder.h"
#import "WeatherInfoModel.h"
#import "MyApp.h"
@implementation JsonDecoder

//将请求到的天气Json数据解析成WeatherInfoModel
+ (WeatherInfoModel *)decodeJson: (NSString *)cityName
{
    MyApp *app = [MyApp sharedInstance];
    WeatherInfoModel *returnModel = [[WeatherInfoModel alloc] init];
    
    //建立请求url
    NSMutableString *Url = [[NSMutableString alloc]  initWithString:@"http://t.weather.sojson.com/api/weather/city/"];
    [Url appendString:app.cityToCodeMap[cityName]];
    NSURL *NsUrl = [NSURL URLWithString:Url];
    
    //一些中间处理过程
    NSData *data = [NSData dataWithContentsOfURL:NsUrl];
    NSString *info = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    NSString *jsonString = info;
    NSData * wdata = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError * error = [[NSError alloc] init];
    NSDictionary * res = [NSJSONSerialization JSONObjectWithData:wdata options:0 error:&error];
    NSMutableDictionary *weatherInfoDictionary = [[NSMutableDictionary alloc] initWithDictionary:res];
    
    //解析过程
    NSDictionary *cityinfo = weatherInfoDictionary[@"cityInfo"];
    NSDictionary *weatherdata = weatherInfoDictionary[@"data"];
    NSMutableArray *forecast = weatherdata[@"forecast"];
    NSDictionary *forecastToday = forecast[0];
    NSString *date = weatherInfoDictionary[@"date"];
    NSString *thecityName = cityinfo[@"city"];
    NSString *updateTime = cityinfo[@"updateTime"];
    NSString *shidu = weatherdata[@"shidu"];
    NSString *temperature = weatherdata[@"wendu"];
    NSString *highest = forecastToday[@"high"];
    NSString *lowest = forecastToday[@"low"];
    NSString *type = forecastToday[@"type"];
    NSString *notice = forecastToday[@"notice"];
    
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
