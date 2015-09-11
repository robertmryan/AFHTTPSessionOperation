//
//  ConcurrentOperation.m
//

#import "ConcurrentOperation.h"

@interface ConcurrentOperation ()

@property (nonatomic, getter = isFinished, readwrite)  BOOL finished;
@property (nonatomic, getter = isExecuting, readwrite) BOOL executing;

@end

@implementation ConcurrentOperation

@synthesize finished  = _finished;
@synthesize executing = _executing;

- (id)init {
    self = [super init];
    if (self) {
        _finished  = NO;
        _executing = NO;
    }
    return self;
}

- (void)start {
    if ([self isCancelled]) {
        self.finished = YES;
        return;
    }

    self.executing = YES;

    [self main];
}

- (void)completeOperation {
    self.executing = NO;
    self.finished  = YES;
}

#pragma mark - NSOperation methods

- (BOOL)isConcurrent {
    return YES;
}

- (BOOL)isAsynchronous {
    return YES;
}

- (BOOL)isExecuting {
    @synchronized(self) {
        return _executing;
    }
}

- (BOOL)isFinished {
    @synchronized(self) {
        return _finished;
    }
}

- (void)setExecuting:(BOOL)executing {
    @synchronized(self) {
        NSString *key = NSStringFromSelector(@selector(isExecuting));
        
        if (_executing != executing) {
            [self willChangeValueForKey:key];
            _executing = executing;
            [self didChangeValueForKey:key];
        }
    }
}

- (void)setFinished:(BOOL)finished {
    @synchronized(self) {
        NSString *key = NSStringFromSelector(@selector(isFinished));
    
        if (_finished != finished) {
            [self willChangeValueForKey:key];
            _finished = finished;
            [self didChangeValueForKey:key];
        }
    }
}

@end
