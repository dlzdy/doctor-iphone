//
//  ScanViewController.m
//  doctor-iphone
//
//  Created by zhangdy on 17/7/6.
//  Copyright © 2017年 zhangdy. All rights reserved.
//

#import "ScanViewController.h"

#import "SGQRCode.h"
@interface ScanViewController () <AVCaptureMetadataOutputObjectsDelegate>
@property (strong,nonatomic)AVCaptureDevice *device;
@property (strong,nonatomic)AVCaptureDeviceInput *input;
@property (strong,nonatomic)AVCaptureMetadataOutput *output;
@property (strong,nonatomic)AVCaptureSession *session;
@property (strong,nonatomic)AVCaptureVideoPreviewLayer *preview;
@end

@implementation ScanViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //设置背景
    self.view.backgroundColor = [UIColor whiteColor];
    
    //创建按钮，居中，点击后打开扫描
    UIButton *btnScan = [[UIButton alloc]init];
    [btnScan setTitle:@"开始扫描" forState:UIControlStateNormal];
    btnScan.frame = CGRectMake(50, 100, 150, 50);

    //监听点击事件
    [btnScan addTarget:self action:@selector(btnScanClick) forControlEvents:UIControlEventTouchUpInside];
    //self.view.backgroundColor= [UIColor greenColor];
    [self.view addSubview:btnScan];

    // 设置摄像头
    //[self setupCapture];
    /// 扫描二维码创建
    SGQRCodeScanManager *manager = [SGQRCodeScanManager sharedManager];
    NSArray *arr = @[AVMetadataObjectTypeQRCode, AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeCode128Code];
    // AVCaptureSessionPreset1920x1080 推荐使用，对于小型的二维码读取率较高
    [manager SG_setupSessionPreset:AVCaptureSessionPreset1920x1080 metadataObjectTypes:arr currentController:self];
    manager.delegate = self;

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

    [self.view.layer insertSublayer:_preview atIndex:0];
    
    // 10、启动会话
    [_session startRunning];
}

/**
 * 初始化摄像头
 */
- (void)setupCapture {
    // 1、获取摄像设备
    _device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    // 2、创建设备输入流
    _input = [AVCaptureDeviceInput deviceInputWithDevice:self.device error:nil];
    
    // 3、创建数据输出流
    _output = [[AVCaptureMetadataOutput alloc] init];
    
    // 4、设置代理：在主线程里刷新
    [_output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    
    // 设置扫描范围（每一个取值0～1，以屏幕右上角为坐标原点）
    // 注：微信二维码的扫描范围是整个屏幕，这里并没有做处理（可不用设置）
    _output.rectOfInterest = CGRectMake(0.05, 0.2, 0.7, 0.6);
    
    // 5、创建会话对象
    _session = [[AVCaptureSession alloc] init];
    // 会话采集率: AVCaptureSessionPresetHigh
    _session.sessionPreset = AVCaptureSessionPresetHigh;
    
    // 6、添加设备输入流到会话对象
    if ([_session canAddInput:_input]) {
        [_session addInput:_input];
    }
    
    // 7、添加设备输入流到会话对象
    if ([_session canAddOutput:_output]) {
        [_session addOutput:_output];
    }
    
    // 8、设置数据输出类型，需要将数据输出添加到会话后，才能指定元数据类型，否则会报错
    // 设置扫码支持的编码格式(如下设置条形码和二维码兼容)
    //    NSArray *metadataObjectTypes =
    //        [[NSArray alloc]initWithObjects:@[AVMetadataObjectTypeQRCode, AVMetadataObjectTypeEAN13Code,  AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeCode128Code]];
    //    _output.metadataObjectTypes = metadataObjectTypes;
    if (_input) {
    _output.metadataObjectTypes = @[AVMetadataObjectTypeQRCode, AVMetadataObjectTypeEAN13Code,  AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeCode128Code];//可以运行，不错
    }
    
    // 9、实例化预览图层, 传递_session是为了告诉图层将来显示什么内容
    _preview = [AVCaptureVideoPreviewLayer layerWithSession:_session];
    // 保持纵横比；填充层边界
    _preview.videoGravity = AVLayerVideoGravityResizeAspectFill;
    _preview.frame = self.view.layer.bounds;
}
/**
 * 扫描成功返回字符串
 */
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection {
    if (metadataObjects.count > 0) {
        AVMetadataMachineReadableCodeObject *metadataObj = [metadataObjects objectAtIndex:0];
        NSLog(@"scan result = %@", metadataObj.stringValue);
    }
}

/// 二维码扫描获取数据的回调方法
- (void)QRCodeScanManager:(SGQRCodeScanManager *)scanManager didOutputMetadataObjects:(NSArray *)metadataObjects{
    if (metadataObjects.count > 0) {
        AVMetadataMachineReadableCodeObject *metadataObj = [metadataObjects objectAtIndex:0];
        NSLog(@"scan result = %@", metadataObj.stringValue);
    }
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
