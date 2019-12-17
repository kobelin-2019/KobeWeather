//
//  MyApp.m
//  KobeWeatherReport
//
//  Created by kobelin on 2019/12/9.
//  Copyright © 2019 kobelin. All rights reserved.
//

#import "MyApp.h"

@implementation MyApp

static MyApp *sharedInstance = nil;

//MyApp作为单例模式设计，供全局使用
+ (instancetype)sharedInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}


-(id) init
{
    self = [super init];
    if(self)
    {
        self.codeToCityMap = [[NSMutableDictionary alloc] init];
        self.cityToCodeMap = [[NSMutableDictionary alloc] init];
        self.mySuscriptions = [[NSMutableArray alloc] init];
        self.citySelectorViewController = [[CitySelectorViewcontroller alloc] init];
    }
    return self;
}


@end
