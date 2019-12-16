//
//  WeatherInfoGetter.m
//  NEWKobeWeather
//
//  Created by kobelin on 2019/12/13.
//  Copyright © 2019 kobelin. All rights reserved.
//

#import "WeatherInfoGetter.h"
#import "myApp.h"
@implementation WeatherInfoGetter

-(NSString *)getWeatherInfo:(NSString *)cityName
{
    //NSLog(@"Searching%@",cityName);
    myApp *app = [myApp getInstance];
    NSMutableString *Url = [[NSMutableString alloc]  initWithString:@"http://t.weather.sojson.com/api/weather/city/"];
   
    [Url appendString:app.cityCodeMap[cityName]];
    //NSLog(@"%@",Url);
    NSURL *NsUrl = [NSURL URLWithString:Url];
     NSData *data = [NSData dataWithContentsOfURL:NsUrl];
           NSString *info = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
           NSString *jsonString = info;
          // NSLog(@"%@",jsonString);
    return jsonString;
}

@end
