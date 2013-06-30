TTTRandomizedEnumerator
=======
**Random Access (Collection) Memories**

Mix things up in your collection classes with style and class (well, a category, but you get the idea).

I think we can all make a little more room in our hearts for `NSEnumerator`, that fresh jam from 1995.

> Random aside: did you know you can reverse an `NSArray` in a single line with `NSEnumerator`? `array.reverseObjectEnumerator.allObjects`. Boom.

Anyway, this is the best way to randomly step through the objects of an `NSArray`, `NSSet`, or `NSOrderedSet`, as well as the keys and values of an `NSDictionary`.

## Example Usage

```objective-c
#import "TTTRandomizedEnumerator.h"

NSUInteger capacity = 100;
NSMutableArray *mutableNumbers = [NSMutableArray arrayWithCapacity:capacity];
for (NSUInteger i = 0; i < capacity; i++) {
    [mutableNumbers addObject:@(i)];
}

// Classic `NSEnumerator` use with `while` loop
NSNumber *number = nil;
NSEnumerator *enumerator = [mutableNumbers randomizedObjectEnumerator];
while ((number = [enumerator nextObject])) {
    NSLog(@"%@", number);
}

// `NSEnumerator` also conforms to `<NSFastEnumeration>`
for (NSNumber *number in [mutableNumbers randomizedObjectEnumerator]) {
    NSLog(@"%@", number);
}
```

## Category Methods

### `NSArray`

```objective-c
- (NSEnumerator *)randomizedObjectEnumerator;
```

### `NSSet`

```objective-c
- (NSEnumerator *)randomizedObjectEnumerator;
```

### `NSOrderedSet`

```objective-c
- (NSEnumerator *)randomizedObjectEnumerator;
```

### `NSDictionary`

```objective-c
- (NSEnumerator *)randomizedKeyEnumerator;
- (NSEnumerator *)randomizedObjectEnumerator;
```

## Contact

Mattt Thompson

- http://github.com/mattt
- http://twitter.com/mattt
- m@mattt.me

## License

TTTRandomizedEnumerator is available under the MIT license. See the LICENSE file for more info.
