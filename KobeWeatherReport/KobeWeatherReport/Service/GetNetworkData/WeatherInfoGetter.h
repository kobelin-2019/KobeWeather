//
//  WeatherInfoGetter.h
//  KobeWeatherReport
//
//  Created by kobelin on 2019/12/9.
//  Copyright © 2019 kobelin. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface WeatherInfoGetter : NSObject

-(NSDictionary *)getWeatherInfo:(NSString *)cityCode;
@end

NS_ASSUME_NONNULL_END
