//
//  MyApp.h
//  NEWKobeWeather
//
//  Created by kobelin on 2019/12/13.
//  Copyright © 2019 kobelin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CitySelectorViewController.h"
#import "WeatherMainPageViewController.h"

NS_ASSUME_NONNULL_BEGIN
/*
MyApp作为单例模式设计，供全局使用
*/
@interface MyApp : NSObject

@property (nonatomic, retain)NSMutableArray *mySuscriptions;
@property (nonatomic, retain)NSMutableDictionary *codeToCityMap;
@property (nonatomic, retain)NSMutableDictionary *cityToCodeMap;

@property (nonatomic, strong)WeatherMainPageViewController *weatherMainPageViewController;
@property (nonatomic, strong)CitySelectorViewcontroller *citySelectorViewController;

+ (id)sharedInstance;

@end

NS_ASSUME_NONNULL_END
