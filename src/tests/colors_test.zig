const std = @import("std");
const enums = @import("../enums.zig");
const termColors = @import("../lib.zig");

const testing = std.testing;
const ColorParams = enums.ColorParams;
const Colors = termColors.Colors;
const comptime_colors = termColors.ComptimeColors;

test "colors default" {
    var buffer: [8]u8 = undefined;
    var fbs = std.io.fixedBufferStream(&buffer);

    const colors = Colors{ .escape_codes = {} };

    {
        // default foreground text
        const expected = "\x1b[39m";
        try colors.default(fbs.writer(), .foreground);
        try std.testing.expectEqualSlices(u8, expected, fbs.getWritten());
    }

    fbs.reset();

    {
        // default background text
        const expected = "\x1b[49m";
        try colors.default(fbs.writer(), .background);
        try std.testing.expectEqualSlices(u8, expected, fbs.getWritten());
    }
}

test "colors color16" {
    var buffer: [8]u8 = undefined;
    var fbs = std.io.fixedBufferStream(&buffer);

    const colors = Colors{ .escape_codes = {} };

    {
        // normal red foreground text
        const expected = "\x1b[31m";
        try colors.color16(fbs.writer(), .red, .foreground);
        try std.testing.expectEqualSlices(u8, expected, fbs.getWritten());
    }

    fbs.reset();

    {
        // normal green background text
        const expected = "\x1b[42m";
        try colors.color16(fbs.writer(), .green, .background);
        try std.testing.expectEqualSlices(u8, expected, fbs.getWritten());
    }

    fbs.reset();

    {
        // bright blue foreground text
        const expected = "\x1b[94m";
        try colors.color16(fbs.writer(), .bright_blue, .foreground);
        try std.testing.expectEqualSlices(u8, expected, fbs.getWritten());
    }

    fbs.reset();

    {
        // bright magenta background text
        const expected = "\x1b[105m";
        try colors.color16(fbs.writer(), .bright_magenta, .background);
        try std.testing.expectEqualSlices(u8, expected, fbs.getWritten());
    }
}

test "comptime colors default" {
    {
        // default foreground text
        const expected = "\x1b[39m";
        const actual = comptime_colors.default(.foreground);
        try testing.expectEqualStrings(expected, actual);
    }
    {
        // default background text
        const expected = "\x1b[49m";
        const actual = comptime_colors.default(.background);
        try testing.expectEqualStrings(expected, actual);
    }
}

test "comptime colors color16" {
    {
        // normal red foreground text
        const expected = "\x1b[31m";
        const actual = comptime_colors.color16(.red, .foreground);
        try testing.expectEqualStrings(expected, actual);
    }
    {
        // normal green background text
        const expected = "\x1b[42m";
        const actual = comptime_colors.color16(.green, .background);
        try testing.expectEqualStrings(expected, actual);
    }
    {
        // bright blue foreground text
        const expected = "\x1b[94m";
        const actual = comptime_colors.color16(.bright_blue, .foreground);
        try testing.expectEqualStrings(expected, actual);
    }
    {
        // bright magenta background text
        const expected = "\x1b[105m";
        const actual = comptime_colors.color16(.bright_magenta, .background);
        try testing.expectEqualStrings(expected, actual);
    }
}

test "comptime colors print" {
    {
        // normal red foreground text
        const expected = "\x1b[31mHello year 2024 world!\x1b[39m";
        const actual = comptime_colors.print(.red, .foreground, "Hello year {d} world!", .{2024});
        try testing.expectEqualStrings(expected, actual);
    }
    {
        // normal green background text
        const expected = "\x1b[42mHello year 2024 world!\x1b[49m";
        const actual = comptime_colors.print(.green, .background, "Hello year {d} world!", .{2024});
        try testing.expectEqualStrings(expected, actual);
    }
    {
        // bright blue foreground text
        const expected = "\x1b[94mHello year 2024 world!\x1b[39m";
        const actual = comptime_colors.print(.bright_blue, .foreground, "Hello year {d} world!", .{2024});
        try testing.expectEqualStrings(expected, actual);
    }
    {
        // bright magenta background text
        const expected = "\x1b[105mHello year 2024 world!\x1b[49m";
        const actual = comptime_colors.print(.bright_magenta, .background, "Hello year {d} world!", .{2024});
        try testing.expectEqualStrings(expected, actual);
    }
}

test "comptime colors fg" {
    {
        // normal black text
        const expected = "\x1b[30m";
        const actual = comptime_colors.fg(.black);
        try testing.expectEqualStrings(expected, actual);
    }
    {
        // normal white text
        const expected = "\x1b[37m";
        const actual = comptime_colors.fg(.white);
        try testing.expectEqualStrings(expected, actual);
    }
    {
        // bright black text
        const expected = "\x1b[90m";
        const actual = comptime_colors.fg(.bright_black);
        try testing.expectEqualStrings(expected, actual);
    }
    {
        // bright white text
        const expected = "\x1b[97m";
        const actual = comptime_colors.fg(.bright_white);
        try testing.expectEqualStrings(expected, actual);
    }
}

test "comptime colors bg" {
    {
        // normal black background
        const expected = "\x1b[40m";
        const actual = comptime_colors.bg(.black);
        try testing.expectEqualStrings(expected, actual);
    }
    {
        // normal white background
        const expected = "\x1b[47m";
        const actual = comptime_colors.bg(.white);
        try testing.expectEqualStrings(expected, actual);
    }
    {
        // bright black background
        const expected = "\x1b[100m";
        const actual = comptime_colors.bg(.bright_black);
        try testing.expectEqualStrings(expected, actual);
    }
    {
        // bright white background
        const expected = "\x1b[107m";
        const actual = comptime_colors.bg(.bright_white);
        try testing.expectEqualStrings(expected, actual);
    }
}

test "create colors function" {
    {
        // no color
        const tty_config = std.io.tty.Config{ .no_color = {} };
        const colors = termColors.createColors(tty_config);

        var buffer: [8]u8 = undefined;
        var fbs = std.io.fixedBufferStream(&buffer);

        const expected = "";
        try colors.default(fbs.writer(), .foreground);
        try std.testing.expectEqualSlices(u8, expected, fbs.getWritten());
    }
    {
        // escape codes
        const tty_config = std.io.tty.Config{ .escape_codes = {} };
        const colors = termColors.createColors(tty_config);

        var buffer: [8]u8 = undefined;
        var fbs = std.io.fixedBufferStream(&buffer);

        const expected = "\x1b[39m";
        try colors.default(fbs.writer(), .foreground);
        try std.testing.expectEqualSlices(u8, expected, fbs.getWritten());
    }
}
