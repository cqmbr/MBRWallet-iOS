//
//  WDBalanceSingleDCViewController.m
//  WalletDemo
//
//  Created by autoround-032 on 2018/4/10.
//  Copyright © 2018年 mbr. All rights reserved.
//

#import "WDBalanceSingleDCViewController.h"
#import "WDQRCodeView.h"
#import "WDTransferViewController.h"
#import <MBRWallet/MBRWallet.h>

@interface WDBalanceSingleDCViewController ()

// 币图标
@property (weak, nonatomic) IBOutlet UIImageView *coinImage;
// 币名称
@property (weak, nonatomic) IBOutlet UILabel *coinName;
// 币余额
@property (weak, nonatomic) IBOutlet UILabel *coinBalance;

@end

@implementation WDBalanceSingleDCViewController

#pragma mark -
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupNav];
    [self.view setBackgroundColor:WDMainColor];
    [self.coinImage sd_setImageWithURL:[NSURL URLWithString:self.coin.avatarUrl]];
    self.coinName.text = self.coin.abbr;
    self.coinBalance.text = [self amountShowTextValue:self.coin];
}

-(void)setupNav {
    [self setNavTitleColor:WDWhiteColor];
    [self setLeftBtnTitleColor:WDWhiteColor];
    [self setLeftBtnNomalImage:[UIImage imageNamed:@"arrow_back_white"] highlighted:nil];
    [self setNavTitle:self.coin.abbr];
}

#pragma mark - 支付演示

/**
 支付功能演示
 1.从服务端获取订单信息
 2.输入交易密码
 3.调用MBRWallet支付
 */
- (IBAction)payAction:(id)sender {
    
    // 测试币地址 34190899187000 eth币 // 7739138616000 ph币
    NSString *amount = @"0.000001"; // 支付金额
    NSString *toAddr = @"34190899187000"; // 支付目标地址
    
    // 请求服务端获取订单信息，请根据自己业务请求自己的服务端
    [self prePay:toAddr amount:amount];
}

- (void)prePay:(NSString *)coinId amount:(NSString *)amount{
    
    [WDToastUtil showLoadingInView:nil];
    
    NSString *urlString = [NSString stringWithFormat:@"http://47.100.47.200:9927/home/prepay?coinId=%@&amount=%@",coinId,amount];
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSURLSession *session=[NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask=[session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [WDToastUtil hideInView:nil];
            
            if(!error){
                
                NSError *error;
                NSDictionary *responseDict = [NSJSONSerialization JSONObjectWithData:data
                                                                             options:NSJSONReadingMutableContainers
                                                                               error:&error];
                if (error == nil) {
                    NSString *code = responseDict[@"code"];
                    if ([code isEqualToString:@"200"]) {
                        // 请求结果
                        dispatch_async(dispatch_get_main_queue(), ^{
                            NSString *orderInfo = responseDict[@"data"];
                            NSLog(@"\rorderInfo:\r%@",orderInfo);
                            [self handlePayWithInfo:orderInfo];
                        });
                    }else {
                        NSLog(@"error:%@",@"server error");
                        [WDToastUtil showToast:@"服务端错误" InView:nil];
                    }
                }
            } else {
                // 请求返回错误
                NSLog(@"error:%@",[error description]);
                [WDToastUtil showToast:[error description] InView:nil];
                
            }
        });
    }];
    
    //5.执行任务
    [dataTask resume];
}

- (void)handlePayWithInfo:(NSString*)orderInfo {
    
    // 验证密码
    [self inputTextWithTitle:@"请输入密码" callback:^(NSString *pwd) {
        // 支付
        [self doPay:pwd orderInfo:orderInfo];
    }];
}

// 支付业务
- (void)doPay:(NSString*)pwd orderInfo:(NSString*)orderInfo {
    
    [WDToastUtil showLoadingInView:nil];
    
    // 构造支付参数
    MBRWPayParam *param = [MBRWPayParam new];
    param.orderInfo = orderInfo;
    param.addressFrom = self.account.accountAddress;
    param.feeStr = [[MBRWWallet defaultEthWithCoinId:self.coin.coinId] stringValue];
    param.memo = @"";
    
    // 支付
    [MBRWWallet payWithPrarm:param password:pwd success:^{
        [WDToastUtil hideInView:nil];
        [WDToastUtil showToast:@"支付成功" InView:nil];
    } failure:^(NSError *error) {
        [WDToastUtil hideInView:nil];
        [WDToastUtil showError:error view:nil];
    }];
}


#pragma mark - 交易
- (IBAction)transaction:(id)sender {
    WDTransferViewController *controller = [[WDTransferViewController alloc] init];
    controller.account = self.account;
    controller.coinData = self.coin;
    [self.navigationController pushViewController:controller animated:YES];
}

#pragma mark - QR码
- (IBAction)showQRImage:(id)sender {

    WDQRCodeView *qrCodeView = [[WDQRCodeView alloc] initWithAccountName:self.account.accountName address:self.account.accountAddress];
    [qrCodeView show];
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
