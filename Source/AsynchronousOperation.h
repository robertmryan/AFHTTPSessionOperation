//
//  AsynchronousOperation.h
//

#import <Foundation/Foundation.h>

@interface AsynchronousOperation : NSOperation

/// Complete the asynchronous operation.
///
/// This also triggers the necessary KVO to support asynchronous operations.

- (void)completeOperation;

@end
