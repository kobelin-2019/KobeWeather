//
//  UserDefaultStorage.m
//  NEWKobeWeather
//
//  Created by kobelin on 2019/12/13.
//  Copyright © 2019 kobelin. All rights reserved.
//

#import "UserDefaultStorageService.h"
#import "myApp.h"

@implementation UserDefaultStorageService

- (void)readUserDefaultConfig
{
    myApp *app = [myApp getInstance];
    NSArray*muArr=[[NSUserDefaults standardUserDefaults]objectForKey:@"mySuscriptions"];
    for(int i=0;i<muArr.count;i++)
    {
        [app.mySuscriptions addObject:muArr[i]];
    }
    app.cityCodeMap = [[NSUserDefaults standardUserDefaults] objectForKey:@"cityCodeMap"];
    app.codeCityMap = [[NSUserDefaults standardUserDefaults] objectForKey:@"codeCityMap"];
}

- (void)saveUserDefaultConfig
{
    myApp *app = [myApp getInstance];
    NSUserDefaults *defaut = [NSUserDefaults standardUserDefaults];
    [defaut setObject:app.mySuscriptions forKey:@"mySuscriptions"];
    [defaut setObject:app.cityCodeMap forKey:@"cityCodeMap"];
    [defaut setObject:app.codeCityMap forKey:@"codeCityMap"];
}

@end
