//
//  WDQRCodeScanViewController.m
//  WalletDemo
//
//  Created by liaofulin on 2018/03/30.
//  Copyright © 2018年 mbr. All rights reserved.
//

#import "WDQRCodeScanViewController.h"
#import <AVFoundation/AVFoundation.h>

//设备宽/高/坐标
#define kDeviceWidth [UIScreen mainScreen].bounds.size.width
#define KDeviceHeight [UIScreen mainScreen].bounds.size.height
//相机显示view
#define kCameraViewY 90

#define kReaderViewWidth WDFitablePixel(280)
#define kReaderViewHeight WDFitablePixel(280)

#define kLineWidth WDFitablePixel(250)
#define kLineMinY WDFitablePixel(88)
#define kLineMaxY (kLineMinY + kReaderViewHeight)

@interface WDQRCodeScanViewController () <AVCaptureMetadataOutputObjectsDelegate>

@property (nonatomic, strong) AVCaptureSession *qrSession;//回话
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *qrVideoPreviewLayer;//读取
@property (nonatomic, strong) UIImageView *line;//交互线
@property (nonatomic, strong) NSTimer *lineTimer;//交互线控制

@end

@implementation WDQRCodeScanViewController

- (void)dealloc {
    if (_qrSession) {
        [_qrSession stopRunning];
        _qrSession = nil;
    }
    
    if (_qrVideoPreviewLayer) {
        _qrVideoPreviewLayer = nil;
    }
    
    if (_line) {
        _line = nil;
    }
    
    if (_lineTimer) {
        [_lineTimer invalidate];
        _lineTimer = nil;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNav];
    [self setupViews];
    [self setOverlayPickerView];
    [self startSYQRCodeReading];
}

// 导航栏
- (void)setupNav {
    [self setNavTitle:@"扫描二维码"];
    self.leftButton.hidden = YES;
    [self setRightBtnNomalImage:[UIImage imageNamed:@"close"] highlighted:nil];
}

-(void)rightAction {
    
    //停止扫描
    [self stopSYQRCodeReading];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)setupViews {
    
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    //摄像头判断
    NSError *error = nil;
    
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:device error:&error];
    
    if (error)
    {
        NSLog(@"没有摄像头-%@", error.localizedDescription);
        
        return;
    }
    
    //设置输出(Metadata元数据)
    AVCaptureMetadataOutput *output = [[AVCaptureMetadataOutput alloc] init];
    
    //设置输出的代理
    //使用主线程队列，相应比较同步，使用其他队列，相应不同步，容易让用户产生不好的体验
    [output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    [output setRectOfInterest:[self getReaderViewBoundsWithSize:CGSizeMake(kReaderViewWidth, kReaderViewHeight)]];
    
    //拍摄会话
    AVCaptureSession *session = [[AVCaptureSession alloc] init];
    
    // 读取质量，质量越高，可读取小尺寸的二维码
    if ([session canSetSessionPreset:AVCaptureSessionPreset1920x1080])
    {
        [session setSessionPreset:AVCaptureSessionPreset1920x1080];
    }
    else if ([session canSetSessionPreset:AVCaptureSessionPreset1280x720])
    {
        [session setSessionPreset:AVCaptureSessionPreset1280x720];
    }
    else
    {
        [session setSessionPreset:AVCaptureSessionPresetPhoto];
    }
    
    if ([session canAddInput:input])
    {
        [session addInput:input];
    }
    
    if ([session canAddOutput:output])
    {
        [session addOutput:output];
    }
    
    //设置输出的格式
    //一定要先设置会话的输出为output之后，再指定输出的元数据类型
    [output setMetadataObjectTypes:@[AVMetadataObjectTypeQRCode]];
    
    //设置预览图层
    AVCaptureVideoPreviewLayer *preview = [AVCaptureVideoPreviewLayer layerWithSession:session];
    
    //设置preview图层的属性
    //preview.borderColor = [UIColor redColor].CGColor;
    //preview.borderWidth = 1.5;
    [preview setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    
    //设置preview图层的大小
    //preview.frame = self.view.layer.bounds;
    [preview setFrame:CGRectMake(0, kCameraViewY, kDeviceWidth, KDeviceHeight-kCameraViewY)];
    
    //将图层添加到视图的图层
    [self.view.layer insertSublayer:preview atIndex:0];
    //[self.view.layer addSublayer:preview];
    self.qrVideoPreviewLayer = preview;
    self.qrSession = session;
}

- (CGRect)getReaderViewBoundsWithSize:(CGSize)asize
{
    return CGRectMake(kLineMinY / KDeviceHeight, ((kDeviceWidth - asize.width) / 2.0) / kDeviceWidth, asize.height / KDeviceHeight, asize.width / kDeviceWidth);
}

- (void)setOverlayPickerView
{
    UIView *containerView = [[UIView alloc] init];
    containerView.frame = CGRectMake(0, kCameraViewY, kDeviceWidth, KDeviceHeight - kCameraViewY);
    [self.view addSubview:containerView];
    
    //画中间的基准线
    _line = [[UIImageView alloc] initWithFrame:CGRectMake((kDeviceWidth - kLineWidth) / 2.0, kLineMinY, kLineWidth, WDFitablePixel(4))];
    [_line setImage:[UIImage imageNamed:@"img_qr_line"]];
    [containerView addSubview:_line];
    
    //最上部view
    UIView* upView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, kLineMinY)];//80
    upView.alpha = 0.3;
    upView.backgroundColor = [UIColor blackColor];
    [containerView addSubview:upView];
    
    //左侧的view
    UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, kLineMinY, (kDeviceWidth - kReaderViewWidth) / 2.0, kReaderViewHeight)];
    leftView.alpha = 0.3;
    leftView.backgroundColor = [UIColor blackColor];
    [containerView addSubview:leftView];
    
    //右侧的view
    UIView *rightView = [[UIView alloc] initWithFrame:CGRectMake(kDeviceWidth - CGRectGetMaxX(leftView.frame), kLineMinY, CGRectGetMaxX(leftView.frame), kReaderViewHeight)];
    rightView.alpha = 0.3;
    rightView.backgroundColor = [UIColor blackColor];
    [containerView addSubview:rightView];
    
    CGFloat space_h = KDeviceHeight - kLineMaxY;
    
    //底部view
    UIView *downView = [[UIView alloc] initWithFrame:CGRectMake(0, kLineMaxY, kDeviceWidth, space_h)];
    downView.alpha = 0.3;
    downView.backgroundColor = [UIColor blackColor];
    [containerView addSubview:downView];
    
    //四个边角
    UIImage *cornerImage = [UIImage imageNamed:@"img_qr_tl"];
    
    //左侧的view
    UIImageView *leftView_image = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(leftView.frame), CGRectGetMaxY(upView.frame), cornerImage.size.width, cornerImage.size.height)];
    leftView_image.image = cornerImage;
    [containerView addSubview:leftView_image];
    
    cornerImage = [UIImage imageNamed:@"img_qr_tr"];
    
    //右侧的view
    UIImageView *rightView_image = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMinX(rightView.frame) - cornerImage.size.width, CGRectGetMaxY(upView.frame), cornerImage.size.width, cornerImage.size.height)];
    rightView_image.image = cornerImage;
    [containerView addSubview:rightView_image];
    
    cornerImage = [UIImage imageNamed:@"img_qr_bl"];
    
    //底部view
    UIImageView *downView_image = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(leftView.frame), CGRectGetMinY(downView.frame) - cornerImage.size.height, cornerImage.size.width, cornerImage.size.height)];
    downView_image.image = cornerImage;
    //downView.backgroundColor = [UIColor blackColor];
    [containerView addSubview:downView_image];
    
    cornerImage = [UIImage imageNamed:@"img_qr_br"];
    
    UIImageView *downViewRight_image = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMinX(rightView.frame) - cornerImage.size.width , CGRectGetMinY(downView.frame) - cornerImage.size.height, cornerImage.size.width, cornerImage.size.height)];
    downViewRight_image.image = cornerImage;
    //downView.backgroundColor = [UIColor blackColor];
    [containerView addSubview:downViewRight_image];
    
    //说明label
    UILabel *labIntroudction = [[UILabel alloc] init];
    labIntroudction.backgroundColor = WDColor_5;
    labIntroudction.alpha = 0.6;
    labIntroudction.frame = CGRectMake(CGRectGetMaxX(leftView.frame), CGRectGetMinY(downView.frame) + 70, kReaderViewWidth, 38);
    labIntroudction.textAlignment = NSTextAlignmentCenter;
    labIntroudction.font = WDFont_14;
    labIntroudction.textColor = [UIColor whiteColor];
    labIntroudction.text = @"请将二维码置于框内";
    [containerView addSubview:labIntroudction];
    
}


