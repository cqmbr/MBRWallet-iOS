//
//  WDBalanceDetailViewController.m
//  WalletDemo
//
//  Created by liaofulin on 2018/03/30.
//  Copyright © 2018年 mbr. All rights reserved.
//

#import "WDBalanceDetailViewController.h"
#import "WDAddDCTableViewCell.h"
#import "WDBackUpContentViewController.h"
#import "WDAccountExportKeystoreView.h"
#import <MBRWallet/MBRWWallet.h>

@interface WDBalanceDetailViewController ()<
UITableViewDelegate,
UITableViewDataSource
>

@property (weak, nonatomic) IBOutlet UITableView *myTableView;
@property (nonatomic, strong)NSMutableArray<MBRBgCoin *> *forceArray; // 必选币
@property (nonatomic, strong)NSMutableArray<MBRBgCoin *> *unForceArray; // 可选币

@end

@implementation WDBalanceDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupNav];
    [self loadData];
}

-(void)setupNav {
    [self setLeftBtnNomalImage:[UIImage imageNamed:@"arrow_back"] highlighted:nil];
    [self setRightBtnNomalImage:[UIImage imageNamed:@"dots2"] highlighted:nil];
    [self setNavTitle:self.account.accountName];
}

-(void)loadData {
    
    self.forceArray = [NSMutableArray arrayWithArray:[MBRWWallet getForceCoins]];
    self.unForceArray = [NSMutableArray arrayWithArray:[MBRWWallet getNomalCoins]];
    
    MBRWAccount *account = self.account;
    
    // 更新收藏状态，如果账户中有则为已收藏
    for (MBRBgCoin *item in self.unForceArray) {
        MBRBgCoin *coin = [account getCoinWithId:item.coinId];
        if (coin) {
            item.isCollected = YES;
        } else {
            item.isCollected = NO;
        }
    }
    
    [self.myTableView reloadData];
}

#pragma mark - tableview代理及数据源
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) { // 必选
        return self.forceArray.count;
    }else{ // 可选
        return self.unForceArray.count;
    }
    
    return 0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *indetifier = @"Cell";
    WDAddDCTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:indetifier];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"WDAddDCTableViewCell" owner:self options:nil] lastObject];
    }
    
    if (indexPath.section == 0) {
        // 必选栏
        [cell.checkImageView setImage:[UIImage imageNamed:@"check_gray"]];
        MBRBgCoin *model = self.forceArray[indexPath.row];
        [cell.iconImageView sd_setImageWithURL:[NSURL URLWithString:model.avatarUrl] placeholderImage:[UIImage imageNamed:@"coins_default"]];
        cell.name.text = model.abbr;

    }else{
        // 可选栏
        MBRBgCoin *model = self.unForceArray[indexPath.row];
        [cell.iconImageView sd_setImageWithURL:[NSURL URLWithString:model.avatarUrl] placeholderImage:[UIImage imageNamed:@"coins_default"]];
        cell.name.text =  model.abbr;
        if (model.isCollected == YES) {
            [cell.checkImageView setImage:[UIImage imageNamed:@"check"]];
        }else{
            [cell.checkImageView setImage:[UIImage imageNamed:@"check_gray"]];
        }
    }
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 77;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 0.5;
    }else{
        return 10;
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return nil;
    }else{
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WDScreenW, 10)];
        return view;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        // 强制显示的不允许勾选
    }else{
        MBRBgCoin *model = self.unForceArray[indexPath.row];
        [self changeAccountCoinCollectSatate:model];
    }
}

#pragma mark - 账户操作按钮点击
// 点击导航栏右边操作账户按钮
-(void)rightAction {
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"账户操作" message:nil preferredStyle:UIAlertControllerStyleActionSheet];

    // 重命名
    [alertController addAction:[UIAlertAction actionWithTitle:@"重命名" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self handleRenameAccount];
    }]];
    
    // 设为默认
    NSString *isDef = [self isDefaultAccount] ? @"默认账户" : @"设为默认账户";
    [alertController addAction:[UIAlertAction actionWithTitle:isDef style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if (![self isDefaultAccount]) {
            // 不是默认账户操作
            [self handleSetDefaultAccount];
        }
    }]];

    // 移除账户
    [alertController addAction:[UIAlertAction actionWithTitle:@"移除账户" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self handleRemoveAccount];
    }]];
    
    // 导出keystore
    [alertController addAction:[UIAlertAction actionWithTitle:@"导出keystore" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self handleExportKeystore];
    }]];
    
    // 备份
    [alertController addAction:[UIAlertAction actionWithTitle:@"备份" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self handleBackupAccount];
    }]];
    
    // 取消
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    
    [self presentViewController:alertController animated:true completion:nil];
}

- (void)handleRenameAccount {
    [self inputTextWithTitle:@"请输入密码" callback:^(NSString *pwd) {
        
        if ([self valifyPwd:pwd]) {
            [self inputTextWithTitle:@"请输入新账户名称" callback:^(NSString *newName) {
                [self doRenameWithOldName:self.account.accountName newName:newName pwd:pwd];
            }];
        }
    }];
}

- (void)handleSetDefaultAccount {
    [self inputTextWithTitle:@"请输入密码" callback:^(NSString *pwd) {
        
        if ([self valifyPwd:pwd]) {
            [self doSetAsDefaultAccount:self.account.accountName pwd:pwd];
        }
    }];
}

