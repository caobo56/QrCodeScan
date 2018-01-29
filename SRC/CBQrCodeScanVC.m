//
//  ViewController.m
//  LCQRcodeScan
//
//  Created by caobo56 on 16/6/30.
//  Copyright © 2016年 caobo56. All rights reserved.
//

#import "CBQrCodeScanVC.h"
#import <AVFoundation/AVFoundation.h>
#import "ABImagePicker.h"

/**
 *  屏幕 高 宽 边界
 */
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
#define SCREEN_WIDTH  [UIScreen mainScreen].bounds.size.width
#define SCREEN_BOUNDS  [UIScreen mainScreen].bounds

#define TOP (SCREEN_HEIGHT-220)/2
#define LEFT (SCREEN_WIDTH-220)/2

#define kScanRect CGRectMake(LEFT, TOP, 220, 220)

@interface CBQrCodeScanVC ()<AVCaptureMetadataOutputObjectsDelegate>{
    int num;
    BOOL upOrdown;
    NSTimer * timer;
    CAShapeLayer *cropLayer;
}
@property (strong,nonatomic)AVCaptureDevice * device;
@property (strong,nonatomic)AVCaptureDeviceInput * input;
@property (strong,nonatomic)AVCaptureMetadataOutput * output;
@property (strong,nonatomic)AVCaptureSession * session;
@property (strong,nonatomic)AVCaptureVideoPreviewLayer * preview;

@property (nonatomic, strong) UIImageView * line;

@end

@implementation CBQrCodeScanVC{
    UIButton * flashBtn;
    BOOL flashBtnHidden;
    
    UIButton * albumBtn;
    BOOL albumBtnHidden;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        flashBtnHidden = NO;
        albumBtnHidden = NO;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self configView];
    
}

-(BOOL)prefersStatusBarHidden{
    return  YES;
}

-(void)configView{
    
    UIImageView * imageView = [[UIImageView alloc]initWithFrame:kScanRect];
    imageView.image = [UIImage imageNamed:@"pick_bg"];
    [self.view addSubview:imageView];
    
    UILabel * titleLable = [[UILabel alloc]init];
    
    [titleLable setFrame:CGRectMake(imageView.frame.origin.x, imageView.frame.origin.y+imageView.frame.size.height, imageView.frame.size.width, 44)];
    titleLable.font = [UIFont systemFontOfSize:14.0f];
    titleLable.textColor = [UIColor whiteColor];
    titleLable.backgroundColor = [UIColor clearColor];
    titleLable.textAlignment = NSTextAlignmentCenter;
    titleLable.text = @"将扫描框对准二维码即可自动扫描";
    [self.view addSubview:titleLable];
    if (!flashBtnHidden) {
        flashBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [flashBtn setFrame:CGRectMake(imageView.frame.origin.x, imageView.frame.origin.y+imageView.frame.size.height
                                      -44, imageView.frame.size.width, 44)];
        [flashBtn setTitle:@"打开闪光灯" forState:UIControlStateNormal];
        [flashBtn setTitle:@"关闭闪光灯" forState:UIControlStateSelected];
        flashBtn.backgroundColor = [UIColor clearColor];
        flashBtn.titleLabel.font = [UIFont systemFontOfSize:14.0f];
        flashBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        [flashBtn addTarget:self action:@selector(openFlash:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:flashBtn];
    }
    
    if (!albumBtnHidden) {
        albumBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [albumBtn setFrame:CGRectMake(titleLable.frame.origin.x, titleLable.frame.origin.y+titleLable.frame.size.height
                                      +5, imageView.frame.size.width, 44)];
        [albumBtn setTitle:@"我的二维码" forState:UIControlStateNormal];
        albumBtn.backgroundColor = [UIColor clearColor];
        albumBtn.titleLabel.font = [UIFont systemFontOfSize:14.0f];
        albumBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        [albumBtn addTarget:self action:@selector(openAlbum:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:albumBtn];
    }
    upOrdown = NO;
    num =0;
    _line = [[UIImageView alloc] initWithFrame:CGRectMake(LEFT, TOP+10, 220, 2)];
    _line.image = [UIImage imageNamed:@"line.png"];
    [self.view addSubview:_line];
    
    timer = [NSTimer scheduledTimerWithTimeInterval:.02 target:self selector:@selector(animationUpDown) userInfo:nil repeats:YES];
    

}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setCropRect:kScanRect];
    [self performSelector:@selector(setupCamera) withObject:nil afterDelay:0.3];
}

-(void)hiddenFlashBtn:(BOOL)type{
    flashBtnHidden = type;
}

-(void)hiddenAlbumBtn:(BOOL)type{
    albumBtnHidden = type;
}

