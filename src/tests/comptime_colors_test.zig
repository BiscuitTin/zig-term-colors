const std = @import("std");
const enums = @import("../enums.zig");
const termColors = @import("../lib.zig");

const testing = std.testing;
const ColorParams = enums.ColorParams;
const colors = termColors.ComptimeColors;

test "comptime colors default" {
    std.debug.print("Test: comptime colors default\n", .{});
    // Cases
    {
        // default foreground text
        std.debug.print("\x09Case: default foreground text\n", .{});

        const expected = "\x1b[39m";
        const actual = colors.default(.foreground);
        try testing.expectEqualStrings(expected, actual);
    }
    {
        // default background text
        std.debug.print("\x09Case: default background text\n", .{});

        const expected = "\x1b[49m";
        const actual = colors.default(.background);
        try testing.expectEqualStrings(expected, actual);
    }
}

test "comptime colors color16" {
    std.debug.print("Test: comptime colors color16\n", .{});
    // Cases
    {
        // normal red foreground text
        std.debug.print("\x09Case: normal red foreground text\n", .{});

        const expected = "\x1b[31m";
        const actual = colors.color16(.red, .foreground);
        try testing.expectEqualStrings(expected, actual);
    }
    {
        // normal green background text
        std.debug.print("\x09Case: normal green background text\n", .{});

        const expected = "\x1b[42m";
        const actual = colors.color16(.green, .background);
        try testing.expectEqualStrings(expected, actual);
    }
    {
        // bright blue foreground text
        std.debug.print("\x09Case: bright blue foreground text\n", .{});

        const expected = "\x1b[94m";
        const actual = colors.color16(.bright_blue, .foreground);
        try testing.expectEqualStrings(expected, actual);
    }
    {
        // bright magenta background text
        std.debug.print("\x09Case: bright magenta background text\n", .{});

        const expected = "\x1b[105m";
        const actual = colors.color16(.bright_magenta, .background);
        try testing.expectEqualStrings(expected, actual);
    }
}
