//
//  WeatherInfoModel.h
//  NEWKobeWeather
//
//  Created by kobelin on 2019/12/13.
//  Copyright © 2019 kobelin. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
/*
 天气数据模型
 */
@interface WeatherInfoModel : NSObject

@property NSMutableDictionary *weatherInfoDictionary;

//当天天气数据
@property (nonatomic, retain)NSDictionary *cityinfo;//城市信息
@property (nonatomic, retain)NSDictionary *weatherdata;//天气数据
@property (nonatomic, retain)NSDictionary *forecastToday;//当天天气数据
//当天详细天气
@property (nonatomic, copy)NSString *date;//日期
@property (nonatomic, copy)NSString *cityName;//城市名称
@property (nonatomic, copy)NSString *updateTime;//更新时间
@property (nonatomic, copy)NSString *shidu;//湿度
@property (nonatomic, copy)NSString *temperature;//温度
@property (nonatomic, copy)NSString *highest;//最高气温
@property (nonatomic, copy)NSString *lowest;//最低气温
@property (nonatomic, copy)NSString *type;//天气类型
@property (nonatomic, copy)NSString *notice;//天气小提示
//未来15天天气数据
@property NSMutableArray *forecast;

@end

NS_ASSUME_NONNULL_END