- (void)handleRemoveAccount {
    [self inputTextWithTitle:@"请输入密码" callback:^(NSString *pwd) {
        
        if ([self valifyPwd:pwd]) {
            [self doRemoveAccount:self.account.accountName pwd:pwd];        }
    }];
}

- (void)handleExportKeystore {
    [self inputTextWithTitle:@"请输入密码" callback:^(NSString *pwd) {
        
        if ([self valifyPwd:pwd]) {
            [self inputTextWithTitle:@"请输入keystore密码" callback:^(NSString *ksPwd) {
                [self doExportWithAddress:self.account.accountAddress pwd:pwd ksPwd:ksPwd];
            }];
        }
    }];
}

- (void)handleBackupAccount {
    [self inputTextWithTitle:@"请输入密码" callback:^(NSString *pwd) {
        
        if ([self valifyPwd:pwd]) {
            UIStoryboard *board = [UIStoryboard storyboardWithName:@"Balance" bundle:nil];
            WDBackUpContentViewController
            *backupController = [board instantiateViewControllerWithIdentifier:@"WDBackUpContentViewController"];
            backupController.account = self.account;
            backupController.tmpPwd = pwd;
            [self.navigationController pushViewController:backupController animated:YES];
        }
    }];
}


#pragma mark - 账户操作
// 是否为默认账户
- (BOOL)isDefaultAccount {
    return [[MBRWWallet getDefaultAccount].accountAddress isEqualToString:self.account.accountAddress];
}

// 验证密码是否一致
- (BOOL)valifyPwd:(NSString*)pwd {
    
    BOOL same = [MBRWWallet isSamePassword:pwd];
    if (!same) {
        [WDToastUtil showToast:@"密码错误" InView:nil];
    }
    return same;
}

// 更改账户中币的选中状态，即对账户添加/删除币
// 将线上的币列表添加到账户中或者从账户中删除
- (void)changeAccountCoinCollectSatate:(MBRBgCoin*)model {
    
    model.isCollected = !model.isCollected;
    [self.myTableView reloadData];
    
    [WDToastUtil showLoadingInView:nil];
    [MBRWWallet updateAccountCoinSelectSatate:model toAccountAddress:self.account.accountAddress callBack:^(BOOL success) {
        [WDToastUtil hideInView:nil];
        if (success) {
            [WDToastUtil showToast:@"操作成功" InView:nil];
        } else {
            // 修改失败，还原以前状态
            [WDToastUtil showToast:@"操作失败" InView:nil];
            model.isCollected = !model.isCollected;
            [self.myTableView reloadData];
        }
    }];
}


/**
 移除账户

 @param name 账户名
 @param pwd 密码
 */
- (void)doRemoveAccount:(NSString*)name pwd:(NSString*)pwd {
    
    [MBRWWallet removeAccount:name pwd:pwd success:^(MBRWAccount *account) {
        [WDToastUtil showToast:@"操作成功" InView:nil];
        [self popAction:2];
        
    } failure:^(NSError *error) {
        [WDToastUtil showError:error view:nil];
    }];
}

/**
 设为默认账户

 @param name 账户名
 @param pwd 密码
 */
- (void)doSetAsDefaultAccount:(NSString*)name pwd:(NSString*)pwd {
    
    [MBRWWallet setAsDefaultAccount:name pwd:pwd success:^(MBRWAccount *account) {
        [WDToastUtil showToast:@"操作成功" InView:nil];
        [self popAction:2];
        
    } failure:^(NSError *error) {
        [WDToastUtil showError:error view:nil];
    }];
}


/**
 重命名账户

 @param oldName 旧名称
 @param newName 新名称
 @param pwd 密码
 */
- (void)doRenameWithOldName:(NSString*)oldName newName:(NSString*)newName pwd:(NSString*)pwd {
    [MBRWWallet renameAccount:oldName newName:newName pwd:pwd success:^(MBRWAccount *account) {
        [WDToastUtil showToast:@"操作成功" InView:nil];
        [self popAction:2];
    
    } failure:^(NSError *error) {
        [WDToastUtil showError:error view:nil];
    }];
}

/**
 导出keystore

 @param address 账户地址
 @param pwd 钱包密码
 @param ksPwd keystore密码
 */
- (void)doExportWithAddress:(NSString*)address pwd:(NSString*)pwd ksPwd:(NSString*)ksPwd {
    
    [WDToastUtil showLoadingInView:nil];
    [MBRWWallet exportKeystore:address pwd:pwd ksPwd:ksPwd success:^(NSString *json) {
    
        [WDToastUtil hideInView:nil];
        
        // 显示keystore
        WDAccountExportKeystoreView *expeortView = [[WDAccountExportKeystoreView alloc] initWithFrame:CGRectZero];
        [self.view addSubview:expeortView];
        [expeortView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
        [expeortView showKeyStore:json];
        
    } failure:^(NSError *error) {
        [WDToastUtil hideInView:nil];
        [WDToastUtil showError:error view:nil];
    }];
}


#pragma mark - other

- (void)popAction:(NSTimeInterval)timerInterval {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(timerInterval * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.navigationController popViewControllerAnimated:YES];
    });
}

@end
