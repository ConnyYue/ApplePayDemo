//
//  ViewController.h
//  ApplePayDemo
//
//  Created by 岳琛 on 2017/2/22.
//  Copyright © 2017年 Enhance. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController


/**
 ApplePay的Merchant ID证书需要自己配置 并在工程的capabilities中开启ApplyPay
 */


/**
 * 支付授权的流程：
 
 框架发送支付请求给安全模块，只有安全模块可以访问存储在设备上的标记化的卡信息。
 安全模块把特定的卡和商家等支付数据加密，以保证只有苹果可以读取，然后发送给框架。框架会将这些数据发送给苹果。
 苹果服务器再次加密这些支付数据，以保证只有商家可以读取。然后服务器对它进行签名，生成支付token，然后发送给设备。
 框架调用相应的代理方法并传入这个token，然后你的代理方法传送token给你的服务器。
 */


/**
 服务器接收到token处理流程:
 
 验证支付数据的哈希表和签名
 为加密过的支付数据解码
 向支付处理系统提交支付数据
 向订单追踪系统提交订单
 处理支付请求时，你有两个选择；你既可以利用支付平台处理支付请求，也可以自己实现支付请求处理流程。
 一个常用的支付平台可以完成上述大部分操作。
 */

@end

