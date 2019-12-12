//
//  DetailedWeatherViewController.h
//  KobeWeatherReport
//
//  Created by kobelin on 2019/12/9.
//  Copyright © 2019 kobelin. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DetailedWeatherViewController : UIViewController
@property NSString *cityName;
@property NSMutableArray *labels;
@property NSMutableArray *icons;

@end

NS_ASSUME_NONNULL_END
