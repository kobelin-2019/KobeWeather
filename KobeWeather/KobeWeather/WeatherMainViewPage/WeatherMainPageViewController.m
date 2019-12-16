//
//  WeatherMainPageViewController.m
//  KobeWeatherReport
//
//  Created by kobelin on 2019/12/9.
//  Copyright © 2019 kobelin. All rights reserved.
//

#import "WeatherMainPageViewController.h"
#import "CitySelectorViewcontroller.h"
#import "SingleCityForecastView.h"
#import "myApp.h"
#import "WeatherInfoGetter.h"
#import "WeatherInfoModel.h"
#import "JsonDecoder.h"
#import "ReversePageAnimation.h"
#import "UserDefaultStorageService.h"
/*
天气主页面：以卡片形式展示订阅的天气数据
 */

@interface WeatherMainPageViewController ()

@end

@implementation WeatherMainPageViewController
- (id)init
{
    self = [super init];
    if(self)
    {
        _weatherInfoGetter = [[WeatherInfoGetter alloc] init];
        [self viewDidLoad];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.weatherInfoGetter = [[WeatherInfoGetter alloc]init];
    UIImageView *backGroundImageView = [[UIImageView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    UIImage *img = [UIImage imageNamed:@"background.jpg"];
    backGroundImageView.image = img;
    [self.view addSubview:backGroundImageView];
    self.cityNanageBtn = [[UIButton alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width - 40,30,27, 27)];
    //[self.cityNanageBtn setTitle:@"添加" forState:UIControlStateNormal];
    [self.cityNanageBtn setImage:[UIImage imageNamed:@"addCity.png"] forState:UIControlStateNormal];
    [self.cityNanageBtn setImage:[UIImage imageNamed:@"addCity2.png"] forState:UIControlStateHighlighted];
    [self.cityNanageBtn setTitleColor:[UIColor yellowColor] forState:UIControlStateNormal];
    [self.cityNanageBtn addTarget:self action:@selector(goEditSuscription) forControlEvents:UIControlEventTouchUpInside];
    [self loadWeatherData];
    UserDefaultStorageService *userDefaultStorageService = [[UserDefaultStorageService alloc] init];
    [userDefaultStorageService saveUserDefaultConfig];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (void)loadWeatherData
{
    
    myApp *app = [myApp getInstance];
    self.suscriptions = app.mySuscriptions;

    if(!self.cardColor)self.cardColor = [[NSMutableArray alloc] init];
    CGSize cardSize = CGSizeMake(270, 360+120+50);
    NSInteger cardCount = self.suscriptions.count;
    SingleCityForecastView *singleCityForecastView;
        singleCityForecastView = [[SingleCityForecastView alloc] initWithFrame:CGRectMake(0, 20, self.view.frame.size.width, self.view.frame.size.height - 20)];
        [self.view addSubview:singleCityForecastView];
        singleCityForecastView.actualWidth = cardSize.width;
        singleCityForecastView.actualHeight = cardSize.height;
    self.scrollView = singleCityForecastView;
    self.cardViews = [[NSMutableArray alloc] init];
    self.reverseCardViews = [[NSMutableArray alloc]init];
    
    @autoreleasepool
    {
        
    for (int i = 0; i < cardCount; i++) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(i * cardSize.width, 0, cardSize.width, cardSize.height)];
        
        self.refreshBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.view.bounds.size.width/2 - 10,30+25 , 20, 20)];
        [self.refreshBtn setImage:[UIImage imageNamed:@"shuaxin.png"] forState:UIControlStateNormal];
        [self.refreshBtn addTarget:self action:@selector(refreshAnimation:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:self.refreshBtn];
        
        UIView *card = [[UIView alloc] initWithFrame:CGRectInset(view.bounds, 10, 10)];
        card.layer.cornerRadius = self.suscriptions.count;
        card.layer.masksToBounds = YES;
        if(i<_cardColor.count)
        {
            card.backgroundColor = _cardColor[i];
        }
        else
        {
            card.backgroundColor = [[self randomColor]colorWithAlphaComponent:0.4f];
            [_cardColor addObject:card.backgroundColor];
        }
        
        UIView *reverseView = [[UIView alloc] initWithFrame:card.frame];
        reverseView.backgroundColor = card.backgroundColor;

        
        [self.cardViews addObject:card];
        [self.reverseCardViews addObject:reverseView];
        reverseView.hidden = YES;
        [view addSubview:reverseView];
        [view addSubview:card];
        [singleCityForecastView.scrollView addSubview:view];
       
        JsonDecoder *jsonDecoder = [JsonDecoder new];
        WeatherInfoModel *weatherInfoModel = [[WeatherInfoModel alloc] init];
        weatherInfoModel = [jsonDecoder decodeJson:app.codeCityMap[self.suscriptions[i]]];
        
        
        NSDictionary *weatherdata = weatherInfoModel.weatherdata;
        NSLog(@"获取的天气数据%@",weatherdata);
        
        int forcastViewHeight = reverseView.frame.size.height - 30;
        int averageForecastViewHeight = (forcastViewHeight-30)/12.0;
        int posy = 40;int posx = 0;
        for(int i=1;i<13;i++)
        {
            NSDictionary *forecast = weatherInfoModel.forecast[i];
            NSString * date = forecast[@"date"];
            date = [date stringByAppendingString:@"日"];
            NSString *highest = forecast[@"high"];
            NSString *lowest = forecast[@"low"];
            NSString *type = forecast[@"type"];
            int ww = reverseView.frame.size.width/5;
            int posx = 0;
            UILabel *dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(posx, posy, ww, averageForecastViewHeight)];
            posx += ww;
            dateLabel.text = date;
            dateLabel.adjustsFontSizeToFitWidth = YES;
            
            UIImage *weatherIcon;
            if([type containsString:@"晴"])
            {
                weatherIcon = [UIImage imageNamed:@"0.png"];
            }
            else if([type containsString:@"云"])
            {
                weatherIcon = [UIImage imageNamed:@"1.png"];
            }
            else if([type containsString:@"雨"])
            {
                weatherIcon = [UIImage imageNamed:@"2.png"];
            }
            else if([type containsString:@"雾"])
            {
                weatherIcon = [UIImage imageNamed:@"3.png"];
            }
            else if([type containsString:@"雪"])
            {
                weatherIcon = [UIImage imageNamed:@"4.png"];
            }
            else {
                weatherIcon = [UIImage imageNamed:@"1.png"];
            }
            
            UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(posx, posy, ww, averageForecastViewHeight)];
            posx += ww;
            UIImage *img = weatherIcon;
            imgView.image = img;

            UILabel *highestLabel = [[UILabel alloc] initWithFrame:CGRectMake(posx, posy, ww, averageForecastViewHeight)];
            posx += ww;
            highestLabel.text = highest;
            highestLabel.adjustsFontSizeToFitWidth = YES;
            
            UILabel *lowestLabel = [[UILabel alloc] initWithFrame:CGRectMake(posx, posy, ww, averageForecastViewHeight)];
            posx += ww;
            lowestLabel.text = lowest;
            lowestLabel.adjustsFontSizeToFitWidth = YES;
            
            UILabel *typeLabel = [[UILabel alloc] initWithFrame:CGRectMake(posx, posy, ww, averageForecastViewHeight)];
            posx += ww;
            typeLabel.text = type;
            typeLabel.adjustsFontSizeToFitWidth = YES;
          
            dateLabel.textColor = [UIColor blackColor];
            highestLabel.textColor = [UIColor blackColor];
            lowestLabel.textColor = [UIColor blackColor];
            typeLabel.textColor = [UIColor blackColor];
            [reverseView addSubview:dateLabel];
            [reverseView addSubview:highestLabel];
            [reverseView addSubview:lowestLabel];
            [reverseView addSubview:typeLabel];
            [reverseView addSubview:imgView];
            posy += averageForecastViewHeight;
        }
        
        
       /*
        forecast":[{"date":"10","high":"高温 19℃","low":"低温 11℃","ymd":"2019-12-10","week":"星期二","sunrise":"06:25","sunset":"17:06","aqi":39,"fx":"无持续风向","fl":"<3级","type":"晴","notice":"愿你拥有比阳光明媚的心情"}
        */
        
        NSString *date = weatherInfoModel.date;
        NSString *cityName = weatherInfoModel.cityName;
        NSString *updateTime = weatherInfoModel.updateTime;
        NSString *shidu = weatherInfoModel.shidu;
        //float pm25 = weatherdata[@"pm25"];
        NSString *temperature = weatherInfoModel.temperature;
        //NSDictionary *forecastToday = weatherdata[@"forecast"][0];
        NSString *highest = weatherInfoModel.highest;
        NSString *lowest = weatherInfoModel.lowest;
        NSString *type = weatherInfoModel.type;
        NSString *notice = weatherInfoModel.notice;
        
        
        if(!date)date = @"";
        if(!cityName)cityName = @"";
        if(!updateTime)updateTime = @"";
        if(!shidu)shidu = @"";
        //if(!pm25)pm25 = 0.0f;
        if(!temperature)temperature = @"";
        if(!highest)highest = @"";
        if(!lowest)lowest = @"";
        if(!type)type = @"";
        if(!notice)notice = @"";
        
        UILabel *innerView = [[UILabel alloc] initWithFrame:CGRectInset(card.bounds ,20, 20)];
        
        posx = innerView.frame.origin.x;
        posy = innerView.frame.origin.y;
        UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(posx + 10, posy + 5+50, innerView.frame.size.width/2 - 20, 30)];
        label1.text = cityName;
        [label1 setFont:[UIFont systemFontOfSize:25]];
        label1.textColor = [UIColor blackColor];
        label1.adjustsFontSizeToFitWidth = YES;
        [card addSubview:label1];
        
        label1 = [[UILabel alloc] initWithFrame:CGRectMake(posx + 10 + card.frame.size.width/2, posy+5+50,innerView.frame.size.width/2 -20 , 30)];
        label1.text = type;
        [label1 setFont:[UIFont systemFontOfSize:25]];
        label1.textColor = [UIColor blackColor];
        [card addSubview:label1];
        
        
        
        posy += 50;
        UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(posx + 10 + 20, posy + 5, innerView.frame.size.width/2 , card.frame.size.height - 350)];
        label2.text = temperature;
        [label2 setFont:[UIFont systemFontOfSize:70]];
        label2.textColor = [UIColor blackColor];
        label2.adjustsFontSizeToFitWidth = YES;
        [card addSubview:label2];

        
        
        UILabel *label23 = [[UILabel alloc] initWithFrame:CGRectMake(posx + 10 + card.frame.size.width/2 - 15, posy + 5 - 17, innerView.frame.size.width/2 - 20, card.frame.size.height - 400)];
        label23.text = @"。";
        label23.textColor = [UIColor blackColor];
        [label23 setFont:[UIFont systemFontOfSize:40]];
        [card addSubview:label23];

        UILabel *label3 = [[UILabel alloc] initWithFrame:CGRectMake(posx + 10 + card.frame.size.width/2, posy + 5, innerView.frame.size.width/2 - 20, card.frame.size.height - 380)];
        label3.text = @"C";
        label3.textColor = [UIColor blackColor];
        [label3 setFont:[UIFont systemFontOfSize:40]];
        [card addSubview:label3];

       
        
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(posx+40, label3.frame.origin.y + label3.frame.size.height , card.frame.size.width - 2*(posx +40) , 120)];
        [card addSubview:imgView];
        UIImage *weatherIcon = nil;
        if([type containsString:@"晴"])
        {
            weatherIcon = [UIImage imageNamed:@"0.png"];
        }
        else if([type containsString:@"云"])
        {
            weatherIcon = [UIImage imageNamed:@"1.png"];
        }
        else if([type containsString:@"雨"])
        {
            weatherIcon = [UIImage imageNamed:@"2.png"];
        }
        else if([type containsString:@"雾"])
        {
            weatherIcon = [UIImage imageNamed:@"3.png"];
        }
        else if([type containsString:@"雪"])
        {
            weatherIcon = [UIImage imageNamed:@"4.png"];
        }
        else {weatherIcon = [UIImage imageNamed:@"1.png"];}
        imgView.image = weatherIcon;

        
        posy += card.frame.size.height -350 + 150;
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(posx + 10 , posy + 5, innerView.frame.size.width/2 - 20, 40)];
        label.text = lowest;
        label.textColor = [UIColor blackColor];
        [label setFont:[UIFont systemFontOfSize:15]];
        label.adjustsFontSizeToFitWidth = YES;
        [card addSubview:label];
        
        
        label = [[UILabel alloc] initWithFrame:CGRectMake(posx + 10 + card.frame.size.width/2, posy + 5, innerView.frame.size.width/2 - 20, 40)];
        label.text = highest;
        label.textColor = [UIColor blackColor];
        [label setFont:[UIFont systemFontOfSize:15]];
        label.adjustsFontSizeToFitWidth = YES;
        [card addSubview:label];
        

       
        posy =card.frame.origin.y + card.frame.size.height - 180;
        UILabel *noticeLabel = [[UILabel alloc] initWithFrame:CGRectMake(posx + 10, posy + 5, innerView.frame.size.width - 10, 30)];
        noticeLabel.text = notice;
        [noticeLabel setFont:[UIFont systemFontOfSize:16]];
        noticeLabel.textColor = [UIColor blackColor];
        label.adjustsFontSizeToFitWidth = YES;
        [card addSubview:noticeLabel];
        
        posy = card.frame.origin.y + card.frame.size.height - 90;

        UILabel *label4 = [[UILabel alloc] initWithFrame:CGRectMake(posx + 10, posy + 5, innerView.frame.size.width - 20, 30)];
        label4.text = @"数据更新于：";
        [label4 setFont:[UIFont systemFontOfSize:15]];
        label4.textColor = [UIColor blackColor];
        [card addSubview:label4];

        posy += 30;
        
        UILabel *label5 = [[UILabel alloc] initWithFrame:CGRectMake(posx + 10, posy + 5, innerView.frame.size.width/2 - 20, 30)];
        label5.text = date;
        [label5 setFont:[UIFont systemFontOfSize:15]];
        label5.textColor = [UIColor blackColor];
        [card addSubview:label5];

        posx += card.frame.size.width/2;
        UILabel *label6 = [[UILabel alloc] initWithFrame:CGRectMake(posx + 10, posy + 5, innerView.frame.size.width/2 - 20, 30)];
        label6.text = updateTime;
        [label6 setFont:[UIFont systemFontOfSize:14]];
        label6.textColor = [UIColor blackColor];
        [card addSubview:label6];

        UIButton *deleteCard = [[UIButton alloc] initWithFrame:CGRectMake(card.frame.origin.x - 7 , card.frame.origin.y-12, 30, 30)];
        UIButton *flipCard = [[UIButton alloc] initWithFrame:CGRectMake(card.frame.origin.x + card.frame.size.width - 25-5-2-5, card.frame.origin.y-12, 27, 30)];
        [flipCard setImage:[UIImage imageNamed:@"reverse.png"] forState:UIControlStateNormal];
        [flipCard addTarget:self action:@selector(reverseCard:) forControlEvents:UIControlEventTouchUpInside];
        flipCard.tag = i;
        [deleteCard setBackgroundImage:[UIImage imageNamed:@"chahao.png"] forState:UIControlStateNormal];
        deleteCard.showsTouchWhenHighlighted = YES;
        [card addSubview:deleteCard];
        [card addSubview:flipCard];
        
        
        flipCard = [[UIButton alloc] initWithFrame:CGRectMake(card.frame.origin.x + card.frame.size.width - 25-5-2-5, card.frame.origin.y-12, 27, 30)];
        [flipCard setImage:[UIImage imageNamed:@"reverse.png"] forState:UIControlStateNormal];
        [flipCard addTarget:self action:@selector(reverseCard2:) forControlEvents:UIControlEventTouchUpInside];
        flipCard.tag = i;
        [reverseView addSubview:flipCard];
        
        deleteCard.tag = i;
        [deleteCard addTarget:self action:@selector(delCard:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    [singleCityForecastView addSubview:self.cityNanageBtn];
    singleCityForecastView.scrollView.contentSize = CGSizeMake(cardSize.width * self.suscriptions.count, cardSize.height);
    
    
    }
}
- (void)reverseCard:(UIButton *)bnt
{
    [ReversePageAnimation transitformShowView:self.cardViews[bnt.tag] hiddenView:self.reverseCardViews[bnt.tag]];
    UIView *v1 = self.cardViews[bnt.tag];
    v1.hidden = YES;
    UIView *v2 = self.reverseCardViews[bnt.tag];
    v2.hidden = NO;
}
- (void)reverseCard2:(UIButton *)bnt
{
    [ReversePageAnimation transitformShowView:self.reverseCardViews[bnt.tag] hiddenView:self.cardViews[bnt.tag]];
    UIView *v1 = self.cardViews[bnt.tag];
       v1.hidden = NO;
       UIView *v2 = self.reverseCardViews[bnt.tag];
       v2.hidden = YES;
}
-(void)delCard:(UIButton*)bnt
{
    if(bnt.tag == self.suscriptions.count-1)
    {
        NSLog(@"inIN");
         [self.suscriptions removeObjectAtIndex:bnt.tag];
          [self.cardColor removeObjectAtIndex:bnt.tag];
          __block int width = 0;
          __block UIView *card = self.cardViews[bnt.tag];
          int posx = self.scrollView.scrollView.contentOffset.x;
          int posy = self.scrollView.scrollView.contentOffset.y;
          [UIView animateWithDuration:0.3 animations:^{
              card.alpha = 0.1;
              width = card.frame.size.width;
              for(int i=0;i<bnt.tag;i++)
              {
                  UIView *nxtCards = _cardViews[i];
                  nxtCards.frame = CGRectMake(nxtCards.frame.origin.x + 270, nxtCards.frame.origin.y, nxtCards.frame.size.width, nxtCards.frame.size.height);
                  
              }
         //     [self.view layoutSubviews];
              

          } completion:^(BOOL finished){
              self.scrollView.frame = CGRectMake(self.scrollView.frame.origin.x , self.scrollView.frame.origin.y, self.scrollView.frame.size.width- 270, self.scrollView.frame.size.height);
              card.alpha = 0;
              [card removeFromSuperview];
              [self viewDidLoad];
              if(bnt.tag!=self.suscriptions.count)
                  [self.scrollView.scrollView setContentOffset:CGPointMake(posx, posy)];
              else {
                  [self.scrollView.scrollView setContentOffset:CGPointMake(posx-270, posy)];
              }
          }];
        
        [self.cardViews removeObjectAtIndex:bnt.tag];
        [self.reverseCardViews removeObjectAtIndex:bnt.tag];
        return;
    }
    
    
   [self.suscriptions removeObjectAtIndex:bnt.tag];
    [self.cardColor removeObjectAtIndex:bnt.tag];
    __block int width = 0;
    __block UIView *card = self.cardViews[bnt.tag];
    int posx = self.scrollView.scrollView.contentOffset.x;
    int posy = self.scrollView.scrollView.contentOffset.y;
    [UIView animateWithDuration:0.3 animations:^{
        card.alpha = 0.1;
        width = card.frame.size.width;
        for(int i=bnt.tag+1;i<_cardViews.count;i++)
        {
            UIView *nxtCards = _cardViews[i];
            nxtCards.frame = CGRectMake(nxtCards.frame.origin.x - 270, nxtCards.frame.origin.y, nxtCards.frame.size.width, nxtCards.frame.size.height);
            
        }
        

    } completion:^(BOOL finished){
        self.scrollView.frame = CGRectMake(self.scrollView.frame.origin.x , self.scrollView.frame.origin.y, self.scrollView.frame.size.width- 270, self.scrollView.frame.size.height);
        card.alpha = 0;
        [card removeFromSuperview];
        
        [self viewDidLoad];
        if(bnt.tag!=self.suscriptions.count)
            [self.scrollView.scrollView setContentOffset:CGPointMake(posx, posy)];
        else {
            [self.scrollView.scrollView setContentOffset:CGPointMake(posx-270, posy)];
        }
    }];

    [self.cardViews removeObjectAtIndex:bnt.tag];
    [self.reverseCardViews removeObjectAtIndex:bnt.tag];
}

