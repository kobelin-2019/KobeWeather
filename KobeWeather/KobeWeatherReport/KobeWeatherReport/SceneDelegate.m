
//
//  SceneDelegate.h
//  KobeWeatherReport
//
//  Created by kobelin on 2019/12/9.
//  Copyright © 2019 kobelin. All rights reserved.
//


#import "SceneDelegate.h"
#import "WeatherInfoGetter.h"
#import "myApp.h"
#import "SingleCityForecastViewController.h"
#import "EditSuscriptionsViewController.h"
#import "MainViewController.h"
@interface SceneDelegate ()
@property MainViewController *mainVC;
@end

@implementation SceneDelegate
- (void)setUpDefaultUserSettings
{
    [self setUpCityCodeMap];
    [self setUpDefauftSuscriptions];
}

- (void)setUpDefauftSuscriptions {
    NSArray*muArr=[[NSUserDefaults standardUserDefaults]objectForKey:@"mySuscriptions"];
    for(int i=0;i<muArr.count;i++)
    {
        [self.mainVC.app.mySuscriptions addObject:muArr[i]];
    }
    if(!self.mainVC.app.mySuscriptions)
    {
        self.mainVC.app.mySuscriptions = [[NSMutableArray alloc] init];
        //默认订阅北京,上海天气
        [_mainVC.app.mySuscriptions addObject:@"101010100"];
        [_mainVC.app.mySuscriptions addObject:@"101020100"];
        NSUserDefaults *defaut = [NSUserDefaults standardUserDefaults];
        [defaut setObject:self.mainVC.app.mySuscriptions forKey:@"mySuscriptions"];
    }
}

- (void)setUpCityCodeMap{
    
    NSMutableDictionary*muDic=[[NSMutableDictionary alloc]initWithDictionary:[[NSUserDefaults standardUserDefaults]objectForKey:@"CodeCityMap"]];
    self.mainVC.app.codeCityMap = muDic;
    muDic=[[NSMutableDictionary alloc]initWithDictionary:[[NSUserDefaults standardUserDefaults]objectForKey:@"CityCodeMap"]];
    self.mainVC.app.cityCodeMap = muDic;
    if(!self.mainVC.app.codeCityMap||!self.mainVC.app.cityCodeMap||self.mainVC.app.codeCityMap.count==0||self.mainVC.app.cityCodeMap.count==0)
    {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"CityCode" ofType:@"json"];
        NSData *jsonData = [[NSData alloc] initWithContentsOfFile:path];
        NSError *error;
        id jsonObj = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&error];
        if (!jsonData || error) {
            NSLog(@"JSON解码失败");
        } else {

            NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        NSData * weatherdata = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
        NSError * error = [[NSError alloc] init];
        NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:weatherdata options:0 error:&error];
            self.mainVC.app.codeCityMap = [[NSMutableDictionary alloc] init];
            self.mainVC.app.cityCodeMap = [[NSMutableDictionary alloc] init];
            NSLog(@"%@",self.mainVC.app.codeCityMap);
            self.mainVC.app.codeCityMap[@"jidjaf"] = @"sjdifaj";
            NSLog(@"%d",(int)self.mainVC.app.codeCityMap.count);
            for(id item in dic)
            {
                NSLog(@"%@",item);
                NSDictionary *detail = item;
                [self.mainVC.app.codeCityMap setValue:detail[@"city_name"] forKey:detail[@"city_code"]];
                [self.mainVC.app.cityCodeMap setValue:detail[@"city_code"] forKey:detail[@"city_name"]];
            }
            //NSLog(@"%@",self.mainVC.app.cityCodeMap[@"北京"]);
            NSUserDefaults *defaut = [NSUserDefaults standardUserDefaults];
            [defaut setObject:self.mainVC.app.codeCityMap forKey:@"CodeCityMap"];
            [defaut setObject:self.mainVC.app.cityCodeMap forKey:@"CityCodeMap"];
            
        }
    }

}

- (void)scene:(UIScene *)scene willConnectToSession:(UISceneSession *)session options:(UISceneConnectionOptions *)connectionOptions {
    self.mainVC = [[MainViewController alloc] init];
    self.mainVC.app = [[myApp alloc] init];
    [self setUpDefaultUserSettings];
    myApp *app = [myApp getInstance];
    self.mainVC = [[SingleCityForecastViewController alloc]init];
    UINavigationController * navigationController = [[UINavigationController alloc] initWithRootViewController:self.mainVC];
    app.mainVC = self.mainVC;
    self.window.rootViewController = navigationController;
    app.editSuscriptionsViewController = [[EditSuscriptionsViewController alloc]init];  
    //[self setUpDefaultUserSettings];
    
    
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
