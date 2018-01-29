# QrCodeScan
使用系统的AVMetadataObject类实现二维码扫描

有关二维码的介绍，我这里不做过多说明， 可以直接去基维百科查看.
IOS7之前，开发者进行扫码编程时，一般会借助第三方库。
常用的是ZBarSDKa和ZXingObjC.
IOS7之后，系统的AVMetadataObject类中，为我们提供了解析二维码的接口。
经过测试，使用原生API扫描和处理的效率非常高，远远高于第三方库。

### 使用方法：
使用pod 安装，也可以直接下载源码拖进工程
```
    pod 'QrCodeScan'
```
### 导入头文件
```
#import <CBQrCodeScanVC.h>
```

### 初始化CBQrCodeScanVC
```
CBQrCodeScanVC * vc = [[CBQrCodeScanVC alloc]init];
    [vc hiddenFlashBtn:NO];
    //NO为隐藏闪光灯按钮，默认为不隐藏，不隐藏可不用调取该方法
    [vc hiddenAlbumBtn:NO];
    //NO为隐藏相册按钮，默认为不隐藏，不隐藏可不用调取该方法
    [vc setComp:^(CBQrCodeScanVC *qrCodeScanVC, NSError *error, NSString *content) {
        if (!error) {
            NSLog(@"content = %@",content);
            //content 即为识别出二维码的字符串
            [qrCodeScanVC dismissViewControllerAnimated:YES completion:nil];
            //qrCodeScanVC 是识别二维码的VC 的 weak 引用，可以直接使用
        }else{
            
        }
    }];
    [self presentViewController:vc animated:YES completion:nil];
```

### 接口列表：
```
@class CBQrCodeScanVC;

/**
 选择器的回调

 @param vc vc 当前CBQrCodeScanVC对象
 @param error error error
 @param content content 识别出的内容
 */
typedef void(^CBQrCodeScanCompletion)(CBQrCodeScanVC * vc,NSError* error,NSString * content);

@interface CBQrCodeScanVC : UIViewController

@property (weak,nonatomic)CBQrCodeScanCompletion comp;
//回调的block


/**
 隐藏闪光灯按钮的方法，NO为隐藏闪光灯按钮，默认为不隐藏，不隐藏可不用调取该方法

 @param type NO为隐藏闪光灯按钮
 */
-(void)hiddenFlashBtn:(BOOL)type;

/**
 隐藏相册按钮的方法，NO为隐藏相册按钮，默认为不隐藏，不隐藏可不用调取该方法

 @param type NO为隐藏相册按钮
 */
-(void)hiddenAlbumBtn:(BOOL)type;

@end


```
