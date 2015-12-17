//
//  IAPHelper.m
//  iap
//
//  Created by jackyshan on 11/12/14.
//  Copyright (c) 2014 jackyshan. All rights reserved.
//

#import "IAPHelper.h"
#import <StoreKit/StoreKit.h>

@interface IAPHelper() {
    NSString *_productIdentifiers;
    BOOL _isRestore;
}

@property (nonatomic, copy) iapBlock iapBlock;

@property (nonatomic, strong) SKProductsRequest *request;

@end

@implementation IAPHelper

+ (IAPHelper *)sharedHelper {
    static IAPHelper *_sharedHelper = nil;
    static dispatch_once_t onetoken;
    dispatch_once(&onetoken, ^{
        _sharedHelper = [[self alloc] init];
    });
    return _sharedHelper;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
    }
    
    return self;
}

- (void)dealloc {
    [[SKPaymentQueue defaultQueue] removeTransactionObserver:self];
}

#pragma mark - 恢复购买
- (void)restoreProductIdentifier:(NSString *)productIdentifiers iapBlock:(iapBlock)block {
    if (!productIdentifiers)return;
    
    _productIdentifiers = productIdentifiers;
    if (![SKPaymentQueue canMakePayments]) {
        NSLog(@"失败，用户禁止应用内付费购买.");
        block(@"没开启苹果内购", NO);return;
    }
    
    if (self.iapBlock != block) {
        self.iapBlock = block;
    }
    
    [[SKPaymentQueue defaultQueue] restoreCompletedTransactions];
}

#pragma mark - 拉取购买项目
- (void)buyIapProduct:(NSString *)productIdentifiers iapBlock:(iapBlock)block {//拉取单个商品
    if (!productIdentifiers)return;
    
    _productIdentifiers = productIdentifiers;
    if (![SKPaymentQueue canMakePayments]) {
        NSLog(@"失败，用户禁止应用内付费购买.");
        block(@"没开启苹果内购", NO);return;
    }
    
    if (self.iapBlock != block) {
        self.iapBlock = block;
    }
    
    [self requestProducts:[NSSet setWithObject:productIdentifiers]];
}

- (void)requestProducts:(NSSet *)productIdentifiers {
    if (self.request) {
        return;
    }
    NSLog(@"request请求...");
    self.request = [[SKProductsRequest alloc] initWithProductIdentifiers:productIdentifiers];
    _request.delegate = self;
    [_request start];
}

- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response {
    NSLog(@"Received products results...");
    self.request = nil;
    if (!response.products.count) {
        self.iapBlock(@"获取商品信息失败", NO);return;
    }
    [self buyProductIdentifier:response.products[0]];
}

#pragma mark - 购买操作
- (void)buyProductIdentifier:(SKProduct *)productIdentifier {//开始购买
    NSLog(@"Buying %@...", productIdentifier.localizedTitle);
    
    SKPayment *payment = [SKPayment paymentWithProduct:productIdentifier];
    [[SKPaymentQueue defaultQueue] addPayment:payment];
}

- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions {//购买返回
    for (SKPaymentTransaction *transaction in transactions)
    {
        switch (transaction.transactionState)
        {
            case SKPaymentTransactionStatePurchased://交易完成
                NSLog(@"transactionIdentifier = %@", transaction.transactionIdentifier);
                [self completeTransaction:transaction];
                break;
            case SKPaymentTransactionStateFailed://交易失败
                [self failedTransaction:transaction];
                break;
            case SKPaymentTransactionStateRestored://已经购买过该商品
                NSLog(@"restoreIdentifier = %@", transaction.originalTransaction.transactionIdentifier);
                [self restoreTransaction:transaction];
                break;
            case SKPaymentTransactionStatePurchasing://商品添加进列表
                NSLog(@"商品添加进列表");
                break;
            default:
                break;
        }
    }
}

- (void)completeTransaction:(SKPaymentTransaction *)transaction {//购买完成
    NSLog(@"completeTransaction...");
    
    [self recordTransaction:transaction];
    [self provideContent: transaction.payment.productIdentifier];
    [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
}

- (void)restoreTransaction:(SKPaymentTransaction *)transaction {//购买过恢复交易
    NSLog(@"restoreTransaction...");
    [self recordTransaction: transaction];
    [self provideContent: transaction.originalTransaction.payment.productIdentifier];
    [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
}

- (void)failedTransaction:(SKPaymentTransaction *)transaction {//购买失败
    if(transaction.error.code != SKErrorPaymentCancelled) {
        NSString *errstr = [NSString stringWithFormat:@"%@", transaction.error.localizedDescription];
        self.iapBlock(errstr, NO);
    } else {
        NSLog(@"用户取消交易");
        self.iapBlock(@"取消购买", NO);
    }
    
    [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
}

- (void)paymentQueue:(SKPaymentQueue *)queue restoreCompletedTransactionsFailedWithError:(NSError *)error {//恢复购买取消
    self.iapBlock(error.localizedDescription, NO);
}

- (void)paymentQueueRestoreCompletedTransactionsFinished:(SKPaymentQueue *)queue {//恢复购买事务finished
    NSLog(@"恢复购买事务完成...");
    if (!_isRestore) {
        self.iapBlock(@"未购买过该商品", NO);
    }
}

- (void)recordTransaction:(SKPaymentTransaction *)transaction {//纪录这次交易
    // Optional: Record the transaction on the server side...
}

- (void)provideContent:(NSString *)productIdentifier {//同步购买完成的交易
    NSLog(@"Toggling flag for: %@", productIdentifier);
    
    NSURL *receiptURL = [[NSBundle mainBundle] appStoreReceiptURL];
    NSData *receipt = [NSData dataWithContentsOfURL:receiptURL];
    if (!receipt) {
        self.iapBlock(@"购买失败", NO);return;
    }
    else {
        if ([productIdentifier isEqualToString:_productIdentifiers]) {
            _isRestore = YES;
            NSLog(@"iap客户端成功支付,把receipt发送到服务端进行验证");
            self.iapBlock(receipt, YES);//把receipt发送到服务端进行验证
        }
    }
}

@end
