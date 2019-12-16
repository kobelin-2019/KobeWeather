
//
//  SceneDelegate.h
//  KobeWeatherReport
//
//  Created by kobelin on 2019/12/9.
//  Copyright © 2019 kobelin. All rights reserved.
//


#import "SceneDelegate.h"
#import "myApp.h"
#import "WeatherMainPageViewController.h"
#import "CitySelectorViewController.h"
#import "UserDefaultStorageService.h"

@interface SceneDelegate ()
@end

@implementation SceneDelegate
- (void)setUpAppSettings
{
    myApp *app = [myApp getInstance];
    UserDefaultStorageService *dataStorage = [[UserDefaultStorageService alloc] init];
    [dataStorage readUserDefaultConfig];
    
    //如果本地没有数据缓存,则重新设置数据
    if(!app.mySuscriptions||!app.citySelectorViewController)
    {
        [self setUpCityCodeMap];
        [self setUpDefauftSuscriptions];//默认订阅北京,上海天气
        app.citySelectorViewController = [[CitySelectorViewcontroller alloc] init];
    }
    
}

- (void)setUpDefauftSuscriptions {
    myApp *app = [myApp getInstance];
    app.mySuscriptions = [[NSMutableArray alloc] init];
    [app.mySuscriptions addObject:@"101010100"];
    [app.mySuscriptions addObject:@"101020100"];
}

- (void)setUpCityCodeMap{
    myApp *app = [myApp getInstance];
    NSString *path = [[NSBundle mainBundle] pathForResource:@"CityCode" ofType:@"json"];
    NSData *jsonData = [[NSData alloc] initWithContentsOfFile:path];
    NSError *error;
    id jsonObj = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&error];
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
        app.codeCityMap = [[NSMutableDictionary alloc] init];
        app.cityCodeMap = [[NSMutableDictionary alloc] init];
        app.codeCityMap[@"jidjaf"] = @"sjdifaj";
        for(id item in dic)
        {
            
            NSDictionary *detail = item;
            [app.codeCityMap setValue:detail[@"city_name"] forKey:detail[@"city_code"]];
            [app.cityCodeMap setValue:detail[@"city_code"] forKey:detail[@"city_name"]];
        }
        
        NSUserDefaults *defaut = [NSUserDefaults standardUserDefaults];
        [defaut setObject:app.codeCityMap forKey:@"CodeCityMap"];
        [defaut setObject:app.cityCodeMap forKey:@"CityCodeMap"];
        
    }

}

- (void)scene:(UIScene *)scene willConnectToSession:(UISceneSession *)session options:(UISceneConnectionOptions *)connectionOptions {
    
    [self setUpAppSettings];
    myApp *app = [myApp getInstance];
    WeatherMainPageViewController *mainvc = [[WeatherMainPageViewController alloc] init];
    self.window.rootViewController = mainvc;
    app.weatherMainPageViewController = mainvc;
    [self setUpCityCodeMap];
}


- (void)sceneDidDisconnect:(UIScene *)scene {
    // Called as the scene is being released by the system.
    // This occurs shortly after the scene enters the background, or when its session is discarded.
    // Release any resources associated with this scene that can be re-created the next time the scene connects.
    // The scene may re-connect later, as its session was not neccessarily discarded (see `application:didDiscardSceneSessions` instead).
}


- (void)sceneDidBecomeActive:(UIScene *)scene {
    // Called when the scene has moved from an inactive state to an active state.
    // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
}


- (void)sceneWillResignActive:(UIScene *)scene {
    // Called when the scene will move from an active state to an inactive state.
    // This may occur due to temporary interruptions (ex. an incoming phone call).
}


- (void)sceneWillEnterForeground:(UIScene *)scene {
    
    // Called as the scene transitions from the background to the foreground.
    // Use this method to undo the changes made on entering the background.
}


- (void)sceneDidEnterBackground:(UIScene *)scene {
    
    // Called as the scene transitions from the foreground to the background.
    // Use this method to save data, release shared resources, and store enough scene-specific state information
    // to restore the scene back to its current state.
}


@end
