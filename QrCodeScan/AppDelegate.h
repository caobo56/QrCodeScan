//
//  AppDelegate.h
//  QrCodeScan
//
//  Created by caobo56 on 2016/11/2.
//  Copyright © 2016年 caobo56. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

+ (instancetype)sharedAppDelegate;
@end

