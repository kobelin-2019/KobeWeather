//
//  CitySelectorViewcontroller.m
//  KobeWeatherReport
//
//  Created by kobelin on 2019/12/9.
//  Copyright © 2019 kobelin. All rights reserved.
//

#import "CitySelectorViewController.h"
#import "myApp.h"
@interface CitySelectorViewcontroller ()<UISearchBarDelegate,UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
@property (nonatomic) BOOL isSearch;//判断是否在搜索
@property BOOL haveInitArr;
@property NSMutableArray *searhList;
@end


@implementation CitySelectorViewcontroller
- (id)init
{
    self = [super init];
   // if(self)
    return self;
}
- (NSString*)pinyin:(NSString *)ss
{
    if (ss == nil || ss.length == 0) {
        return @"";
    }
    ss = [ss substringToIndex:2];
    NSMutableString *result = [NSMutableString stringWithString:ss];
    //先转换为带声调的拼音
    CFStringTransform((CFMutableStringRef)result,NULL, kCFStringTransformMandarinLatin,NO);
    //再转换为不带声调的拼音
    CFStringTransform((CFMutableStringRef)result,NULL, kCFStringTransformStripDiacritics,NO);
    return [result uppercaseString];
}
- (int)toint:(char)ch
{
   // NSLog(@"%c",ch);
    if(ch == 'A')return 0;
    if(ch == 'B')return 1;
    if(ch == 'C')return 2;
    if(ch == 'D')return 3;
    if(ch == 'E')return 4;
    if(ch == 'F')return 5;
    if(ch == 'G')return 6;
    if(ch == 'H')return 7;
    if(ch == 'I')return 8;
    if(ch == 'J')return 9;
    if(ch == 'K')return 10;
    if(ch == 'L')return 11;
    if(ch == 'M')return 12;
    if(ch == 'N')return 13;
    if(ch == 'O')return 14;
    if(ch == 'P')return 15;
    if(ch == 'Q')return 16;
    if(ch == 'R')return 17;
    if(ch == 'S')return 18;
    if(ch == 'T')return 19;
    if(ch == 'U')return 20;
    if(ch == 'V')return 21;
    if(ch == 'W')return 22;
    if(ch == 'X')return 23;
    if(ch == 'Y')return 24;
    if(ch == 'Z')return 25;
    return -1;
}
- (void)initSearchList{
    int posx = self.view.frame.size.width - 50;
    int  posy = 60;
    int gap = self.view.frame.size.height - 120;
    gap /= 26;
    NSArray *str = @[@"A",@"B",@"C",@"D",@"E",@"F",@"G",@"H",@"I",@"J",@"K",@"L",
                            @"M",@"N",@"O",@"P",@"Q",@"R",@"S",@"T",@"U",@"V",@"W",@"X",
                            @"Y",@"Z"];
    for(int i=0;i<26;i++)
    {
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(posx, posy, gap, gap)];
        posy += gap;
        [btn setBackgroundColor:[UIColor grayColor]];
        [btn setTitle:str[i] forState:UIControlStateNormal];
        [self.searhList insertObject:btn atIndex:i];
        
    }
    
}
- (void)domakeArr{
        NSLog(@"kobedsjafasfdsdf");
    NSDictionary *mySuscriptionsDictionary = [[NSUserDefaults standardUserDefaults] objectForKey:@"CityCodeMap"];
    
    self.arr = [[NSMutableArray alloc] init];
    
    static int ch[26][10005];
    int len[26];
    for(int i=0;i<26;i++)len[i] = 0;
    for(id key in mySuscriptionsDictionary)
    {
        [_arr insertObject:key atIndex:_arr.count];
        int ch1 = [self toint:([[self pinyin:key] characterAtIndex:0]) ];
        
   //     NSLog(@"%d",ch1);
     //   NSLog(@"%@",key);
       // NSLog(@"%d",cnt);
        if(ch1 == -1)continue;
        ch[ch1][len[ch1]] = _arr.count-1;
        len[ch1]++;
          //  char ch2 = [[self pinyin:key] characterAtIndex:0];
    }
    
    NSMutableArray *newArray = [[NSMutableArray alloc] init];
        NSArray *str = @[@"A",@"B",@"C",@"D",@"E",@"F",@"G",@"H",@"I",@"J",@"K",@"L",
                         @"M",@"N",@"O",@"P",@"Q",@"R",@"S",@"T",@"U",@"V",@"W",@"X",
                         @"Y",@"Z"];
    for(int i=0;i<26;i++)
    {
        [newArray insertObject:str[i] atIndex:newArray.count];
        
        for(int j=0;j<len[i];j++)
        {
           // NSLog(@"%@",_arr[ch[i][j]]);
            
            [newArray insertObject:_arr[ch[i][j]] atIndex:newArray.count];
        }
        
    }

    [_arr removeAllObjects];
    _arr = newArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    NSDictionary *mySuscriptionsDictionary = [[NSUserDefaults standardUserDefaults] objectForKey:@"CityCodeMap"];
    self.view.backgroundColor = [UIColor clearColor];
    
    [self domakeArr];
    [self initSearchList];
    self.haveInitArr = YES;
   
    _searchBar = [[MiSearchBar alloc] initWithFrame:CGRectMake(0,  0, self.view.bounds.size.width, 40) placeholder:@"搜索"];
  //  NSLog(@"%d",self.navigationController.navigationBar.frame.size.height);
    _searchBar.delegate = self;
    _searchBar.tintColor = [UIColor clearColor];
    [self.view addSubview:_searchBar];
    

    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, self.searchBar.frame.origin.y+self.searchBar.frame.size.height, self.view.bounds.size.width, self.view.bounds.size.height-80) style:UITableViewStylePlain];
    _tableView.delegate  =self;
    _tableView.dataSource = self;
    _tableView.tableFooterView = [[UIView alloc] init];
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    UIImage *img = [UIImage imageNamed:@"background"];
    imgView.image = img;
    _tableView.backgroundView = imgView;
    _tableView.backgroundColor = [UIColor clearColor];
    for(int i=0;i<26;i++)
        [_tableView addSubview:self.searhList[i]];
    
    [self.view addSubview:_tableView];
    _resultArr = [[NSMutableArray alloc]init];
}



