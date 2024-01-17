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

test "utils reset" {
    std.debug.print("Test: utils reset\n", .{});

    const expected = "\x1b[0m";
    const actual = utils.reset();
    try testing.expectEqualStrings(expected, actual);
}

test "utils font styles" {
    std.debug.print("Test: utils font styles\n", .{});
    // Cases
    {
        // bold text
        std.debug.print("\x09Case: bold text\n", .{});

        const expected = "\x1b[1m";
        const actual = utils.bold(true);
        try testing.expectEqualStrings(expected, actual);
    }
    {
        // dim text
        std.debug.print("\x09Case: dim text\n", .{});

        const expected = "\x1b[2m";
        const actual = utils.dim(true);
        try testing.expectEqualStrings(expected, actual);
    }
    {
        // italic text
        std.debug.print("\x09Case: italic text\n", .{});

        const expected = "\x1b[3m";
        const actual = utils.italic(true);
        try testing.expectEqualStrings(expected, actual);
    }
    {
        // underline text
        std.debug.print("\x09Case: underline text\n", .{});

        const expected = "\x1b[4m";
        const actual = utils.underline(true);
        try testing.expectEqualStrings(expected, actual);
    }
    {
        // blink text
        std.debug.print("\x09Case: blink text\n", .{});

        const expected = "\x1b[5m";
        const actual = utils.blink(true);
        try testing.expectEqualStrings(expected, actual);
    }
    {
        // inverse text
        std.debug.print("\x09Case: inverse text\n", .{});

        const expected = "\x1b[7m";
        const actual = utils.inverse(true);
        try testing.expectEqualStrings(expected, actual);
    }
    {
        // hidden text
        std.debug.print("\x09Case: hidden text\n", .{});

        const expected = "\x1b[8m";
        const actual = utils.hidden(true);
        try testing.expectEqualStrings(expected, actual);
    }
    {
        // strikethrough text
        std.debug.print("\x09Case: strikethrough text\n", .{});

        const expected = "\x1b[9m";
        const actual = utils.strikethrough(true);
        try testing.expectEqualStrings(expected, actual);
    }
    {
        // no bold text
        std.debug.print("\x09Case: no bold text\n", .{});

        const expected = "\x1b[22m";
        const actual = utils.bold(false);
        try testing.expectEqualStrings(expected, actual);
    }
    {
        // no dim text
        std.debug.print("\x09Case: no dim text\n", .{});

        const expected = "\x1b[22m";
        const actual = utils.dim(false);
        try testing.expectEqualStrings(expected, actual);
    }
    {
        // no italic text
        std.debug.print("\x09Case: no italic text\n", .{});

        const expected = "\x1b[23m";
        const actual = utils.italic(false);
        try testing.expectEqualStrings(expected, actual);
    }
    {
        // no underline text
        std.debug.print("\x09Case: no underline text\n", .{});

        const expected = "\x1b[24m";
        const actual = utils.underline(false);
        try testing.expectEqualStrings(expected, actual);
    }
    {
        // no blink text
        std.debug.print("\x09Case: no blink text\n", .{});

        const expected = "\x1b[25m";
        const actual = utils.blink(false);
        try testing.expectEqualStrings(expected, actual);
    }
    {
        // no inverse text
        std.debug.print("\x09Case: no inverse text\n", .{});

        const expected = "\x1b[27m";
        const actual = utils.inverse(false);
        try testing.expectEqualStrings(expected, actual);
    }
    {
        // no hidden text
        std.debug.print("\x09Case: no hidden text\n", .{});

        const expected = "\x1b[28m";
        const actual = utils.hidden(false);
        try testing.expectEqualStrings(expected, actual);
    }
    {
        // no strikethrough text
        std.debug.print("\x09Case: no strikethrough text\n", .{});

        const expected = "\x1b[29m";
        const actual = utils.strikethrough(false);
        try testing.expectEqualStrings(expected, actual);
    }
}
