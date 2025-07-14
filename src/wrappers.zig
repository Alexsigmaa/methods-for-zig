// my-zig-utils/src/wrappers.zig
const std = @import("std");

pub const IntWrapper_i64 = IntWrapper(i64);
pub const FloatWrapper_f64 = FloatWrapper(f64);
pub const GenericWrapper_bool = GenericWrapper(bool);

/// --- WRAPPERS ---
pub const Wrapper = union(enum) {
    int: IntWrapper_i64,
    float: FloatWrapper_f64,
    string: StringWrapper,
    generic: GenericWrapper_bool,
};

pub fn Wrap(comptime T: type, value: T) Wrapper {
    const info = @typeInfo(T);
    if (info == .Int) {
        return Wrapper{ .int = IntWrapper_i64{ .value = @as(i64, value) } };
    } else if (info == .Float) {
        return Wrapper{ .float = FloatWrapper_f64{ .value = @as(f64, value) } };
    } else if (info == .Slice and info.Slice.child == u8) {
        return Wrapper{ .string = StringWrapper{ .value = value } };
    } else {
        return Wrapper{ .generic = GenericWrapper_bool{ .value = @as(bool, value) } };
    }
}

pub fn IntWrapper(comptime T: type) type {
    return struct {
        value: T,
        pub fn isEven(self: @This()) bool {
            return (@rem(self.value, 2)) == 0;
        }
        pub fn isOdd(self: @This()) bool {
            return (@rem(self.value, 2)) != 0;
        }
        pub fn abs(self: @This()) T {
            return if (self.value < 0) -self.value else self.value;
        }
    };
}

pub fn FloatWrapper(comptime T: type) type {
    return struct {
        value: T,
        pub fn isFinite(self: @This()) bool {
            return std.math.isFinite(self.value);
        }
        pub fn isNaN(self: @This()) bool {
            return std.math.isNaN(self.value);
        }
        pub fn abs(self: @This()) T {
            return if (self.value < 0) -self.value else self.value;
        }
    };
}

pub const StringWrapper = struct {
    value: []const u8,
    pub fn startsWith(self: @This(), prefix: []const u8) bool {
        return std.mem.startsWith(u8, self.value, prefix);
    }
    pub fn endsWith(self: @This(), suffix: []const u8) bool {
        return std.mem.endsWith(u8, self.value, suffix);
    }
    pub fn contains(self: @This(), substr: []const u8) bool {
        return std.mem.indexOf(u8, self.value, substr) != null;
    }
    pub fn reverse(self: @This(), allocator: std.mem.Allocator) !std.ArrayList(u8) {
        var reversed = std.ArrayList(u8).init(allocator);
        try reversed.ensureCapacity(self.value.len);
        for (0..self.value.len) |i| {
            try reversed.append(self.value[self.value.len - 1 - i]);
        }
        return reversed;
    }
    pub fn toUpper(self: @This(), allocator: std.mem.Allocator) !std.ArrayList(u8) {
        var result = std.ArrayList(u8).init(allocator);
        try result.ensureCapacity(self.value.len);
        for (self.value) |c| {
            if (c >= 'a' and c <= 'z') {
                try result.append(c - ('a' - 'A'));
            } else {
                try result.append(c);
            }
        }
        return result;
    }
    pub fn toLower(self: @This(), allocator: std.mem.Allocator) !std.ArrayList(u8) {
        var result = std.ArrayList(u8).init(allocator);
        try result.ensureCapacity(self.value.len);
        for (self.value) |c| {
            if (c >= 'A' and c <= 'Z') {
                try result.append(c + ('a' - 'A'));
            } else {
                try result.append(c);
            }
        }
        return result;
    }
    pub fn trim(self: @This()) []const u8 {
        var start: usize = 0;
        var end: usize = self.value.len;
        while (start < end) : (start += 1) {
            if (!std.ascii.isWhitespace(self.value[start])) break;
        }
        while (end > start) : (end -= 1) {
            if (!std.ascii.isWhitespace(self.value[end - 1])) break;
        }
        return self.value[start..end];
    }
    pub fn split(self: @This(), allocator: std.mem.Allocator, delim: u8) !std.ArrayList([]const u8) {
        var parts = std.ArrayList([]const u8).init(allocator);
        var slice = self.value;
        while (true) {
            const idx = std.mem.indexOf(u8, slice, &[_]u8{delim});
            if (idx) |i| {
                try parts.append(slice[0..i]);
                slice = slice[i + 1 ..];
            } else {
                try parts.append(slice);
                break;
            }
        }
        return parts;
    }
};

pub fn GenericWrapper(comptime T: type) type {
    return struct {
        value: T,
    };
}
