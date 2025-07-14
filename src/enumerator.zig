// methods/src/enumerator.zig
const std = @import("std");

pub fn Item(comptime T: type) type {
    return struct {
        index: usize,
        value: T,
    };
}

pub fn Enumerator(comptime T: type, SliceType: type) type {
    return struct {
        const Self = @This();
        data: SliceType,
        i: usize,

        pub fn next(self: *Self) ?Item(T) {
            if (self.i >= self.data.len) return null;
            const result = Item(T){ .index = self.i, .value = self.data[self.i] };
            self.i += 1;
            return result;
        }

        pub fn peek(self: *Self) ?Item(T) {
            if (self.i >= self.data.len) return null;
            return Item(T){ .index = self.i, .value = self.data[self.i] };
        }

        pub fn reset(self: *Self) void {
            self.i = 0;
        }

        pub fn len(self: Self) usize {
            return self.data.len - self.i;
        }

        pub fn isDone(self: Self) bool {
            return self.i >= self.data.len;
        }

        pub fn collect(self: *Self, allocator: std.mem.Allocator) !std.ArrayList(Item(T)) {
            var result = std.ArrayList(Item(T)).init(allocator);
            while (self.next()) |item| {
                try result.append(item);
            }
            return result;
        }
    };
}

pub fn enumerate(comptime T: type, data: []const T) Enumerator(T, []const T) {
    return Enumerator(T, []const T){ .data = data, .i = 0 };
}

pub fn enumerateMutable(comptime T: type, data: []T) Enumerator(T, []T) {
    return Enumerator(T, []T){ .data = data, .i = 0 };
}
