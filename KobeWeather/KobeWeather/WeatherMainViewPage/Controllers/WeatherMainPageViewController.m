//
//  WeatherMainPageViewController.m
//  KobeWeatherReport
//
//  Created by kobelin on 2019/12/9.
//  Copyright © 2019 kobelin. All rights reserved.
//

#import "WeatherMainPageViewController.h"
#import "CitySelectorViewcontroller.h"
#import "CityForecastScrollView.h"
#import "MyApp.h"
#import "WeatherInfoModel.h"
#import "JsonDecoder.h"
#import "ReversePageAnimation.h"
#import "UserDefaultStorageService.h"
#import "RandomColor.h"

#define ScreenHeight [UIScreen mainScreen].bounds.size.height
#define ScreenWidth [UIScreen mainScreen].bounds.size.width
#define CardWidth 270
#define CardHeight 360+120+50


/*
天气主页面：以卡片形式展示订阅的天气数据
 */

@interface WeatherMainPageViewController ()

@property (nonatomic, strong)CityForecastScrollView *scrollView;
@property (nonatomic, strong)WeatherInfoModel *weatherInfoModel;

@property (nonatomic, strong)UIButton *cityNanageBtn;
@property (nonatomic, strong)UIButton *refreshBtn;
@property (nonatomic, strong)NSMutableArray *reverseCardViews;
@property (nonatomic, retain)NSMutableArray *cardColor;
@property (nonatomic, retain)NSMutableArray *suscriptions;
@property (nonatomic, retain)NSMutableArray *cardViews;

@end

@implementation WeatherMainPageViewController

//初始化
- (id)init
{
    self = [super init];
    if(self)
    {
        [self viewDidLoad];
    }
    return self;
}