#pragma mark -
#pragma mark 交互事件

- (void)startSYQRCodeReading
{
    _lineTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 / 20 target:self selector:@selector(animationLine) userInfo:nil repeats:YES];
    
    [self.qrSession startRunning];
    
    NSLog(@"start reading");
}

- (void)stopSYQRCodeReading
{
    if (_lineTimer)
    {
        [_lineTimer invalidate];
        _lineTimer = nil;
    }
    
    [self.qrSession stopRunning];
    
    NSLog(@"stop reading");
}


#pragma mark -
#pragma mark 上下滚动交互线

- (void)animationLine
{
    __block CGRect frame = _line.frame;
    
    static BOOL flag = YES;
    
    if (flag)
    {
        frame.origin.y = kLineMinY;
        flag = NO;
        
        [UIView animateWithDuration:1.0 / 20 animations:^{
            
            frame.origin.y += 5;
            _line.frame = frame;
            
        } completion:nil];
    }
    else
    {
        if (_line.frame.origin.y >= kLineMinY)
        {
            if (_line.frame.origin.y >= kLineMaxY - 12)
            {
                frame.origin.y = kLineMinY;
                _line.frame = frame;
                
                flag = YES;
            }
            else
            {
                [UIView animateWithDuration:1.0 / 20 animations:^{
                    
                    frame.origin.y += 5;
                    _line.frame = frame;
                    
                } completion:nil];
            }
        }
        else
        {
            flag = !flag;
        }
    }
    
    //NSLog(@"_line.frame.origin.y==%f",_line.frame.origin.y);
}



/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */


-(void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection{
    if (metadataObjects.count>0) {
        //停止扫描
        [self stopSYQRCodeReading];
        AVMetadataMachineReadableCodeObject * metadataObject = [metadataObjects objectAtIndex : 0 ];
        //输出扫描字符串
        NSLog(@"%@",metadataObject.stringValue);
        NSString *address = metadataObject.stringValue;
        if([address containsString:@"eth:"]){
            address = [address stringByReplacingOccurrencesOfString:@"eth:" withString:@""];
        }
        [self.navigationController popViewControllerAnimated:NO];
        if ([self.delegate respondsToSelector:@selector(qRCodeScanViewController:value:)]) {
            [self.delegate qRCodeScanViewController:self value:address];
        }
        
    }
}

@end
