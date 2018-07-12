//
//  WDConfigManager.m
//  WalletDemo
//
//  Created by lfl on 2018/7/11.
//  Copyright © 2018年 mbr. All rights reserved.
//

#import "WDConfigManager.h"

static NSString* defaultValueAppMechantId = @"31698305396200";
static NSString * appPrivateKeyPEM = @"-----BEGIN PRIVATE KEY-----\
MIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQCJjBeC/vAd9tWAwfiWubtR9DcigURUWCDgw3APdE1GY+VJNSQMQN/tHpYH+LnCSyXGk7ysgcnrqiODhvyQg7QTWnHBTEO+beVK6WcGDuKhR9THDAqlLulo86hkvDbhN3/2l9SXUpR1SOW87Ed1uYeqe6PT1515q0tYXYx/RnXJIz63Ih9PTeVZeRfjVtcPdCLdtnpZWd9rPBofMbu2ZJxp84VFcxpByUBHemPGEqnRgTXtNy6I07vGQrlmcDO1S/MsqpIO3l7/EvThTuK580ic9MB8iqAnEyffWMESqCk2qHqX90q+ZMVMIZ/mIh5+N4PmD7cS2DHcYwPsA5bHgQTTAgMBAAECggEAQACG5DZ6RocXm50mbgQojJ7llNGvmMuVKODn4NkOKAXNp/3pMyZwy+Yii70JusW64ybVcTPHYDg/5DDIjvopraO1MOuqzg5W1j+654+/lqpU8PXCclBc3bAbGByYML3hdj359xu+5sAv3nPXYIke/o4fkjBPH1E8cva8rHB92EQ0fDGWWy3ddjEOvp9CoKW9VDmkvy2SNTfW+UU0au0zY207/oGkm9rvvcIsZ4rOB68U3HBgWXYHSu/S9752vKS9SgxtsNOA6a8J3KHLUBNl0t1pa5dgYCjGioY1qU+muRO+lky5oMYl/UUq3fDfT5rqEp1OAagXzckm8banJmOgqQKBgQDalOdRnBMOMYoa0qhMZGnKFxE4h6Bv6sOam8Z9559ssqs0r0FMK3Lcu9c7aExmMlHERsNTyAyrpfC0ZQFoJw0LUJihn1h/nlN5XCPt0NfkH8Sy3BF/Y5DAt/Bie0WDuo18qeYHcv4tFrL1ybTK/xv6CdG1/IUxxjBasjWHBOTkNwKBgQChF/IIWSj0QIA2BtWq9rmbCVwBECdpr52X237wNHOWCyQ40JM+Ixn1O1EBLoKHqoaaT3JYX91YS/sZs9PUxbKplIxwRzfAqOKTn92//8aDa/Wl6Kly5wsbUAhFvyhJDT1SNqvt+3EmGlL4Bb8W7qoX+MXk9NyUQ8HHNpWu4A+ORQKBgHECCTJFSgjNjgReI0sToyorkOi0HjuembCmlxHjHaaaHS/o6A6UbBc5OobpXo57t5CNsVDwnbRk37S0f+y0O+c8rRzqgFvCpI+bFqxOjD/SOOTsKFO/S0iIEM0pxH/dhGcOg/IX/tea4711onZNPM6iIv0+6DIasEdD2a7L1fczAoGAMczZQcNuabPW7tzGCQgk8My/6IQ56u4jZeKxJ0jPwr7G/9la64ama61eqWLbb11EJ0gQLUnVf4pdoeB5x/kl9k6566vYjHKpOMHfJ4/GqrIhSpzWZXMPd+4R4J3rskmpf1Tvaa6lmAXjSFFedZRqeOarJtCbsCoSKaeyNlGF/ZECgYEAuTKLRKyl+2MylP++vszJCDN3olGrSXqF8JyQHcWQQOrrk3hrq8wSuUM0LjJOjpBQdHqGZtidwizhOSDU1lKnnppq8w6k4ZJaUZzipnxouP2UPO3R3owsQLaRs3957cTx0/T8U1MRumXtJMB/oB2JcY7tSYyXRNKP04pX4oWYNcc=\
-----END PRIVATE KEY-----";

static NSString *channel = @"31699023385400";
static NSString *apiHost = @"http://47.100.18.6:9900/";

@implementation WDConfigManager

+ (NSString*)privateKey {
    return appPrivateKeyPEM;
}

+ (NSString*)merchantId {
    return defaultValueAppMechantId;
}

+ (NSString*)channel {
    return channel;
}

+ (NSString*)apiHost {
    return apiHost;
}

@end
