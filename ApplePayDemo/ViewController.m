//
//  ViewController.m
//  ApplePayDemo
//
//  Created by 岳琛 on 2017/2/22.
//  Copyright © 2017年 Enhance. All rights reserved.
//

#import "ViewController.h"
#import <PassKit/PassKit.h>

@interface ViewController ()<PKPaymentAuthorizationViewControllerDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self prepareToPay];
}

-(void)prepareToPay {
    
    if(![PKPaymentAuthorizationViewController canMakePayments]) {
        NSLog(@"当前设备不支持ApplePay");
        return;
    }

    if (![PKPaymentAuthorizationViewController canMakePaymentsUsingNetworks:@[PKPaymentNetworkAmex, PKPaymentNetworkMasterCard, PKPaymentNetworkVisa, PKPaymentNetworkChinaUnionPay]]) {
        NSLog(@"Wallet没有添加储蓄卡/信用卡");
        return;
    }

    [self startPay];
    
}

-(void)startPay {
    //1. 创建一个支付请求
    PKPaymentRequest *request = [[PKPaymentRequest alloc] init];
    
    // 2. 参数配置
    // 2.1
    request.merchantIdentifier = @"com.lalabb.ApplePayDemo";//商店标识 额外配置的merchant证书的merchantID
    request.currencyCode = @"CNY";//货币代码
    request.countryCode = @"CN";//国家编码
    
    // 2.2
    // 设置支付支持的网络  ！！！PKPaymentNetworkChinaUnionPay---iOS 9.2
    request.supportedNetworks = @[PKPaymentNetworkAmex, PKPaymentNetworkMasterCard, PKPaymentNetworkVisa, PKPaymentNetworkChinaUnionPay];
    
    // 2.3
    // 支付请求包含一个支付摘要项目的列表
    NSDecimalNumber *price1 = [NSDecimalNumber decimalNumberWithString:@"2"];
    PKPaymentSummaryItem *item1 = [PKPaymentSummaryItem summaryItemWithLabel:@"课程1" amount:price1];
    
    NSDecimalNumber *price2 = [NSDecimalNumber decimalNumberWithString:@"6"];
    PKPaymentSummaryItem *item2 = [PKPaymentSummaryItem summaryItemWithLabel:@"课程2" amount:price2 type:PKPaymentSummaryItemTypePending];
    
    NSDecimalNumber *totalAmount = [NSDecimalNumber zero];
    totalAmount = [totalAmount decimalNumberByAdding:price1];
    totalAmount = [totalAmount decimalNumberByAdding:price2];
    PKPaymentSummaryItem *total = [PKPaymentSummaryItem summaryItemWithLabel:@"公司财务部" amount:totalAmount type:PKPaymentSummaryItemTypePending];
    request.paymentSummaryItems = @[item1, item2, total];//项目1价格 项目2价格 ！！！第3个是总价
    
    // 2.4 运输方式
    NSDecimalNumber *shippingPrice = [NSDecimalNumber decimalNumberWithString:@"18.0"];
    PKShippingMethod *method = [PKShippingMethod summaryItemWithLabel:@"我是超级迅速的韵达" amount:shippingPrice];
    method.detail = @"大概三天内到达";
    method.identifier = @"yunda";
    request.shippingMethods = @[method];
    request.shippingType = PKShippingTypeServicePickup;
    
    // 2.5 通过指定merchantCapabilities属性来指定你支持的支付处理标准，3DS支付方式是必须支持的，EMV方式是可选的，
    request.merchantCapabilities = PKMerchantCapability3DS | PKMerchantCapabilityEMV | PKMerchantCapabilityCredit | PKMerchantCapabilityDebit;
    
    // 2.6 需要的配送信息和账单信息
    request.requiredBillingAddressFields = PKAddressFieldAll;
    request.requiredShippingAddressFields = PKAddressFieldAll;
    
    // 2.7 存储额外信息
    // applicationData属性来存储一些在你的应用中关于这次支付请求的唯一标识信息
    // 比如一个购物车的标识符。在用户授权支付之后，这个属性的哈希值会出现在这次支付的token中。
    request.applicationData = [@"购物车ID: 666666" dataUsingEncoding:NSUTF8StringEncoding];

    // 3. 开始支付
    PKPaymentAuthorizationViewController *paymentPane = [[PKPaymentAuthorizationViewController alloc] initWithPaymentRequest:request];
    if (paymentPane == nil) {
        NSLog(@"授权控制器创建失败");
        return;
    }
    paymentPane.delegate = self;
    [self presentViewController:paymentPane animated:YES completion:nil];
}

#pragma mark - PKPaymentAuthorizationViewController Delegate
/**
 *  当授权成功会调用这个代理方法
 */
- (void)paymentAuthorizationViewController:(PKPaymentAuthorizationViewController *)controller
                       didAuthorizePayment:(PKPayment *)payment
                                completion:(void (^)(PKPaymentAuthorizationStatus status))completion;
{
//    PKPayment *temp = payment;
    NSLog(@"验证授权---%@", payment.token);
    
    /**
     服务器验证
     */
    
    NSLog(@"验证通过后, 需要开发者继续完成交易");
    
    // 需要连接服务器 并上传支付令牌和订单信息 完成整个支付流程。
    BOOL isSuccess = YES;
    if (isSuccess) {
        completion(PKPaymentAuthorizationStatusSuccess);
    }else
    {
        completion(PKPaymentAuthorizationStatusFailure);
    }
    
}

/**
 *  当授权成功之后或者取消授权会调用这个代理方法
 */
- (void)paymentAuthorizationViewControllerDidFinish:(PKPaymentAuthorizationViewController *)controller
{
    NSLog(@"取消或者交易完成");
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