- (void)openFlash:(UIButton *)sender {
    
    sender.selected = !sender.selected;
    if (sender.isSelected == YES) { //打开闪光灯
        AVCaptureDevice *captureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
        NSError *error = nil;
        
        if ([captureDevice hasTorch]) {
            BOOL locked = [captureDevice lockForConfiguration:&error];
            if (locked) {
                captureDevice.torchMode = AVCaptureTorchModeOn;
                [captureDevice unlockForConfiguration];
            }
        }
    }else{//关闭闪光灯
        AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
        if ([device hasTorch]) {
            [device lockForConfiguration:nil];
            [device setTorchMode: AVCaptureTorchModeOff];
            [device unlockForConfiguration];
        }
    }
}

-(void)openAlbum:(UIButton *)sender{
    ABImagePicker * picker = [ABImagePicker shared];
    [picker startWithVC:self];
    [picker setPickerCompletion:^(ABImagePicker * picker, NSError *error, UIImage *image) {
        if (!error) {
            //图片可用
            CIDetector * detector = [CIDetector detectorOfType:CIDetectorTypeQRCode context:nil options:@{CIDetectorAccuracy:CIDetectorAccuracyHigh}];
            NSData*imageData = UIImagePNGRepresentation(image);
            CIImage*ciImage = [CIImage imageWithData:imageData];
            NSArray*features = [detector featuresInImage:ciImage];
            CIQRCodeFeature*feature = [features objectAtIndex:0];
            NSString*scannedResult = feature.messageString;
            dispatch_async(dispatch_get_main_queue(), ^{
                if (_comp) {
                    __weak typeof(self) weakSelf = self;
                    _comp(weakSelf,nil,scannedResult);
                }
            });
        }else{
            //error 中会有错误的说明
        }
    }];
}

-(void)animationUpDown
{
    if (upOrdown == NO) {
        num ++;
        _line.frame = CGRectMake(LEFT, TOP+10+2*num, 220, 2);
        if (2*num == 200) {
            upOrdown = YES;
        }
    }
    else {
        num --;
        _line.frame = CGRectMake(LEFT, TOP+10+2*num, 220, 2);
        if (num == 0) {
            upOrdown = NO;
        }
    }
    
}


- (void)setCropRect:(CGRect)cropRect{
    cropLayer = [[CAShapeLayer alloc] init];
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, nil, cropRect);
    CGPathAddRect(path, nil, self.view.bounds);
    
    [cropLayer setFillRule:kCAFillRuleEvenOdd];
    [cropLayer setPath:path];
    [cropLayer setFillColor:[UIColor blackColor].CGColor];
    [cropLayer setOpacity:0.6];
    
    [cropLayer setNeedsDisplay];
    
    [self.view.layer addSublayer:cropLayer];

}

- (void)setupCamera
{
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    if (device==nil) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"设备没有摄像头" preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }]];
        [self presentViewController:alert animated:YES completion:nil];
        return;
    }
    // Device
    _device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    // Input
    _input = [AVCaptureDeviceInput deviceInputWithDevice:self.device error:nil];
    
    // Output
    _output = [[AVCaptureMetadataOutput alloc]init];
    [_output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    
    //设置扫描区域
    CGFloat top = TOP/SCREEN_HEIGHT;
    CGFloat left = LEFT/SCREEN_WIDTH;
    CGFloat width = 220/SCREEN_WIDTH;
    CGFloat height = 220/SCREEN_HEIGHT;
    ///top 与 left 互换  width 与 height 互换
    [_output setRectOfInterest:CGRectMake(top,left, height, width)];

   
    // Session
    _session = [[AVCaptureSession alloc]init];
    [_session setSessionPreset:AVCaptureSessionPresetHigh];
    if ([_session canAddInput:self.input])
    {
        [_session addInput:self.input];
    }
    
    if ([_session canAddOutput:self.output])
    {
        [_session addOutput:self.output];
    }
    
    // 条码类型 AVMetadataObjectTypeQRCode
    [_output setMetadataObjectTypes:[NSArray arrayWithObjects:AVMetadataObjectTypeQRCode, nil]];
    
    // Preview
    _preview =[AVCaptureVideoPreviewLayer layerWithSession:_session];
    _preview.videoGravity = AVLayerVideoGravityResizeAspectFill;
    _preview.frame =self.view.layer.bounds;
    [self.view.layer insertSublayer:_preview atIndex:0];
    
    // Start
    [_session startRunning];
}

#pragma mark AVCaptureMetadataOutputObjectsDelegate
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    NSString *stringValue;
    
    if ([metadataObjects count] >0)
    {
        //停止扫描
        [_session stopRunning];
        [timer setFireDate:[NSDate distantFuture]];
        
        AVMetadataMachineReadableCodeObject * metadataObject = [metadataObjects objectAtIndex:0];
        stringValue = metadataObject.stringValue;
//        NSLog(@"扫描结果：%@",stringValue);
        
//        NSArray *arry = metadataObject.corners;
//        for (id temp in arry) {
//            NSLog(@"%@",temp);
//        }
        dispatch_async(dispatch_get_main_queue(), ^{
            if (_comp) {
                __weak typeof(self) weakSelf = self;
                _comp(weakSelf,nil,stringValue);
            }
        });
    } else {
//        NSLog(@"无扫描信息");
        return;
    }
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