//离开视图前保存订阅的天气数据
-(void)viewWillDisappear:(BOOL)animated{
//    [super viewWillDisappear:animated];
//    myApp *app = [myApp getInstance];
//    NSUserDefaults *defaut = [NSUserDefaults standardUserDefaults];
//    [defaut setObject:app.mySuscriptions forKey:@"mySuscriptions"];
}


- (void)goEditSuscription
{
    myApp *app = [myApp getInstance];
    CitySelectorViewcontroller *editVC = app.citySelectorViewController;
    if(editVC==nil){app.citySelectorViewController = editVC = [[CitySelectorViewcontroller alloc] init];
    }
    //[self.navigationController pushViewController:editVC animated:YES];
    [self presentViewController:editVC animated:YES completion:^{
        
    }];
}

- (UIColor *)randomColor
{
    CGFloat randomR = drand48();
    CGFloat randomG = drand48();
    CGFloat randomB = drand48();
    return [UIColor colorWithRed:randomR green:randomG blue:randomB alpha:1];
}

- (void)refreshAnimation:(UIButton *)btn;
{
    NSLog(@"clicked");
    [btn reloadInputViews];
    [UIView animateWithDuration:1 animations:^{
        btn.transform = CGAffineTransformMakeRotation(M_PI);
    } completion:^(BOOL finished){btn.alpha = 0;}];

}

@end
