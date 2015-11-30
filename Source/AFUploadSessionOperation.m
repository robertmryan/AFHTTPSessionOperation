//
//  AFUploadSessionOperation.m
//  KaKa_iOS
//
//  Created by Calvin Sun on 15/11/30.
//  Copyright © 2015年 com.opentrans. All rights reserved.
//

#import "AFUploadSessionOperation.h"
#import "AFNetworking.h"

@interface AFUploadSessionOperation ()

@property (nonatomic, strong) AFHTTPSessionManager *manager;
@property (nonatomic, strong) NSURLRequest *request;
@property (nonatomic, strong) NSData *bodyData;
@property (strong, nonatomic) NSProgress *progress;
@property (nonatomic, copy) void (^progressUpdate)(NSProgress *progress);
@property (nonatomic, copy) void (^success)(NSURLResponse *response, id responseObject);
@property (nonatomic, copy) void (^failure)(NSURLResponse *response, NSError * error);

@property (nonatomic, weak) NSURLSessionTask *task;

@end


@implementation AFUploadSessionOperation

+ (nullable instancetype)operationWithManager:(AFHTTPSessionManager *)manager
                                      request:(NSURLRequest *)request
                                     fromData:(NSData *)bodyData
                               progressUpdate:(void (^)(NSProgress *progress))progressUpdate
                                      success:(nullable void (^)(NSURLResponse *response, id responseObject))success
                                      failure:(nullable void (^)(NSURLResponse *response, NSError * error))failure;
{
    AFUploadSessionOperation *operation = [[self alloc] init];
    
    operation.manager = manager;
    operation.request = request;
    operation.bodyData = bodyData;
    operation.progressUpdate = progressUpdate;
    operation.success = success;
    operation.failure = failure;
    
    return operation;
}

- (void)main
{
    NSProgress *progress = nil;
    NSURLSessionUploadTask *uploadTask = [_manager uploadTaskWithRequest:_request
                                                                fromData:_bodyData
                                                                progress:&progress
                                                       completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error)
    {
        if (error) {
            if (_failure) {
                _failure(response, error);
            }
        } else {
            if (_success) {
                _success(response, responseObject);
            }
        }
        [self completeOperation];
    }];
    
    [progress addObserver:self
               forKeyPath:NSStringFromSelector(@selector(fractionCompleted))
                  options:NSKeyValueObservingOptionInitial
                  context:nil];
    _progress = progress;
    
    [uploadTask resume];
    _task = uploadTask;
}

- (void)completeOperation
{
    self.failure = nil;
    self.success = nil;
    
    [super completeOperation];
}

- (void)cancel
{
    [self.task cancel];
    
    [super cancel];
}

#pragma mark - KVO method

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    if ([keyPath isEqualToString:NSStringFromSelector(@selector(fractionCompleted))]) {
        if ([_progress isEqual:object] && _progressUpdate) {
            _progressUpdate(object);
        }
    }
}

@end
