//
//  ImageViewController.m
//  Decocamera2
//
//  Created by 井上圭一 on 2016/02/01.
//  Copyright © 2016年 keiichi, inoue. All rights reserved.
//

#import "ImageViewController.h"

@interface ImageViewController()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@property (weak, nonatomic) IBOutlet UIButton *grayButton;
@property (assign, nonatomic) BOOL isGray;

- (IBAction)saveButtonAction:(id)sender;
- (IBAction)grayButtonAction:(id)sender;
- (IBAction)backButtonAction:(id)sender;
- (IBAction)zoomButtonAction:(id)sender;
- (IBAction)miniButtonAction:(id)sender;

@end

@implementation ImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.imageView.image = self.editImage;
    self.isGray = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)saveButtonAction:(id)sender {
    
    SEL selector = @selector(onCompleteCapture:didFinishSavingWithError:contextInfo:);
    //画像を保存する
    UIImageWriteToSavedPhotosAlbum(self.imageView.image, self, selector, NULL);
}

//画像保存完了時のセレクタ
- (void)onCompleteCapture:(UIImage *)screenImage didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"保存終了" message:@"画像を保存しました" preferredStyle:UIAlertControllerStyleAlert];
    
    // addActionした順に左から右にボタンが配置されます
    [alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        // ボタンを押した際に処理が必要ならここに書きます。
        
    }]];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

- (IBAction)grayButtonAction:(id)sender {
    
    self.isGray = !self.isGray;
    
    if (self.isGray) {
        
        [self.grayButton setTitle:@"Reset" forState:UIControlStateNormal];
        
        UIImage *image = self.editImage;
        CGRect imageRect = (CGRect){0.0, 0.0, image.size.width, image.size.height};
        
        // CoreGraphicsのモノクロ色空間を準備します
        CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceGray();
        
        // ビットマップコンテキストを作りサイズと色空間を設定します
        CGContextRef context = CGBitmapContextCreate(nil, image.size.width, image.size.height, 8, 0, colorSpace, kCGImageAlphaNone);
        
        // ビットマップコンテキストに画像を描画します
        CGContextDrawImage(context, imageRect, [image CGImage]);
        
        // ビットマップコンテキストに描画された画像を取得します
        CGImageRef imageRef = CGBitmapContextCreateImage(context);
        
        // 取得した画像からUIImageを作ります
        UIImage *grayScaleImage = [UIImage imageWithCGImage:imageRef];
        
        // 準備した色空間、ビットマップコンテキスト、取得した画像をメモリから解放します
        CGColorSpaceRelease(colorSpace);
        CGContextRelease(context);
        CFRelease(imageRef);
        
        // Storyboard上のUIImageViewに画像を描画します
        self.imageView.image = grayScaleImage;
    } else {
        
        self.grayButton.titleLabel.text = @"Gray";
        [self.grayButton setTitle:@"Gray" forState:UIControlStateNormal];
        
        self.imageView.image = self.editImage;
    }
    
}

- (IBAction)backButtonAction:(id)sender {
    
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (IBAction)zoomButtonAction:(id)sender {
    
    self.imageView.image = nil;
    
    //UIImage作成
    UIImage *image = self.editImage;
    
    // 画像の幅
    CGFloat width = image.size.width;
    // 画像の高さ
    CGFloat height = image.size.height;
    // 拡大・縮小率
    CGFloat scale = 1.25f;
    
    //UIImageView作成
    UIImageView *imageView =[[UIImageView alloc]initWithImage:image];
    
    // 画像サイズ変更
    CGRect rect = CGRectMake(0, 0, width*scale, height*scale);
    // ImageView frame をCGRectMakeで作った矩形に合わせる
    imageView.frame = rect;
    // view に ImageView を追加する
    [self.imageView addSubview:imageView];
}

- (IBAction)miniButtonAction:(id)sender {

    self.imageView.image = nil;
    
    //UIImage作成
    UIImage *image = self.editImage;
    
    // 画像の幅
    CGFloat width = image.size.width;
    // 画像の高さ
    CGFloat height = image.size.height;
    // 拡大・縮小率
    CGFloat scale = 0.75f;
    
    //UIImageView作成
    UIImageView *imageView =[[UIImageView alloc]initWithImage:image];
    
    // 画像サイズ変更
    CGRect rect = CGRectMake(0, 0, width*scale, height*scale);
    // ImageView frame をCGRectMakeで作った矩形に合わせる
    imageView.frame = rect;
    // view に ImageView を追加する
    [self.imageView addSubview:imageView];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
