# methods: Utility Wrappers and Iterators for Zig

This package provides utility wrappers for numbers and strings, a string builder, and enumerator utilities for Zig. It is designed to be used as a Zig package.

## Features
- **Wrap**: Automatically wraps values in a union type for convenient methods on numbers and strings.
- **IntWrapper(i64)**: Methods for integer values (isEven, isOdd, abs).
- **FloatWrapper(f64)**: Methods for floating-point values (isFinite, isNaN, abs).
- **StringWrapper**: Methods for string slices (startsWith, endsWith, contains, reverse, toUpper, toLower, trim, split).
- **GenericWrapper(bool)**: For other types, exposes the value only.
- **StringBuilder**: Efficient string concatenation.
- **Enumerator**: Iterate over slices with index and value.

## Usage

### Wrapping Values

```zig
const methods = @import("methods");
const wrapped = methods.Wrap(i32, 42); // Returns Wrapper{ .int = IntWrapper_i64{ ... } }
wrapped.int.isEven(); // true
```

### IntWrapper
```zig
const int_wrap = methods.Wrap(i32, -5);
_ = int_wrap.int.isEven(); // false
_ = int_wrap.int.abs();    // 5
```

### FloatWrapper
```zig
const float_wrap = methods.Wrap(f64, -3.14);
_ = float_wrap.float.isFinite(); // true
_ = float_wrap.float.abs();      // 3.14
```

### StringWrapper
```zig
const s = methods.Wrap([]const u8, "  Hello World!  ");
_ = s.string.trim(); // "Hello World!"
```

### GenericWrapper
```zig
const g = methods.Wrap(bool, true);
_ = g.generic.value; // true
```

### StringBuilder
```zig
const std = @import("std");
var allocator = std.heap.page_allocator;
var sb = try methods.StringBuilder.init(allocator, 32);
defer sb.deinit();
try sb.append("Hello, ");
try sb.append("World!");
const result = sb.toSlice(); // "Hello, World!"
```

### Enumerator
```zig
const data = [_]i32{ 10, 20, 30 };
var iter = methods.enumerate(i32, &data);
while (iter.next()) |item| {
    // item.index, item.value
}
```

## Installation
Add this package to your `build.zig.zon` dependencies and import it in your Zig code:

```zig
const methods = @import("methods");
```

### Using as a Dependency from GitHub
To use this package in your own project, add it to your `build.zig.zon` dependencies like this:

```zig
.{
    .name = "myproject",
    .version = "0.1.0",
    .dependencies = .{
        .methods = .{
            .url = "https://github.com/yourusername/methods",
            // Optionally specify a tag, branch, or commit:
            // .tag = "v0.1.0",
            // .branch = "main",
            // .commit = "abcdef1234567890",
        },
    },
}
```

Replace `yourusername` and the repo name as appropriate. You can specify a tag, branch, or commit for versioning.

## Notes
- For methods that require an allocator, use `