-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.isSearch) {
        return _resultArr.count ;
    }else{
        return _arr.count;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell==nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    if (self.isSearch) {
        cell.textLabel.text = _resultArr[indexPath.row];
    }else{
        cell.textLabel.text = _arr[indexPath.row];
    }
    cell.backgroundColor = [UIColor clearColor];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    myApp * app = [myApp getInstance];
    if(self.isSearch)
    {  if(_resultArr[indexPath.row]!=nil&&[_resultArr[indexPath.row] length]!=1)
        [app.mySuscriptions insertObject:app.cityCodeMap[_resultArr[indexPath.row]] atIndex:0];
    }
    else {
        if(_arr[indexPath.row]!=nil&&[_arr[indexPath.row] length]!=1)
            [app.mySuscriptions insertObject:app.cityCodeMap[_arr[indexPath.row]] atIndex:0];
    }
    [[self presentingViewController] viewDidLoad];
    [self dismissViewControllerAnimated:YES completion:^{
    }];
}

-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if (searchText.length == 0) {
        _searchText = @"";
        self.isSearch = NO;
        [self.tableView reloadData];
    }
    NSLog(@" --- %@",searchText);
    [_resultArr removeAllObjects];
    
    for (NSString *searchStr in _arr) {
        if ([searchStr rangeOfString:searchText].location != NSNotFound) {
            [_resultArr addObject:searchStr];
        }
    }
    if (_resultArr.count) {
        self.isSearch = YES;
        [self.tableView reloadData];
    }
}


-(BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    return YES;
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    self.isSearch = NO;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
    self.isSearch = NO;
    [self.tableView reloadData];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
