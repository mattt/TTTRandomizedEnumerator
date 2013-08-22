// TTTRandomizedEnumerator.m
// 
// Copyright (c) 2013 Mattt Thompson (http://mattt.me)
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
// 
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
// 
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import "TTTRandomizedEnumerator.h"

#import <libkern/OSAtomic.h>

@interface TTTRandomizedEnumerator () {
    int32_t _idx;
}

@property (readwrite, nonatomic, strong) NSArray *objects;

- (id)initWithObjects:(NSArray *)objects;

@end

@implementation TTTRandomizedEnumerator

- (id)initWithObjects:(NSArray *)objects {
    self = [super init];
    if (!self) {
        return nil;
    }

    NSMutableArray *mutableObjects = [NSMutableArray arrayWithArray:objects];
    NSUInteger count = [mutableObjects count];
    // See http://en.wikipedia.org/wiki/Fisher–Yates_shuffle
    if (count > 1) {
      for (NSUInteger i = count - 1; i > 0; --i) {
          [mutableObjects exchangeObjectAtIndex:i withObjectAtIndex:arc4random_uniform((int32_t)(i + 1))];
      }
    }
    self.objects = mutableObjects;

    return self;
}

#pragma mark NSEnumerator

- (NSArray *)allObjects {
    NSUInteger idx = _idx;
    if (idx < [self.objects count]) {
        _idx = (int32_t)[self.objects count];
        return [self.objects subarrayWithRange:NSMakeRange(idx, [self.objects count] - idx)];
    }

    return nil;
}

- (id)nextObject {
    NSUInteger idx = _idx;
    if (idx < [self.objects count]) {
        OSAtomicIncrement32(&_idx);
        return [self.objects objectAtIndex:idx];
    }

    return nil;
}

@end

#pragma mark -

@implementation NSArray (TTTRandomizedEnumerator)

- (NSEnumerator *)randomizedObjectEnumerator {
    return [[TTTRandomizedEnumerator alloc] initWithObjects:self];
}

@end

#pragma mark -

@implementation NSSet (TTTRandomizedEnumerator)

- (NSEnumerator *)randomizedObjectEnumerator {
    return [[TTTRandomizedEnumerator alloc] initWithObjects:[self allObjects]];
}

@end

#pragma mark -

@implementation NSOrderedSet (TTTRandomizedEnumerator)

- (NSEnumerator *)randomizedObjectEnumerator {
    return [[TTTRandomizedEnumerator alloc] initWithObjects:[self array]];
}

@end

#pragma mark -

@implementation NSDictionary (TTTRandomizedEnumerator)

- (NSEnumerator *)randomizedKeyEnumerator {
    return [[TTTRandomizedEnumerator alloc] initWithObjects:[self allKeys]];
}

- (NSEnumerator *)randomizedObjectEnumerator {
    return [[TTTRandomizedEnumerator alloc] initWithObjects:[self allValues]];
}

@end
