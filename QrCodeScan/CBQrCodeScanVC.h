//
//  ViewController.h
//  LCQRcodeScan
//
//  Created by caobo56 on 16/6/30.
//  Copyright © 2016年 caobo56. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 选择器的回调
 
 @param vc 当前CBQrCodeScanVC对象
 @param error error
 @param content 识别出的内容
 */
@class CBQrCodeScanVC;
typedef void(^CBQrCodeScanCompletion)(CBQrCodeScanVC * vc,NSError* error,NSString * content);

@interface CBQrCodeScanVC : UIViewController

@property (weak,nonatomic)CBQrCodeScanCompletion comp;

-(void)hiddenFlashBtn:(BOOL)type;
-(void)hiddenFlashBtn:(BOOL)type;

@end

