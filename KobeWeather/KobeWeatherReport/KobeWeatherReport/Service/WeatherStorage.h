//
//  WeatherStorage.h
//  KobeWeatherReport
//
//  Created by kobelin on 2019/12/10.
//  Copyright © 2019 kobelin. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface WeatherStorage : NSObject
+ (void)StoreWeatherData;
+ (void)ReadWeatherData;
@end

NS_ASSUME_NONNULL_END
