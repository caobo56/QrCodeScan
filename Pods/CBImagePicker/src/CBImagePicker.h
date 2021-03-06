//
//  CBImagePicker.h
//  ABCreditApp
//
//  Created by caobo56 on 2017/3/13.
//  Copyright © 2017年 caobo56. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class CBImagePicker;
/**
 选择器的回调

 @param picker 当前picker对象
 @param error error
 @param image 图片
 */
typedef void(^PickerCompletion)(CBImagePicker * picker,NSError* error,UIImage* image);

@interface CBImagePicker : NSObject


/**
 单例模式，可以直接获取对象

 @return CBImagePicker
 */
+(instancetype)shared;


/**
 设置当前选择器的VC

 @param vc 当前选择器的VC
 */
-(void)startWithVC:(UIViewController *)vc;


/**
 选择器的回调

 @param comp 回调中有图片
 */
-(void)setPickerCompletion:(PickerCompletion)comp;

@end