//视图即将出现时的设置
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIImageView *backGroundImageView = [[UIImageView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    UIImage *img = [UIImage imageNamed:@"background.jpg"];
    backGroundImageView.image = img;
    [self.view addSubview:backGroundImageView];
    
    self.cityNanageBtn = [[UIButton alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width - 40,30,27, 27)];
    [self.cityNanageBtn setImage:[UIImage imageNamed:@"addCity.png"] forState:UIControlStateNormal];
    [self.cityNanageBtn setImage:[UIImage imageNamed:@"addCity2.png"] forState:UIControlStateHighlighted];
    [self.cityNanageBtn setTitleColor:[UIColor yellowColor] forState:UIControlStateNormal];
    [self.cityNanageBtn addTarget:self action:@selector(goCitySelectorViewController) forControlEvents:UIControlEventTouchUpInside];
    [self loadWeatherCardViews];
    
    UserDefaultStorageService *userDefaultStorageService = [[UserDefaultStorageService alloc] init];
    [userDefaultStorageService saveUserDefaultConfig];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

//建立视图第一层子视图
- (void)setUpMainViewComponents
{
    const int TopGapHeight = 20;
    if(!self.cardColor)self.cardColor = [[NSMutableArray alloc] init];
    CGSize cardSize = CGSizeMake(CardWidth, CardHeight);
    CityForecastScrollView *cityForecastScrollView = [[CityForecastScrollView alloc] initWithFrame:CGRectMake(0, TopGapHeight, self.view.frame.size.width, self.view.frame.size.height - TopGapHeight)];
        [self.view addSubview:cityForecastScrollView];
        cityForecastScrollView.actualWidth = cardSize.width;
        cityForecastScrollView.actualHeight = cardSize.height;
    
    self.scrollView = cityForecastScrollView;
    self.cardViews = [[NSMutableArray alloc] init];
    self.reverseCardViews = [[NSMutableArray alloc]init];
}

//给卡片正面和反面添加button等组件
- (void)setUpCardElements:(UIView *)card ReverseView:(UIView *)reverseView CardNumber:(NSInteger)i
{
    UIButton *deleteCard = [[UIButton alloc] initWithFrame:CGRectMake(card.frame.origin.x - 7 , card.frame.origin.y-12, 30, 30)];
    UIButton *flipCard = [[UIButton alloc] initWithFrame:CGRectMake(card.frame.origin.x + card.frame.size.width - 25-5-2-5, card.frame.origin.y-12, 26, 26)];
    [flipCard setImage:[UIImage imageNamed:@"reverse.png"] forState:UIControlStateNormal];
    [flipCard addTarget:self action:@selector(reverseCard:) forControlEvents:UIControlEventTouchUpInside];
    flipCard.tag = i;
    [deleteCard setBackgroundImage:[UIImage imageNamed:@"chahao.png"] forState:UIControlStateNormal];
    deleteCard.showsTouchWhenHighlighted = YES;
    [card addSubview:deleteCard];
    [card addSubview:flipCard];
    
    flipCard = [[UIButton alloc] initWithFrame:CGRectMake(card.frame.origin.x + card.frame.size.width - 25-5-2-5, card.frame.origin.y-12, 26, 26)];
    [flipCard setImage:[UIImage imageNamed:@"reverse.png"] forState:UIControlStateNormal];
    [flipCard addTarget:self action:@selector(reverseCard2:) forControlEvents:UIControlEventTouchUpInside];
    flipCard.tag = i;
    [reverseView addSubview:flipCard];
    
    deleteCard.tag = i;
    [deleteCard addTarget:self action:@selector(delCard:) forControlEvents:UIControlEventTouchUpInside];
}

//根据天气数据绘制卡片反面的视图
- (void)setUpReverseForecastView:(UIView *)reverseView WeatherInfo:(WeatherInfoModel *)weatherInfoModel
{
    int forcastViewHeight = reverseView.frame.size.height - 30;
    int averageForecastViewHeight = (forcastViewHeight-30)/12.0;
    int posY = 40;
    for(int i=1; i < 13; i++)
    {
        NSDictionary *forecast = weatherInfoModel.forecast[i];
        NSString * date = forecast[@"date"];
        date = [date stringByAppendingString:@"日"];
        NSString *highest = forecast[@"high"];
        NSString *lowest = forecast[@"low"];
        NSString *type = forecast[@"type"];
        int ww = reverseView.frame.size.width/5;
        int posX = 0;
        UILabel *dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(posX, posY, ww, averageForecastViewHeight)];
        posX += ww;
        dateLabel.text = date;
        dateLabel.adjustsFontSizeToFitWidth = YES;
        dateLabel.textColor = [UIColor blackColor];
        
        UIImage *weatherIcon = [self getWeatherIconWithType:type];
        
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(posX, posY, ww, averageForecastViewHeight)];
        posX += ww;
        UIImage *img = weatherIcon;
        imgView.image = img;

        UILabel *highestLabel = [[UILabel alloc] initWithFrame:CGRectMake(posX, posY, ww, averageForecastViewHeight)];
        posX += ww;
        highestLabel.text = highest;
        highestLabel.adjustsFontSizeToFitWidth = YES;
        highestLabel.textColor = [UIColor blackColor];
        
        UILabel *lowestLabel = [[UILabel alloc] initWithFrame:CGRectMake(posX, posY, ww, averageForecastViewHeight)];
        posX += ww;
        lowestLabel.text = lowest;
        lowestLabel.adjustsFontSizeToFitWidth = YES;
        lowestLabel.textColor = [UIColor blackColor];
        
        UILabel *typeLabel = [[UILabel alloc] initWithFrame:CGRectMake(posX, posY, ww, averageForecastViewHeight)];
        posX += ww;
        typeLabel.text = type;
        typeLabel.adjustsFontSizeToFitWidth = YES;
        typeLabel.textColor = [UIColor blackColor];
      
        [reverseView addSubview:dateLabel];
        [reverseView addSubview:highestLabel];
        [reverseView addSubview:lowestLabel];
        [reverseView addSubview:typeLabel];
        [reverseView addSubview:imgView];
        posY += averageForecastViewHeight;
    }
}

//获取天气类型对应的图标
- (UIImage *)getWeatherIconWithType:(NSString *)type
{
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
    else {
        weatherIcon = [UIImage imageNamed:@"1.png"];
    }
    return weatherIcon;
}


