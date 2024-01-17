const std = @import("std");
const enums = @import("../enums.zig");
const utils = @import("../utils.zig");

const testing = std.testing;
const ColorParams = enums.ColorParams;

test "utils default" {
    std.debug.print("Test: utils default\n", .{});
    // Cases
    {
        // default foreground text
        std.debug.print("\x09Case: default foreground text\n", .{});

        const expected = "\x1b[39m";
        const actual = utils.default(.foreground);
        try testing.expectEqualStrings(expected, actual);
    }
    {
        // default background text
        std.debug.print("\x09Case: default background text\n", .{});

        const expected = "\x1b[49m";
        const actual = utils.default(.background);
        try testing.expectEqualStrings(expected, actual);
    }
}

fn testColor16(params: ColorParams, expected: []const u8) !void {
    var buffer: [8]u8 = undefined;
    var fbs = std.io.fixedBufferStream(&buffer);

    try utils.color16(fbs.writer(), params[0], params[1]);
    try std.testing.expectEqualSlices(u8, expected, fbs.getWritten());
}

test "utils color16" {
    std.debug.print("Test: utils color16\n", .{});
    // Cases
    {
        // normal red foreground text
        std.debug.print("\x09Case: normal red foreground text\n", .{});

        const expected = "\x1b[31m";
        try testColor16(.{ .red, .foreground }, expected);
    }
    {
        // normal green background text
        std.debug.print("\x09Case: normal green background text\n", .{});

        const expected = "\x1b[42m";
        try testColor16(.{ .green, .background }, expected);
    }
    {
        // bright blue foreground text
        std.debug.print("\x09Case: bright blue foreground text\n", .{});

        const expected = "\x1b[94m";
        try testColor16(.{ .bright_blue, .foreground }, expected);
    }
    {
        // bright magenta background text
        std.debug.print("\x09Case: bright magenta background text\n", .{});

        const expected = "\x1b[105m";
        try testColor16(.{ .bright_magenta, .background }, expected);
    }
}
