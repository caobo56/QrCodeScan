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