//加载天气数据，绘制卡片
- (void)loadWeatherCardViews
{
    MyApp *app = [MyApp sharedInstance];
    self.suscriptions = app.mySuscriptions;

    [self setUpMainViewComponents];
    CityForecastScrollView *cityForecastScrollView = self.scrollView;
    NSInteger cardCount = self.suscriptions.count;
    CGSize cardSize = CGSizeMake(CardWidth, CardHeight);
    
    for (int i = 0; i < cardCount; i++)
    {
        @autoreleasepool
        {
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(i * cardSize.width, 0, cardSize.width, cardSize.height)];
            
            self.refreshBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.view.bounds.size.width/2 - 10,55 , 20, 20)];
            [self.refreshBtn setImage:[UIImage imageNamed:@"shuaxin.png"] forState:UIControlStateNormal];
            [self.refreshBtn addTarget:self action:@selector(refreshAnimation:) forControlEvents:UIControlEventTouchUpInside];
            [self.view addSubview:self.refreshBtn];
            
            UIView *card = [[UIView alloc] initWithFrame:CGRectInset(view.bounds, 10, 10)];
            card.layer.cornerRadius = self.suscriptions.count;
            card.layer.masksToBounds = YES;
            if(i < _cardColor.count)
            {
                card.backgroundColor = _cardColor[i];
            }
            else
            {
                card.backgroundColor = [[RandomColor randomColor]colorWithAlphaComponent:0.4f];
                [_cardColor addObject:card.backgroundColor];
            }
            
            UIView *reverseView = [[UIView alloc] initWithFrame:card.frame];
            reverseView.backgroundColor = card.backgroundColor;

            [self.cardViews addObject:card];
            [self.reverseCardViews addObject:reverseView];
            reverseView.hidden = YES;
            [view addSubview:reverseView];
            [view addSubview:card];
            [cityForecastScrollView.scrollView addSubview:view];
           
            WeatherInfoModel *weatherInfoModel = [[WeatherInfoModel alloc] init];
            weatherInfoModel = [JsonDecoder decodeJson:app.codeToCityMap[self.suscriptions[i]]];
            
            UIView *innerView = [[UIView alloc] initWithFrame:CGRectInset(card.bounds, 10, 10)];
            [self setUpReverseForecastView:reverseView WeatherInfo:weatherInfoModel];
            [self setUpCardInnerView:weatherInfoModel CardView:card InnerView:innerView];
            [self setUpCardElements:card ReverseView:reverseView CardNumber:i];
        }
    }
    [cityForecastScrollView addSubview:self.cityNanageBtn];
    cityForecastScrollView.scrollView.contentSize = CGSizeMake(cardSize.width * self.suscriptions.count, cardSize.height);
    
}

//从正面翻转天气卡片到反面
- (void)reverseCard:(UIButton *)button
{
    [ReversePageAnimation transitformShowView:self.cardViews[button.tag] hiddenView:self.reverseCardViews[button.tag]];
    UIView *view1 = self.cardViews[button.tag];
    view1.hidden = YES;
    UIView *view2 = self.reverseCardViews[button.tag];
    view2.hidden = NO;
}

//从反面翻转天气卡片到正面
- (void)reverseCard2:(UIButton *)button
{
    [ReversePageAnimation transitformShowView:self.reverseCardViews[button.tag] hiddenView:self.cardViews[button.tag]];
    UIView *view1 = self.cardViews[button.tag];
    view1.hidden = NO;
    UIView *view2 = self.reverseCardViews[button.tag];
    view2.hidden = YES;
}

