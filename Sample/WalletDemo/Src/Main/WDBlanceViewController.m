//
//  WDBlanceViewController.m
//  WalletDemo
//
//  Created by liaofulin on 2018/3/26.
//  Copyright © 2018年 mbr. All rights reserved.
//

#import "WDBlanceViewController.h"
#import "WDBalanceCollectionCell.h"
#import "WDBalanceCollectionReusableView.h"
#import "WDBalanceDetailViewController.h"
#import "WDBalanceSingleDCViewController.h"
#import <MJRefresh/MJRefresh.h>
#import "WDHomeLeftMenuHandler.h"
#import <MBRWallet/MBRWWallet.h>
#import <MJExtension/MJExtension.h>

@interface WDBlanceViewController () <
UICollectionViewDelegate,
UICollectionViewDataSource,
UICollectionViewDelegateFlowLayout,
BalanceHeaderDelegate
>

@property (nonatomic, strong) UIView* emptyView;
@property (weak, nonatomic) IBOutlet UICollectionView *myCollection;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *myCollectionTopConstrain;
@property (strong,nonatomic) NSMutableArray<MBRWAccount*> *dataArray;

@property (nonatomic, strong) WDHomeLeftMenuHandler* menuHandler;

@end

@implementation WDBlanceViewController

#pragma mark - 页面初始化
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self setupNav];
    
    // 页面偏移量调整
    CGFloat topOffset = 64;
    if (@available(iOS 11.0, *)) {
        topOffset -= 24;
    }
    _myCollectionTopConstrain.constant = topOffset;
    [self setDataCollectionView];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear: YES];
    [self loadAccount];
}

// 导航栏
- (void)setupNav {
    [self setLeftBtnNomalImage:[UIImage imageNamed:@"menu_dark"] highlighted:nil];
    [self.navigationView setBackgroundColor:WDWhiteColor];
    [self setNavTitle:@"账户"];
}

// 设置coleectionview
-(void)setDataCollectionView {
    
    // 设置layout
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    int w = (int)(WDScreenW -60) / 3;
    layout.itemSize = CGSizeMake(w, 149);
    layout.minimumLineSpacing = 10;
    layout.minimumInteritemSpacing = 0;
    layout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
    _myCollection.collectionViewLayout = layout;
    
    // 注册view
    [_myCollection registerNib:[UINib nibWithNibName:@"WDBalanceCollectionCell" bundle:nil] forCellWithReuseIdentifier:@"WDBalanceCollectionCell"];
    [_myCollection registerNib:[UINib nibWithNibName:@"WDBalanceCollectionReusableView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"balanceHeader"];
    [_myCollection registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"footer"];
    
    // 刷新
    _myCollection.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadBalance)];
    
}

#pragma mark - collectionView delegate

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"WDBalanceCollectionCell";
    WDBalanceCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
    
    if (indexPath.section < self.dataArray.count) {
        MBRWAccount* acc = self.dataArray[indexPath.section];
        NSArray<MBRBgCoin*> *coins = [acc getCoinList];
        if (indexPath.row < coins.count) {
            MBRBgCoin *coin = coins[indexPath.row];
            [cell.iconImage sd_setImageWithURL:[NSURL URLWithString:coin.avatarUrl] placeholderImage:[UIImage imageNamed:@"coins_default"]];
            cell.nameLb.text = coin.abbr;
            cell.balanceLb.text = [self amountShowTextValue:coin];
        }
    }
    
    return cell;
    
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return _dataArray.count;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return CGSizeMake(WDScreenW, 50);
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
    return CGSizeMake(WDScreenW, 10);
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        WDBalanceCollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"balanceHeader" forIndexPath:indexPath];
        headerView.cindexPath = indexPath;
        [headerView setDelegate:(id<BalanceHeaderDelegate>)self];
        
        headerView.accountName.text = self.dataArray[indexPath.section].accountName;
        
        return headerView;
    }else if ([kind isEqualToString:UICollectionElementKindSectionFooter]){
        UICollectionReusableView *view = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"footer" forIndexPath:indexPath];
        [view setBackgroundColor:WDWhiteColor];
        return view;
    }else{
        return nil;
    }
    
}


-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    
    return self.dataArray[section].getCoinList.count;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSLog(@"section: %ld & itemIndex:%ld",indexPath.section, indexPath.row);

    UIStoryboard *board = [UIStoryboard storyboardWithName:@"Balance" bundle:nil];
    WDBalanceSingleDCViewController *WDSingleVC = [board instantiateViewControllerWithIdentifier:@"WDBalanceSingleDCViewController"];
    WDSingleVC.account = self.dataArray[indexPath.section];
    WDSingleVC.coin = [self.dataArray[indexPath.section] getCoinList][indexPath.row];
    [self.navigationController pushViewController:WDSingleVC animated:YES];
    
}

