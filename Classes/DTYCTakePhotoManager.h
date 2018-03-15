//
//  DTYCTakePhotoManager.h
//  WaterPurifierProduct
//
//  Created by yc on 2017/11/22.
//  Copyright © 2017年 Cong Yao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef void(^ImageCallBackBlock)(UIImage *image);

@interface DTYCTakePhotoManager : NSObject

+ (instancetype)shareManager;

- (void)yc_showActionSheetCallBack:(ImageCallBackBlock)imageBlock;

@end
