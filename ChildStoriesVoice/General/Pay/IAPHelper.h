//
//  IAPHelper.h
//  iap
//
//  Created by jackyshan on 11/12/14.
//  Copyright (c) 2014 jackyshan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <StoreKit/StoreKit.h>

typedef void(^iapBlock)(id result, BOOL succ);

@interface IAPHelper : NSObject<SKProductsRequestDelegate, SKPaymentTransactionObserver>

+ (IAPHelper *)sharedHelper;

- (void)restoreProductIdentifier:(NSString *)productIdentifiers iapBlock:(iapBlock)block;
- (void)buyIapProduct:(NSString *)productIdentifiers iapBlock:(iapBlock)block;

@end