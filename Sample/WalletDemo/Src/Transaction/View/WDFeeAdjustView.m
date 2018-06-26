//
//  WDFeeAdjustView.m
//  WalletDemo
//
//  Created by zhanbin on 2018/4/11.
//  Copyright © 2018年 mbr. All rights reserved.
//

#import "WDFeeAdjustView.h"
#import "WDUIPrefix.h"

static const int sectionNumber = 5;//分段数量

@interface WDFeeAdjustView()

@property (nonatomic, weak) UITextField* feeTextField;

@property (nonatomic, strong) NSArray* valueSectionArray;//数值分段数组

@property (nonatomic, assign) NSInteger nowSection;//当前显示的分段

@end

@implementation WDFeeAdjustView

- (NSArray *)valueSectionArray {
    if (!_valueSectionArray) {
        NSMutableArray *valueArray = [NSMutableArray arrayWithCapacity:sectionNumber];
        for (int i=0; i<sectionNumber; i++) {
            NSDecimalNumber *space = [[self.maxValue decimalNumberBySubtracting:self.minValue] decimalNumberByDividingBy:[NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%d",(sectionNumber-1)]]];
            NSDecimalNumber *value = [self.minValue decimalNumberByAdding:[space decimalNumberByMultiplyingBy:[NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%d",i]]]];
            [valueArray addObject:value];
        }
        _valueSectionArray = [valueArray copy];
    }
    return _valueSectionArray;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [self setupViews];
    }
    return self;
}

- (void)setupViews {
    //plus button
    UIButton *plusButton = [[UIButton alloc] init];
    [plusButton setImage:[UIImage imageNamed:@"plus"] forState:UIControlStateNormal];
    [plusButton addTarget:self action:@selector(plusButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:plusButton];
    [plusButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self);
        make.width.height.mas_equalTo(WDFitablePixel(26));
        make.centerY.equalTo(self);
    }];
    //account label
    UITextField *feeTextField = [[UITextField alloc] init];
    [feeTextField setFont:WDFont_14];
    feeTextField.textColor = WDColor_2;
    [self addSubview:feeTextField];
    self.feeTextField = feeTextField;
    [feeTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(plusButton.mas_left).offset(WDFitablePixel(-10));
        make.width.mas_equalTo(100);
        make.top.bottom.equalTo(plusButton);
    }];
    //minus button
    UIButton *minusButton = [[UIButton alloc] init];
    [minusButton setImage:[UIImage imageNamed:@"minus"] forState:UIControlStateNormal];
    [minusButton addTarget:self action:@selector(minusButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:minusButton];
    [minusButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(feeTextField.mas_left).offset(WDFitablePixel(-10));
        make.width.height.mas_equalTo(WDFitablePixel(26));
        make.centerY.equalTo(self);
        make.left.equalTo(self);
    }];
}

- (void)setFee:(NSDecimalNumber *)fee {
    _fee = fee;
    self.feeTextField.text = fee.stringValue;
}

- (void)setMinValue:(NSDecimalNumber *)minValue{
    _minValue = minValue;
}

- (void)setMaxValue:(NSDecimalNumber *)maxValue {
    _maxValue = maxValue;
}

- (void)plusButtonAction:(UIButton *)sender {
    NSLog(@"plus button click");
    for (int i=0; i<self.valueSectionArray.count; i++) {
        double value = [self.valueSectionArray[i] doubleValue];
        double textFieldValue = [self.feeTextField.text doubleValue];
        if (value - textFieldValue > 0.00000000000001) {
            self.feeTextField.text = [self.valueSectionArray[i] stringValue];
            break;
        }
    }
}

- (void)minusButtonAction:(UIButton *)sender {
    NSLog(@"minus button click");
    for (NSInteger i=self.valueSectionArray.count-1; i>=0; i--) {
        double value = [self.valueSectionArray[i] doubleValue];
        double textFieldValue = [self.feeTextField.text doubleValue];
        if (textFieldValue - value > 0.00000000000001) {
            self.feeTextField.text = [self.valueSectionArray[i] stringValue];
            break;
        }
    }
}

- (double)getChoiceFee {
    return [self.feeTextField.text doubleValue];
}

- (NSString *)getChoiceFeeString {
    return self.feeTextField.text;
}

@end
