const std = @import("std");
const term_colors = @import("term-colors");

fn printColorCodeCells(comptime style: []const u8, id: comptime_int, comptime name: []const u8) void {
    const colors = term_colors.comptime_colors;

    std.debug.print("{s}", .{style});

    inline for (@typeInfo(term_colors.Color).Enum.fields) |c| {
        const color: term_colors.Color = @enumFromInt(c.value);
        std.debug.print("{s} {d} {s}", .{ colors.fg(color), c.value, colors.default(.foreground) });
    }

    std.debug.print("{s} - ({d}) {s}\n", .{ colors.reset(), id, name });
}

fn printColorCells(id: comptime_int, comptime name: []const u8) void {
    const colors = term_colors.comptime_colors;

    inline for (@typeInfo(term_colors.Color).Enum.fields) |c| {
        if (id == 3) if (c.value > 40) break;
        if (id == 9) if (c.value < 40) continue;

        const color: term_colors.Color = @enumFromInt(c.value);
        std.debug.print("{s}        {s}", .{ colors.bg(color), colors.default(.background) });
    }

    std.debug.print("{s} - ({d}x) {s}\n", .{ colors.reset(), id, name });
}

fn comptimeColorsDemo() void {
    std.debug.print("{s:-^64}\n", .{"foreground text colors and font styles"});

    const colors = term_colors.comptime_colors;
    printColorCodeCells("", 0, "normal");
    printColorCodeCells(colors.bold(true), 1, "bold");
    printColorCodeCells(colors.dim(true), 2, "dim");
    printColorCodeCells(colors.italic(true), 3, "italic");
    printColorCodeCells(colors.underline(true), 4, "underline");
    printColorCodeCells(colors.blink(true), 5, "blink");
    printColorCodeCells(colors.inverse(true), 7, "inverse");
    printColorCodeCells(colors.hidden(true), 8, "hidden");
    printColorCodeCells(colors.strikethrough(true), 9, "strikethrough");

    std.debug.print("{s:-^64}\n", .{"normal and bright background colors"});

    printColorCells(3, "normal");
    printColorCells(9, "bright");
}

pub fn main() !void {
    // sometimes zig build will print debug info before the program output
    std.debug.print("\n", .{});

    comptimeColorsDemo();
}