//删除一张天气卡片
-(void)delCard:(UIButton*)button
{
    [self.suscriptions removeObjectAtIndex:button.tag];
    [self.cardColor removeObjectAtIndex:button.tag];
    UIView *card = self.cardViews[button.tag];
    int posX = self.scrollView.scrollView.contentOffset.x;
    int posY = self.scrollView.scrollView.contentOffset.y;
    [UIView animateWithDuration:0.3 animations:^{
        int width = 0;
        card.alpha = 0.1;
        width = card.frame.size.width;
        //如果要删除的是最后一张，则scrollView往右移动
        if(button.tag == self.suscriptions.count)
        {
            for(int i=0;i<button.tag;i++)
            {
            UIView *nxtCards = self.cardViews[i];
            nxtCards.frame = CGRectMake(nxtCards.frame.origin.x + 270, nxtCards.frame.origin.y, nxtCards.frame.size.width, nxtCards.frame.size.height);
            }
        }
        else//否则scrollView向左移动
        {
            for(int i=(int)button.tag+1;i<self.cardViews.count;i++)
            {
                UIView *nxtCards = self.cardViews[i];
                nxtCards.frame = CGRectMake(nxtCards.frame.origin.x - 270, nxtCards.frame.origin.y, nxtCards.frame.size.width, nxtCards.frame.size.height);
                
            }
        }
    } completion:^(BOOL finished){
        self.scrollView.frame = CGRectMake(self.scrollView.frame.origin.x , self.scrollView.frame.origin.y, self.scrollView.frame.size.width- 270, self.scrollView.frame.size.height);
        card.alpha = 0;
        [card removeFromSuperview];
        [self viewDidLoad];
        if(button.tag!=self.suscriptions.count)
        [self.scrollView.scrollView setContentOffset:CGPointMake(posX, posY)];
        else {
        [self.scrollView.scrollView setContentOffset:CGPointMake(posX-270, posY)];
        }
    }];

    [self.cardViews removeObjectAtIndex:button.tag];
    [self.reverseCardViews removeObjectAtIndex:button.tag];
}

