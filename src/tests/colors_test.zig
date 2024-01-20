const std = @import("std");
const enums = @import("../enums.zig");
const termColors = @import("../lib.zig");

const testing = std.testing;
const ColorParams = enums.ColorParams;
const Colors = termColors.Colors;
const comptime_colors = termColors.comptime_colors;

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

test "colors print" {
    var buffer: [40]u8 = undefined;
    var fbs = std.io.fixedBufferStream(&buffer);
    const colors = Colors{ .escape_codes = {} };
    {
        // normal red foreground text
        const expected = "\x1b[31mHello year 2024 world!\x1b[39m";
        try colors.print(fbs.writer(), .{ .red, .foreground }, "Hello year {d} world!", .{2024});
        try std.testing.expectEqualSlices(u8, expected, fbs.getWritten());
    }
    fbs.reset();
    {
        // normal green background text
        const expected = "\x1b[42mHello year 2024 world!\x1b[49m";
        try colors.print(fbs.writer(), .{ .green, .background }, "Hello year {d} world!", .{2024});
        try std.testing.expectEqualSlices(u8, expected, fbs.getWritten());
    }
    fbs.reset();
    {
        // bright blue foreground text
        const expected = "\x1b[94mHello year 2024 world!\x1b[39m";
        try colors.print(fbs.writer(), .{ .bright_blue, .foreground }, "Hello year {d} world!", .{2024});
        try std.testing.expectEqualSlices(u8, expected, fbs.getWritten());
    }
    fbs.reset();
    {
        // bright magenta background text
        const expected = "\x1b[105mHello year 2024 world!\x1b[49m";
        try colors.print(fbs.writer(), .{ .bright_magenta, .background }, "Hello year {d} world!", .{2024});
        try std.testing.expectEqualSlices(u8, expected, fbs.getWritten());
    }
}

test "colors set color" {
    var buffer: [8]u8 = undefined;
    var fbs = std.io.fixedBufferStream(&buffer);
    const colors = Colors{ .escape_codes = {} };
    {
        // normal red foreground text
        const expected = "\x1b[31m";
        try colors.setColor(fbs.writer(), .red, .foreground);
        try std.testing.expectEqualSlices(u8, expected, fbs.getWritten());
    }
    fbs.reset();
    {
        // normal green background text
        const expected = "\x1b[42m";
        try colors.setColor(fbs.writer(), .green, .background);
        try std.testing.expectEqualSlices(u8, expected, fbs.getWritten());
    }
    fbs.reset();
    {
        // bright blue foreground text
        const expected = "\x1b[94m";
        try colors.setColor(fbs.writer(), .bright_blue, .foreground);
        try std.testing.expectEqualSlices(u8, expected, fbs.getWritten());
    }
    fbs.reset();
    {
        // bright magenta background text
        const expected = "\x1b[105m";
        try colors.setColor(fbs.writer(), .bright_magenta, .background);
        try std.testing.expectEqualSlices(u8, expected, fbs.getWritten());
    }
}

test "colors fg" {
    var buffer: [8]u8 = undefined;
    var fbs = std.io.fixedBufferStream(&buffer);
    const colors = Colors{ .escape_codes = {} };
    {
        // normal black text
        const expected = "\x1b[30m";
        try colors.fg(fbs.writer(), .black);
        try std.testing.expectEqualSlices(u8, expected, fbs.getWritten());
    }
    fbs.reset();
    {
        // normal white text
        const expected = "\x1b[37m";
        try colors.fg(fbs.writer(), .white);
        try std.testing.expectEqualSlices(u8, expected, fbs.getWritten());
    }
    fbs.reset();
    {
        // bright black text
        const expected = "\x1b[90m";
        try colors.fg(fbs.writer(), .bright_black);
        try std.testing.expectEqualSlices(u8, expected, fbs.getWritten());
    }
    fbs.reset();
    {
        // bright white text
        const expected = "\x1b[97m";
        try colors.fg(fbs.writer(), .bright_white);
        try std.testing.expectEqualSlices(u8, expected, fbs.getWritten());
    }
}

