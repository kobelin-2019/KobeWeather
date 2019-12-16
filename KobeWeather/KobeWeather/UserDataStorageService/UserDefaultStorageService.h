//
//  UserDefaultStorage.h
//  NEWKobeWeather
//
//  Created by kobelin on 2019/12/13.
//  Copyright © 2019 kobelin. All rights reserved.
//

//提供用户数据本地缓存服务
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface UserDefaultStorageService : NSObject

- (void)readUserDefaultConfig;
- (void)saveUserDefaultConfig;

@end

NS_ASSUME_NONNULL_END
