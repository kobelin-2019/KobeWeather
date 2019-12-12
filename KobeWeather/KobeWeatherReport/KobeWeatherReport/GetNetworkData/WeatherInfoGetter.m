//
//  WeatherInfoGetter.m
//  KobeWeatherReport
//
//  Created by kobelin on 2019/12/9.
//  Copyright © 2019 kobelin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WeatherInfoGetter.h"

@interface WeatherInfoGetter()
@end
@implementation WeatherInfoGetter
- (NSDictionary *)getWeatherInfo:(NSString *)cityCode
{
    
    NSDictionary * resDictionary = [[NSUserDefaults standardUserDefaults] objectForKey:@"WeatherStorage"];
    NSData *cityWeatherStorageData = resDictionary[cityCode];
    if(cityWeatherStorageData!=nil)
    {
        NSError * error = [[NSError alloc] init];
               NSDictionary * res = [NSJSONSerialization JSONObjectWithData:cityWeatherStorageData options:0 error:&error];
        return res;
    }
    
    else
    {
        
    NSMutableString *Url = [[NSMutableString alloc]  initWithString:@"http://t.weather.sojson.com/api/weather/city/"];
    [Url appendString:cityCode];
    NSURL *NsUrl = [NSURL URLWithString:Url];
    NSData *data = [NSData dataWithContentsOfURL:NsUrl];
    NSString *info = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    NSString *jsonString = info;
        NSLog(@"%@",jsonString);
        NSData * weatherdata = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
        NSError * error = [[NSError alloc] init];
        NSDictionary * res = [NSJSONSerialization JSONObjectWithData:weatherdata options:0 error:&error];
       
        
        
        //NSUserDefaults *defaut = [NSUserDefaults standardUserDefaults];
      //  [defaut setObject:self.mainVC.app.mySuscriptions forKey:@"mySuscriptions"];
        
        
        return res;
        
        
    }
}
@end