test "colors bg" {
    var buffer: [8]u8 = undefined;
    var fbs = std.io.fixedBufferStream(&buffer);
    const colors = Colors{ .escape_codes = {} };
    {
        // normal black background
        const expected = "\x1b[40m";
        try colors.bg(fbs.writer(), .black);
        try std.testing.expectEqualSlices(u8, expected, fbs.getWritten());
    }
    fbs.reset();
    {
        // normal white background
        const expected = "\x1b[47m";
        try colors.bg(fbs.writer(), .white);
        try std.testing.expectEqualSlices(u8, expected, fbs.getWritten());
    }
    fbs.reset();
    {
        // bright black background
        const expected = "\x1b[100m";
        try colors.bg(fbs.writer(), .bright_black);
        try std.testing.expectEqualSlices(u8, expected, fbs.getWritten());
    }
    fbs.reset();
    {
        // bright white background
        const expected = "\x1b[107m";
        try colors.bg(fbs.writer(), .bright_white);
        try std.testing.expectEqualSlices(u8, expected, fbs.getWritten());
    }
}

test "16 colors" {
    var buffer: [8]u8 = undefined;
    var fbs = std.io.fixedBufferStream(&buffer);
    const colors = Colors{ .escape_codes = {} };
    {
        // normal black foreground text
        const expected = "\x1b[30m";
        try colors.black(fbs.writer(), .foreground);
        try std.testing.expectEqualSlices(u8, expected, fbs.getWritten());
    }
    fbs.reset();
    {
        // bright black background text
        const expected = "\x1b[100m";
        try colors.brightBlack(fbs.writer(), .background);
        try std.testing.expectEqualSlices(u8, expected, fbs.getWritten());
    }
    fbs.reset();
    {
        // normal red foreground text
        const expected = "\x1b[31m";
        try colors.red(fbs.writer(), .foreground);
        try std.testing.expectEqualSlices(u8, expected, fbs.getWritten());
    }
    fbs.reset();
    {
        // bright red background text
        const expected = "\x1b[101m";
        try colors.brightRed(fbs.writer(), .background);
        try std.testing.expectEqualSlices(u8, expected, fbs.getWritten());
    }
    fbs.reset();
    {
        // normal green foreground text
        const expected = "\x1b[32m";
        try colors.green(fbs.writer(), .foreground);
        try std.testing.expectEqualSlices(u8, expected, fbs.getWritten());
    }
    fbs.reset();
    {
        // bright green background text
        const expected = "\x1b[102m";
        try colors.brightGreen(fbs.writer(), .background);
        try std.testing.expectEqualSlices(u8, expected, fbs.getWritten());
    }
    fbs.reset();
    {
        // normal yellow foreground text
        const expected = "\x1b[33m";
        try colors.yellow(fbs.writer(), .foreground);
        try std.testing.expectEqualSlices(u8, expected, fbs.getWritten());
    }
    fbs.reset();
    {
        // bright yellow background text
        const expected = "\x1b[103m";
        try colors.brightYellow(fbs.writer(), .background);
        try std.testing.expectEqualSlices(u8, expected, fbs.getWritten());
    }
    fbs.reset();
    {
        // normal blue foreground text
        const expected = "\x1b[34m";
        try colors.blue(fbs.writer(), .foreground);
        try std.testing.expectEqualSlices(u8, expected, fbs.getWritten());
    }
    fbs.reset();
    {
        // bright blue background text
        const expected = "\x1b[104m";
        try colors.brightBlue(fbs.writer(), .background);
        try std.testing.expectEqualSlices(u8, expected, fbs.getWritten());
    }
    fbs.reset();
    {
        // normal magenta foreground text
        const expected = "\x1b[35m";
        try colors.magenta(fbs.writer(), .foreground);
        try std.testing.expectEqualSlices(u8, expected, fbs.getWritten());
    }
    fbs.reset();
    {
        // bright magenta background text
        const expected = "\x1b[105m";
        try colors.brightMagenta(fbs.writer(), .background);
        try std.testing.expectEqualSlices(u8, expected, fbs.getWritten());
    }
    fbs.reset();
    {
        // normal cyan foreground text
        const expected = "\x1b[36m";
        try colors.cyan(fbs.writer(), .foreground);
        try std.testing.expectEqualSlices(u8, expected, fbs.getWritten());
    }
    fbs.reset();
    {
        // bright cyan background text
        const expected = "\x1b[106m";
        try colors.brightCyan(fbs.writer(), .background);
        try std.testing.expectEqualSlices(u8, expected, fbs.getWritten());
    }
    fbs.reset();
    {
        // normal white foreground text
        const expected = "\x1b[37m";
        try colors.white(fbs.writer(), .foreground);
        try std.testing.expectEqualSlices(u8, expected, fbs.getWritten());
    }
    fbs.reset();
    {
        // bright white background text
        const expected = "\x1b[107m";
        try colors.brightWhite(fbs.writer(), .background);
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

test "comptime 16 colors" {
    {
        // normal black foreground text
        const expected = "\x1b[30m";
        const actual = comptime_colors.black(.foreground);
        try testing.expectEqualStrings(expected, actual);
    }
    {
        // bright black background text
        const expected = "\x1b[100m";
        const actual = comptime_colors.brightBlack(.background);
        try testing.expectEqualStrings(expected, actual);
    }
    {
        // normal red foreground text
        const expected = "\x1b[31m";
        const actual = comptime_colors.red(.foreground);
        try testing.expectEqualStrings(expected, actual);
    }
    {
        // bright red background text
        const expected = "\x1b[101m";
        const actual = comptime_colors.brightRed(.background);
        try testing.expectEqualStrings(expected, actual);
    }
    {
        // normal green foreground text
        const expected = "\x1b[32m";
        const actual = comptime_colors.green(.foreground);
        try testing.expectEqualStrings(expected, actual);
    }
    {
        // bright green background text
        const expected = "\x1b[102m";
        const actual = comptime_colors.brightGreen(.background);
        try testing.expectEqualStrings(expected, actual);
    }
    {
        // normal yellow foreground text
        const expected = "\x1b[33m";
        const actual = comptime_colors.yellow(.foreground);
        try testing.expectEqualStrings(expected, actual);
    }
    {
        // bright yellow background text
        const expected = "\x1b[103m";
        const actual = comptime_colors.brightYellow(.background);
        try testing.expectEqualStrings(expected, actual);
    }
    {
        // normal blue foreground text
        const expected = "\x1b[34m";
        const actual = comptime_colors.blue(.foreground);
        try testing.expectEqualStrings(expected, actual);
    }
    {
        // bright blue background text
        const expected = "\x1b[104m";
        const actual = comptime_colors.brightBlue(.background);
        try testing.expectEqualStrings(expected, actual);
    }
    {
        // normal magenta foreground text
        const expected = "\x1b[35m";
        const actual = comptime_colors.magenta(.foreground);
        try testing.expectEqualStrings(expected, actual);
    }
    {
        // bright magenta background text
        const expected = "\x1b[105m";
        const actual = comptime_colors.brightMagenta(.background);
        try testing.expectEqualStrings(expected, actual);
    }
    {
        // normal cyan foreground text
        const expected = "\x1b[36m";
        const actual = comptime_colors.cyan(.foreground);
        try testing.expectEqualStrings(expected, actual);
    }
    {
        // bright cyan background text
        const expected = "\x1b[106m";
        const actual = comptime_colors.brightCyan(.background);
        try testing.expectEqualStrings(expected, actual);
    }
    {
        // normal white foreground text
        const expected = "\x1b[37m";
        const actual = comptime_colors.white(.foreground);
        try testing.expectEqualStrings(expected, actual);
    }
    {
        // bright white background text
        const expected = "\x1b[107m";
        const actual = comptime_colors.brightWhite(.background);
        try testing.expectEqualStrings(expected, actual);
    }
}

test "create colors function" {
    var buffer: [8]u8 = undefined;
    var fbs = std.io.fixedBufferStream(&buffer);
    {
        // no color
        const tty_config = std.io.tty.Config{ .no_color = {} };
        const colors = termColors.createColors(tty_config);

        const expected = "";
        try colors.default(fbs.writer(), .foreground);
        try std.testing.expectEqualSlices(u8, expected, fbs.getWritten());
    }
    fbs.reset();
    {
        // escape codes
        const tty_config = std.io.tty.Config{ .escape_codes = {} };
        const colors = termColors.createColors(tty_config);

        const expected = "\x1b[39m";
        try colors.default(fbs.writer(), .foreground);
        try std.testing.expectEqualSlices(u8, expected, fbs.getWritten());
    }
}
