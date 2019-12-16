//
//  CitySelectorViewcontroller.h
//  KobeWeatherReport
//
//  Created by kobelin on 2019/12/9.
//  Copyright © 2019 kobelin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MiSearchBar.h"
NS_ASSUME_NONNULL_BEGIN

@interface CitySelectorViewcontroller : UIViewController

@property (nonatomic,strong) MiSearchBar *searchBar;
@property (nonatomic,strong) NSString *searchText;
@property (nonatomic,retain) UITableView *tableView;
@property (nonatomic,retain) NSMutableArray *arr;
@property (nonatomic,retain) NSMutableArray *resultArr;

@end

NS_ASSUME_NONNULL_END