#pragma mark - BalanceHeaderDelegate
// 点击账户操作按钮
-(void)addDC:(UICollectionReusableView *)resuableView atIndexPath:(NSIndexPath *)indexPath {
    UIStoryboard *board = [UIStoryboard storyboardWithName:@"Balance" bundle:nil];
    WDBalanceDetailViewController *dtlVC = [board instantiateViewControllerWithIdentifier:@"WDBalanceDetailViewController"];
    dtlVC.account = _dataArray[indexPath.section];
    [self.navigationController pushViewController:dtlVC animated:YES];
}

#pragma mark - 数据操作
-(void)loadAccount {
    
    NSArray *mbrAccountArray = [MBRWWallet getAllAccount];
    self.dataArray = [NSMutableArray arrayWithArray:mbrAccountArray];
    [_myCollection reloadData];
    [_myCollection.mj_header endRefreshing];

    [self showEmptyView:self.dataArray.count < 1];
}

- (void)loadBalance {
    [MBRWWallet syncAllAccountBalance:^(BOOL success) {
        [self loadAccount];
    }];
}

#pragma mark - 账户列表为空view
- (void)showEmptyView:(BOOL)show {
    if (!self.emptyView) {
        // 创建view
        UIView *emptyView = [UIView new];
        emptyView.userInteractionEnabled = YES;
        self.emptyView = emptyView;
        
        UIButton *btn1 = [self btnWithImg:[UIImage imageNamed:@"create_dark"] title: @"新建账户"];
        UIButton *btn2 = [self btnWithImg:[UIImage imageNamed:@"import_dark"] title:@"导入账户"];
        btn1.tag = 1;
        btn2.tag = 2;
        [emptyView addSubview:btn1];
        [emptyView addSubview:btn2];
        [btn1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(emptyView);
            make.height.mas_equalTo(30);
            make.width.mas_equalTo(100);
            make.top.equalTo(emptyView).offset(30);
        }];
        [btn2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.height.equalTo(btn1);
            make.top.equalTo(btn1.mas_bottom).offset(30);
        }];
    }

    if (show) {
        // 显示
        if (!self.emptyView.superview) {
            [self.view addSubview:self.emptyView];
            [self.emptyView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(_myCollection);
            }];
        }
        self.emptyView.hidden = NO;
    } else {
        // 隐藏
        self.emptyView.hidden = YES;
        [self.emptyView removeFromSuperview];
    }
}

- (UIButton*)btnWithImg:(UIImage*)image title:(NSString*)title {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.titleLabel.font = WDFont_12;
    [btn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [btn setImageEdgeInsets:UIEdgeInsetsMake(0.0, -10, 0.0, 0.0)];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setImage:image forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(clickEmptyViewBtn:) forControlEvents:UIControlEventTouchUpInside];
    return btn;
}

- (void)clickEmptyViewBtn:(UIButton*)btn {
    NSInteger index = btn.tag;
    switch (index) {
        case 1: // 新建
            [self goToCreateAccount];
            break;
        case 2: // 导入
            [self goToImportAccount];
            break;

            
        default:
            break;
    }
}

// 新建账户
- (void)goToCreateAccount {
    
    UIStoryboard *board = [UIStoryboard storyboardWithName:@"Account" bundle:nil];
    UIViewController *dst = [board instantiateViewControllerWithIdentifier:@"WDAccountCreateViewController"];
    [self.navigationController pushViewController:dst animated:YES];
}

// 导入账户
- (void)goToImportAccount {
    
    UIStoryboard *board = [UIStoryboard storyboardWithName:@"Account" bundle:nil];
    UIViewController *dst = [board instantiateViewControllerWithIdentifier:@"WDAccountImportViewController"];
    [self.navigationController pushViewController:dst animated:YES];
}

#pragma mark - Aciton
// 点击导航栏菜单
- (void)leftAction {
    [self.menuHandler showMenuView];
}

- (WDHomeLeftMenuHandler *)menuHandler {
    if (_menuHandler == nil) {
        _menuHandler = [[WDHomeLeftMenuHandler alloc] init];
        _menuHandler.srcVc = self;
    }
    return _menuHandler;
}

#pragma mark - other
- (NSString *)amountShowTextValue:(MBRBgCoin*)coin
{
    NSDecimalNumber *decimals = [NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%lld",(long long)pow(10, [coin.decimals intValue])]];
    
    NSString *amountStr = [@(coin.amount) stringValue];
    NSDecimalNumber *amount = [[NSDecimalNumber decimalNumberWithString:amountStr] decimalNumberByDividingBy:decimals];
    return [amount stringValue];
}
@end
