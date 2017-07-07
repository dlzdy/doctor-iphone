//
//  ScanViewController.m
//  doctor-iphone
//
//  Created by zhangdy on 17/7/6.
//  Copyright © 2017年 zhangdy. All rights reserved.
//

#import "QRCodeScanningVC.h"

#import "SGQRCode.h"
@interface QRCodeScanningVC () <SGQRCodeScanManagerDelegate>
@property (nonatomic, strong) SGQRCodeScanningView *scanningView;
@property (nonatomic, strong) SGQRCodeScanManager *manager;
@end




@implementation QRCodeScanningVC


- (void)viewDidLoad {
    NSLog(@"viewDidLoad");
    [super viewDidLoad];
    
    //设置背景
    self.view.backgroundColor = [UIColor clearColor];
    
    [self.view addSubview:self.scanningView];

    //创建按钮，居中，点击后打开扫描
    UIButton *btnScan = [[UIButton alloc]init];
    [btnScan setTitle:@"开始扫描" forState:UIControlStateNormal];
    btnScan.frame = CGRectMake(50, 60, 150, 50);
    //监听点击事件
    [btnScan addTarget:self action:@selector(btnScanClick) forControlEvents:UIControlEventTouchUpInside];
    btnScan.backgroundColor= [UIColor greenColor];
    [self.view addSubview:btnScan];

    [self setupQRCodeScanning];

}

/**
 * when show
 */
- (void)viewDidAppear:(BOOL)animated {
    NSLog(@"viewDidAppear");
    [super viewDidAppear:animated];
    //增加全屏预览+扫描框
    [self.scanningView addTimer];
    
    [_manager startRunning];
}

/**
 * when hide
 */
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    NSLog(@"viewWillDisappear");
    
    [_manager stopRunning];//停止扫描
    [self removeScanningView];//
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/**
 * 点击扫描按钮执行动作
 */
- (void)btnScanClick {
    //打开二维码扫描
    NSLog(@"开始二维码扫描");
    [_manager startRunning];

}



#pragma 二维码扫描获取数据的回调方法
- (void)QRCodeScanManager:(SGQRCodeScanManager *)scanManager didOutputMetadataObjects:(NSArray *)metadataObjects{
    if (metadataObjects.count > 0) {
        AVMetadataMachineReadableCodeObject *metadataObj = [metadataObjects objectAtIndex:0];
        NSLog(@"scan result = %@", metadataObj.stringValue);
        
        // 播放声音
        [scanManager palySoundName:@"SGQRCode.bundle/sound.caf"];
        
        // 停止扫描
        [scanManager stopRunning];
        
        // 删除定时器，停止扫描动画
        [self removeScanningView];
        

        //
    }
}

/**
 * 扫描预览窗口
 */
- (SGQRCodeScanningView *)scanningView {
    if (!_scanningView) {
        _scanningView = [SGQRCodeScanningView scanningViewWithFrame:self.view.bounds layer:self.view.layer];
    }
    return _scanningView;
}

/**
 * 创建二维码扫描
 */
- (void)setupQRCodeScanning{
    _manager = [SGQRCodeScanManager sharedManager];
    NSArray *arr = @[AVMetadataObjectTypeQRCode, AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeCode128Code];
    [_manager setupSessionPreset:AVCaptureSessionPreset1920x1080 metadataObjectTypes:arr currentController:self];
    _manager.delegate = self;
}

- (void)dealloc {
    NSLog(@"SGQRCodeScanningVC - dealloc");
    [self removeScanningView];
}

- (void)removeScanningView {
    if (_scanningView) {
        // 关灯光
        [self.scanningView turnOnLight:NO];
        // 定时器
        [self.scanningView removeTimer];
        // 删除全屏预览框
        // [_manager SG_videoPreviewLayerRemoveFromSuperlayer];
        // 删除自己
        //[self.scanningView removeFromSuperview];//
 
        //self.scanningView = nil;
    }
}

@end
