//
//  WDBackUpConfirmViewController.m
//  WalletDemo
//
//  Created by sean on 2018/4/10.
//  Copyright © 2018年 mbr. All rights reserved.
//

#import "WDBackUpConfirmViewController.h"
#import "WDButtonGroupTagsFrame.h"
#import <QMUIKit/QMUIButton.h>
#import <MBRWallet/MBRWWallet.h>

@interface WDBackUpConfirmViewController ()
{
    WDButtonGroupTagsFrame *_frame;
    NSArray *_tagsArray;
    NSMutableArray *btnStatusArray;
}
@property (weak, nonatomic) IBOutlet UIButton *confirmBtn;
@property (weak, nonatomic) IBOutlet UILabel *confirmTipsLab;
@property (weak, nonatomic) IBOutlet UILabel *mnemonicLaber;
@property (weak, nonatomic) IBOutlet UIView *backView;
@end

@implementation WDBackUpConfirmViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNav];
    [self createSubView];
}

-(void)setupNav {
    [self setLeftBtnNomalImage:[UIImage imageNamed:@"arrow_back"] highlighted:nil];
    [self setNavTitle:@"确认助记词"];
    _confirmTipsLab.text = @"请按照顺序选择助记词，确保助记词正确填入。";
    [_confirmBtn setTitle:@"确定" forState:UIControlStateNormal];
}

- (void)createSubView {
    [_mnemonicLaber.layer setBorderWidth:1];
    _mnemonicLaber.numberOfLines = 0;
    _mnemonicLaber.lineBreakMode = NSLineBreakByWordWrapping;
    [_mnemonicLaber.layer setBorderColor:WDGrayColor.CGColor];
    
    //获取助记词数组
    _mnemonicString = [_mnemonicString stringByReplacingOccurrencesOfString:@"  " withString:@" "];
    __block NSArray *sortArr = [_mnemonicString componentsSeparatedByString:@" "];
    NSMutableArray *tmpArr = [NSMutableArray new];
    for (int i = 0; i < sortArr.count; i++) {
        NSString *str = sortArr[i];
        if (ISNULLSTR(str)) {
            
        }else{
            [tmpArr addObject:str];
        }
    }
    
    _mnemonicString = [tmpArr componentsJoinedByString:@" "];
    
    sortArr = tmpArr;
    //对助记词数字进行乱序排序
    sortArr = [sortArr sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        NSComparisonResult result = [obj1 compare:obj2];
        
        return result == NSOrderedDescending;
    }];
    
    _tagsArray = sortArr;
    btnStatusArray = [[NSMutableArray alloc]init];
    for (int i = 0; i< _tagsArray.count; i++) {
        [btnStatusArray addObject:@"unCheck"];
    }
    
    _frame = [[WDButtonGroupTagsFrame alloc] init];
    _frame.tagsArray = _tagsArray;
    
    for (NSInteger i=0; i< _tagsArray.count; i++) {
        QMUIButton *tagsBtn = [QMUIButton buttonWithType:UIButtonTypeCustom];
        [tagsBtn setTitle:_tagsArray[i] forState:UIControlStateNormal];
        [tagsBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [tagsBtn setImagePosition:QMUIButtonImagePositionRight];
        [tagsBtn setImage:[UIImage imageNamed:@"unCheck"] forState:UIControlStateNormal];
        tagsBtn.titleLabel.font = TagsTitleFont;
        tagsBtn.backgroundColor = [UIColor whiteColor];
        tagsBtn.layer.borderWidth = 1;
        tagsBtn.layer.borderColor = [UIColor clearColor].CGColor;
        tagsBtn.layer.cornerRadius = 0;
        tagsBtn.layer.masksToBounds = YES;
        tagsBtn.frame = CGRectFromString(_frame.tagsFrames[i]);
        [_backView addSubview:tagsBtn];
        
        [tagsBtn setTag:i];
        [tagsBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
}

-(void)btnClick:(UIButton *)sender {
    NSString *labstr = _mnemonicLaber.text;
    if (labstr == nil) {
        labstr = @"";
    }
    
    NSLog(@"click tag = %ld",[sender tag]);
    NSInteger tags = [sender tag];
    UIButton *btn = sender;
    if ([btnStatusArray[tags] isEqualToString:@"unCheck"]) {
        btnStatusArray[tags] = @"check";
        btn.layer.borderColor = [UIColor lightGrayColor].CGColor;
        
        labstr = [labstr stringByAppendingString:btn.titleLabel.text];
        labstr = [labstr stringByAppendingString:@" "];
        
    }
    
    [btn setImage:[UIImage imageNamed:btnStatusArray[tags]] forState:UIControlStateNormal];
    
    _mnemonicLaber.text = labstr;
}

- (IBAction)confirmAction:(id)sender {
    //去除头尾空格
    NSString *mnemonicWords = [_mnemonicLaber.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];

    
    [MBRWWallet backupAccount:_address pwd:self.tmpPwd mnemonic:mnemonicWords success:^(MBRWAccount *account) {
        [MBProgressHUD bwm_showTitle:@"助记词确认成功" toView:self.view hideAfter:4];
    } failure:^(NSError *error) {
        [MBProgressHUD bwm_showTitle:@"助记词不正确，请从新选择" toView:self.view hideAfter:4];
        
        [btnStatusArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            btnStatusArray[idx] = @"unCheck";
            _mnemonicLaber.text = @"";
        }];
        
        for (UIView *view in _backView.subviews) {
            if ([view isKindOfClass:[UIButton class]]) {
                UIButton *btn = (UIButton *)view;
                [btn setImage:[UIImage imageNamed:@"unCheck"] forState:UIControlStateNormal];
            }
        }
    }];
}


@end
