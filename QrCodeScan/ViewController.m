//
//  ViewController.m
//  LCQRcodeScan
//
//  Created by caobo56 on 16/6/30.
//  Copyright © 2018年 刘通超. All rights reserved.
//

#import "ViewController.h"
#import "CBQrCodeScanVC.h"
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
    [vc hiddenFlashBtn:YES];
    //隐藏闪光灯按钮
    [vc setComp:^(CBQrCodeScanVC *vc, NSError *error, NSString *content) {
        if (!error) {
            NSLog(@"content = %@",content);
            [vc dismissViewControllerAnimated:YES completion:nil];
        }else{
            
        }
    }];
    [self presentViewController:vc animated:YES completion:nil];
}


@end
