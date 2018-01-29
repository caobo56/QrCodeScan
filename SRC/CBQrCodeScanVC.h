//
//  ViewController.h
//  LCQRcodeScan
//
//  Created by caobo56 on 16/6/30.
//  Copyright © 2016年 caobo56. All rights reserved.
//

#import <UIKit/UIKit.h>

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

-(void)hiddenFlashBtn:(BOOL)type;
-(void)hiddenAlbumBtn:(BOOL)type;

@end

