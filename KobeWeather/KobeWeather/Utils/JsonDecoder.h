//
//  JsonDecoder.h
//  NEWKobeWeather
//
//  Created by kobelin on 2019/12/13.
//  Copyright © 2019 kobelin. All rights reserved.
//

//将获取到的天气数据转化为WeahterMainPage使用的数据模型
#import <Foundation/Foundation.h>
#import "WeatherInfoGetter.h"
#import "WeatherInfoModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface JsonDecoder : NSObject

- (WeatherInfoModel *)decodeJson: (NSString *)cityName;

@end

NS_ASSUME_NONNULL_END
