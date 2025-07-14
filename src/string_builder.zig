// methods/src/string_builder.zig
const std = @import("std");

pub const StringBuilder = struct {
    allocator: std.mem.Allocator,
    buffer: std.ArrayList(u8),

    pub fn init(allocator: std.mem.Allocator, initial_capacity: usize) !StringBuilder {
        var buffer = std.ArrayList(u8).init(allocator);
        errdefer buffer.deinit();
        try buffer.ensureTotalCapacity(initial_capacity);

        return StringBuilder{
            .allocator = allocator,
            .buffer = buffer,
        };
    }

    pub fn deinit(self: *StringBuilder) void {
        self.buffer.deinit();
    }

    pub fn append(self: *StringBuilder, s: []const u8) !void {
        try self.buffer.appendSlice(s);
    }

    pub fn appendChar(self: *StringBuilder, c: u8) !void {
        try self.buffer.append(c);
    }

    pub fn toSlice(self: *const StringBuilder) []const u8 {
        return self.buffer.items;
    }

    pub fn clear(self: *StringBuilder) void {
        self.buffer.clearRetainingCapacity();
    }
};
