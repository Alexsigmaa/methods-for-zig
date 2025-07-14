// methods/src/lib.zig
// Expose the public API of your modules.
pub const Wrap = @import("wrappers.zig").Wrap;
pub const IntWrapper = @import("wrappers.zig").IntWrapper;
pub const FloatWrapper = @import("wrappers.zig").FloatWrapper;
pub const StringWrapper = @import("wrappers.zig").StringWrapper;
pub const GenericWrapper = @import("wrappers.zig").GenericWrapper;

pub const enumerate = @import("enumerator.zig").enumerate;
pub const enumerateMutable = @import("enumerator.zig").enumerateMutable;
pub const Enumerator = @import("enumerator.zig").Enumerator;
pub const Item = @import("enumerator.zig").Item;

pub const StringBuilder = @import("string_builder.zig").StringBuilder;

// Tests for your package.
const std = @import("std");
const testing = std.testing;

test "StringWrapper trim" {
    const s = StringWrapper{ .value = "  hello world  " };
    try testing.expectEqualStrings("hello world", s.trim());
}

test "IntWrapper isEven/isOdd" {
    const ten = Wrap(i32, 10);
    try testing.expect(ten.int.isEven());
    try testing.expect(!ten.int.isOdd());
}

test "Enumerator" {
    const data = [_]i32{ 10, 20, 30 };
    var iter = enumerate(i32, &data);

    var item = iter.next().?;
    try testing.expectEqual(@as(usize, 0), item.index);
    try testing.expectEqual(@as(i32, 10), item.value);

    item = iter.next().?;
    try testing.expectEqual(@as(usize, 1), item.index);
    try testing.expectEqual(@as(i32, 20), item.value);
}

test "StringBuilder" {
    var sb = try StringBuilder.init(testing.allocator, 0);
    defer sb.deinit();

    try sb.append("Hello, ");
    try sb.append("World!");

    try testing.expectEqualStrings("Hello, World!", sb.toSlice());
}
