//
//  DTYCTakePhotoManager.m
//  WaterPurifierProduct
//
//  Created by yc on 2017/11/22.
//  Copyright © 2017年 Cong Yao. All rights reserved.
//

#import "DTYCTakePhotoManager.h"

@interface DTYCTakePhotoManager ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (nonatomic ,copy) ImageCallBackBlock imageCallBlock;
@property (nonatomic ,strong) NSData *imageData;
@property (nonatomic ,strong) UIImagePickerController *pickerVC;
@property (nonatomic ,strong) UIViewController *showViewController;

@end

@implementation DTYCTakePhotoManager


- (void)yc_showActionSheetImageCallBack:(ImageCallBackBlock)imageBlock{
    UIAlertController *alertcontroller = [UIAlertController alertControllerWithTitle:@"提示" message:@"请选择图片获取方式" preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    UIAlertAction *takePhoto = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self takePhoto];
    }];
    
    UIAlertAction *album = [UIAlertAction actionWithTitle:@"相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self album];
    }];
    self.imageCallBlock = imageBlock;
    [alertcontroller addAction:cancelAction];
    [alertcontroller addAction:takePhoto];
    [alertcontroller addAction:album];
    
    [self.showViewController presentViewController:alertcontroller animated:YES completion:nil];
}

- (UIViewController *)showViewController {
    if (!_showViewController) {
        UINavigationController *nvc = (UINavigationController *)[UIApplication sharedApplication].keyWindow.rootViewController;
        _showViewController = nvc.visibleViewController;
    }
    return _showViewController;
}

#pragma mark -
#pragma mark - 拍照
- (void)takePhoto {
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"设备不可用" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    self.pickerVC.sourceType = UIImagePickerControllerSourceTypeCamera;
    [self.showController presentViewController:self.pickerVC animated:YES completion:nil];
}

#pragma mark -
#pragma mark - 相册
- (void)album {

    self.pickerVC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self.showController presentViewController:self.pickerVC animated:YES completion:nil];
}

#pragma mark -
#pragma mark - private Method

- (void)imageRepresentation {

    UIImage *newImage = [UIImage  imageWithData:self.imageData];
    CGFloat compression = 0.9;
    CGFloat maxCompression = 0.1;
    CGFloat maxFileSize = 1024*100;
    NSData *compressedData = UIImageJPEGRepresentation(newImage, compression);
    while ([compressedData length] > maxFileSize && compression > maxCompression) {
        compression -= 0.1;
        UIImage *image_m = [UIImage imageWithData: compressedData];
        compressedData = UIImageJPEGRepresentation(image_m, compression);
        NSLog(@" ====== %ld",compressedData.length);
    }
    self.imageCallBlock([UIImage  imageWithData:compressedData]);
}


#pragma mark -
#pragma mark - delegate
// 完成选择
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    [picker dismissViewControllerAnimated:YES completion:nil];
    UIImage * image = [info objectForKey:UIImagePickerControllerEditedImage];  // 取出被编辑的图片
    self.imageData = UIImageJPEGRepresentation(image, 1.0f);
    [self imageRepresentation];
}

// 取消选择
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (UIImagePickerController *)pickerVC {
    if (!_pickerVC) {
        _pickerVC = [[UIImagePickerController alloc]init];
        _pickerVC.delegate = self;
        _pickerVC.allowsEditing = YES;
    }
    return _pickerVC;
}

@end