//根据天气数据模型在卡片上显示数据
- (void)setUpCardInnerView:(WeatherInfoModel *)weatherInfoModel CardView:(UIView *)card InnerView:(UIView *)innerView
{
    NSString *date = weatherInfoModel.date ? weatherInfoModel.date : @"";
    NSString *cityName = weatherInfoModel.cityName ? weatherInfoModel.cityName : @"";
    NSString *updateTime = weatherInfoModel.updateTime ? weatherInfoModel.updateTime : @"";
    NSString *temperature = weatherInfoModel.temperature ? weatherInfoModel.temperature : @"";
    NSString *highest = weatherInfoModel.highest ? weatherInfoModel.highest : @"";
    NSString *lowest = weatherInfoModel.lowest ? weatherInfoModel.lowest : @"";
    NSString *type = weatherInfoModel.type ? weatherInfoModel.type : @"";
    NSString *notice = weatherInfoModel.notice ? weatherInfoModel.notice : @"";
    
    int posX = innerView.frame.origin.x;
    int posY = innerView.frame.origin.y;
    UILabel *labelCityName = [[UILabel alloc] initWithFrame:CGRectMake(posX + 10, posY + 5+50, card.frame.size.width/2 - 20, 30)];
    labelCityName.text = cityName;
    [labelCityName setFont:[UIFont systemFontOfSize:25]];
    labelCityName.adjustsFontSizeToFitWidth = YES;
    labelCityName.textColor = [UIColor blackColor];
    [card addSubview:labelCityName];
    
    UILabel *labelType = [[UILabel alloc] initWithFrame:CGRectMake(posX + 10 + card.frame.size.width/2, posY+5+50,card.frame.size.width/2 -20 , 30)];
    labelType.text = type;
    [labelType setFont:[UIFont systemFontOfSize:25]];
    labelType.textColor = [UIColor blackColor];
    [card addSubview:labelType];
    
    posY += 50;
    UILabel *labeltemperature = [[UILabel alloc] initWithFrame:CGRectMake(posX + 10 + 20, posY + 5, card.frame.size.width/2 , card.frame.size.height - 350)];
    labeltemperature.text = temperature;
    [labeltemperature setFont:[UIFont systemFontOfSize:70]];
    labeltemperature.adjustsFontSizeToFitWidth = YES;
    labeltemperature.textColor = [UIColor blackColor];
    [card addSubview:labeltemperature];

    UILabel *labelCircleIcon = [[UILabel alloc] initWithFrame:CGRectMake(posX + 10 + card.frame.size.width/2 - 15, posY + 5 - 17, card.frame.size.width/2 - 20, card.frame.size.height - 400)];
    labelCircleIcon.text = @"。";
    [labelCircleIcon setFont:[UIFont systemFontOfSize:40]];
    labelCircleIcon.textColor = [UIColor blackColor];
    [card addSubview:labelCircleIcon];

    UILabel *labelTemperatureSign = [[UILabel alloc] initWithFrame:CGRectMake(posX + 10 + card.frame.size.width/2, posY + 5, card.frame.size.width/2 - 20, card.frame.size.height - 380)];
    labelTemperatureSign.text = @"C";
    [labelTemperatureSign setFont:[UIFont systemFontOfSize:40]];
    labelTemperatureSign.textColor = [UIColor blackColor];
    [card addSubview:labelTemperatureSign];

    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(posX+40, labelTemperatureSign.frame.origin.y + labelTemperatureSign.frame.size.height , card.frame.size.width - 2*(posX +40) , 120)];
    [card addSubview:imgView];
    UIImage *weatherIcon = nil;
    weatherIcon = [self getWeatherIconWithType:type];
    imgView.image = weatherIcon;

    posY += card.frame.size.height -350 + 150;
    UILabel *lowestLabel = [[UILabel alloc] initWithFrame:CGRectMake(posX + 10 , posY + 5, card.frame.size.width/2 - 20, 40)];
    lowestLabel.text = lowest;
    [lowestLabel setFont:[UIFont systemFontOfSize:15]];
    lowestLabel.adjustsFontSizeToFitWidth = YES;
    lowestLabel.textColor = [UIColor blackColor];
    [card addSubview:lowestLabel];
    
    UILabel *highestLabel = [[UILabel alloc] initWithFrame:CGRectMake(posX + 10 + card.frame.size.width/2, posY + 5, card.frame.size.width/2 - 20, 40)];
    highestLabel.text = highest;
    [highestLabel setFont:[UIFont systemFontOfSize:15]];
    highestLabel.adjustsFontSizeToFitWidth = YES;
    highestLabel.textColor = [UIColor blackColor];
    [card addSubview:highestLabel];
    
    posY =card.frame.origin.y + card.frame.size.height - 180;
    UILabel *noticeLabel = [[UILabel alloc] initWithFrame:CGRectMake(posX + 10, posY + 5, card.frame.size.width - 10, 30)];
    noticeLabel.text = notice;
    [noticeLabel setFont:[UIFont systemFontOfSize:16]];
    noticeLabel.adjustsFontSizeToFitWidth = YES;
    noticeLabel.textColor = [UIColor blackColor];
    [card addSubview:noticeLabel];
    
    posY = card.frame.origin.y + card.frame.size.height - 90;

    UILabel *updateTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(posX + 10, posY + 5, card.frame.size.width - 20, 30)];
    updateTimeLabel.text = @"数据更新于：";
    [updateTimeLabel setFont:[UIFont systemFontOfSize:15]];
    updateTimeLabel.textColor = [UIColor blackColor];
    [card addSubview:updateTimeLabel];

    posY += 30;
    UILabel *dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(posX + 10, posY + 5, card.frame.size.width/2 - 20, 30)];
    dateLabel.text = date;
    [dateLabel setFont:[UIFont systemFontOfSize:15]];
    dateLabel.textColor = [UIColor blackColor];
    [card addSubview:dateLabel];

    posX += card.frame.size.width/2;
    UILabel *label6 = [[UILabel alloc] initWithFrame:CGRectMake(posX + 10, posY + 5, card.frame.size.width/2 - 20, 30)];
    label6.text = updateTime;
    [label6 setFont:[UIFont systemFontOfSize:14]];
    label6.textColor = [UIColor blackColor];
    [card addSubview:label6];
    
}

- (void)viewWillDisappear:(BOOL)animated
{

}

//跳转到城市选择页面
- (void)goCitySelectorViewController
{
    MyApp *app = [MyApp sharedInstance];
    CitySelectorViewcontroller *editVC = app.citySelectorViewController;
    if(!editVC)
    {
    app.citySelectorViewController = editVC = [[CitySelectorViewcontroller alloc] init];
    }

    [self presentViewController:editVC animated:YES completion:^{}];
}

//刷新动画
- (void)refreshAnimation:(UIButton *)btn;
{
    [btn reloadInputViews];
    [UIView animateWithDuration:1 animations:^{
        btn.transform = CGAffineTransformMakeRotation(M_PI);
    } completion:^(BOOL finished){btn.alpha = 0;}];

}

@end
