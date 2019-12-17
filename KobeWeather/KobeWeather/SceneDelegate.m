
//
//  SceneDelegate.h
//  KobeWeatherReport
//
//  Created by kobelin on 2019/12/9.
//  Copyright © 2019 kobelin. All rights reserved.
//


#import "SceneDelegate.h"
#import "MyApp.h"
#import "WeatherMainPageViewController.h"
#import "CitySelectorViewController.h"
#import "UserDefaultStorageService.h"

@interface SceneDelegate ()
@end

@implementation SceneDelegate

//程序启动后则执行此方法设置必要的数据
- (void)setUpAppSettings
{
    MyApp *app = [MyApp sharedInstance];
    UserDefaultStorageService *dataStorage = [[UserDefaultStorageService alloc] init];
    [dataStorage readUserDefaultConfig];
    
    //如果本地没有数据缓存,则重新设置数据
    if(!app.mySuscriptions||!app.citySelectorViewController)
    {
        [self setUpDefauftSuscriptions];
        app.citySelectorViewController = [[CitySelectorViewcontroller alloc] init];
    }
    
}

//默认订阅北京,上海天气
- (void)setUpDefauftSuscriptions {
    MyApp *app = [MyApp sharedInstance];
    app.mySuscriptions = [[NSMutableArray alloc] init];
    [app.mySuscriptions addObject:@"101010100"];
    [app.mySuscriptions addObject:@"101020100"];
}

//主scene入口，建立入口视图控制器
- (void)scene:(UIScene *)scene willConnectToSession:(UISceneSession *)session options:(UISceneConnectionOptions *)connectionOptions {
    [self setUpAppSettings];
    MyApp *app = [MyApp sharedInstance];
    app.citySelectorViewController = [[CitySelectorViewcontroller alloc] init];
    WeatherMainPageViewController *mainvc = [[WeatherMainPageViewController alloc] init];
    self.window.rootViewController = mainvc;
    app.weatherMainPageViewController = mainvc;
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
