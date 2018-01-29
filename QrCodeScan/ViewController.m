//
//  ViewController.m
//  LCQRcodeScan
//
//  Created by caobo56 on 16/6/30.
//  Copyright © 2018年 caobo56. All rights reserved.
//

#import "ViewController.h"
#import <CBQrCodeScanVC.h>
@class CBQrCodeScanVC;
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)startScan:(id)sender {
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
}


@end
