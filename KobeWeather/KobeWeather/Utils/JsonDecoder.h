//
//  JsonDecoder.h
//  NEWKobeWeather
//
//  Created by kobelin on 2019/12/13.
//  Copyright © 2019 kobelin. All rights reserved.
//

//将获取到的天气数据转化为WeahterMainPage使用的数据模型
#import <Foundation/Foundation.h>
#import "WeatherInfoModel.h"

NS_ASSUME_NONNULL_BEGIN
/*
 Json解析类
 */
@interface JsonDecoder : NSObject

//将请求到的天气Json数据解析成WeatherInfoModel
+ (WeatherInfoModel *)decodeJson: (NSString *)cityName;

@end

NS_ASSUME_NONNULL_END
