//
//  DetailedWeatherViewController.m
//  KobeWeatherReport
//
//  Created by kobelin on 2019/12/9.
//  Copyright © 2019 kobelin. All rights reserved.
//

#import "DetailedWeatherViewController.h"

@interface DetailedWeatherViewController ()

@end

@implementation DetailedWeatherViewController

- (id)initWithCityName: (NSString*)CityName
{
    self = [super init];
    if(self)
    {
        self.cityName = CityName;
    
    
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
