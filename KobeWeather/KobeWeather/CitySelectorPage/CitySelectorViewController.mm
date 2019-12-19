//
//  CitySelectorViewcontroller.m
//  KobeWeatherReport
//
//  Created by kobelin on 2019/12/9.
//  Copyright © 2019 kobelin. All rights reserved.
//

#import "CitySelectorViewController.h"
#import "MyApp.h"

#define ScreenHeight [UIScreen mainScreen].bounds.size.height
#define ScreenWidth [UIScreen mainScreen].bounds.size.width
#define MAXSizeOfOneSection 10005
#define CellHeight 44
#define SearchBarHeight 40
#define CharacterNumber 26

@interface CitySelectorViewcontroller()<UISearchBarDelegate,
    UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>

@property (nonatomic ,strong) MiSearchBar *searchBar;
@property (nonatomic ,strong) NSString *searchText;
@property (nonatomic ,retain) UITableView *tableView;
@property (nonatomic ,retain) NSMutableArray *arr;
@property (nonatomic ,retain) NSMutableArray *resultArr;
@property (nonatomic ,assign) BOOL isSearch;//判断是否在搜索
@property (nonatomic ,retain) NSMutableArray *tableViewOffSetArray;

@end

@implementation CitySelectorViewcontroller

#pragma mark - 一些初始化工作

- (id)init
{
    self = [super init];
    if(self)
    {
        self.view.backgroundColor = [UIColor clearColor];
        _tableViewOffSetArray = [[NSMutableArray alloc] init];
        [self domakeArr];
    
        _searchBar = [[MiSearchBar alloc] initWithFrame:CGRectMake(0,  0, self.view.bounds.size.width, SearchBarHeight) placeholder:@"搜索"];
        _searchBar.delegate = self;
        _searchBar.tintColor = [UIColor clearColor];
        [self.view addSubview:_searchBar];
        
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, self.searchBar.frame.origin.y+self.searchBar.frame.size.height, self.view.bounds.size.width, self.view.bounds.size.height-SearchBarHeight) style:UITableViewStylePlain];
        _tableView.delegate  =self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [[UIView alloc] init];
        
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:self.view.bounds];
        UIImage *img = [UIImage imageNamed:@"background"];
        imgView.image = img;
        
        _tableView.backgroundView = imgView;
        _tableView.backgroundColor = [UIColor clearColor];
        
        [self.view addSubview:_tableView];
        _resultArr = [[NSMutableArray alloc]init];
        
        CGFloat startHeight = ScreenHeight / 7.0;
        CGFloat endHeight = ScreenHeight - startHeight;
        CGFloat averageHeight = (endHeight - startHeight)/26.0;
        CGFloat posX = ScreenWidth - 25;
        CGFloat posY = startHeight;
        NSArray *str = @[@"A",@"B",@"C",@"D",@"E",@"F",@"G",@"H",@"I",@"J",@"K",@"L",
        @"M",@"N",@"O",@"P",@"Q",@"R",@"S",@"T",@"U",@"V",@"W",@"X",
        @"Y",@"Z"];
        for (int i = 0; i < 26 ; ++i) {
            UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(posX, posY, 25, averageHeight)];
            posY += averageHeight;
            [btn setTitle:str[i] forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            btn.titleLabel.font = [UIFont systemFontOfSize: 12.0];
            [self.view addSubview:btn];
            btn.tag = i;
            [btn addTarget:self action:@selector(jumpToTableViewOffSet:) forControlEvents:UIControlEventTouchUpInside];
        }
        
         
    }
    return self;
}

- (void)jumpToTableViewOffSet:(UIButton *)button
{
    NSNumber *number = self.tableViewOffSetArray[button.tag];
    CGPoint offSet = CGPointMake(0, 1.0*number.floatValue);
    [self.tableView setContentOffset:offSet];
}

