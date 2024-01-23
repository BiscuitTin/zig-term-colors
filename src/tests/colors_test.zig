const std = @import("std");
const enums = @import("../enums.zig");
const termColors = @import("../lib.zig");

const testing = std.testing;
const ColorParams = enums.ColorParams;
const Colors = termColors.Colors;
const comptime_colors = termColors.comptime_colors;

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
        try colors.setColor(fbs.writer(), .red);
        try std.testing.expectEqualSlices(u8, expected, fbs.getWritten());
    }
    fbs.reset();
    {
        // normal green background text
        const expected = "\x1b[42m";
        try colors.setBackgroundColor(fbs.writer(), .green);
        try std.testing.expectEqualSlices(u8, expected, fbs.getWritten());
    }
    fbs.reset();
    {
        // bright blue foreground text
        const expected = "\x1b[94m";
        try colors.setColor(fbs.writer(), .bright_blue);
        try std.testing.expectEqualSlices(u8, expected, fbs.getWritten());
    }
    fbs.reset();
    {
        // bright magenta background text
        const expected = "\x1b[105m";
        try colors.setBackgroundColor(fbs.writer(), .bright_magenta);
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

test "reset" {
    var buffer: [8]u8 = undefined;
    var fbs = std.io.fixedBufferStream(&buffer);
    const colors = Colors{ .escape_codes = {} };
    {
        const expected = "\x1b[0m";
        try colors.reset(fbs.writer());
        try std.testing.expectEqualSlices(u8, expected, fbs.getWritten());
    }
}

test "font styles" {
    var buffer: [8]u8 = undefined;
    var fbs = std.io.fixedBufferStream(&buffer);
    const colors = Colors{ .escape_codes = {} };
    {
        // bold text
        const expected = "\x1b[1m";
        try colors.bold(fbs.writer(), true);
        try std.testing.expectEqualSlices(u8, expected, fbs.getWritten());
    }
    fbs.reset();
    {
        // dim text
        const expected = "\x1b[2m";
        try colors.dim(fbs.writer(), true);
        try std.testing.expectEqualSlices(u8, expected, fbs.getWritten());
    }
    fbs.reset();
    {
        // italic text
        const expected = "\x1b[3m";
        try colors.italic(fbs.writer(), true);
        try std.testing.expectEqualSlices(u8, expected, fbs.getWritten());
    }
    fbs.reset();
    {
        // underline text
        const expected = "\x1b[4m";
        try colors.underline(fbs.writer(), true);
        try std.testing.expectEqualSlices(u8, expected, fbs.getWritten());
    }
    fbs.reset();
    {
        // blink text
        const expected = "\x1b[5m";
        try colors.blink(fbs.writer(), true);
        try std.testing.expectEqualSlices(u8, expected, fbs.getWritten());
    }
    fbs.reset();
    {
        // inverse text
        const expected = "\x1b[7m";
        try colors.inverse(fbs.writer(), true);
        try std.testing.expectEqualSlices(u8, expected, fbs.getWritten());
    }
    fbs.reset();
    {
        // hidden text
        const expected = "\x1b[8m";
        try colors.hidden(fbs.writer(), true);
        try std.testing.expectEqualSlices(u8, expected, fbs.getWritten());
    }
    fbs.reset();
    {
        // strikethrough text
        const expected = "\x1b[9m";
        try colors.strikethrough(fbs.writer(), true);
        try std.testing.expectEqualSlices(u8, expected, fbs.getWritten());
    }
    fbs.reset();
    {
        // no bold text
        const expected = "\x1b[22m";
        try colors.bold(fbs.writer(), false);
        try std.testing.expectEqualSlices(u8, expected, fbs.getWritten());
    }
    fbs.reset();
    {
        // no dim text
        const expected = "\x1b[22m";
        try colors.dim(fbs.writer(), false);
        try std.testing.expectEqualSlices(u8, expected, fbs.getWritten());
    }
    fbs.reset();
    {
        // no italic text
        const expected = "\x1b[23m";
        try colors.italic(fbs.writer(), false);
        try std.testing.expectEqualSlices(u8, expected, fbs.getWritten());
    }
    fbs.reset();
    {
        // no underline text
        const expected = "\x1b[24m";
        try colors.underline(fbs.writer(), false);
        try std.testing.expectEqualSlices(u8, expected, fbs.getWritten());
    }
    fbs.reset();
    {
        // no blink text
        const expected = "\x1b[25m";
        try colors.blink(fbs.writer(), false);
        try std.testing.expectEqualSlices(u8, expected, fbs.getWritten());
    }
    fbs.reset();
    {
        // no inverse text
        const expected = "\x1b[27m";
        try colors.inverse(fbs.writer(), false);
        try std.testing.expectEqualSlices(u8, expected, fbs.getWritten());
    }
    fbs.reset();
    {
        // no hidden text
        const expected = "\x1b[28m";
        try colors.hidden(fbs.writer(), false);
        try std.testing.expectEqualSlices(u8, expected, fbs.getWritten());
    }
    fbs.reset();
    {
        // no strikethrough text
        const expected = "\x1b[29m";
        try colors.strikethrough(fbs.writer(), false);
        try std.testing.expectEqualSlices(u8, expected, fbs.getWritten());
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

test "comptime reset" {
    const expected = "\x1b[0m";
    const actual = comptime_colors.reset();
    try testing.expectEqualStrings(expected, actual);
}

test "comptime font styles" {
    {
        // bold text
        const expected = "\x1b[1m";
        const actual = comptime_colors.bold(true);
        try testing.expectEqualStrings(expected, actual);
    }
    {
        // dim text
        const expected = "\x1b[2m";
        const actual = comptime_colors.dim(true);
        try testing.expectEqualStrings(expected, actual);
    }
    {
        // italic text
        const expected = "\x1b[3m";
        const actual = comptime_colors.italic(true);
        try testing.expectEqualStrings(expected, actual);
    }
    {
        // underline text
        const expected = "\x1b[4m";
        const actual = comptime_colors.underline(true);
        try testing.expectEqualStrings(expected, actual);
    }
    {
        // blink text
        const expected = "\x1b[5m";
        const actual = comptime_colors.blink(true);
        try testing.expectEqualStrings(expected, actual);
    }
    {
        // inverse text
        const expected = "\x1b[7m";
        const actual = comptime_colors.inverse(true);
        try testing.expectEqualStrings(expected, actual);
    }
    {
        // hidden text
        const expected = "\x1b[8m";
        const actual = comptime_colors.hidden(true);
        try testing.expectEqualStrings(expected, actual);
    }
    {
        // strikethrough text
        const expected = "\x1b[9m";
        const actual = comptime_colors.strikethrough(true);
        try testing.expectEqualStrings(expected, actual);
    }
    {
        // no bold text
        const expected = "\x1b[22m";
        const actual = comptime_colors.bold(false);
        try testing.expectEqualStrings(expected, actual);
    }
    {
        // no dim text
        const expected = "\x1b[22m";
        const actual = comptime_colors.dim(false);
        try testing.expectEqualStrings(expected, actual);
    }
    {
        // no italic text
        const expected = "\x1b[23m";
        const actual = comptime_colors.italic(false);
        try testing.expectEqualStrings(expected, actual);
    }
    {
        // no underline text
        const expected = "\x1b[24m";
        const actual = comptime_colors.underline(false);
        try testing.expectEqualStrings(expected, actual);
    }
    {
        // no blink text
        const expected = "\x1b[25m";
        const actual = comptime_colors.blink(false);
        try testing.expectEqualStrings(expected, actual);
    }
    {
        // no inverse text
        const expected = "\x1b[27m";
        const actual = comptime_colors.inverse(false);
        try testing.expectEqualStrings(expected, actual);
    }
    {
        // no hidden text
        const expected = "\x1b[28m";
        const actual = comptime_colors.hidden(false);
        try testing.expectEqualStrings(expected, actual);
    }
    {
        // no strikethrough text
        const expected = "\x1b[29m";
        const actual = comptime_colors.strikethrough(false);
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
    fbs.reset();
    {
        // windows api
        const file = std.io.getStdErr();
        const windows = std.os.windows;
        const builtin = @import("builtin");
        const native_os = builtin.os.tag;
        const info: windows.CONSOLE_SCREEN_BUFFER_INFO = undefined;
        const tty_config = std.io.tty.Config{ .windows_api = if (native_os == .windows) .{
            .handle = file.handle,
            .reset_attributes = info.wAttributes,
        } else {} };
        const colors = termColors.createColors(tty_config);

        const expected = "";
        try colors.default(fbs.writer(), .foreground);
        try std.testing.expectEqualSlices(u8, expected, fbs.getWritten());
    }
}

test "no color" {
    var buffer: [8]u8 = undefined;
    var fbs = std.io.fixedBufferStream(&buffer);
    const tty_config = std.io.tty.Config{ .no_color = {} };
    const colors = termColors.createColors(tty_config);
    {
        // no color
        const expected = "";
        try colors.setColor(fbs.writer(), .red);
        try std.testing.expectEqualSlices(u8, expected, fbs.getWritten());
    }
    fbs.reset();
    {
        // no reset
        const expected = "";
        try colors.reset(fbs.writer());
        try std.testing.expectEqualSlices(u8, expected, fbs.getWritten());
    }
    fbs.reset();
    {
        // no font styles
        const expected = "";
        try colors.bold(fbs.writer(), true);
        try std.testing.expectEqualSlices(u8, expected, fbs.getWritten());
    }
}
