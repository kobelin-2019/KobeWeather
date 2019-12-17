//
//  UserDefaultStorage.m
//  NEWKobeWeather
//
//  Created by kobelin on 2019/12/13.
//  Copyright © 2019 kobelin. All rights reserved.
//

#import "UserDefaultStorageService.h"
#import "MyApp.h"

@implementation UserDefaultStorageService

//读取用户本地数据
- (void)readUserDefaultConfig
{
    MyApp *app = [MyApp sharedInstance];
    NSArray*muArr=[[NSUserDefaults standardUserDefaults]objectForKey:@"mySuscriptions"];
    for(int i = 0; i < muArr.count; i++)
    {
        [app.mySuscriptions addObject:muArr[i]];
    }
    app.cityToCodeMap = [[NSUserDefaults standardUserDefaults] objectForKey:@"cityToCodeMap"];
    app.codeToCityMap = [[NSUserDefaults standardUserDefaults] objectForKey:@"codeToCityMap"];
    if(!app.cityToCodeMap || !app.codeToCityMap)
    {
        [self setUpcityCodeMap];
    }
}

//保存用户数据到本地
- (void)saveUserDefaultConfig
{
    MyApp *app = [MyApp sharedInstance];
    NSUserDefaults *defaut = [NSUserDefaults standardUserDefaults];
    [defaut setObject:app.mySuscriptions forKey:@"mySuscriptions"];
    [defaut setObject:app.cityToCodeMap forKey:@"cityToCodeMap"];
    [defaut setObject:app.codeToCityMap forKey:@"codeToCityMap"];
}

//建立城市名<->城市代码的映射字典
- (void)setUpcityCodeMap{
    MyApp *app = [MyApp sharedInstance];
    NSString *path = [[NSBundle mainBundle] pathForResource:@"CityCode" ofType:@"json"];
    NSData *jsonData = [[NSData alloc] initWithContentsOfFile:path];
    NSError *error;
    if (!jsonData || error)
    {
        NSLog(@"JSON解码失败");
    }
    else
    {
        NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        NSData * weatherdata = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
        NSError * error = [[NSError alloc] init];
        NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:weatherdata options:0 error:&error];
        app.codeToCityMap = [[NSMutableDictionary alloc] init];
        app.cityToCodeMap = [[NSMutableDictionary alloc] init];
        app.codeToCityMap[@"jidjaf"] = @"sjdifaj";
        for(id item in dic)
        {
            NSDictionary *detail = item;
            [app.codeToCityMap setValue:detail[@"city_name"] forKey:detail[@"city_code"]];
            [app.cityToCodeMap setValue:detail[@"city_code"] forKey:detail[@"city_name"]];
        }
        
        NSUserDefaults *defaut = [NSUserDefaults standardUserDefaults];
        [defaut setObject:app.codeToCityMap forKey:@"codeToCityMap"];
        [defaut setObject:app.cityToCodeMap forKey:@"cityToCodeMap"];
        
    }

}

@end
