<!-- TOC -->

- [SDK集成](#sdk集成)
    - [使用说明](#使用说明)
    - [初始化](#初始化)
        - [初始化方法](#初始化方法方法)
        - [参数](#参数)
            - [MBRWalletConfig](#MBRWalletConfig)
            - [languageCode](#languageCode)
- [SDK接口文档](#sdk接口文档)
    - [密码接口](#密码接口)
        - [设置交易密码](#设置交易密码)
        - [修改密码](#修改密码)
        - [是否已设置密码](#是否已设置密码)
        - [密码是否相同](#密码是否相同)
        - [设置密码提示](#设置密码提示)
        - [获取密码提示](#获取密码提示)
    - [币接口](#币接口)
        - [同步币列表](#同步币列表)
        - [获取所有币列表](#获取所有币列表)
        - [获取必选币列表](#获取必选币列表)
        - [获取非必选币列表](#获取非必选币列表)
        - [获取矿工费默认值](#获取矿工费默认值)
        - [获取矿工费最大值](#获取矿工费最大值)
        - [获取矿工费最小值](#获取矿工费最小值)
    - [账户接口](#账户接口)
        - [创建新账户](#创建新账户)
        - [助记词导入账户](#助记词导入账户)
        - [keystore导入账户](#keystore导入账户)
        - [删除账户](#删除账户)
        - [获取账户助记词](#获取账户助记词)
        - [是否已备份账户](#是否已备份账户)
        - [备份账户](#备份账户)
        - [导出keystore](#导出keystore)
        - [设为默认账户](#设为默认账户)
        - [重命名账户](#重命名账户)
        - [获取所有账户](#获取所有账户)
        - [获取默认账户](#获取默认账户)
        - [查找账户](#查找账户)
        - [同步账户余额信息](#同步账户余额信息)
        - [更新账户中币的选中状态](#更新账户中币的选中状态)
    - [交易接口](#交易接口)
        - [密码支付](#密码支付)
        - [密码转账](#密码转账)

<!-- /TOC -->
## SDK集成

### 使用说明

- 工具：XCode、CocoaPods
- 配置：在工程的Podfile文件里面添加以下代码：
  pod 'MBRWallet'
  保存并执行pod install,然后用后缀为.xcworkspace的文件打开工程。

### 初始化

在使用钱包功能之前必须对钱包sdk进行初始化。
建议在AppDelegate.m的application:didFinishLaunchingWithOptions:方法中初始化。

#### 初始化方法

+(void)setupWithConfig:(MBRWWalletConfig*)config

#### 参数

##### MBRWWalletConfig

参数名                       |说明             | 备注
----------------------------|----------------|-------
languageCode                | 语言码          |可选项，默认为中文（可选值如下）
channel                     | 渠道号          |必选项，渠道号联系服务端人员分配
apiHost                     | 服务端地址       |可选项，不填为默认钱包地址

##### languageCode

|语言码            | 备注
------------------|-------------------
zh_CN             |中文
zh_TW             |繁体中文
en_US             |英文
ja_JP             |日文
ko_KR             |韩文

## SDK接口文档

### 密码接口

#### 设置交易密码

```java
/**
 设置交易密码

 @param pwd 密码
 @param err 错误
 */
+ (void)setPassword:(NSString*)pwd error:(NSError *__autoreleasing *)err;
```

#### 修改密码

```java
/**
 修改密码

 @param oldPwd 旧密码
 @param newPwd 新密码
 @param success 修改成功回调
 @param failure 修改失败回调
 */
+ (void)modifyPasswordWithOldPwd:(NSString *)oldPwd
                          newPwd:(NSString*)newPwd
                         success:(void (^)(void))success
                         failure:(MBRWFailureBlock)failure;
```

#### 是否已设置密码

```java
/**
 是否已设置密码
 - 使用账户操作等需要密码权限校验的接口前应该先设置密码
 - 设置密码接口调用：[MBRWWallet setPassword:pwd error:&error];

 @return YES=已设置；NO=未设置
 */
+ (BOOL)haveSetPassword;
```

#### 密码是否相同

```java
/**
 密码是否相同（校验传入密码是否与设置的密码相等）

 @return YES = 相等；NO = 不相等
 */
+ (BOOL)isSamePassword:(NSString*)pwd;
```

#### 设置密码提示

```java
/**
 设置密码提示

 @param hint 密码提示文本
 */
+ (void)setPasswardHint:(NSString*)hint;
```

#### 获取密码提示

```java
/**
 获取密码提示

 @return 密码提示文本
 */
+ (NSString*)getPasswordHint;
```

### 币接口

#### 同步币列表

```java
/**
 同步币列表
 
 @param callBack 结果回调（success=YES:同步成功）

 */
+ (void)syncAllERC20CoinList:(void (^)(BOOL success))callBack;
```

#### 获取所有币列表

```java
/**
 获取所有币列表
 
 @return 币数组
 */
+ (NSArray<MBRBgCoin*>*)getAllCoins;
```

#### 获取必选币列表

```java
/**
 获取必选币列表

 @return 币数组
 */
+ (NSArray<MBRBgCoin*>*)getForceCoins;
```

#### 获取非必选币列表

```java
/**
 获取非必选币列表

 @return 币数组
 */
+ (NSArray<MBRBgCoin*>*)getNomalCoins;
```

#### 获取矿工费默认值

```java
/**
 获取矿工费默认值
 
 @param coinId 币Id
 @return 价格（转换后的价格：单位：eth)
 */
+ (NSDecimalNumber*)defaultEthWithCoinId:(NSString*)coinId;
```

#### 获取矿工费最大值

```java
/**
 矿工费最大值
 
 @param coinId 币Id
 @return 价格（转换后的价格：单位：eth)
 */
+ (NSDecimalNumber*)maxEthWithCoinId:(NSString*)coinId;
```

#### 获取矿工费最小值

```java
/**
 矿工费最小值
 
 @param coinId 币Id
 @return 价格（转换后的价格：单位：eth)
 */
+ (NSDecimalNumber*)minEthWithCoinId:(NSString*)coinId;
```

### 账户接口

#### 创建新账户

```java
/**
 创建新账户

 @param name 账户名称
 @param pwd 交易密码
 @param success 操作成功回调
 @param failure 操作失败回调
 */
+ (void)addNewAccountWithName:(NSString*)name
                          pwd:(NSString *)pwd
                      success:(MBRWAccountOprationSuccessBlock)success
                      failure:(MBRWFailureBlock)failure;
```

#### 助记词导入账户

```java
/**
 助记词导入账户

 @param mnemonic 助记词
 @param pwd 交易
 @param name 账户名称
 @param success 操作成功回调
 @param failure 操作失败回调
 */
+ (void)importAccountByMnemonic:(NSString*)mnemonic
                            pwd:(NSString*)pwd
                           name:(NSString*)name
                        success:(MBRWAccountOprationSuccessBlock)success
                        failure:(MBRWFailureBlock)failure;
```

#### keystore导入账户

```java
/**
 keystore导入账户

 @param keyStore keystore
 @param pwd 密码
 @param pwdKS keystore密码
 @param name 账户名称
 @param success 操作成功回调
 @param failure 操作失败回调
 */
+ (void)importAccountByKeystore:(NSString*)keyStore
                            pwd:(NSString*)pwd
                          pwdKS:(NSString*)pwdKS
                           name:(NSString*)name
                        success:(MBRWAccountOprationSuccessBlock)success
                        failure:(MBRWFailureBlock)failure;
```

#### 删除账户

```java
/**
 删除账户

 @param name 账户名
 @param pwd 密码
 @param success 操作成功回调
 @param failure 操作失败回调
 */
+ (void)removeAccount:(NSString*)name
                  pwd:(NSString*)pwd
              success:(MBRWAccountOprationSuccessBlock)success
              failure:(MBRWFailureBlock)failure;
```

#### 获取账户助记词

```java
/**
 获取账户助记词

 @param address 账户地址
 @param pwd 密码
 @param err 错误
 @return 助记词文本
 */
+ (NSString*)getMnemonic:(NSString*)address
                     pwd:(NSString*)pwd
                   error:(NSError *__autoreleasing *)err;
```

#### 是否已备份账户

```java
/**
 是否已备份账户
 
 @param address 账户地址
 @return YES：账户已经备份过助记词或者账户是由keystore导入的
 */
+ (BOOL)isAccountBackup:(NSString*)address;
```

#### 备份账户

```java
/**
 备份账户
 
 @param address 账户地址
 @param pwd 校验密码
 @param mnemonic 校验助记词
 @param success 操作成功
 @param failure 操作失败
 */
+ (void)backupAccount:(NSString*)address
                  pwd:(NSString*)pwd
             mnemonic:(NSString*)mnemonic
              success:(MBRWAccountOprationSuccessBlock)success
              failure:(MBRWFailureBlock)failure;
```

#### 导出keystore

```java
/**
 导出keystore
 
 @param address 账户地址
 @param pwd 账户密码
 @param ksPwd keystory密码
 @param success 导出成功回调
 @param failure 导出失败回调
 */
+ (void)exportKeystore:(NSString*)address
                   pwd:(NSString*)pwd
                 ksPwd:(NSString*)ksPwd
               success:(void (^)(NSString *json))success
               failure:(MBRWFailureBlock)failure;
```

#### 设为默认账户

```java
/**
 设为默认账户

 @param address 地址
 @param pwd 密码
 @param success 操作成功回调
 @param failure 操作失败回调
 */
+ (void)setAsDefaultAccount:(NSString*)address
                        pwd:(NSString*)pwd
                    success:(MBRWAccountOprationSuccessBlock)success
                    failure:(MBRWFailureBlock)failure;
```

#### 重命名账户

```java
/**
 重命名账户

 @param name 账户名
 @param newName 新名称
 @param pwd 交易密码
 @param success 操作成功回调
 @param failure 操作失败回调
 */
+ (void)renameAccount:(NSString*)name
              newName:(NSString*)newName
                  pwd:(NSString*)pwd
              success:(MBRWAccountOprationSuccessBlock)success
              failure:(MBRWFailureBlock)failure;
```

#### 获取所有账户

```java
/**
 获取所有账户

 @return MBRWAccount数组
 */
+ (NSArray<MBRWAccount*>*)getAllAccount;

```

#### 获取默认账户

```java
/**
 获取默认账户

 @return MBRWAccount
 */
+ (MBRWAccount*)getDefaultAccount;

```

#### 查找账户

```java
/**
 查找账户
 
 @param address 地址
 @return MBRWAccount
 */
+ (MBRWAccount*)getAccountWithAddress:(NSString*)address;
```

#### 同步账户余额信息

```java
/**
 同步账户余额信息
 
 @param complete 同步完成回调
 */
+ (void)syncAllAccountBalance:(void(^)(BOOL success))complete;
```

#### 更新账户中币的选中状态

```java
/**
 更新账户中币的选中状态
 
 @param coin MBRBgCoin
 @param address 账户地址
 @param callBack 完成回调
 */
+ (void)updateAccountCoinSelectSatate:(MBRBgCoin *)coin
                     toAccountAddress:(NSString *)address
                             callBack:(void (^)(BOOL success))callBack;
```

### 交易接口

#### 支付

```java
/**
 密码支付
 
 @param param 参数
 @param pwd 密码
 @param success 支付成功回调
 @param failure 支付失败回调
 */
+ (void)payWithPrarm:(MBRWPayParam*)param
            password:(NSString*)pwd
             success:(MBRWTransactionSuccessBlock)success
             failure:(MBRWFailureBlock)failure;
```

#### 转账

```java
/**
 密码转账
 
 @param param 参数
 @param pwd 密码
 @param success 支付成功回调
 @param failure 支付失败回调
 */
+ (void)transferWithPrarm:(MBRWTransferParam*)param
            password:(NSString*)pwd
             success:(MBRWTransactionSuccessBlock)success
             failure:(MBRWFailureBlock)failure;
```

## 错误码
错误码使用示例：
```java
+ (NSString*)parseError:(NSError*)error {

    NSString *errorCOde = nil；
    //判断是否钱包错误码
    if ([error mbrw_isWalletError]) {
        // 获取错误码
        NSString *errorCOde = [error mbrw_errorCode];
    }
        
    return errorCOde;    
}    
```

错误                          |含义               | 备注
-----------------------------|------------------|-------------------
Error_Unknown                |  未知错误        | 钱包配置错误，抛出此异常
Pwd_None                     |  输入密码为空     | 无密码，需先设置密码
Pwd_NotExist                 |  钱包未设置密码   |
Pwd_Exist                    |  密码已经存在     |
Pwd_NotSame                  |  密码错误        | 
Pwd_Same                     |  密码一样        | 修改密码时，密码也原密码一样
PASSWORD_ERROR               |  密码错误        |
PASSWORD_SET_FAIL          |  设置密码失败       |
PASSWORD_SET_FAIL_FOR_ALREADY_SET |  密码已经设置过   |此处需要调用修改密码接口
PASSWORD_MODIFY_FAIL |    |
PASSWORD_REMINDER_EMPTY_ERROR |    |
PASSWORD_REMINDER_LONG_ERROR |    |
PASSWORD_REMINDER_EQUAL_PWD_ERROR |    |
PASSWORD_MODIFY_OLD_PWD_ERROR |    |
PASSWORD_MODIFY_NEWPWD_SAME_TO_OLDPWD_ERROR |    |
FINGER_UNAVAILABLE_ERROR |    |
FINGERPRINT_ERROR |    |
COIN_UPDATE_ERROR |    |
ACCOUNT_NAME_EMPTY_ERROR |    |
ACCOUNT_NAME_LONG_ERROR |    |
ACCOUNT_NAME_DUPLICATE_ERROR |    |
ACCOUNT_FULL_ERROR |    |
ACCOUNT_DUPLICATE_ERROR |    |
ACCOUNT_CHAIN_TYPE_ERROR |    |
ACCOUNT_CREATE_FAIL_ERROR |    |
ACCOUNT_NOT_EXIST_ERROR |    |
ACCOUNT_RENAME_ERROR |    |
ACCOUNT_DELETE_ERROR |    |
ACCOUNT_BACKUP_ERROR |    |
ACCOUNT_EXPORT_KEYSTORE_ERROR |    |
ACCOUNT_SET_DEFAULT_ERROR |    |
ACCOUNT_COINS_UPDATE_ERROR |    |
MNEMONIC_EMPTY_ERROR |    |
MNEMONIC_ERROR |    |
KEYSTORE_EMPTY_ERROR |    |
KEYSTORE_ERROR |    |
PAY_FINGER_EMPTY_ERROR |    |
PAY_FINGER_CHANGED_ERROR |    |
PAY_FEE_INPUT_RANGE_ERROR |    |
PAY_FEE_NOT_ENOUGH_ERROR |    |
PAY_BALANCE_NOT_ENOUGH_ERROR |    |

