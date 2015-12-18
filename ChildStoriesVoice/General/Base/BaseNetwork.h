//
//  BaseNetwork.h
//  DBMeiziFuli
//
//  Created by jackyshan on 9/14/15.
//  Copyright © 2015 jackyshan. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef enum : NSUInteger { NWFlagNone, NWFlagToken } NWFlag;

typedef enum { HttpMethodPost, HttpMethodGet } HttpMethodType;

typedef enum {
  CacheTypeUseCahe,
  CacheTypeUseServer,
  CacheTypeCacheAndServer
} CacheType;

typedef enum {
    ServerTypeNormal,
    ServerTypeTest
} ServerType;

@interface BaseNetwork : NSObject {
  NSDictionary *_params;
  NWFlag _flag;
  CacheType _cacheType;
  NSArray *_files;
  BOOL _pureJSONData;

  BOOL _fileDownload;
  BOOL _breakResume;
  NSString *_fileSavePath;

  ServerType _serverType;
}

@property (nonatomic, strong)  NSString *path;

/**
 *  请求完成的回调
 */
@property(nonatomic, copy) void (^completion)(id result, BOOL succ);
@property (nonatomic, assign, readonly) BOOL isCache;

/**
 *  开始get请求
 */
- (void)startGet;
/**
 *  开始post请求
 */
- (void)startPost;


/**
 *  请求完成, 虚函数
 *
 *  @param result 请求的结果
 *  @param succ   是否成功请求
 */
- (void)dealComplete:(id)result succ:(BOOL)succ;


/**
 *  开始请求,虚函数
 */
- (void)startRequest;
- (void)startRequestWithCache:(CacheType)type;
//- (void)startRequest:(NSDictionary *)params;
- (void)startRequestWithParams:(NSDictionary *)params;


/**
 *  取消正在进行的请求
 */
- (void)cancel;
+ (void)cancelAllOperations;
+ (void)cancelLogin;

@end