- (void)domakeArr
{
    NSDictionary *mySuscriptionsDictionary = [[NSUserDefaults standardUserDefaults] objectForKey:@"cityToCodeMap"];
    self.arr = [[NSMutableArray alloc] init];
    
    static int ch[CharacterNumber][MAXSizeOfOneSection];
    int len[CharacterNumber];
    for(int i = 0; i < CharacterNumber; i++)len[i] = 0;
    for(id key in mySuscriptionsDictionary)
    {
        [_arr insertObject:key atIndex:_arr.count];
        int ch1 = [self toint:([[self pinyin:key] characterAtIndex:0]) ];
        if(ch1 == -1)continue;
        ch[ch1][len[ch1]] = (int)_arr.count - 1;
        len[ch1]++;
    }
    
    NSMutableArray *newArray = [[NSMutableArray alloc] init];
    NSArray *str = @[@"A",@"B",@"C",@"D",@"E",@"F",@"G",@"H",@"I",@"J",@"K",@"L",
                    @"M",@"N",@"O",@"P",@"Q",@"R",@"S",@"T",@"U",@"V",@"W",@"X",
                    @"Y",@"Z"];
    
    for(int i = 0; i < CharacterNumber; i++)
    {
        [newArray insertObject:str[i] atIndex:newArray.count];
        int num = ((int)newArray.count-1) * CellHeight;
        NSNumber *number = [NSNumber numberWithInt:num];
        [self.tableViewOffSetArray addObject:number];
        for(int j = 0; j < len[i]; j++)
        {
            [newArray insertObject:_arr[ch[i][j]] atIndex:newArray.count];
        }
        
    }

    _arr = newArray;
}

#pragma mark - 城市名拼音转化,方便排序

- (NSString*)pinyin:(NSString *)string
{
    if (string == nil || string.length == 0) {
        return @"";
    }
    NSMutableString *result = [NSMutableString stringWithString:string];
    
    //先转换为带声调的拼音
    CFStringTransform((CFMutableStringRef)result,NULL, kCFStringTransformMandarinLatin,NO);
    //再转换为不带声调的拼音
    CFStringTransform((CFMutableStringRef)result,NULL, kCFStringTransformStripDiacritics,NO);
    
    return [result uppercaseString];
}


- (int)toint:(char)ch
{
    if(ch >= 'A' && ch <= 'Z')
    {
        return ch - 'A';
    }
    else
    {
        return -1;
    }
}


- (void)viewDidLoad
{
    [super viewDidLoad];
}

#pragma mark - UITableViewDelegate,UITableViewDataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.isSearch)
    {
        return _resultArr.count ;
    }
    else
    {
        return _arr.count;
    }
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell==nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    if (self.isSearch)
    {
        cell.textLabel.text = _resultArr[indexPath.row];
    }
    else
    {
        cell.textLabel.text = _arr[indexPath.row];
    }
    cell.textLabel.textColor = [UIColor blackColor];
    cell.backgroundColor = [UIColor clearColor];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return CellHeight;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    MyApp * app = [MyApp sharedInstance];
    if(self.isSearch)
    {
        if(_resultArr[indexPath.row] != nil && [_resultArr[indexPath.row] length] != 1)
        {
            [app.mySuscriptions insertObject:app.cityToCodeMap[_resultArr[indexPath.row]] atIndex:0];
        }
    }
    else
    {
        if(_arr[indexPath.row] != nil && [_arr[indexPath.row] length] != 1)
        {
            [app.mySuscriptions insertObject:app.cityToCodeMap[_arr[indexPath.row]] atIndex:0];
        }
    }
    
    [[self presentingViewController] viewDidLoad];
    
    [self dismissViewControllerAnimated:YES completion:^{
    }];
}

#pragma mark - UISearchBarDelegate

-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if (searchText.length == 0)
    {
        _searchText = @"";
        self.isSearch = NO;
        [self.tableView reloadData];
    }
    [_resultArr removeAllObjects];
    
    for (NSString *searchStr in _arr)
    {
        if ([searchStr rangeOfString:searchText].location != NSNotFound)
        {
            [_resultArr addObject:searchStr];
        }
    }
    if (_resultArr.count)
    {
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

#pragma mark - UITextFieldDelegate

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
    self.isSearch = NO;
    [self.tableView reloadData];
}

@end
