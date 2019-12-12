//
//  SingleCityForecastViewController.m
//  KobeWeatherReport
//
//  Created by kobelin on 2019/12/9.
//  Copyright © 2019 kobelin. All rights reserved.
//

#import "SingleCityForecastViewController.h"
#import "SingleCityForecastView.h"
#import "EditSuscriptionsViewController.h"
#import "myApp.h"
#import "WeatherInfoGetter.h"
#import "CardView.h"
@interface SingleCityForecastViewController ()
@property UIButton *cityNanageBtn;
@property NSMutableArray *suscriptions;
@property WeatherInfoGetter *weatherInfoGetter;
@property SingleCityForecastView *scrollView;
@property NSMutableArray *cardViews;
@property UIButton *refreshBtn;
@end

@implementation SingleCityForecastViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.weatherInfoGetter = [[WeatherInfoGetter alloc]init];
    UIImageView *backGroundImageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    UIImage *img = [UIImage imageNamed:@"background.jpg"];
    backGroundImageView.image = img;
//    self.view = backGroundImageView;
    [self.view addSubview:backGroundImageView];
    NSInteger barHeight = self.navigationController.navigationBar.frame.size.height;
    self.cityNanageBtn = [[UIButton alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width - 45,barHeight+30,50 , 30)];
    [self.cityNanageBtn setTitle:@"添加" forState:UIControlStateNormal];
    [self.cityNanageBtn setTitleColor:[UIColor yellowColor] forState:UIControlStateNormal];
    [self.cityNanageBtn addTarget:self action:@selector(goEditSuscription) forControlEvents:UIControlEventTouchUpInside];
    [self loadWeatherData];
    // Do any additional setup after loading the view.
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadWeatherData {
    
    myApp *app = [myApp getInstance];
    self.suscriptions = app.mySuscriptions;

    
    CGSize cardSize = CGSizeMake(270, 360+120);
    NSInteger cardCount = self.suscriptions.count;
    SingleCityForecastView *singleCityForecastView = [[SingleCityForecastView alloc] initWithFrame:CGRectMake(0, 20, self.view.frame.size.width, self.view.frame.size.height - 20)];
    [self.view addSubview:singleCityForecastView];
    singleCityForecastView.actualWidth = cardSize.width;
    singleCityForecastView.actualHeight = cardSize.height;
    self.scrollView = singleCityForecastView;
    
    
    for (int i = 0; i < cardCount; i++) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(i * cardSize.width, 0, cardSize.width, cardSize.height)];
        

        self.refreshBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.view.bounds.size.width/2 - 10,self.navigationController.navigationBar.frame.size.height+30+30 , 20, 20)];
        [self.refreshBtn setImage:[UIImage imageNamed:@"shuaxin.png"] forState:UIControlStateNormal];
        [self.refreshBtn addTarget:self action:@selector(refreshAnimation:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:self.refreshBtn];
        
        
        UIView *card = [[UIView alloc] initWithFrame:CGRectInset(view.bounds, 10, 10)];
        card.layer.cornerRadius = self.suscriptions.count;
        card.layer.masksToBounds = YES;
        card.backgroundColor = [[self randomColor]colorWithAlphaComponent:0.4f];
        [self.cardViews addObject:card];
        [view addSubview:card];
        [singleCityForecastView.scrollView addSubview:view];
        
        //利用网络获取到的天气数据加载到视图卡片中,（解析json数据）
        NSMutableDictionary *weatherInfoDictionary = [self.weatherInfoGetter getWeatherInfo:self.suscriptions[i]];
       
        
        NSDictionary *cityinfo = weatherInfoDictionary[@"cityInfo"];
        NSDictionary *weatherdata = weatherInfoDictionary[@"data"];
        
       /*
        forecast":[{"date":"10","high":"高温 19℃","low":"低温 11℃","ymd":"2019-12-10","week":"星期二","sunrise":"06:25","sunset":"17:06","aqi":39,"fx":"无持续风向","fl":"<3级","type":"晴","notice":"愿你拥有比阳光明媚的心情"}
        */
        
       
        
        
        NSString *date = weatherInfoDictionary[@"date"];
        NSString *cityName = cityinfo[@"city"];
        NSString *updateTime = cityinfo[@"updateTime"];
        NSString *shidu = weatherdata[@"shidu"];
        //float pm25 = weatherdata[@"pm25"];
        NSString *temperature = weatherdata[@"wendu"];
        NSDictionary *forecastToday = weatherdata[@"forecast"][0];
        NSString *highest = forecastToday[@"high"];
        NSString *lowest = forecastToday[@"low"];
        NSString *type = forecastToday[@"type"];
        NSString *notice = forecastToday[@"notice"];
        
        
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
        
        int posx = innerView.frame.origin.x;
        int posy = innerView.frame.origin.y;
        UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(posx + 10, posy + 5, innerView.frame.size.width/2 - 20, 30)];
        label1.text = cityName;
        [label1 setFont:[UIFont systemFontOfSize:25]];
        label1.textColor = [UIColor blackColor];
        [card addSubview:label1];
        
        label1 = [[UILabel alloc] initWithFrame:CGRectMake(posx + 10 + card.frame.size.width/2, posy+5,innerView.frame.size.width/2 -20 , 30)];
        label1.text = type;
        [label1 setFont:[UIFont systemFontOfSize:25]];
        label1.textColor = [UIColor blackColor];
        [card addSubview:label1];
        
        
        
        posy += 50;
        UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(posx + 10 + 20, posy + 5, innerView.frame.size.width/2 , card.frame.size.height - 350)];
        label2.text = temperature;
        [label2 setFont:[UIFont systemFontOfSize:70]];
        label2.textColor = [UIColor blackColor];
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
        imgView.image = weatherIcon;

        
        posy += card.frame.size.height -350 + 150;
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(posx + 10 , posy + 5, innerView.frame.size.width/2 - 20, 40)];
        label.text = lowest;
        label.textColor = [UIColor blackColor];
        [label setFont:[UIFont systemFontOfSize:15]];
        [card addSubview:label];
        
        
        label = [[UILabel alloc] initWithFrame:CGRectMake(posx + 10 + card.frame.size.width/2, posy + 5, innerView.frame.size.width/2 - 20, 40)];
        label.text = highest;
        label.textColor = [UIColor blackColor];
        [label setFont:[UIFont systemFontOfSize:15]];
        [card addSubview:label];
        

       
        posy =card.frame.origin.y + card.frame.size.height - 180;
        UILabel *noticeLabel = [[UILabel alloc] initWithFrame:CGRectMake(posx + 10, posy + 5, innerView.frame.size.width - 10, 30)];
        noticeLabel.text = notice;
        [noticeLabel setFont:[UIFont systemFontOfSize:16]];
        noticeLabel.textColor = [UIColor blackColor];
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

        UIButton *deleteCard = [[UIButton alloc] initWithFrame:CGRectMake(card.frame.origin.x + card.frame.size.width - 25-5-2-5, card.frame.origin.y-12, 25, 25)];
        
        
        [deleteCard setBackgroundImage:[UIImage imageNamed:@"delete.png"] forState:UIControlStateNormal];
        deleteCard.showsTouchWhenHighlighted = YES;
        [card addSubview:deleteCard];
        
        deleteCard.tag = i;
        [deleteCard addTarget:self action:@selector(delCard:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    [singleCityForecastView addSubview:self.cityNanageBtn];
    singleCityForecastView.scrollView.contentSize = CGSizeMake(cardSize.width * self.suscriptions.count, cardSize.height);
    
}

-(void)delCard:(UIButton*)bnt
{
   [self.suscriptions removeObjectAtIndex:bnt.tag];
    [self viewDidLoad];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    myApp *app = [myApp getInstance];
    NSUserDefaults *defaut = [NSUserDefaults standardUserDefaults];
    [defaut setObject:app.mySuscriptions forKey:@"mySuscriptions"];
}


- (void)goEditSuscription
{
    myApp *app = [myApp getInstance];
    
    EditSuscriptionsViewController *editVC = app.editSuscriptionsViewController;
    if(editVC==nil)editVC = [[EditSuscriptionsViewController alloc] init];
    [self.navigationController pushViewController:editVC animated:YES];
    
}

- (UIColor *)randomColor {
    CGFloat randomR = drand48();
    CGFloat randomG = drand48();
    CGFloat randomB = drand48();
    return [UIColor colorWithRed:randomR green:randomG blue:randomB alpha:1];
}

- (void)refreshAnimation:(UIButton *)btn;
{
//    UIImageView *imgView = btn.imageView;
//    [UIView animateWithDuration:0.5 animations:^{
//        CGAffineTransform transform = CGAffineTransformMakeRotation(0.5 * 3.141526535f);
//        btn.transform = transform;
//    } completion:^(BOOL finished){
//        [self viewDidLoad];
//    }];
    NSLog(@"clicked");
    [btn reloadInputViews];
    [UIView animateWithDuration:1 animations:^{
               btn.transform = CGAffineTransformMakeRotation(M_PI);
    } completion:^(BOOL finished){}];

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
