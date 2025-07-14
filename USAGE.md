# Zig Methods Package Usage Guide

This document explains how to use the features provided by this package, including wrappers for numbers and strings, a string builder, and enumerator utilities. Each section includes explanations and code examples.

---

## Table of Contents
- [Wrappers](#wrappers)
  - [Wrap](#wrap)
  - [IntWrapper](#intwrapper)
  - [FloatWrapper](#floatwrapper)
  - [StringWrapper](#stringwrapper)
  - [GenericWrapper](#genericwrapper)
- [StringBuilder](#stringbuilder)
- [Enumerator](#enumerator)
- [Importing the Package](#importing-the-package)

---

## Wrappers

Wrappers provide utility methods for numbers and strings. Use the `Wrap` function to automatically select the correct wrapper for a value. `Wrap` now returns a `Wrapper` union, so you must access the correct field (e.g., `.int`, `.float`, `.string`, `.generic`) before calling methods.

### Wrap
Wraps a value in the appropriate wrapper type based on its type. Returns a `Wrapper` union.

```zig
const methods = @import("methods");
const wrapped = methods.Wrap(i32, 42); // Returns Wrapper{ .int = IntWrapper_i64{ ... } }
// To use methods:
wrapped.int.isEven();
```

### IntWrapper
Provides methods for integer values. The union always uses `IntWrapper(i64)`.

```zig
const methods = @import("methods");
const int_wrap = methods.Wrap(i32, -5);
_ = int_wrap.int.isEven(); // false
_ = int_wrap.int.isOdd();  // true
_ = int_wrap.int.abs();    // 5
```

### FloatWrapper
Provides methods for floating-point values. The union always uses `FloatWrapper(f64)`.

```zig
const methods = @import("methods");
const float_wrap = methods.Wrap(f64, -3.14);
_ = float_wrap.float.isFinite(); // true
_ = float_wrap.float.isNaN();    // false
_ = float_wrap.float.abs();      // 3.14
```

### StringWrapper
Provides methods for string slices (`[]const u8`).

```zig
const methods = @import("methods");
const s = methods.Wrap([]const u8, "  Hello World!  ");
_ = s.string.startsWith("  He"); // true
_ = s.string.endsWith("!  ");    // true
_ = s.string.contains("World");  // true
_ = s.string.trim();              // "Hello World!"

// Methods that allocate require an allocator:
const std = @import("std");
var allocator = std.heap.page_allocator;
var reversed = try s.string.reverse(allocator);
var upper = try s.string.toUpper(allocator);
var lower = try s.string.toLower(allocator);
var parts = try s.string.split(allocator, ' ');
```

### GenericWrapper
Wraps any other type not covered above. The union uses `GenericWrapper(bool)`.

```zig
const methods = @import("methods");
const g = methods.Wrap(bool, true);
_ = g.generic.value; // true
```

---

## StringBuilder
Efficiently build strings by appending slices or characters.

```zig
const methods = @import("methods");
const std = @import("std");
var allocator = std.heap.page_allocator;
var sb = try methods.StringBuilder.init(allocator, 32);
defer sb.deinit();
try sb.append("Hello, ");
try sb.append("World!");
const result = sb.toSlice(); // "Hello, World!"
sb.clear();
```

---

## Enumerator
Iterate over slices with index and value.

```zig
const methods = @import("methods");
const data = [_]i32{ 10, 20, 30 };
var iter = methods.enumerate(i32, &data);
while (iter.next()) |item| {
    // item.index, item.value
}

// For mutable iteration:
var mut_data = [_]i32{ 1, 2, 3 };
var mut_iter = methods.enumerateMutable(i32, &mut_data);
while (mut_iter.next()) |item| {
    // item.value is mutable
}
```

---

## Importing the Package

Add this package to your `build.zig.zon` dependencies and import it in your Zig code:

```zig
const methods = @import("methods");
```

---

## Notes
- For methods that require an allocator, use `std.heap.page_allocator` or your own allocator.
- All wrappers expose the `.value` field for the underlying value.
- See the package tests in `src/lib.zig` for more usage examples. 