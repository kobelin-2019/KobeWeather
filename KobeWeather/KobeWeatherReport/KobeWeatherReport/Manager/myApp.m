//
//  myApp.m
//  KobeWeatherReport
//
//  Created by kobelin on 2019/12/9.
//  Copyright © 2019 kobelin. All rights reserved.
//

#import "myApp.h"
static myApp *appInstance = nil;
@implementation myApp
+(id) getInstance
{
    if(appInstance==nil)
    {
        appInstance = [[myApp alloc] init];
    }
    return appInstance;
}
-(id) init
{
    
    if(!appInstance)
    {
        self = [super init];
   
        self.codeCityMap = [[NSMutableDictionary alloc] init];
        self.cityCodeMap = [[NSMutableDictionary alloc] init];
        self.mySuscriptions = [[NSMutableArray alloc] init];
        appInstance = self;
        return self;
    }
    else {
        return appInstance;
    }
}
@end
